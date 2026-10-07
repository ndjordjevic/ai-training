#!/usr/bin/env bash
# Deterministic audit baseline: step 1 of "Auditing an existing repo" in our-sdlc.md.
# No AI, no tokens. Its output is the input for the AI audit.
#
# Setup: copy this folder to <repo>/.audit-tools/ and adapt the "Repo settings" below
# (or set them as env vars). Install the pinned tool versions listed in README.md.
#
# Usage (from anywhere inside the repo):
#   .audit-tools/audit-run.sh                 # all steps
#   .audit-tools/audit-run.sh go tests        # only some steps
# Steps: go tests terraform actions shell make yaml openapi docs secrets
#
# Safety:
# - Scans a throwaway clone of HEAD (uncommitted changes are NOT scanned).
#   The repo itself is never written to, except audit-out/.
# - Cloud, GitHub and Terraform credentials are removed from every tool's environment.
# - Private Terraform modules are fetched over SSH (your ssh-agent), via env-scoped git config.
# - Missing tools are skipped and listed in the summary.
set -uo pipefail # no -e: keep going when a tool fails, record its exit code

# --- Repo settings (adapt per repo) ---------------------------------------------------
GO_DIR="${GO_DIR:-app}"                        # folder with go.mod
TF_DIR="${TF_DIR:-terraform}"                  # Terraform root module
SPEC_DIR="${SPEC_DIR:-$TF_DIR/swaggers}"       # OpenAPI specs
read -ra SH_FILES <<< "${SH_FILES:-build.sh}"  # shell scripts to check
read -ra MAKE_VERIFY <<< "${MAKE_VERIFY:-}"    # make targets that check, e.g. "verify-generated verify-tidy"
read -ra YAML_PATHS <<< "${YAML_PATHS:-.github/workflows}"
read -ra DOC_PATHS <<< "${DOC_PATHS:-README.md docs}"
PRIVATE_GIT_ORG="${PRIVATE_GIT_ORG:-}"         # e.g. my-org: fetch github.com/my-org/* over SSH
GO_BIN_DIR="${GO_BIN_DIR:-}"                   # e.g. /opt/homebrew/opt/go@1.26/bin if default go is too old
GEN_PATTERN='\.gen\.go'                        # generated code, left out of coverage

# --- Paths ------------------------------------------------------------------------------
REPO="$(git rev-parse --show-toplevel)"
TOOLS="$REPO/.audit-tools"
SHA="$(git -C "$REPO" rev-parse --short HEAD)"
BRANCH="$(git -C "$REPO" rev-parse --abbrev-ref HEAD)"
OUT="$REPO/audit-out/runs/$(date -u +%Y%m%dT%H%M%SZ)-$SHA"
mkdir -p "$OUT"
ln -sfn "$OUT" "$REPO/audit-out/latest"

export PATH="${GO_BIN_DIR:+$GO_BIN_DIR:}$TOOLS/bin:$HOME/go/bin:$HOME/.local/bin:$PATH"
export GOTOOLCHAIN=local

ALL_STEPS="go tests terraform actions shell make yaml openapi docs secrets"
STEPS="${*:-$ALL_STEPS}"
want() { [[ " $STEPS " == *" $1 "* ]]; }

# --- Safety: run tools without credentials ---------------------------------------------
safe() {
  local unset_args=()
  for v in TF_TOKEN_app_terraform_io ARTIFACTORY_ACCESS_TOKEN GITHUB_TOKEN GH_TOKEN \
           AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_PROFILE; do
    unset_args+=(-u "$v")
  done
  while IFS='=' read -r name _; do
    [[ $name == SAML2AWS_* ]] && unset_args+=(-u "$name")
  done < <(env)
  env "${unset_args[@]}" AWS_CONFIG_FILE=/dev/null AWS_SHARED_CREDENTIALS_FILE=/dev/null "$@"
}
# https://github.com/<org>/... -> SSH, only for commands that fetch private modules
GIT_SSH_ENV=()
if [[ -n $PRIVATE_GIT_ORG ]]; then
  GIT_SSH_ENV=(GIT_CONFIG_COUNT=1 "GIT_CONFIG_KEY_0=url.git@github.com:$PRIVATE_GIT_ORG/.insteadOf"
               "GIT_CONFIG_VALUE_0=https://github.com/$PRIVATE_GIT_ORG/")
fi

# --- Throwaway clone of HEAD -----------------------------------------------------------
SCRATCH="$(mktemp -d -t audit-scratch.XXXXXX)"
trap 'rm -rf "$SCRATCH"' EXIT
git clone --quiet --no-hardlinks "$REPO" "$SCRATCH/repo"
git -C "$SCRATCH/repo" checkout --quiet --detach "$SHA"
W="$SCRATCH/repo"

# --- Step runner -----------------------------------------------------------------------
SUMMARY="$OUT/RUN-SUMMARY.md"
{
  echo "# Audit run, $(date -u '+%Y-%m-%d %H:%M UTC')"
  echo
  echo "- Repo: $(basename "$REPO"), branch \`$BRANCH\`, commit \`$SHA\` (clean clone of HEAD)"
  have_go=$(command -v go >/dev/null && go version | awk '{print $3}')
  echo "- Go: ${have_go:-not installed}, GOTOOLCHAIN=local"
  echo
  echo "| Step | Tool | Exit | Seconds | Output | Note |"
  echo "|---|---|---|---|---|---|"
} > "$SUMMARY"

# run <step> <label> <output-file> <command...>   (stdout+stderr -> output file)
run() {
  local step=$1 label=$2 outfile=$3; shift 3
  local start rc
  start=$(date +%s)
  echo "▶ [$step] $label"
  "$@" > "$OUT/$outfile" 2>&1; rc=$?
  echo "| $step | $label | $rc | $(( $(date +%s) - start )) | \`$outfile\` | |" >> "$SUMMARY"
  return 0
}
skip() { echo "| $1 | $2 | – | – | – | skipped: $3 |" >> "$SUMMARY"; echo "⏭  [$1] $2: $3"; }
have() { command -v "$1" >/dev/null 2>&1; }

# --- Go --------------------------------------------------------------------------------
if want go; then
  if [[ -f "$W/$GO_DIR/go.mod" ]]; then
    cd "$W/$GO_DIR" || exit 1
    if have golangci-lint; then
      run go "golangci-lint (curated)" golangci.txt safe golangci-lint run ./... \
        --config "$TOOLS/golangci.yml" \
        --output.text.path stdout \
        --output.json.path "$OUT/golangci.json" \
        --output.sarif.path "$OUT/golangci.sarif"
    else skip go golangci-lint "not installed"; fi
    if have govulncheck; then
      run go govulncheck govulncheck.txt safe govulncheck ./...
      run go "govulncheck (sarif)" govulncheck.sarif safe govulncheck -format sarif ./...
    else skip go govulncheck "not installed"; fi
    if have osv-scanner; then
      run go osv-scanner osv-scanner.txt safe osv-scanner scan source --lockfile go.mod
    else skip go osv-scanner "not installed"; fi
    if have deadcode; then run go deadcode deadcode.txt safe deadcode ./...
    else skip go deadcode "not installed"; fi
    if have nilaway; then run go "nilaway (leads only)" nilaway.txt safe nilaway ./...
    else skip go nilaway "not installed"; fi
    run go "go fix -diff" go-fix.diff safe go fix -diff ./...
    run go "go vet" go-vet.txt safe go vet ./...
  else skip go all "no $GO_DIR/go.mod"; fi
fi

# --- Tests -----------------------------------------------------------------------------
if want tests; then
  if [[ -f "$W/$GO_DIR/go.mod" ]]; then
    cd "$W/$GO_DIR" || exit 1
    run tests "go test -race -shuffle -coverpkg" go-test.json safe go test ./... \
      -race -shuffle=on -count=1 -covermode=atomic -coverpkg=./... \
      -coverprofile="$OUT/cover.out" -json
    if [[ -s "$OUT/cover.out" ]]; then
      run tests "coverage by func" cover-func.txt go tool cover -func="$OUT/cover.out"
      grep -Ev "${GEN_PATTERN}:" "$OUT/cover.out" > "$OUT/cover-nogen.out"
      run tests "coverage excl. generated" cover-func-nogen.txt go tool cover -func="$OUT/cover-nogen.out"
    fi
  else skip tests all "no $GO_DIR/go.mod"; fi
fi

# --- Terraform -------------------------------------------------------------------------
if want terraform; then
  if [[ -d "$W/$TF_DIR" ]] && have terraform; then
    cd "$W/$TF_DIR" || exit 1
    run terraform "terraform fmt -check" terraform-fmt.txt terraform fmt -check -recursive -diff
    run terraform "terraform init -backend=false" terraform-init.txt \
      safe env ${GIT_SSH_ENV[@]+"${GIT_SSH_ENV[@]}"} terraform init -backend=false -input=false
    run terraform "terraform validate" terraform-validate.json terraform validate -json
    if have tflint; then
      run terraform "tflint --init" tflint-init.txt safe tflint --init --config "$TOOLS/tflint.hcl"
      run terraform "tflint + aws ruleset" tflint.sarif safe tflint --config "$TOOLS/tflint.hcl" --format sarif
    else skip terraform tflint "not installed"; fi
    if have checkov; then
      mkdir -p "$OUT/checkov-terraform"
      run terraform "checkov terraform (with modules)" checkov-terraform.txt \
        safe env ${GIT_SSH_ENV[@]+"${GIT_SSH_ENV[@]}"} checkov -d . --framework terraform \
        --download-external-modules true --compact --quiet \
        -o cli -o json -o sarif --output-file-path "$OUT/checkov-terraform"
    else skip terraform checkov "not installed"; fi
  else skip terraform all "no $TF_DIR/ or terraform not installed"; fi
fi

# --- GitHub Actions --------------------------------------------------------------------
if want actions; then
  cd "$W" || exit 1
  if [[ -d .github/workflows ]]; then
    if have actionlint; then run actions actionlint actionlint.txt safe actionlint
    else skip actions actionlint "not installed"; fi
    if have zizmor; then
      run actions "zizmor --offline (auditor)" zizmor.txt safe zizmor --offline --persona=auditor .github/workflows
      run actions "zizmor (sarif)" zizmor.sarif safe zizmor --offline --persona=auditor --format sarif .github/workflows
    else skip actions zizmor "not installed"; fi
    if have checkov; then
      mkdir -p "$OUT/checkov-gha"
      run actions "checkov github_actions" checkov-gha.txt safe checkov -d . \
        --framework github_actions --compact --quiet \
        -o cli -o sarif --output-file-path "$OUT/checkov-gha"
    fi
  else skip actions all "no .github/workflows"; fi
fi

# --- Shell -----------------------------------------------------------------------------
if want shell; then
  cd "$W" || exit 1
  if have shellcheck; then run shell shellcheck shellcheck.txt shellcheck "${SH_FILES[@]}"
  else skip shell shellcheck "not installed"; fi
  if have shfmt; then run shell "shfmt -d" shfmt.diff shfmt -d "${SH_FILES[@]}"
  else skip shell shfmt "not installed"; fi
fi

# --- Makefile --------------------------------------------------------------------------
if want make; then
  if [[ -f "$W/$GO_DIR/Makefile" ]]; then
    cd "$W/$GO_DIR" || exit 1
    run make "make -n" make-n.txt make -n
    for t in ${MAKE_VERIFY[@]+"${MAKE_VERIFY[@]}"}; do
      run make "make $t" "make-$t.txt" safe make "$t"
    done
    if have checkmake; then run make checkmake checkmake.txt checkmake Makefile
    else skip make checkmake "not installed"; fi
  else skip make all "no $GO_DIR/Makefile"; fi
fi

# --- YAML / config ---------------------------------------------------------------------
if want yaml; then
  cd "$W" || exit 1
  if have yamllint; then
    run yaml yamllint yamllint.txt yamllint -f parsable "${YAML_PATHS[@]}"
  else skip yaml yamllint "not installed"; fi
  if have check-jsonschema && compgen -G ".github/workflows/*.yml" >/dev/null; then
    run yaml "check-jsonschema workflows" check-jsonschema-workflows.txt \
      check-jsonschema --builtin-schema vendor.github-workflows .github/workflows/*.yml
  else skip yaml check-jsonschema "not installed or no workflows"; fi
fi

# --- OpenAPI ---------------------------------------------------------------------------
if want openapi; then
  cd "$W" || exit 1
  if [[ -d $SPEC_DIR ]]; then
    mkdir -p "$OUT/openapi"
    while IFS= read -r spec; do
      name=$(basename "$spec")
      have validate && run openapi "kin-openapi validate $name" "openapi/kin-$name.txt" validate "$spec"
      have vacuum && run openapi "vacuum (OWASP) $name" "openapi/vacuum-$name.txt" \
        vacuum lint -r "$TOOLS/vacuum-ruleset.yaml" -d "$spec"
    done < <(find "$SPEC_DIR" -type f \( -name '*.yaml' -o -name '*.yml' -o -name '*.json' \) | sort)
  else skip openapi all "no $SPEC_DIR/"; fi
fi

# --- Docs ------------------------------------------------------------------------------
if want docs; then
  cd "$W" || exit 1
  if have npx; then
    run docs markdownlint-cli2 markdownlint.txt npx --yes markdownlint-cli2@0.23.3 "*.md" "docs/**/*.md"
  else skip docs markdownlint "npx not installed"; fi
  if [[ -f mkdocs.yml ]] && have mkdocs; then
    run docs "mkdocs build --strict" mkdocs-build.txt mkdocs build --strict --site-dir "$SCRATCH/site"
  else skip docs mkdocs "no mkdocs.yml or not installed"; fi
  if have lychee; then
    run docs "lychee links" lychee.txt safe lychee --no-progress "${DOC_PATHS[@]}"
  else skip docs lychee "not installed"; fi
fi

# --- Secrets (full git history) --------------------------------------------------------
if want secrets; then
  if have trufflehog; then
    run secrets "trufflehog git history" trufflehog.json \
      safe trufflehog git "file://$W" --json --no-update
  else skip secrets trufflehog "not installed"; fi
fi

# --- Quick counts ----------------------------------------------------------------------
{
  echo
  echo "## Quick counts"
  if [[ -s "$OUT/golangci.json" ]]; then
    echo "- golangci-lint issues: $(jq '.Issues | length' "$OUT/golangci.json" 2>/dev/null)"
    echo "  - by linter: $(jq -r '[.Issues[].FromLinter] | group_by(.) | map("\(.[0]) \(length)") | join(", ")' "$OUT/golangci.json" 2>/dev/null)"
  fi
  if [[ -s "$OUT/go-test.json" ]]; then
    echo "- tests: pass $(jq -s '[.[] | select(.Action=="pass" and .Test)] | length' "$OUT/go-test.json" 2>/dev/null), fail $(jq -s '[.[] | select(.Action=="fail" and .Test)] | length' "$OUT/go-test.json" 2>/dev/null)"
  fi
  [[ -s "$OUT/cover-func-nogen.txt" ]] && echo "- coverage excl. generated: $(tail -1 "$OUT/cover-func-nogen.txt" | awk '{print $NF}')"
  [[ -s "$OUT/deadcode.txt" ]] && echo "- deadcode: $(grep -c . "$OUT/deadcode.txt") unreachable funcs"
  [[ -s "$OUT/trufflehog.json" ]] && echo "- trufflehog findings: $(grep -c '"SourceMetadata"' "$OUT/trufflehog.json")"
  echo
  echo "## Not done by this script"
  echo "- Terraform plan-JSON scans (need the remote backend, e.g. Terraform Cloud)."
  echo "- zizmor online audits and environment protection checks (need a GitHub token)."
} >> "$SUMMARY"

# --- Guard: the repo must be untouched -------------------------------------------------
if [[ -n "$(git -C "$REPO" status --porcelain)" ]]; then
  echo "⚠️  git status is not clean in the repo. Check what changed." | tee -a "$SUMMARY"
fi

echo
echo "Done. Summary: $SUMMARY"
echo "Latest run is linked at audit-out/latest/"

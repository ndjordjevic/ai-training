# Audit kit

Step 1 of "Auditing an existing repo" in [our-sdlc.md](../our-sdlc.md): the exact tools, run by one script, with no AI and no tokens. Its output is what the AI audit reads next. Later this becomes part of our own audit skill.

Built from our first real audit (a Go + Terraform service on AWS). A full run took about 2.5 minutes.

## Files

- `audit-run.sh`: runs every tool on a throwaway clone of the repo and writes `audit-out/runs/<date>-<sha>/RUN-SUMMARY.md`, plus an `audit-out/latest` link.
- `golangci.yml`: curated Go linters that find bugs, not style. It cut the lint run from 6.5 minutes to 5 seconds.
- `tflint.hcl`: TFLint with all Terraform rules and the AWS ruleset.
- `vacuum-ruleset.yaml`: OpenAPI lint with the OWASP rules.

## Set up in a repo

1. Copy this folder to `<repo>/.audit-tools/` and make the script executable.
2. Keep it out of git if it's only for you: add `.audit-tools/` and `audit-out/` to `.git/info/exclude`.
3. Adapt the "Repo settings" at the top of the script, or set them as env vars:
   - `GO_DIR` (folder with `go.mod`), `TF_DIR`, `SPEC_DIR` (OpenAPI specs)
   - `SH_FILES`, `MAKE_VERIFY` (for example `"verify-generated verify-tidy"`), `YAML_PATHS`, `DOC_PATHS`
   - `PRIVATE_GIT_ORG`: your GitHub org, so private Terraform modules come over SSH
   - `GO_BIN_DIR`: only if your default `go` is older than the repo needs
4. Install the tools below. Missing tools are skipped and listed in the summary.

## Run

```sh
.audit-tools/audit-run.sh              # all steps
.audit-tools/audit-run.sh go tests     # only some
```

Steps: `go tests terraform actions shell make yaml openapi docs secrets`.

## Tool versions (pinned)

Never use "latest". Trivy and KICS were both hacked in 2026, so they are not used at all. Avoid releases only 1 or 2 days old.

| Install with | Tools |
|---|---|
| `go install` | golangci-lint v2.14.0, govulncheck v1.1.4, deadcode (golang.org/x/tools) v0.51.0, nilaway (pin a commit), tflint v0.64.0, shfmt v3.14.1, checkmake v0.3.2, vacuum v0.30.6, kin-openapi `cmd/validate` v0.133.0, actionlint v1.7.12 |
| `pipx` | zizmor 1.30.1, checkov 3.3.21, yamllint 1.38.0, check-jsonschema 0.38.2, mkdocs-techdocs-core 1.7.1 (only for Backstage docs) |
| Release binary, checksum checked | trufflehog v3.97.9, osv-scanner v2.6.0, lychee v0.24.2 (put in `.audit-tools/bin/`) |
| Other | markdownlint-cli2 0.23.3 (via `npx`), tflint-ruleset-aws 0.49.0 (via `tflint --init`), shellcheck, terraform, jq |

## How it is built (worth copying)

- **Keeps going when a tool fails.** Every tool's exit code and time go into the summary.
- **No credentials.** `safe()` removes AWS, GitHub and Terraform tokens from each tool's environment.
- **Repo untouched.** Tools run on a throwaway clone. A final check warns if `git status` is not clean.
- **AI-ready output.** SARIF and JSON files, so the AI audit looks beyond the lint results instead of finding them again.
- **Not covered:** Terraform plan scans (need the remote backend) and zizmor's online checks (need a GitHub token).

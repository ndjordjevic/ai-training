#!/usr/bin/env bash
# One row per open ticket in this repo: worktree, branch, flow step, PR, deployed or not, waiting on, file overlap with other open PRs.
# Read only. Run from the main checkout or any worktree. Usage: board.sh [deploy workflow file, e.g. wf-deploy.yml]
set -uo pipefail
wf="${1:-}"
top=$(git rev-parse --show-toplevel) || exit 1
cd "$top" || exit 1
skills="$(cd "$(dirname "$0")/../.." && pwd)"
git fetch -q origin 2>/dev/null || echo "(fetch failed: refs may be old)"

# last successful deploy: branch and commit
dep_sha=""; dep_line="no deploy workflow given"
if [ -n "$wf" ]; then
  read -r dep_branch dep_sha dep_time < <(gh run list --workflow "$wf" --status success -L 1 \
    --json headBranch,headSha,updatedAt -q '.[0] | "\(.headBranch) \(.headSha) \(.updatedAt)"' 2>/dev/null)
  dep_line="last successful $wf: ${dep_branch:-?} ${dep_sha:0:7} at ${dep_time:-?}"
fi
echo "$dep_line"
echo

prs=$(gh pr list --state open -L 100 --json number,headRefName,baseRefName,isDraft -q '.[] | "\(.headRefName) \(.number) \(.baseRefName) \(.isDraft)"' 2>/dev/null)

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
git worktree list --porcelain | awk '/^worktree /{w=substr($0,10)} /^branch /{sub("refs/heads/","",$2); print $2 "\t" w}' |
while IFS=$'\t' read -r br wt; do
  key=$(grep -oE '[A-Z][A-Z0-9]+-[0-9]+' <<<"$br" | head -1)
  [ -z "$key" ] && continue
  pr=$(awk -v b="$br" '$1==b {print "#"$2" -> "$3 ($4=="true" ? " (draft)" : "")}' <<<"$prs")
  base=$(awk -v b="$br" '$1==b {print $3}' <<<"$prs")
  head=$(git -C "$wt" rev-parse HEAD)
  dirty=$(git -C "$wt" status --porcelain | grep -vc '^??')
  ahead=$(git -C "$wt" rev-list --count "@{u}..HEAD" 2>/dev/null || echo "no upstream")
  deployed="n/a"
  [ -n "$wf" ] && deployed="no"
  if [ -n "$dep_sha" ] && git merge-base --is-ancestor "$head" "$dep_sha" 2>/dev/null; then deployed="yes"; fi
  st=$( cd "$wt" && "$skills/sdlc-ticket/scripts/status.sh" "$key" 2>/dev/null )
  step=$(grep -m1 -E '^(intake|plan|build|review|verify): not done' <<<"$st" | cut -d: -f1)
  plan=$(ls "$wt"/.plans/"$key"-*.md 2>/dev/null | head -1)
  waits=""
  [ -n "$plan" ] && waits=$(grep -ioE 'waiting on:[^.;(]*' "$plan" | grep -viE 'waiting on: *(nothing|none)' | cut -c1-110 | sort -u | head -3)

  echo "$key  $br  ($wt)"
  echo "  pr: ${pr:-none}   deployed: $deployed   uncommitted: $dirty   unpushed: $ahead"
  echo "  next step: ${step:-all done}"
  [ -n "$waits" ] && sed 's/^/  /' <<<"$waits"
  if [ -n "$base" ]; then
    git diff --name-only "origin/$base...$head" 2>/dev/null | sort > "$tmp/$key"
  else
    # no PR: the base the intent records ("Base: <ref> ..."), else origin/HEAD
    ib=$(grep -m1 -oE '^ *Base: *[^ (,]+' <<<"$st" | sed -E 's/^ *Base: *//; s/[.]$//')
    for ref in "$ib" "origin/$ib" origin/HEAD; do
      [ -n "${ref#origin/}" ] && git rev-parse -q --verify "$ref^{commit}" >/dev/null 2>&1 && break
      ref=""
    done
    [ -n "$ref" ] && git diff --name-only "$ref...$head" 2>/dev/null | sort > "$tmp/$key"
  fi
done

# file overlap between open ticket branches
echo
echo "overlap (files changed by more than one open branch):"
found=0
for a in "$tmp"/*; do
  [ -e "$a" ] || continue
  for b in "$tmp"/*; do
    [[ "$a" < "$b" ]] || continue
    all=$(comm -12 "$a" "$b"); n=$(grep -c . <<<"$all")
    common=$(head -5 <<<"$all" | paste -sd ',' -)
    [ "$n" -gt 5 ] && common="$common,… ($n files)"
    [ -n "$common" ] && { echo "  ${a##*/} + ${b##*/}: $common"; found=1; }
  done
done
if [ $found -eq 0 ]; then echo "  none"; fi

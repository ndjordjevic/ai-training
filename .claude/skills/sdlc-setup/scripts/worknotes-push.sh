#!/usr/bin/env bash
# Commit and push this repo's worknotes folder only. Run from the work repo (or its worktree).
# Usage: worknotes-push.sh "<message>"
set -euo pipefail
msg="${1:?usage: worknotes-push.sh \"<message>\"}"
for link in .intent .plans .verify; do [ -L "$link" ] && break; done
[ -L "$link" ] || { echo "no worknotes links here" >&2; exit 1; }
folder=$(cd -P "$link" && cd .. && pwd)
repo=$(git -C "$folder" rev-parse --show-toplevel)
here=$(git rev-parse --show-toplevel 2>/dev/null || true)
[ "$repo" != "$here" ] || { echo "the links point into this repo, not a worknotes repo: $folder" >&2; exit 1; }
cd "$repo"
git add -A -- "$folder"
if git diff --cached --quiet; then echo "nothing to commit"; else git commit -q -m "$msg"; fi
git pull -q --rebase || { git rebase --abort 2>/dev/null; echo "pull failed: fix by hand in $repo" >&2; exit 1; }
git push -q && echo "pushed: $(git log --oneline -1)"

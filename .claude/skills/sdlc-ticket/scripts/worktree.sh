#!/usr/bin/env bash
# Create a worktree for a ticket and copy the main checkout's top-level links (worknotes) into it.
# Run from the main checkout. Usage: worktree.sh <base> <new branch> <folder>
set -euo pipefail
base="${1:?usage: worktree.sh <base> <new branch> <folder>}"; branch="${2:?}"; folder="${3:?}"
top=$(git rev-parse --show-toplevel)

git rev-parse --verify -q "$base^{commit}" >/dev/null || { echo "base not found: $base" >&2; exit 1; }
if git show-ref --verify -q "refs/heads/$branch"; then echo "branch already exists: $branch" >&2; exit 1; fi
[ -e "$folder" ] && { echo "folder already exists: $folder" >&2; exit 1; }

git worktree add -q -b "$branch" "$folder" "$base"
folder=$(cd "$folder" && pwd -P)

for link in "$top"/.[!.]* "$top"/*; do
  [ -L "$link" ] || continue
  name=$(basename "$link"); target=$(readlink "$link")
  case "$target" in /*) ;; *) target="$top/$target" ;; esac
  [ -e "$folder/$name" ] || [ -L "$folder/$name" ] || ln -s "$target" "$folder/$name"
  git -C "$folder" check-ignore -q "$name" || echo "warning: $name is not ignored by git"
done

echo "worktree: $folder"
echo "branch: $branch (from $base at $(git rev-parse --short "$base")), not pushed"
echo "links: $(find "$folder" -maxdepth 1 -type l | wc -l | tr -d ' ')"

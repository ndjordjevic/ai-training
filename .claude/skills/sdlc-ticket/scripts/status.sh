#!/usr/bin/env bash
# Show which steps of the flow are done for a ticket. Run from the work repo (or its worktree).
# Usage: status.sh <ticket key>
set -uo pipefail
key="${1:?usage: status.sh <ticket key>}"

first() { ls $1 2>/dev/null | grep -v -- '-sources\.md$' | head -1; }
intent=$(first ".intent/$key-*.md")
plan=$(first ".plans/$key-*.md")
checks=$(first ".verify/$key-*.md")

echo "Ticket: $key"
if [ -z "$intent" ]; then echo "intake: not done (no intent)"; exit 0; fi
echo "intake: done ($intent)"
grep -m3 -E '^(Base|Branch|Worktree):' "$intent" | sed 's/^/  /'

if [ -z "$plan" ]; then echo "plan: not done (no plan)"; exit 0; fi
echo "plan: $(grep -m1 -i '^Status:' "$plan" | cut -c1-160 || echo 'no Status line') ($plan)"

for step in build review verify; do
  if grep -q -i "flow: $step done" "$plan"; then echo "$step: done"; else echo "$step: not done"; fi
done
pr=$(grep -o -m1 -E 'https://github\.com/[^ )]+/pull/[0-9]+' "$plan" || true)
echo "pr: ${pr:-not opened}"
[ -n "$checks" ] && echo "checks file: $checks" || echo "checks file: none"

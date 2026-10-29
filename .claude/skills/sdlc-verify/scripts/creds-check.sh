#!/usr/bin/env bash
# Check an AWS credentials file without printing its values: line count, file mode, and one identity call.
# Usage: creds-check.sh <credentials file>
set -uo pipefail
file="${1:?usage: creds-check.sh <credentials file>}"
[ -f "$file" ] || { echo "missing: $file"; exit 1; }
echo "export AWS_ lines: $(grep -c '^export AWS_' "$file")"
mode=$(stat -f %Lp "$file" 2>/dev/null || stat -c %a "$file")
echo "file mode: $mode$([ "$mode" = 600 ] || echo ' (should be 600)')"
out=$( (set -a; source "$file"; aws sts get-caller-identity --query Arn --output text) 2>&1 )
if [[ "$out" == arn:* ]]; then
  account=$(cut -d: -f5 <<<"$out"); role=$(cut -d/ -f2 <<<"$out")
  echo "ok: account $account, role $role"
else
  echo "not working: $(grep -o -m1 -E '\(([A-Za-z]+)\)' <<<"$out" || echo 'see aws error')"; exit 1
fi

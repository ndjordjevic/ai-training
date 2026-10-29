#!/usr/bin/env bash
# Download every attachment of a ticket, its parent and the parent's parent, its subtasks and linked
# tickets, and of the Confluence pages given. Prints one line per file; never prints the token.
# Usage: attachments.sh <site, e.g. https://x.atlassian.net> <credentials file> <out dir> <ticket key> [page id ...]
# The credentials file sets JIRA_EMAIL and JIRA_TOKEN (or CF_EMAIL and CF_TOKEN).
set -euo pipefail
site="${1:?usage}"; creds="${2:?}"; out="${3:?}"; key="${4:?}"; shift 4
# shellcheck disable=SC1090
source "$creds"
email="${JIRA_EMAIL:-${CF_EMAIL:-}}"; token="${JIRA_TOKEN:-${CF_TOKEN:-}}"
[ -n "$email" ] && [ -n "$token" ] || { echo "no email or token in $creds" >&2; exit 1; }
api() { printf 'user = "%s:%s"\n' "$email" "$token" | curl -sS -f -L -m 60 -K - "$@"; }
mkdir -p "$out"

issue() { api "$site/rest/api/3/issue/$1?fields=attachment,parent,subtasks,issuelinks"; }
main=$(issue "$key")
keys="$key"
parent=$(jq -r '.fields.parent.key // empty' <<<"$main")
if [ -n "$parent" ]; then
  keys="$keys $parent"
  epic=$(issue "$parent" | jq -r '.fields.parent.key // empty')
  [ -n "$epic" ] && keys="$keys $epic"
fi
keys="$keys $(jq -r '[.fields.subtasks[]?.key, (.fields.issuelinks[]? | (.inwardIssue.key // .outwardIssue.key))] | join(" ")' <<<"$main")"

seen=""
save() { # where id name mime size url
  local dir="$out/$1" file
  mkdir -p "$dir"; file="$dir/$2-$(tr '/' '_' <<<"$3")"
  [ -s "$file" ] || api -o "$file" "$6"
  sum=$(shasum -a 256 "$file" | cut -d' ' -f1)
  dup=$(grep -m1 "^$sum " <<<"$seen" | cut -d' ' -f2- || true)
  seen="$seen"$'\n'"$sum $file"
  printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$1" "$3" "$4" "$5" "$file" "${dup:+same as $dup}"
}

printf 'where\tname\ttype\tsize\tfile\tnote\n'
for k in $keys; do
  issue "$k" | jq -r '.fields.attachment[]? | [.id, .filename, .mimeType, (.size|tostring), .content] | @tsv' |
  while IFS=$'\t' read -r id name mime size url; do save "$k" "$id" "$name" "$mime" "$size" "$url"; done
done
for page in "$@"; do
  api "$site/wiki/api/v2/pages/$page/attachments?limit=100" |
  jq -r '.results[] | [.id, .title, .mediaType, (.fileSize|tostring), .downloadLink] | @tsv' |
  while IFS=$'\t' read -r id name mime size link; do save "page-$page" "$id" "$name" "$mime" "$size" "$site/wiki$link"; done
done

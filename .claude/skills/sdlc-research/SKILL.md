---
name: sdlc-research
description: Find the docs and tickets related to a piece of work - the pages around the linked ones, a search of the same spaces, exact-key searches across the site - and save them to one sources file that later steps reuse. Intake runs these steps itself; run it on its own before there's a ticket, or to add a new lead mid-ticket.
disable-model-invocation: true
argument-hint: "<ticket key, or terms to search> [extra lead: page link, term or question]"
allowed-tools:
  - Bash(${CLAUDE_SKILL_DIR}/scripts/attachments.sh *)
  - Bash(python3 -I ${CLAUDE_SKILL_DIR}/scripts/office2text.py *)
---

# Research: find the related docs once, save them

Input: $ARGUMENTS

Design pages, mapping pages and older tickets are often not linked to the ticket. Find them once and save them, so later sessions read the file instead of searching again.

## Rules

- **Read only.** Never post, edit, comment or watch anything.
- **Access:** the Jira and Confluence tools the instruction file names. If one can't do something (search, attachments, page trees), use the other way it gives, such as the REST API. Never paste tokens into the chat or the file.
- **Narrow first.** Walk the pages around what is linked, then search the same spaces, and search the whole site only for exact, rare strings (ticket keys, API paths, system names). Never search common words across the whole site.
- **Titles first.** Read search results as titles and excerpts. Open a full page only when it looks relevant: about 5 to 15 pages per ticket.
- **Never guess.** Quote rules and values exactly, with the page and version. If two pages disagree, say which is newer.
- **Keep the intent current.** If a source shows the intent is wrong or out of date, fix it without asking and list what you changed. Never change the plan or code; say what may need to change.
- **Read every attachment.** From the ticket, its parent and epic, subtasks and linked tickets, and the pages you cite. Download them with `scripts/attachments.sh <site> <credentials file> <scratch folder> <ticket key> [page id ...]` (next to this file; the site and credentials file are in the instruction file). It gets the ticket's, its parent's and epic's, subtasks' and linked tickets' files, and the pages' you give, into a scratch folder outside any repo, and marks files with the same content. Then read each: PDFs and images directly; Excel, Word and PowerPoint files with `python3 -I scripts/office2text.py <file>`; text, CSV and JSON as they are. Images in descriptions and comments are attachments too. If one can't be read, list it as "not read" with the reason. If two files have the same content, read one and say so. Never commit the files.
- **Plain, short English** in the file and the report.

## 0. Resume or start

If `.intent/<ticket key>-sources.md` exists, read it first. Check each listed page's version and each ticket's last-updated time. Re-read only what changed, and skip searches listed under "Searched, nothing found" unless the input adds a new lead.

## 1. Collect the leads

From the ticket, its parent and epic (the epic may be the parent's parent), subtasks and linked items (read them if intake hasn't):
- **Pages:** every linked page, including links in descriptions and comments, with its id and space.
- **Keys:** the ticket, epic, subtask and linked keys, plus ticket keys found in descriptions and comments.
- **Attachments:** every file on these tickets, with its id, name, type and size.
- **Other links:** any other URL in descriptions and comments (repo, API spec, document). Read it if it can be reached; if not, list it in the sources file.
- **Terms:** the epic name, the feature's main nouns, system and API names, field names. Note other words for the same thing (from `GLOSSARY.md`, if it exists).

## 2. Search

Run these leads. In a tool with subagents, run them in parallel, read only, on the cheapest model (in Claude Code, `haiku`), since step 3 checks every hit: one subagent per lead line, each given the leads, the access commands from the instruction file and the report format below. Do it in this session when the searches are few (for example, one or two linked pages and a handful of terms), and say which you chose.

1. **Around each linked page:** its parents, its siblings (the parent's children) and its children. Check its version history if it looks cut down. Older pages often hold rules the newer ones dropped.
   - Confluence Cloud REST, for example: `/wiki/rest/api/content/<id>?expand=ancestors,version`, `/wiki/api/v2/pages/<id>/children`.
2. **Same spaces, by terms:** a search limited to the spaces of the linked pages, newest first.
   - CQL, for example: `/wiki/rest/api/search?cql=space in (<KEY1>,<KEY2>) AND text ~ "<term>" ORDER BY lastmodified DESC&limit=25`.
3. **Whole site, exact strings only:** ticket keys, API paths, rare system names, for example `text ~ "<ticket key>"`.
4. **Jira:** the epic's other tickets, and tickets that explain a term, setting or acronym the ticket uses but doesn't explain. Search by the terms, for example JQL `text ~ "<term>" ORDER BY updated DESC`.

Stop a search line when its hits stop being about this work.

Attachments: read each one yourself (see Rules), and quote the rules, values and test cases it holds.

Each subagent reports, per hit: title, link, id, version or last-updated time, one line on why it matters, and the exact rules or values it holds, quoted. Plus what it searched with no useful hits. A subagent that fails or returns nothing: retry once, then list its lead as "not searched". Never count it as no hits.

## 3. Check

Check each hit yourself: open the page or ticket and confirm it is about this work and the quotes are exact. Drop the rest. Agents give a reason a page matters; you decide.

## 4. Save

Write `.intent/<ticket key>-sources.md` (or `.intent/<short-name>-sources.md` without a ticket), using `sources-template.md` next to this file. Add new entries to an existing file; don't rewrite it. Commit and push the worknotes repo (`sdlc-setup/scripts/worknotes-push.sh "<message>"`).

## 5. Report

Start with 3 to 5 lines: how many pages and tickets were kept, and the findings that matter, most important first. Then, short:
- **Pages that disagree,** and which is newer.
- **Rules the ticket doesn't mention.**
- **Fixes to the intent.**
- **If the plan or code already exists:** which findings may change them, with the task or file. The plan's next refresh (or the review) decides; don't change them here.

Details stay in the file, not the report.

## Done when

- Every lead was walked or searched, or listed with why not.
- Every kept entry has a link, a version or time, and a reason.
- The sources file is saved and the worknotes repo is pushed.

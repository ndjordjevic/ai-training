---
name: sdlc-catchup
description: Catch up on a ticket you already worked on - find what is new since you last looked (comments, attachments, status, linked tickets, new versions of its docs, new files in shared folders), check each point against the code, and sum up the changes it would need, the open points and the other tickets it affects. Saves the summary to the repo's notes. Never changes code or posts. Use when a ticket you built gets new comments, test results or spec updates.
disable-model-invocation: true
argument-hint: "<ticket key> [since <date>] [note]"
allowed-tools:
  - Bash(${CLAUDE_SKILL_DIR}/../sdlc-research/scripts/attachments.sh *)
  - Bash(python3 -I ${CLAUDE_SKILL_DIR}/../sdlc-research/scripts/office2text.py *)
  - Bash(${CLAUDE_SKILL_DIR}/../sdlc-setup/scripts/worknotes-push.sh *)
---

# Catch-up: what's new on a ticket, and what it means for the code

Input: $ARGUMENTS

The first word is the ticket key. `since <date>` sets the start; otherwise it starts from the last catch-up. Any other text is the engineer's note (for example "focus on the QA test results").

## Rules

- **Read only.** No code changes, no branches, no posts. The only file it writes is the catch-up note (step 5), after showing it.
- **New first.** Report only what is new since the last check, unless the new item changes something older: then say what it changes.
- **Every point has a source:** the comment (author, date), the attachment, the page version, the file.
- **Check the code, don't assume.** Each proposed change names the file and line, from the code as it is now.
- **Plain, short English.** Explain a term the first time. The TL;DR fits in a few lines.
- **Drafts only if asked,** 2 to 4 sentences, in the engineer's voice. Post nothing.

## 1. Where to start

- **The catch-up note:** `.notes/<ticket key>-catchup.md` in the worknotes folder for this repo. Its top line holds the last check: the time, and the ids of the comments and attachments already read.
- **No note yet:** start from the engineer's last comment on the ticket, or the merge of its PR, whichever is later. Say which.
- **`since <date>`:** use that, and say so.

## 2. What's new

Read with the Jira and Confluence tools the instruction file names:

- **The ticket:** comments and attachments not in the note's list, and changes to status, assignee and fix version. Download attachments with `${CLAUDE_SKILL_DIR}/../sdlc-research/scripts/attachments.sh <site> <credentials file> <scratch folder> <ticket key>` and read the new ones: PDFs and images directly, Excel, Word and PowerPoint files with `python3 -I ${CLAUDE_SKILL_DIR}/../sdlc-research/scripts/office2text.py <file>`. A test-case sheet: list each case with its expected and actual result.
- **Around it:** subtasks, parent, and linked tickets: new comments, and status changes that matter to this ticket.
- **Its docs:** for each page in the ticket's sources file (`.intent/<ticket key>-sources.md`) or the repo's notes, the current version against the version last read. If it moved, compare the two versions and list what changed, by section.
- **Shared folders the notes name** (for example where another team drops new API specs): new files since the last check. Download one only with the engineer's OK, to a scratch folder outside any repo. Compare it field by field with the copy in the repo, and list only what affects our code.
- **The code:** commits on the ticket's files since the last check (`git log --since`), by anyone. A coworker may have changed it.

If nothing is new, say "nothing new since <time>" and stop.

## 3. Check it against the code

Find where the ticket's code is now: its open PR, or the branch it merged into. Fetch first. For each new point:

- **Already handled:** where (`file:line`), and how you checked (a test, a read of the code, a call).
- **Needs a change:** what is wrong now and what the change would be, in one or two lines, with `file:line`.
- **Not applicable or out of date:** why (for example, another team confirmed the case can't happen).
- **Waiting on someone:** the question, who can answer it, and whether it's already asked (and where).

Then look wider: which other tickets the same news affects (the same file, the same spec change), and who worked on each (by the PR's author, not the Jira assignee, who may be QA).

## 4. Report

```
<ticket key> catch-up, since <time>

TL;DR
- <the few changes that matter, one line each>

New
- <source>: <what it says, in a line>

Proposed changes
1. <change>: <why, from which source>. <file:line>
...

Already fine
- <point>: <where it's handled>

Open points
- <question>: <who can answer>

Other tickets affected
- <ticket key> (<whose>): <what changes>
```

Leave out a section with nothing in it. End with what you'd do next (wait for an answer, a new ticket, `/sdlc-qa-fix`, `/sdlc-intake` for a follow-up ticket), in one line.

## 5. Save it

Show the report, then save it as a new dated section at the top of the catch-up note, and update the note's top line (the time, the comment and attachment ids read). Add to the note; never rewrite earlier sections. Push the worknotes repo (`${CLAUDE_SKILL_DIR}/../sdlc-setup/scripts/worknotes-push.sh "<message>"`). If the engineer says not to save, skip this step and say the next run will start from the old time.

## Done when

- Every new item since the last check is read and listed with its source, or the report says nothing is new.
- Each proposed change names the code it touches; each open point names who can answer.
- The note holds the report and the new "last checked" line, and the worknotes are pushed.

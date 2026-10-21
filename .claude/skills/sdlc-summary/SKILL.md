---
name: sdlc-summary
description: Sum up a ticket's code changes in one or two plain sentences per file or group of files, and draft a comment for the ticket. Use after the review, when the work is ready to share.
disable-model-invocation: true
argument-hint: "<ticket key> [base branch]"
---

# Summary: the changes, for the ticket

Input: $ARGUMENTS

Ticket readers (the BA, QA, other developers) want to know what changed and what's still open, without reading the code. Keep it short enough to read in a minute.

## Rules

- **Read from the real diff, not from memory.**
- **Plain, short English.** One or two sentences per file or group. No code, no line numbers. Explain a term the first time if a non-developer wouldn't know it.
- **Write as the engineer** ("I added", not "we"). No recommendations unless the engineer asks.
- **Never post** without the engineer approving the exact text.

## 1. Find the diff

- The base: the one given, or the one the plan names, or the branch this one was made from (stacked branches don't start from main). Ask if unsure.
- Diff from where this branch left the base: `git diff -M --stat $(git merge-base HEAD <base>)`, then the full diff. It includes uncommitted changes.
- Read the plan (with its Build log) and the intent if they exist, for the why and what's open.

## 2. Group the files

In data-flow order: config, wiring, logic in call order, infrastructure, docs. Put each test file with the code it tests. Group files with the same kind of change (for example, "README and architecture doc: list the new Lambda").

## 3. Draft the comment

```
<one sentence: what this change does, in business terms>

Changes:
- <file or group>: <one or two sentences>
- ...

Tests: <what they cover, in one sentence>
Still open: <what waits on whom; or "nothing">
PR: <link, if there is one>
```

- Use the ticket's words for things (from the glossary and the intent).
- "Tests" says what they run against (for example, a fake server). Don't call them integration or end-to-end tests unless they are.
- "Still open" lists only real blockers and their owner, from the plan and the status block.
- If the work spans a story and its subtasks, ask which ticket gets the comment.

## 4. Post

Show the draft. Post it as a Jira comment only after the engineer approves the text, then add a Build log line with the comment id.

## Done when

- Every changed file is in a line or a group.
- The engineer has approved the text, and it's posted (or they have it to paste).

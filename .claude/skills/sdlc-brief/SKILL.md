---
name: sdlc-brief
description: Sum up a Jira ticket in plain, simple English - what needs to be done, why, what's done already, and what's unclear - from the ticket, its comments, attachments, subtasks, parent and linked tickets. Read only - writes no files, asks no questions, posts nothing. Use to understand a ticket quickly, before deciding to start it (then run sdlc-intake).
disable-model-invocation: true
argument-hint: "<ticket key> [question]"
allowed-tools:
  - Bash(${CLAUDE_SKILL_DIR}/../sdlc-research/scripts/attachments.sh *)
  - Bash(python3 -I ${CLAUDE_SKILL_DIR}/../sdlc-research/scripts/office2text.py *)
---

# Brief: what a ticket asks for, in plain English

Input: $ARGUMENTS

The first word is the ticket key. Any text after it is the engineer's question, for example "is this only the BMW endpoint?". Answer it in the brief.

## Rules

- **Read only.** Write no files in the repo or the worknotes, post nothing, and change no ticket. Downloads go to a scratch folder outside any repo.
- **Plain, simple English.** Short sentences. Explain each term or acronym the first time, in a few words.
- **Never guess.** Say where each fact comes from (the description, a comment, an attachment). If the ticket doesn't say, write "not said".
- **Newest wins.** A later comment can change what the description asks. Say when it does.
- **Short.** The whole brief fits on one screen.

## 1. Read

- **The ticket**, with the Jira tool the instruction file names: summary, status, assignee, description and every comment.
- **Attachments:** download them with `${CLAUDE_SKILL_DIR}/../sdlc-research/scripts/attachments.sh <site> <credentials file> <scratch folder> <ticket key>` (the site and credentials file are in the instruction file). Read PDFs and images directly, and Excel, Word and PowerPoint files with `python3 -I ${CLAUDE_SKILL_DIR}/../sdlc-research/scripts/office2text.py <file>`.
- **Around it:** its subtasks, its parent (and the epic above it), and its linked tickets: summary, status and the parts that change what this ticket asks. Open a linked Confluence page only if the ticket depends on it.
- **The code, a quick look:** if the session is in a repo, check whether the behaviour already exists, and which part of the code it touches. Start from `REPO-MAP.md` in the worknotes if there is one. Don't plan the work.
- **Our earlier work:** if `.intent/`, `.plans/` or `.verify/` files exist for this key, say so in one line.

## 2. Report

Use this shape. Leave out a section with nothing in it.

```
<ticket key>: <summary>. <status>, <assignee>.

What needs to be done
<two to four sentences: what changes, for whom, and why>

Done when
- <what someone can check at the end, from the ticket's acceptance criteria or their nearest wording>

Already there
- <what exists in the code or another ticket, or a claim in the ticket that isn't true>

Unclear or missing
- <a question the ticket doesn't answer, and who would know>

Around it
- <subtask, parent or linked ticket that matters, and why, one line each>

Size: <small / medium / large>, because <one reason>.
```

- **Unclear or missing:** only what would change the work. Say which source you checked.
- **Size:** a rough guess, marked as one.
- End with one line on the next step: `/sdlc-intake <ticket key>` to start it, or `/sdlc-ticket <ticket key>` to run it all.

## Done when

- The engineer has the brief, with every fact traced to its source and nothing written or posted.

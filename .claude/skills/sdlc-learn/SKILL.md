---
name: sdlc-learn
description: Learn from a finished work session - read its transcript, find where the engineer corrected the agent, where it retried, failed or was reverted, and what worked, then propose small, sourced edits to the SDLC skills and to the repo's notes and instruction file. Nothing changes until the engineer approves each edit. Also tidies a notes file (merges duplicates, flags items proved wrong or unused). Use at the end of a ticket, after a QA round, or when the same mistake shows up twice.
disable-model-invocation: true
argument-hint: "[last | <session id or .jsonl path> | tidy <notes file>] [note]"
allowed-tools:
  - Bash(python3 -I ${CLAUDE_SKILL_DIR}/scripts/transcript.py *)
  - Bash(${CLAUDE_SKILL_DIR}/../sdlc-setup/scripts/worknotes-push.sh *)
---

# Learn: from one session to better skills and notes

Input: $ARGUMENTS

Nothing given, or `last`: the newest finished session of this repo (not this one). A session id or a `.jsonl` path: that session. `tidy <file>`: go to "Tidy" below. Any text after it is the engineer's note (for example "it kept asking about the deploy").

The aim: the next session doesn't repeat this one's mistakes, and keeps what worked. Learn by small edits to the files agents read, never by rewriting them: a rewrite slowly shrinks a file into vague summaries and loses the details that made it useful.

## Rules

- **Read only until approved.** Show every edit first. Apply only the ones the engineer approves.
- **Small edits.** Each one adds, changes or removes one item (a bullet, a sentence). Never rewrite or reorder a whole file or section.
- **Every lesson has evidence:** the message number from the timeline and a short quote. No evidence, no edit.
- **Skills stay generic.** The skills folder (`${CLAUDE_SKILL_DIR}/..`) may be shared with other teams: no company, people or system names, no ticket keys, no ids. Write the rule, with a neutral example. Repo-specific facts go to the repo's notes instead.
- **No secrets.** The script masks keys and tokens. If one shows anyway, don't repeat it, and tell the engineer.
- **Plain, short English** in every edit, the same as the file around it.

## 1. Find the session

Sessions are in `~/.claude/projects/<folder>/`, where the folder is the repo's path with each `/` (and `.`) replaced by `-`. A ticket worktree has its own folder. List them:

```bash
python3 -I ${CLAUDE_SKILL_DIR}/scripts/transcript.py list <folder>
```

Pick the one asked for (by time and first message), and say which. Then read it:

```bash
python3 -I ${CLAUDE_SKILL_DIR}/scripts/transcript.py show <file> [max chars per reply]
```

It prints a numbered timeline: the engineer's messages in full, the agent's replies shortened, failed tool calls, and tool counts. For a reply you need in full, run it again with a higher limit.

Also read what the session wrote, if it worked on a ticket: the ticket's plan Build log, intent and checks files, and the PR's review comments.

## 2. Find the signals

Go through the timeline and list each of these, with its message number:

- **Corrections:** the engineer said no, cut something, reworded a draft, or said "too verbose", "I already said", "why did you".
- **Asked twice:** the engineer repeated a request, or asked "what are you doing?". The agent didn't say enough, or didn't do it.
- **Done by hand:** the engineer did a step themselves that the agent could have done.
- **Stuck:** the same command or approach failed two or more times, or a wrong claim was taken back.
- **Asked when it could look:** a question the code, the notes or the tickets could have answered.
- **Misses after the session:** a QA round, a revert, a fix after merge, a reviewer's comment (from the ticket and the PR).
- **What worked:** a step the engineer accepted at once, or praised. Keep it: a later edit must not remove it.

One signal on its own may be a one-off: say so, and propose an edit only if the cost of a repeat is high. The same signal twice (in this session, or one already in the notes) always gets an edit.

## 3. Lessons and where they go

For each signal: what went wrong, why (the instruction was missing, unclear, or there and not followed), and the smallest fix. Pick the place, in this order:

1. **A check or script** that makes the mistake impossible or catches it (a test, a lint rule, a script a skill runs).
2. **A skill**, if the lesson holds for any repo: the step where it happened, as one rule.
3. **The repo's instruction file**, if every session in this repo needs it: one line.
4. **The repo's notes** (`.notes/`, `VERIFY.md`, the glossary), for facts about this repo and its systems.

Before writing a new item, search the target file (and the other skills) for one that covers it:
- **Covered and followed:** no edit.
- **Covered but not followed:** say why (buried, vague, in another skill). Make it clearer or move it; don't add a second copy.
- **An item that proved wrong in this session:** propose to change or remove it.

## 4. Show the edits

A short list, most important first. For each: the file and section, the edit as a diff or the exact new line, the evidence (message number and quote), and one line on why. Then the signals you chose not to act on, one line each.

Wait for the engineer's answer. They may approve all, some, or reword one.

## 5. Apply

- Apply only the approved edits, exactly as approved.
- **Notes and instruction file:** add the source to the item, as `(seen in <ticket key>)`. If the item already has one, add the new key to it: the list shows how often a rule earns its place. Push the worknotes repo (`${CLAUDE_SKILL_DIR}/../sdlc-setup/scripts/worknotes-push.sh "<message>"`).
- **Skills:** edit the files, but don't commit: the skills repo is the engineer's to commit.
- End with what changed, file by file, in one line each.

## Tidy

`tidy <file>` cleans one notes or instruction file without a session. Read it whole, then propose, as in step 4:
- **Duplicates:** two items that say the same thing. Merge them, keeping every detail and every `seen in` key.
- **Proved wrong:** an item the code, a later note or a ticket now contradicts. Show the evidence.
- **Unused for long:** an item with no `seen in` key, or only old ones, about code or systems that may have changed. Check it against the code; flag it, don't delete it.
- **In the wrong place:** a rule for every repo that belongs in a skill, or a repo fact inside a skill.

Never shorten an item to save space: details are the point. Apply only what the engineer approves.

## Done when

- Every signal is either an approved edit, a rejected one, or listed as not acted on, with its evidence.
- Approved edits are in place, notes are pushed, and skill edits are left for the engineer to commit.

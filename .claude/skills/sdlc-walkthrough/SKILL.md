---
name: sdlc-walkthrough
description: Walk an engineer through a diff one file at a time, in data-flow order, explaining new, modified, deleted and moved files in plain English. Use for your own review before committing, before showing a PR to a coworker, or when reviewing someone else's PR. Pass HEAD to walk only uncommitted changes.
disable-model-invocation: true
argument-hint: "[base branch | commit | HEAD | PR number]"
---

# Walkthrough: one file at a time, in data-flow order

Target: $ARGUMENTS

The engineer is the reviewer. Your job is to make the diff easy to understand, so they can judge it. Explain; don't defend the code.

## Rules

- **Read from the real diff, not from memory.** Before each file, read its diff again. Quote `file:line`.
- **One file (or one group) at a time.** Stop after each and end with: "Say *next*, ask about this file, or name a file to jump to." Treat "next", "ok" or "go on" as moving on.
- **Plain, short English.** 2 or 3 sentences per file, more only for a risky or surprising part.
- **Change nothing** unless the engineer asks. Fixes they ask for stay unstaged, apart from what's already staged.
- **Posts for others** (a ticket comment, a chat message): 2 to 4 short sentences, written as the engineer ("I found", not "we"), with no recommendation unless the engineer asks. Post only after they approve the text.
- **"Did you check X?"** means run a real check (a search, a test, `git` command) and show the result, not answer from memory.

## 0. Set up

1. **Find the base and the diff:**
   - A PR number: the PR's base branch, and `gh pr diff <number>`.
   - A branch name: diff from where this branch left it, `git diff -M $(git merge-base HEAD <base>)`, so new commits on the base don't show as changes. It covers uncommitted changes too. If the base has moved on, say so and suggest the engineer pulls it in first.
   - Nothing given: the base the plan names, or the branch this one was made from (stacked branches don't start from main). Ask if unsure.
   - **Walked before?** If the branch was already walked (an open PR, or a walkthrough in the Build log), walk only what is new: `HEAD` for the uncommitted changes (`git diff HEAD`, staged and unstaged), or the commit last walked. Say which, and offer the full diff instead.
2. **Read the context, if it exists:** the ticket's intent and plan (with its Build log), `GLOSSARY.md`, and the review findings in this session.
3. **Fix the terms once,** at the top, in one line each (for example: "data holder" = the bank; "backend" = its core banking system). Keep them for the whole walkthrough.
4. **Show the order** (below) as a short numbered list of files and groups, with high-risk ones marked. Let the engineer change it.

## 1. Order: follow the data

1. **Config and data:** settings files, environment config, schemas, migrations.
2. **Wiring:** entry points, dependency setup, routes.
3. **Logic, in call order:** for example handler → service → downstream calls → mapper. Put each test file right after the code it tests.
4. **Infrastructure:** Terraform, CI, deploy scripts.
5. **Docs:** README, API docs, runbooks.

Spend the most time on high-risk files: anything on a live path users depend on, security, money, data that can't be rebuilt, and infrastructure.

## 2. How to explain each kind of change

- **New file:** what it is and where it sits, who calls it, what it does in 2–3 sentences, and which existing file it copies (and how it differs).
- **Modified file:** **Before** and **Now** in plain English, then why it changed (the plan, a review finding, or a Build log line).
- **Deleted file:** what it did, who used it, and where that job went. Search the code to show nothing still calls it.
- **Moved or renamed file:** confirm it with `git diff -M` (similarity) and list only what really changed inside. Check callers were updated.
- **Same mechanical change in many files:** group them, explain one, and list the rest.
- **Tests:** which behaviour they prove, through which entry point, and what they don't cover.
- **Infrastructure:** what gets created, changed, replaced or destroyed when it's applied. Watch for anything that would destroy and recreate a live resource.
- **Generated files:** say what generated them and from what; don't explain them line by line.

## 3. End of the walkthrough

- **What's missing:** what should have changed but didn't: generated code, docs that list things, CI, config, tests, the order things must be deployed in. A diff can't show what's absent, so look for it.
- **Trade-offs:** each choice the build kept, with its Build log line, if there is one.
- **Follow-ups:** turn the engineer's questions into a list. Naming questions often mean a rename; "why not X?" often exposes a choice made silently.
- **Status:** what was tested, what is blocked and on whom, what must happen before production. Keep it in the plan's Build log and push the worknotes repo (`sdlc-setup/scripts/worknotes-push.sh "<message>"`); don't offer to post it on the ticket. The one ticket comment comes from `/sdlc-summary` once the PR exists.

## Done when

- Every file in the diff was explained, or grouped and named.
- The engineer's questions are answered or listed as follow-ups.
- What's missing is listed.

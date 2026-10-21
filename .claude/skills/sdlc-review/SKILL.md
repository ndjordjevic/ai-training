---
name: sdlc-review
description: Review a ticket's build before coworkers see it - fresh AI reviewers for bugs, security and plan-vs-code, then a guided walkthrough for the engineer's own review, then the draft PR. Use after the build, in a new session.
disable-model-invocation: true
argument-hint: "<ticket key>"
---

# Review: AI review, the engineer's review, then the draft PR

Ticket: $ARGUMENTS

Coworkers still review the PR. This review comes first, so they get cleaner code and can focus on intent and risk. A session that didn't write the code isn't biased toward it, so run this in a new session.

## Rules

- **Model:** run on the strongest model you have. If you aren't on it, tell the engineer to switch before going on.
- **Change only what the engineer agrees to.** Fixes stay unstaged, apart from the staged build, so the engineer sees them separately. Stage only when they say so.
- **Git:** never commit, push or switch branches. The engineer commits. Never open or update a PR without the engineer approving the text.
- **Every finding has a failing case:** an input or state, and the wrong result it gives. Without one, drop it or mark it "unsure".
- **Read from the diff, not from memory.** Quote `file:line`.
- **Plain, short English.** Start every report with 3 to 5 lines: what was done, what's left, what the engineer must decide. Details after. Fix the project's terms once (from `GLOSSARY.md`) and keep them.
- **Posts and messages for others** (Jira comments, chat messages): 2 to 4 short sentences, plain English, no lists unless the engineer asks. One request per post is fine; don't bundle background.
- **Look before you ask.** Before any question for someone else, check the specs, Confluence pages, code, mocks and test environments. Only ask what none of them answers.
- **Problems outside the ticket:** tell the engineer and draft a new ticket. Don't fix them here.

## 0. Read and refresh

1. Read the plan `.plans/<ticket key>-*.md` (with its Build log), the intent and spec it links, the verify checks file, the instruction file, `GLOSSARY.md`, and any coding standards file.
2. Refresh against Jira: compare the last-updated times of the ticket, its subtasks and linked items, and the Confluence page versions, with the ones in the intent's Source. If nothing changed, say "no change". If something did, update the intent, list the changes, and say what the code may now be missing.
3. **Find the base:** the branch this one was made from (stacked branches don't start from main). Take it from the plan, or ask. The review covers `git diff <base>` plus uncommitted changes, nothing else.
4. If the build is uncommitted and unstaged, ask the engineer to stage it (or stage it when they say so), so later fixes show apart from it.

## 1. AI review: three fresh reviewers

Three reviews, each with a fresh context, read only. Each reports findings, not fixes.

1. **Bugs:** wrong behaviour, missed edge cases, error handling, broken callers, concurrency, resource leaks. Follows the instruction file and any coding standards file.
   - In Claude Code: run the bundled `/code-review high --max-findings all`, without `--fix`.
   - Elsewhere: a reviewer subagent (or a fresh pass in this session).
2. **Security:** secrets, certificates, auth, input checks, what gets logged (personal data, tokens), permissions in infrastructure code.
   - In Claude Code: run the bundled `/security-review`. It compares with the default branch, so on a stacked branch keep only findings in files `git diff <base>` changed.
   - Elsewhere: a reviewer subagent.
3. **Plan vs code**, always a reviewer subagent of our own (no built-in checks this): what the plan or intent asked for that is missing, what was built but not asked for, and anything that breaks a constraint. Tests at the points the Testing section names.

Give each of our own reviewers the base, the paths to the plan and intent, and the rules above. Run them in parallel where you can.

Then **check every finding yourself** against the code: confirmed, unsure, or wrong (say why). Report in these groups, most severe first in each, one short entry per finding (`file:line`, failing case, fix):

1. **Fix now:** confirmed and small enough for this ticket.
2. **Needs an answer:** the right code depends on someone else (the ticket creator, a design page owner). First look for the answer yourself (see Rules); if the sources settle it, it moves to "Fix now". Then read the ticket's comments and the plan's "Questions posted": never ask again what is already asked; say "already asked on <date>" instead. Draft only the new questions: one or two short lines each, one thing each, no background. Say if one blocks the merge. Post only after the engineer approves the text.
3. **Plan or verify text is wrong** (the code is right): fix the plan or checks file, add a Build log line, and say what you changed. Don't ask first.
4. **Outside the ticket:** a draft ticket each.
5. **Dropped:** one line each, with the reason.

For a big change or a one-way door, suggest a second review by a different model, such as `/code-review ultra` in Claude Code (billed, started by the engineer) or a review on GitHub. Different models miss different things.

## 2. Fix what the engineer agrees with

The engineer picks which findings to fix. If they say "fix by best guess", decide each one and give a reason for every one you don't fix. Run the checks the fix touches, then the full build, test and lint once, and paste the output.

A check that compares against git's index (for example "generated code matches") can fail while fixes are unstaged. Prove the real property another way; don't stage just to make it pass.

## 3. The engineer's own review: a walkthrough

The engineer is the reviewer now. Walk the diff with them, in this session, because it already knows every finding and fix.

- **Order:** data flow: config, wiring, logic, infrastructure, API docs. The design shows before the detail. Spend the most time on high-risk tasks.
- **Each file:** 2 or 3 plain sentences, read from the diff: what it does, "before" and "now". Group files with the same mechanical change and explain one.
- **Check claims:** renames and moves against git (`git diff -M`, search for callers). Read infrastructure changes closely: a missing step there can destroy and recreate a live resource.
- **What's missing:** say what should have changed but didn't: generated code, docs, CI, config, the order things must be deployed in. A walkthrough can't show what's absent unless you look.
- **Trade-offs:** for each choice the build made, point to its Build log line.
- **Questions:** answer "why?" from the code and plan. "Did you check X?" means run a real check, not answer from memory. Naming questions and "why not X?" become follow-ups.

The engineer decides what's left open. Change only what they ask for. If a fix changes behaviour after the walkthrough (for example, a new call), walk those files again.

## 4. Status, then commit

Write a short status block: what was tested, what is blocked and on whom, and what must happen before production. For each step the engineer must run, say exactly how (the command, or the CI workflow and its inputs, read from the repo's CI files). Add it to the plan's Build log, commit and push the worknotes repo, and offer to post it on the ticket (only with the engineer's approval).

Then the engineer commits the build and the fixes they keep, and pushes.

## 5. The draft PR

After the push, draft the PR for the engineer to approve:

- **Title:** the ticket key and a short name ("BILL-123: invoice CSV export").
- **Base:** the base branch from step 0.
- **Description:** the intent in two or three lines, the plan's main decisions, and the Testing section (the worknotes files aren't in the repo, so the PR must carry this). Then three parts:
  - **Summary:** the smallest picture of the change: a call tree, a file tree or a small diff.
  - **Evidence:** test output, or before and after.
  - **Merge danger:** easy to roll back or not, and what it could affect.
- Link the ticket.

Open it as a **draft** with the engineer's approval, using the account the instruction file names.

## Done when

- Every finding is fixed, or left open with the engineer's reason.
- The engineer has walked the whole diff, and the full checks pass.
- The status block is in the Build log and the worknotes repo is pushed.
- The draft PR is open, or the engineer has the text.

**Next:** deploy to a lower environment and run the verify checks, in a new session.

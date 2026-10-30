---
name: sdlc-review
description: Review a ticket's build before coworkers see it - fresh AI reviewers for bugs, security and plan-vs-code, fixes the engineer agrees to, then hands off to the walkthrough and the PR. Use after the build, in a new session; run again after later changes.
disable-model-invocation: true
argument-hint: "<ticket key>"
allowed-tools:
  - Bash(${CLAUDE_SKILL_DIR}/../sdlc-setup/scripts/worknotes-push.sh *)
---

# Review: AI review, the engineer's review, then the draft PR

Ticket: $ARGUMENTS

Coworkers still review the PR. This review comes first, so they get cleaner code and can focus on intent and risk. A session that didn't write the code isn't biased toward it, so run this in a new session.

## Rules

- **Model:** run on the strongest model you have. If you aren't on it, tell the engineer to switch before going on.
- **Change only what the engineer agrees to.** Fixes stay unstaged, apart from the staged build, so the engineer sees them separately. Stage only when they say so.
- **Git:** never commit, push or switch branches. The engineer commits. Never open or update a PR without the engineer approving the text.
- **Every finding has a failing case:** an input or state, and the wrong result it gives. Without one, drop it or mark it "unsure". For a claim about what reaches the caller, the logs or another system, follow the call to where that output is built, or run a throwaway test, before you report it.
- **Fix the whole bug class:** for each confirmed finding, search the diff and the files it touches for the same mistake elsewhere, and list every place in one finding.
- **Read from the diff, not from memory.** Quote `file:line`.
- **Plain, short English.** Start every report with 3 to 5 lines: what was done, what's left, what the engineer must decide. Details after. Fix the project's terms once (from `GLOSSARY.md`) and keep them.
- **Posts and messages for others** (Jira comments, chat messages): 2 to 4 short sentences, plain English, no lists unless the engineer asks. One request per post is fine; don't bundle background. Write as the engineer ("I found", not "we"), and leave out your own recommendation unless the engineer asks for it.
- **Look before you ask.** Before any question for someone else, check the specs, Confluence pages, code, mocks and test environments. Only ask what none of them answers.
- **Problems outside the ticket:** if one is small, low-risk and in or next to the code this ticket changes (for example, a handler we change sends an internal error to the caller), put it under "Fix now", marked "was already there". If it's big, risky, in shared code other parts use, or another team's work: tell the engineer and draft a new ticket.

## 0. Read and refresh

1. Read the plan `.plans/<ticket key>-*.md` (with its Build log), the intent and spec it links, the verify checks file, the instruction file, `GLOSSARY.md`, and any coding standards file.
2. Refresh against Jira: compare the last-updated times of the ticket, its subtasks and linked items, and the Confluence page versions, with the ones in the intent's Source and the sources file (`.intent/<ticket key>-sources.md`). Don't search again. If nothing changed, say "no change". If something did, update the intent, list the changes, and say what the code may now be missing.
3. **Find the base:** the branch this one was made from (stacked branches don't start from main). Take it from the plan, or ask. The review covers `git diff <base>` plus uncommitted changes, nothing else.
4. **Same session as the build?** If this session wrote the code, say so and ask once: go on here, or start a new session. The reviewers still start fresh, but your own checking of their findings doesn't.
5. **A second review** of the same ticket: bugs cover only what changed since the last review (say from which commit); security and plan vs code still cover the whole branch. Never raise again what an earlier review dropped with a reason (the Build log has them). If something it fixed shows up again in the same place, the fix failed: reopen it. On a third review, stop first: tell the engineer that more rounds rarely help, and suggest rethinking the approach with them instead.
6. If the build is uncommitted and unstaged, ask the engineer to stage it (or stage it when they say so), so later fixes show apart from it.

## 1. AI review: three fresh reviewers

Three reviews, each with a fresh context, read only. Each reports findings, not fixes.

1. **Bugs:** wrong behaviour, missed edge cases, error handling, broken callers, concurrency, resource leaks. Follows the instruction file and any coding standards file.
   - In Claude Code: run the bundled `/code-review high --max-findings all`, without `--fix`.
   - Elsewhere: a reviewer subagent (or a fresh pass in this session).
2. **Security:** secrets, certificates, auth, input checks, what gets logged (personal data, tokens), permissions in infrastructure code.
   - In Claude Code: run the bundled `/security-review`. It compares with the default branch, so on a stacked branch keep only findings in files `git diff <base>` changed.
   - Elsewhere: a reviewer subagent.
3. **Plan vs code**, always a reviewer subagent of our own (no built-in checks this): what the plan or intent asked for that is missing, what was built but not asked for, and anything that breaks a constraint. Tests at the points the Testing section names.

Give each of our own reviewers the base, the paths to the plan and intent, and the rules above. Run them in parallel where you can. A reviewer that fails or returns nothing didn't review: retry once, then report it as "not run". Never count it as no findings.

Then **check every finding yourself** against the code: confirmed, unsure, or wrong. "Wrong" needs proof a reader can check (a `file:line`, a doc); "it was meant that way" isn't proof, and neither is the build session wanting to drop it. If the proof is outside the repo (a team habit, something agreed in a meeting), give the finding to the engineer to decide. Report in these groups, most severe first in each, one short entry per finding (`file:line`, failing case, fix):

1. **Fix now:** confirmed and small enough for this ticket.
2. **Needs an answer:** the right code depends on someone else (the ticket creator, a design page owner). First look for the answer yourself (see Rules); if the sources settle it, it moves to "Fix now". **Check every question before you show it, every time** (also when you redraft one or add one later): (1) look for the answer in the specs, the sources file, the code, mocks and sample data; (2) check the case really happens (the spec's definitions, sample data, logs); (3) check the answer would change the code or the outcome. Drop any question that fails one. In a tool with subagents, also give the questions to a fresh read-only one and keep only what it can't answer. Under the draft, say in one line per question where you looked. Then read the ticket's comments and the plan's "Questions posted": never ask again what is already asked; say "already asked on <date>" instead. Draft only the new questions, as one comment, using the `sdlc-intake` skill's `questions-template.md`. Say if one blocks the merge. Post only after the engineer approves the text.
3. **Plan or verify text is wrong** (the code is right): fix the plan or checks file, add a Build log line, and say what you changed. Don't ask first.
4. **Outside the ticket:** only the big, risky or other-team ones (see Rules), a draft ticket each.
5. **Dropped:** one line each, with the reason.

For a big change or a one-way door, suggest a second review by a different model, such as `/code-review ultra` in Claude Code (billed, started by the engineer) or a review on GitHub. Different models miss different things.

## 2. Fix what the engineer agrees with

The engineer picks which findings to fix. A fix that adds new behaviour on a live path (for example, dropping data) gets a verify check, and is marked high risk for the walkthrough. If they say "fix by best guess", decide each one and give a reason for every one you don't fix. Each fix gets a test that fails without the fix: undo the fix once and see it fail. Run the checks the fix touches, then the full build, test and lint once, and paste the output.

A check that compares against git's index (for example "generated code matches") can fail while fixes are unstaged. Prove the real property another way; don't stage just to make it pass.

## 3. The engineer's own review: a walkthrough

The engineer is the reviewer now. Do it in this session, because it already knows every finding and fix. Tell the engineer to run `/sdlc-walkthrough <base>` here (on a second review, `/sdlc-walkthrough HEAD`, so only the new changes are walked) (in Claude Code; elsewhere, follow that skill's steps): one file at a time, in data-flow order, ending with what's missing.

The engineer decides what's left open. Change only what they ask for. If a fix changes behaviour after the walkthrough (for example, a new call), walk those files again.

## 4. Status, then commit

Write a short status block: what was tested, what is blocked and on whom, and what must happen before production. For each step the engineer must run, say exactly how (the command, or the CI workflow and its inputs, read from the repo's CI files). Add it to the plan's Build log and commit and push the worknotes repo (`${CLAUDE_SKILL_DIR}/../sdlc-setup/scripts/worknotes-push.sh "<message>"`). Don't offer to post it on the ticket: the one ticket comment comes from `/sdlc-summary` once the PR exists.

Then the engineer commits the build and the fixes they keep, and pushes.

## 5. The draft PR

After the push, tell the engineer to run `/sdlc-pr <ticket key> <base>` here (in Claude Code; elsewhere, follow that skill's steps). It opens the PR as a draft, with a short description and no AI attribution.

## Done when

- Every finding is fixed, or left open with the engineer's reason.
- The engineer has walked the whole diff, and the full checks pass.
- The status block is in the Build log and the worknotes repo is pushed.
- The engineer knows the next step: `/sdlc-pr`.

**Next:** `/sdlc-verify <ticket key>` in a new session: deploy to a lower environment and run the verify checks.

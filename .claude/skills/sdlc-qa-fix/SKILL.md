---
name: sdlc-qa-fix
description: Fix what QA sent back on a ticket - read QA's feedback and attachments, find QA's own call in the logs, reproduce it where QA saw it, find the root cause (also in the services around ours), fix it on the open PR or a new branch, verify through the caller, and draft the reply to QA. Use when QA reopens a ticket or opens a bug subtask under it.
disable-model-invocation: true
argument-hint: "<parent ticket key> [<bug subtask key>]"
allowed-tools:
  - Bash(${CLAUDE_SKILL_DIR}/../sdlc-ticket/scripts/worktree.sh *)
  - Bash(${CLAUDE_SKILL_DIR}/../sdlc-research/scripts/attachments.sh *)
  - Bash(python3 -I ${CLAUDE_SKILL_DIR}/../sdlc-research/scripts/office2text.py *)
  - Bash(${CLAUDE_SKILL_DIR}/../sdlc-verify/scripts/creds-check.sh *)
  - Bash(${CLAUDE_SKILL_DIR}/../sdlc-setup/scripts/worknotes-push.sh *)
---

# QA fix: what QA sent back

Input: $ARGUMENTS

The first word is the parent ticket: the one whose work QA tested. The second, if given, is the bug subtask QA opened under it. Any text after that is the engineer's note. Without a subtask, QA's feedback is on the parent itself (a reopen or a comment).

The parent's intent, plan and checks files hold what was built and how it was tested. QA's feedback says where that fell short. Find out why before changing anything.

## Where to run it

From the main checkout (the folder on the release or main branch). The skill finds out in step 1 whether the PR is merged, and then:
- **Not merged:** works in the ticket's existing worktree. Ask the engineer to add it (`/add-dir <folder>`) if this session can't edit there. Started inside that worktree is fine too.
- **Merged:** makes a new branch and worktree from the branch it merged into (step 5). An old worktree of the parent is out of date: don't build there.

Never change the main checkout itself: only read it.

## Rules

- **Read the rules first:** `${CLAUDE_SKILL_DIR}/../sdlc-ticket/flow-rules.md` (git, network, credentials, writing), and the Rules in `${CLAUDE_SKILL_DIR}/../sdlc-verify/SKILL.md`. Both bind this session.
- **QA's evidence first, then the code.** Every screenshot, log and comment QA gave, read in full.
- **QA's expected result is the target.** If QA shows what they expect (for example, another system's answer in the same case), the fix gives that result, checked where QA saw it. A different result is a question for the team, not an assumption.
- **Check the cases next to it.** When the fix draws a line (for example, missing vs empty vs blank), check what the reference system does on each side of it. Don't assume they're the same case.
- **No guess as a cause.** Each cause is backed by a log line, a code line or a call you ran. Say what you checked and what you didn't.
- **Small side problems** found on the way, in or next to this code: fix them in the same PR, marked "was already there". Big, risky or another team's: a draft ticket.
- **Never post** to the ticket or anywhere else without the engineer approving the exact text.

## 1. Read

- **The bug:** the subtask (or the parent's newest comments): summary, description, every comment and every attachment (`${CLAUDE_SKILL_DIR}/../sdlc-research/scripts/attachments.sh`). Write down what QA did, what they saw, what they expected, when (time, environment), and any ids (customer, trace, request).
- **The parent:** its intent, plan and checks files (`.intent/`, `.plans/`, `.verify/` for the parent key), the PR and whether it's merged. These say what was assumed. A wrong assumption is often the cause.
- **Test data QA changed:** if QA edited shared test data (a mock stub), note it for the engineer. Other tests may now fail because of it.

Keep the notes in the subtask's intent file (`.intent/<subtask key>-*.md`), or in the parent's if there's no subtask, under "QA feedback".

## 2. Find QA's call

Find QA's own request in the logs, by the trace or request id from their evidence, or by time and test id. Follow it through each service, from the first one QA called down to ours (the repo's notes may already have the chain). Say what each service did with it. If you can't find it, say what you searched and carry on.

## 3. Reproduce where QA saw it

Show one call you ran that gives the same wrong result QA saw. Run it as close to QA's call as you can: through the service that calls ours if it can be called in the test environment (the verify skill's "Also through the caller"), not only at our own entry point. A unit test that fails the same way comes next. If you can't reproduce it, say so and what you tried.

## 4. Root cause

List 3 to 5 possible causes, each with a check that would prove it wrong, and run them. Look outside our code too: how the caller reads our answer, the test data, what's deployed. Read the other services' code when the cause may be there (clone it read-only into a scratch folder).

Then tell the engineer in plain words: what's wrong, where, why the earlier checks missed it, and the fix you propose. Wait for a yes before changing code.

## 5. Fix

- **PR not merged:** fix on its branch, in its worktree (ask before creating one if there isn't one).
- **The cause is in another open PR** (for example, a later fix on the same code): fix it on that PR's branch, with this ticket's key in the commit.
- **PR merged:** a new branch and worktree from the release branch it merged into (`${CLAUDE_SKILL_DIR}/../sdlc-ticket/scripts/worktree.sh <base> <branch> <folder>`), with the subtask key in the branch name if there's one. Ask for the name first.
- To try an idea out first, ask before making an experiment branch. When it works, bring it onto the real branch and delete the experiment, locally and on the remote, with the engineer's OK.
- Add a test that fails without the fix. Run the repo's build, tests and lint.
- Commit with the ticket key (the subtask's, if there's one), and push if the engineer allows it.

## 6. Verify

Deploy as the verify skill says (whose deploy it replaces, the before-saves). Then run:
- QA's case, where QA saw it (step 3's call): now the expected result.
- The parent's earlier checks that this fix could change: still as before, or changed on purpose.
- Before and after for each, in a short table, in the checks file.

## 7. PR and the reply to QA

- **PR:** update the description the way the `sdlc-pr` skill says (or open a new one for a new branch). Keep it short.
- **Reply to QA**, a draft for the engineer, as a ticket comment. Tag QA at the top as real mentions, and cc the people the instruction file lists for ticket questions. Short: two or three sentences, then one retest line. No commits, few numbers and ticket ids. Risks for other people (for example, a coming spec change) go to them, not in this reply.
  - What was wrong and what they'll see now, in words QA knows (for example, where our service sits in the flow they call).
  - How to retest: ask QA to make sure the branch is the one deployed in the environment first (you may deploy something else there in between), and to check the mocks. Don't write "it's deployed, run it again". If a new test id can't be reached from QA's tool, say what to use instead.
  - Don't ask QA to put back test data they changed: they check the mocks before testing anyway. Tell the engineer instead, if it matters.
- Show the whole draft in the end report, not in an earlier message. Post it only after the engineer approves the text. Log it in the intent.

## 8. Keep what was learned

Write what the next ticket should know into the repo's notes: the call chain, how to call through the caller, how the caller reads our answers, and anything `VERIFY.md` should say about testing. Add a line to the instruction file if every session needs it. Push the worknotes repo (`${CLAUDE_SKILL_DIR}/../sdlc-setup/scripts/worknotes-push.sh "<message>"`).

## Done when

- QA's case gives the expected result where QA saw it, and the before and after are written down.
- The PR holds the fix and a short, current description.
- The reply to QA is approved and posted, or given to the engineer.
- The notes hold what was learned.

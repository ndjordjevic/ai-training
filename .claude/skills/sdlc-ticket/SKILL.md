---
name: sdlc-ticket
description: Run one ticket from intake to verify in a single session, on its own - intake, plan, build, review, draft PR and verify, each step in a subagent, with one round of questions at the start and every other question collected for the end. For a ticket of normal size, after the repo's setup is done; not for epics.
disable-model-invocation: true
argument-hint: "<ticket key>"
allowed-tools:
  - Bash(${CLAUDE_SKILL_DIR}/scripts/status.sh *)
  - Bash(${CLAUDE_SKILL_DIR}/scripts/worktree.sh *)
  - Bash(${CLAUDE_SKILL_DIR}/../sdlc-research/scripts/attachments.sh *)
  - Bash(python3 -I ${CLAUDE_SKILL_DIR}/../sdlc-research/scripts/office2text.py *)
  - Bash(${CLAUDE_SKILL_DIR}/../sdlc-verify/scripts/creds-check.sh *)
  - Bash(${CLAUDE_SKILL_DIR}/../sdlc-setup/scripts/worknotes-push.sh *)
---

# Ticket: the whole flow, on its own

Ticket: $ARGUMENTS

This skill runs the steps of the other `sdlc-*` skills in order, in one session: intake, plan, build, review, PR and verify. It asks the engineer once, at the start. After that it investigates instead of asking, writes down what it assumes, and brings every open question to the end.

The engineer's own walkthrough of the code comes after this flow, in a new session.

**First, read the flow rules:** `${CLAUDE_SKILL_DIR}/flow-rules.md`. They bind this session and every subagent.

## Models

The strongest model (Opus) costs several times more than a cheaper one (Sonnet), and on a subscription it uses up the usage window fast. Use it where a wrong call is expensive; use the cheaper one where the work is following a plan or running commands.

- **Strongest model:** this session (it holds the gates and checks each report), and the intake, plan and review subagents, with review's reviewers.
- **Cheaper model (Sonnet):** the build subagent and its tasks, the verify subagents, the plan's fresh readers, and the final question check.
- **Cheapest model (Haiku):** research searches only. They report hits that the intake or plan agent then opens and checks, so a weak hit gets dropped.
- **Back to the strongest** for build tasks the plan marks high risk, and in verify for a failure whose cause isn't clear from the logs: the verify subagent reports it, and you find the cause on the strongest model.
- Set the model on every subagent call (in Claude Code, the Agent tool's `model`: `opus`, `sonnet` or `haiku`). No custom agent files are needed.

## How each step runs

The step skills can't be invoked from here; their files are read instead. `<skills folder>` is the folder that holds this skill's folder. Each step's subagent gets this prompt, filled in:

```
Ticket: <ticket key>. Work only in <worktree folder>. Skills folder: <skills folder>.
Read <skills folder>/sdlc-ticket/flow-rules.md, then <skills folder>/sdlc-<step>/SKILL.md, and follow the step skill for this ticket. Where they disagree, the flow rules win.
Changes for this step: <the bullets under this step below>.
Scripts: <the full paths of the scripts this step uses>.
Credentials file: <path, if this step needs it>.
```

Run the steps one after another, except the verify prep (step 4). Before the next step, spot-check the report: the files it names exist and hold what it says (search for the headings and key lines; don't re-read whole files). A report alone isn't proof.

## 0. Check

1. The repo is set up: the instruction file, `.verify/VERIFY.md` and the worknotes links exist. If not, stop and say to run `/sdlc-setup` first.
2. Resume? The status of this ticket, from `scripts/status.sh`:

   !`${CLAUDE_SKILL_DIR}/scripts/status.sh $ARGUMENTS`

   Go on from the first step not done. Run the script again in the ticket's worktree if it was started from another folder.

## 1. Start: one round of questions

Find out first, so you can propose an answer to each of 1 to 3: read the ticket (summary, links), the branches that look related (`git branch -a`, recent merges), the team's branch names, and the pipeline's last deploy to each lower environment (which branch and ticket, and when). Then ask everything in one go. For 1 to 3, give your answer and one line of evidence, so the engineer only confirms or corrects:

1. **Base branch:** the branch to start from (the ticket it depends on, the release branch it ships in).
2. **Branch and worktree:** the branch name (the team's pattern, for example `feature/<ticket key>`) and the folder (next to the main checkout, for example `../<repo>-<ticket key>`).
3. **What I may do on my own,** each yes or no:
   - commit and push the ticket branch (recommend yes: verify needs the pushed branch);
   - open a draft PR (recommend yes);
   - add new stubs to the test mock, new ids only, never changing existing ones (recommend yes if the checks need data the mock doesn't have yet; name the mock, and the ticket that owns it if there is one; the engineer signs in to its web console);
   - deploy to the lower environment (name it): recommend yes only if the last deploy there is old, or is this ticket's base; otherwise no, and say whose work it would replace.
4. **Credentials** (no answer to propose; the engineer does this): for the environments the flow reads or deploys to. You pick the path (a scratch file outside any repo); the engineer copies the export lines and types `! (umask 077; pbpaste | tr -d '\r' > <path>)` themselves. Then run `${CLAUDE_SKILL_DIR}/../sdlc-verify/scripts/creds-check.sh <path>`, and one real read the flow needs (for example, list the gateway's APIs): sign-in passes even where a network rule denies everything else. If the read is denied, ask about the network (VPN or similar) before asking for new credentials. Where `VERIFY.md` says otherwise, the verify skill wins. Say they may expire before verify; then you'll ask once more.

Then create the worktree from the main checkout: `${CLAUDE_SKILL_DIR}/scripts/worktree.sh <base> <branch> <folder>`. It makes the branch and the folder and copies the worknotes links into it. Then run the setup the repo needs there, as the instruction file says (for example `terraform init`). Write the base, the branch and the folder at the top of the intent, so every step and every later session finds them.

The folder is outside the one this session started in, so edits there may ask for permission each time. Ask the engineer to run `/add-dir <folder>` now (in Claude Code), and wait until they have.

From here on, every subagent works only in that folder.

## 2. Intake

A subagent (strongest model) runs `sdlc-intake`, with these changes:
- **Scope:** the subtasks assigned to the engineer in Jira. If none are assigned, the whole ticket.
- **No grilling.** Answer each question yourself from the evidence. What you can't answer becomes an assumption in the intent's Open questions, with the role who should answer it.
- **Already built, or the ticket contradicts itself** in a way that changes the outcome: stop the flow and report.

## 3. Plan

A subagent (strongest model) runs `sdlc-plan`, with these changes:
- The branch question is answered: build on the worktree's branch.
- Design questions become assumptions, not questions. The plan is saved as "ready to build", with the tasks that rest on an assumption marked.
- **Too big for this flow?** If the plan's three questions show it spans several services, needs a security review, or takes more than a few days: stop after the plan and report. That ticket needs the step-by-step flow.
- How to split: thin slices one after another, unless tasks touch different files and can run in parallel.
- The fresh readers run on the cheaper model: Builder and Simpler only (nobody reads a retelling during the flow). Fix what they find yourself.

## 4. Build, with the verify prep alongside

A subagent (cheaper model) runs `sdlc-build`, with these changes:
- No order question: one after another, except tasks the plan marks parallel.
- Each task runs in its own subagent on a cheaper model; high-risk tasks on the strongest.
- Problems outside the ticket: fix the small ones in this ticket, marked "was already there"; list the big ones in the end report.
- End with a Build log line "flow: build done".

At the same time, a second subagent (cheaper model) does the **verify prep:** `sdlc-verify` steps 0, 1, 2 and 4, read only. No deploy, no stubs, no file changes; the calls for the test data come from the plan and the checks file. It reports access, what is deployed, and each check as "ready" or "waiting on: <data>, <owner>". Give that report to the verify subagent in step 7.

## 5. Review

A subagent (strongest model) runs `sdlc-review`, steps 0 to 2, with these changes:
- The build is staged first, so the fixes show apart from it.
- "Fix by best guess": fix every confirmed finding small enough for this ticket, each with a test. Give a reason for every one not fixed.
- "Needs an answer" findings become assumptions and go to the end report.
- If a bundled review command (`/code-review`, `/security-review`) can't run in the subagent, use a reviewer subagent instead and say so.
- No walkthrough here. Write the status block, then "flow: review done".

Then, if allowed, commit the build and the fixes on the ticket branch (the ticket key in the message, no AI attribution in the work repo) and push. Delete the local build and task branches the build made, if any.

## 6. Draft PR

If allowed, open the PR as a draft, as `sdlc-pr` says, without waiting for approval of the text. Add one line under the link: "Draft: open questions and the engineer's review are still to come." If not allowed, put the drafted title and description in the end report.

## 7. Verify

A subagent (cheaper model) runs `sdlc-verify`, with these changes:
- Start from the verify prep's report. Redo steps 1, 2 and 4 only for what it couldn't do, or what changed since (a deploy, new test data).
- Deploy only if allowed at the start. Otherwise check what is deployed and run only the checks it covers.
- The base moved since the branch left it: don't merge it in; deploy the branch as it is and say so in the end report.
- The deploy would replace another ticket's work and the engineer didn't allow that: don't deploy; draft the heads-up for the end report.
- Expired credentials: the only stop in the middle. Ask once for new ones, the same way as at the start.
- Test data that's missing: if stubs were allowed at the start, add them (flow rules). Otherwise mark the check "waiting on: <data>, <owner>", draft the request, go on.
- A failing check caused by this ticket's code: fix it if small, rerun the checks, commit and push if allowed, redeploy if allowed, and run every check again. A bigger one goes in the end report.
- End with "flow: verify done".

## 8. End report

First, the question check: give all the questions from the plan's Open points and the reports to one fresh read-only subagent (cheaper model), with the sources file. Drop each one it can answer from the sources, and say so.

Write the full report in the plan's Build log: review findings left open with reasons, each check and its result, what wasn't tested and what it waits on, big problems outside the ticket with a draft ticket each, what changes if each question's answer is different, and the next steps (walkthrough, send the questions, rerun the plan when answers arrive, `/sdlc-summary`, `/sdlc-pr` to mark it ready, and after the merge `git worktree remove <folder>` then `git branch -d <branch>`). Push the worknotes repo (`${CLAUDE_SKILL_DIR}/../sdlc-setup/scripts/worknotes-push.sh "<message>"`).

Show the engineer only this, short:
- **Blocks the merge** (only if something does: a failing check, a big open finding): one line each, at the top.
- **Changes:** one line per file or group of files.
- **Questions for the team:** one draft ticket comment, using the `sdlc-intake` skill's `questions-template.md`, with the assumption each item was built on. Post nothing; the engineer approves the text first.
- **Verify:** one line, for example "12 of 12 checks passed in <environment>", or what failed or wasn't tested.
- **Next:** `/sdlc-walkthrough <base>` in a new session in the worktree. The rest is in the plan's Build log.

## Done when

- Every step ran, or the flow stopped with a reason (already built, too big, no access).
- Every assumption is in the plan's Open points, every question is in the end report, and the full report is in the Build log.
- The worknotes repo is pushed, and the engineer has the end report.

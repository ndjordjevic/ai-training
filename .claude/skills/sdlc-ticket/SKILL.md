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

This skill runs the steps of the other `sdlc-*` skills in order, in one session: intake, plan, build, review, PR and verify. Their `SKILL.md` files are in the folders next to this one. It asks the engineer once, at the start. After that it investigates instead of asking, writes down what it assumes, and brings every open question to the end.

The engineer's own walkthrough of the code comes after this flow, in a new session.

## Rules for every step

These rules win over the step skills' rules where they disagree. Give them to every subagent.

- **Don't ask; investigate.** Where a step skill says "ask the engineer" or "ask someone", look for the answer instead, in this order: the sources file, Jira (the ticket, its parent, subtasks, linked and nearby tickets, attachments), Confluence, the code, other repos on GitHub (read only), the environments (read only, as `.verify/VERIFY.md` says), mocks and logs.
- **No answer? Assume and go on.** Pick the most likely answer and write it in the plan's Open points: "Assumed: <answer>, because <evidence>. If wrong: <what changes, which tasks>. Ask: <role>." Where two options are close, pick the one that is cheaper to change later.
- **No messages during the flow.** No Jira comments, no chat messages, no "tell your coworker". Drafts for other people go to the end report. If the engineer asks for a post during the flow, show the exact text first and post only after they approve it.
- **No plan mode, and no "stop and wait" for answers.** The plan is written in full, on assumptions, and saved.
- **Git:** work only in the ticket's worktree (step 1). Run every `git` and `gh` command there (`cd` into it, or `git -C <folder>`), also in this session, which may have started in the main checkout. Commit and push only the ticket branch, and only if the engineer allowed it at the start. Never touch other branches, the main checkout, or other tickets' worktrees.
- **Waiting for a yes:** where a step skill waits for the engineer's approval (to post, deploy, fix something big, run a command on a shared machine), the start answers decide. If they don't cover it, don't do it; list it in the end report.
- **Deploy** only to the environment the engineer allowed at the start, through the repo's pipeline, plan first, as the verify skill says.
- **Never change shared test data** (mocks, stubs, test customers) or anything another team owns. Draft what's needed for the end report. The one exception: if the engineer allowed it at the start, add new mock stubs, as the verify skill's "Changing test data" says (new ids only, each called straight after, saved as an import file).
- **Worknotes:** push with `sdlc-setup/scripts/worknotes-push.sh "<message>"` (it commits only this repo's folder and pulls first; another session may have pushed).
- **Scripts** for the steps that are always the same are in the `scripts` folders of this skill and of `sdlc-research`, `sdlc-verify` and `sdlc-setup`. Use them, by their full path, instead of writing the commands again. Give subagents the paths.
- **Mark each step done** with one Build log line in the plan: "flow: build done", "flow: review done", "flow: verify done". The status script reads them.
- **Plain, short English** in every file and report.

## Models

- This session and the intake, plan, review and verify subagents: the strongest model (Opus).
- Build tasks: a cheaper model (Sonnet). Tasks the plan marks high risk run on the strongest model.
- Research searches: a cheaper model.
- Set the model on every subagent call (in Claude Code, the Agent tool's `model`: `opus` or `sonnet`). No custom agent files are needed.
- Wait for each step's subagent to finish before the next step starts.

## How each step runs

The step skills can't be invoked from here; their files are read instead. `<skills folder>` is the folder that holds this skill's folder. Each step's subagent gets this prompt, filled in:

```
Ticket: <ticket key>. Work only in <worktree folder>.
Read <skills folder>/sdlc-<step>/SKILL.md and follow it for this ticket.
Read the "Rules for every step" in <skills folder>/sdlc-ticket/SKILL.md: where they disagree with the step skill, they win.
Changes for this step: <the bullets under this step below>.
Scripts: <the full paths of the scripts this step uses>.
Credentials file: <path, if this step needs it>.
Report back: what you did, the files you wrote, every assumption you made, and anything that stopped you.
```

Check each report against the files it names before the next step starts. A report alone isn't proof.

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
4. **Credentials** (no answer to propose; the engineer does this): for the environments the flow reads or deploys to, they save them now, the way the verify skill's Credentials rule says: you pick the path (a scratch file outside any repo), the engineer copies the export lines and types `! (umask 077; pbpaste | tr -d '\r' > <path>)` themselves. Then run `sdlc-verify/scripts/creds-check.sh <path>`. Where `VERIFY.md` says otherwise, the verify skill wins. Say they may expire before verify; then you'll ask once more.

Then create the worktree from the main checkout: `scripts/worktree.sh <base> <branch> <folder>`. It makes the branch and the folder and copies the worknotes links into it. Then run the setup the repo needs there, as the instruction file says (for example `terraform init`). Write the base, the branch and the folder at the top of the intent, so every step and every later session finds them.

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
- Design questions become assumptions (Rules), not questions. The plan is saved as "ready to build", with the tasks that rest on an assumption marked.
- **Too big for this flow?** If the plan's three questions show it spans several services, needs a security review, or takes more than a few days: stop after the plan and report. That ticket needs the step-by-step flow.
- How to split: thin slices one after another, unless tasks touch different files and can run in parallel.
- The fresh readers still run. Fix what they find yourself; nobody is asked.

## 4. Build

A subagent (strongest model) runs `sdlc-build`, with these changes:
- No order question: one after another, except tasks the plan marks parallel.
- Each task runs in its own subagent on a cheaper model; high-risk tasks on the strongest.
- Problems outside the ticket: fix the small ones in this ticket, marked "was already there"; list the big ones in the end report.
- End with a Build log line "flow: build done".

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

A subagent (strongest model) runs `sdlc-verify`, with these changes:
- Deploy only if allowed at the start. Otherwise check what is deployed and run only the checks it covers.
- The base moved since the branch left it: don't merge it in; deploy the branch as it is and say so in the end report.
- The deploy would replace another ticket's work and the engineer didn't allow that: don't deploy; draft the heads-up for the end report.
- Expired credentials: the only stop in the middle. Ask once for new ones, the same way as at the start.
- Test data that's missing: if stubs were allowed at the start, add them (Rules). Otherwise mark the check "waiting on: <data>, <owner>", draft the request, go on.
- A failing check caused by this ticket's code: fix it if small, rerun the checks, commit and push if allowed, redeploy if allowed, and run every check again. A bigger one goes in the end report.
- End with "flow: verify done".

## 8. End report

Start with 3 to 5 lines: what was built, what passed, what's open.

Then:
1. **Questions, grouped by who should answer** (team lead, BA, QA, PO, customer). For each one: the question, the assumption used, and what changes if the answer is different (tasks, files). Under each group, a short draft message written as the engineer, plain and short. Post nothing.
2. **Review findings left open,** with reasons.
3. **Verify:** each check and its result, what wasn't tested, and what it waits on.
4. **Outside the ticket:** the big problems found, a draft ticket each.
5. **Next steps for the engineer,** in order:
   - Walk the code in a new session in the worktree: `/sdlc-walkthrough <base>`.
   - Send the questions; when answers arrive, rerun the plan in the worktree (`/sdlc-plan <ticket key>`) to see what changes.
   - Post the ticket comment (`/sdlc-summary <ticket key>`).
   - Mark the PR ready when the walkthrough is done and the blockers are closed (`/sdlc-pr <ticket key>`).
   - After the merge, from the main checkout: `git worktree remove <folder>`, then `git branch -d <branch>`.

Add the report to the plan's Build log, then commit and push the worknotes repo (`sdlc-setup/scripts/worknotes-push.sh "<message>"`).

## Done when

- Every step ran, or the flow stopped with a reason (already built, too big, no access).
- Every assumption is in the plan's Open points, and every question is in the end report.
- The worknotes repo is pushed, and the engineer has the end report.

## The steps in short

1. **Check** that the repo is set up, and whether this ticket is already part-done.
2. **Ask once:** the base branch, the branch and folder, what the agent may do alone, and the credentials. Then make the worktree.
3. **Intake:** read the ticket and everything around it, and write the intent. No questions, only assumptions.
4. **Plan:** read the code and write the plan and the checks, on assumptions where needed. Stop if the ticket is too big.
5. **Build:** each task in its own subagent, with tests, until the full checks pass.
6. **Review:** fresh reviewers find problems, and the agent fixes the small ones. Commit and push.
7. **Draft PR**, if allowed.
8. **Verify** in the lower environment: deploy if allowed, then run every check.
9. **End report:** what was done, the questions for each person with the assumptions used, and the engineer's next steps, starting with the walkthrough.

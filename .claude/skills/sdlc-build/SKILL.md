---
name: sdlc-build
description: Build a ticket from its plan - work through every task to the end, checks included, and leave one uncommitted diff on the feature branch for the engineer to review. Use after the plan, in a new session or the plan's session.
disable-model-invocation: true
argument-hint: "<ticket key>"
---

# Build: from plan to one diff

Ticket: $ARGUMENTS

The plan says what to build and where. The build writes the code, checks it, and hands the engineer one diff to review. It doesn't decide where things go; if the plan is wrong, it fixes the plan first.

## Rules

- **Model:** the main session runs on the strongest model you have. If you aren't on it, tell the engineer to switch before going on.
- **Git:** the engineer owns the feature branch: never commit, push, switch it or create it. Never stage anything on it either: delete files with plain `rm`, not `git rm`, so the result is one unstaged diff. Only for parallel tasks may you make local task branches and worktrees (step 3); never push them, and remove them at the end.
- **Never deploy** or change anything in an environment. AWS and other environments: read only, as `.verify/VERIFY.md` says. Ask for credentials in a scratch file outside any repo, never pasted.
- **Don't stop for review.** Work through every task to the end. The engineer reviews all the diffs once, at the end.
- **Small choices don't wait.** If it's small and easy to undo, decide, carry on, and add one line to the plan's Build log: what and why. Stop only for something the plan doesn't cover, that is hard to undo, or that would change what existing users see.
- **Plan wrong?** (A file isn't where it says, or the change belongs elsewhere.) Update the plan first, add a Build log line, then go on.
- **Problems outside the ticket:** tell the engineer and draft a new ticket. Don't fix them here.
- **Comments you add are one line at most.** If it needs more, a name or the code should say it.
- **Plain, short English** in every report.

## 0. Read and refresh

1. Read the plan `.plans/<ticket key>-*.md`, the intent and spec it links, the verify checks file, the instruction file and `GLOSSARY.md`.
2. Refresh against Jira: compare the last-updated times of the ticket, its subtasks and linked items, and the Confluence page versions, with the ones in the intent's Source and the sources file (`.intent/<ticket key>-sources.md`). Don't search again. If nothing changed, say "no change". If something did, update the intent and list the changes. Then show what must change in the plan, and update it. If code is already written, list the parts the change affects and stop until the plan is right.
3. Check the plan's Status and "Open points". A task blocked by a person's answer: if the plan gives an assumption for it, build on the assumption and say so in the final report. If not, skip it.
4. `git status` must be clean and on the feature branch. If not, stop and ask.

## 1. Baseline

Run the full build, test and lint once, before any change. If something already fails, note it in the Build log and leave it; fixing it is another ticket. Later, a failure is only yours if it didn't fail here.

## 2. Order

Show the engineer the order in a few lines: which tasks run in parallel, which wait for which, and which are high risk. Ask only one thing: **parallel or one after another?** Recommend one after another when there are few tasks or they touch the same files.

Start each task as soon as its blockers are done, not in fixed rounds.

## 3. Run the tasks

**One after another:** each task runs in this checkout, with a subagent or in this session, so it sees the earlier work. Changes stay uncommitted.

**In parallel** (if your tool has subagents):
1. Make a local build branch and one worktree per task from the current commit: `git branch <ticket>-build`, then `git worktree add -b <ticket>-task-N <path> HEAD` for each task. Don't rely on automatic worktree options: they may start from the default branch, and linked files (like a linked `.claude` folder) can break them.
2. Write one shared rules file for all subagents, in a scratch folder outside the repo: paths to the plan, intent and glossary (worktrees don't have linked files); the test rules below; "never push, deploy or edit the plan"; the report format (what you built, checks run with output, Build log lines, anything unsure).
3. Each subagent prompt is short: "Your worktree: <path>. Work only there. Rules: <rules file>. Task N in <plan path>."
4. Each subagent commits on its task branch with the ticket key in the message. Before reporting, it merges the latest build branch into its own, so conflicts show early.
5. You merge each finished task branch into the build branch and run the full suite on the result.
6. Tools that can't run twice at once (some linters): run them one at a time.
7. Tests that need untracked files (fixtures, local secrets) may skip silently in a worktree. Run those in the main checkout.

**Models:** task subagents may use a cheaper model; say it in the prompt. Tasks marked high risk run on the strongest model.

**Only you** write the plan and the build branch. Subagents report their Build log lines; you copy them in.

## 4. How each task is built

- **Test rules:**
  - Test only at the points in the plan's Testing section.
  - One failing test, then just enough code to pass it, then the next test.
  - Test behaviour through the public interface, not private functions.
  - Expected values are known values (`15`), not worked out the way the code does it.
  - Mock only external systems (outside APIs, time). Never mock our own code.
  - A failing test means fix the code, never the test. Change a test only when the plan changes the behaviour it checks, and name it in the report.
- **Check often:** the type check and the test file you're working on.
- **Files the plan doesn't name** (for example, a README line): fine if small; add a Build log line.
- **Tool leftovers:** some checks create files (`terraform init` makes a lock file and a `.terraform` folder). Remove what the tool made, or run it in a scratch copy.
- **Copy how similar code is written** in this repo: names, errors, logging, layout. Follow the instruction file (for example, generated code is regenerated, never hand-edited).
- **Same change in many files:** write a script and run it, instead of editing each file by hand. Mention it in the report so a reviewer can rerun it.
- **For a bug:** the failing test first, then the fix. Fix the cause, not the symptom. Debug logs carry one unique tag, so one search removes them.
- **Done** means checked on the real thing: run it, read the value. Not "it compiles", and not a subagent's own summary. If the app can run locally, run it and try the change (in Claude Code, the engineer can start the bundled `/verify`).

## 5. Finish

1. **Clean up the diff:** remove comments that repeat the code, needless defensive checks, debug logs, and style that doesn't match the file. No change in behaviour.
2. **Full checks:** run the full build, test and lint once, and paste the output. Then `git status`: only the files the build meant to change.
3. **Parallel only:** bring the build branch onto the feature branch as uncommitted changes (`git merge --squash <ticket>-build`, then `git reset` to unstage). Remove the worktrees. Keep the build and task branches until the engineer has committed after the review, then delete them.
4. Update the plan's Build log, then commit and push the worknotes repo.

## 6. Report

- What each task built, in one or two lines.
- **Review first:** the high-risk tasks and their files.
- What was built on an assumption, and what was skipped because it waits on an answer.
- Only the Build log lines the engineer must act on or check; point to the plan for the rest.
- The full check output, and any failure that was there before the build.
- What the engineer must run that you couldn't (for example, a cloud plan or a check that needs a clean tree), and exactly how: the command, or the CI workflow and its inputs. Read the repo's CI files to find out; don't guess.
- End with one numbered list of next steps, in order: AI review, the engineer's review, commit and push, then anything that needs the pushed branch (cloud plan, deploy, verify).

## Done when

- Every task that isn't waiting on an answer is built.
- The full build, test and lint pass, and the output is in the report.
- The whole result is uncommitted and unstaged on the feature branch, and no worktrees are left.
- The plan's Build log is up to date and the worknotes repo is pushed.

**Next:** `/sdlc-review <ticket key>` in a new session: the AI review of the uncommitted diff, then the engineer's own review (high-risk tasks first). Commit and push after that.

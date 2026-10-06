# Our AI-native SDLC (draft)

Work in progress, built while reading Anthropic's [AI-native SDLC Playbook](https://academy.claude.com/courses/ai-native-sdlc-playbook/introduction) (all 14 lessons). The course's own flow is summarised in [ai-native-sdlc-playbook.md](ai-native-sdlc-playbook.md). This file is how it could work for us. What is left is to answer the open questions and agree the rollout.

**Words used here**
- **The agent** means Copilot CLI, which is what we have. Claude Code works the same way, and some features below are named in both.
- **intent, spec, plan** are Markdown files per ticket. Features get an intent and a plan. Only big tasks also get a separate spec. See the table below.
- The course calls its first stage "Plan", and that stage produces the **intent**. Our `plan.md` is something else: the implementation plan made before the build.

Many ideas below come from Matt Pocock's [skills](https://github.com/mattpocock/skills). See [matt-skills-notes.md](matt-skills-notes.md) for what we took and why. More come from Lauren Tan's [pstack](https://github.com/cursor/plugins/tree/main/pstack), see [pstack-notes.md](pstack-notes.md).

**Intent, spec and plan**

| File | Answers | Written from | Example (BILL-123) |
|---|---|---|---|
| **Intent** | **Why**, and what is wanted | The ticket and the grilling: the user's or business's view | Customers copy invoices by hand. They want a "Download CSV" button. |
| **Spec** (big tasks only) | **What** we will build, decided | The intent plus our rules (security, UX) | `GET /invoices/export`, these columns, at most 10,000 rows, no tax IDs, no Excel file. |
| **Plan** | **What we build** (when there is no spec), then **how and where** in our code | The intent or spec, plus reading the code | Stream from the invoice repository. Task A in `api/` and `core/`, task B in `web/`, then C. |

They are connected in three ways:
- **Same name, different folders:** `intent/BILL-123-invoice-csv.md`, `specs/BILL-123-invoice-csv.md`, `plans/BILL-123-invoice-csv.md`. The Jira key ties them to the ticket.
- **Each file links to the one before it:** the spec starts with "Intent: …", and the plan with "Spec: …", or "Intent: …" when there is no spec.
- **Changes flow down:** the refresh updates the intent first, then the spec if there is one, then the plan.

## Our starting point

All our work comes from Jira tickets, and the product team will keep writing them as they do today. The change starts when an engineer picks up the ticket. In the course, the person with the idea writes the intent. For us, **the ticket is the first draft, and the engineer and the agent turn it into an intent.**

**Jira stays the source of truth.** It tracks status, assignee and sprint, and the product owner keeps working there. The Markdown files are working copies, with the Jira key in each one and links back from the ticket. (The course offers three options: repo as truth, old tool as truth, or both linked. We use the second, plus links.)

## The flow in one view

1. **Intake:** the agent reads the ticket, interviews the engineer, and writes the intent. Gaps go to the product owner in Jira, who confirms the intent. Big tasks also get a spec, in the same session.
2. **Refresh, then plan:** the agent reads the code and writes what we build and how, split into tasks.
3. **Refresh, then build:** one main session builds the tasks with subagents. The agent checks its own work.
4. **PR:** one PR with the intent, the spec if any, the plan and the code. An optional AI review first, then coworkers review it as today. The agent helps with their comments, CI and conflicts.
5. **Release:** merge the approved PR, deploy to production with a human's approval, and check the AWS logs and metrics.
6. **Back to the start:** problems found in production become new Jira tickets.

Steps 1 to 5 happen on every ticket (Part 1), with the same numbers as the sections below. Three rules apply across the steps: refresh against Jira first, one session per step, and the bug process for bug tickets. The tools behind them are set up once (Part 2).

---

# Part 1: Per ticket

## 1. Intake: ticket to intent (and spec for big tasks)

**Default:** write an intent for every feature or story, however good or bad the ticket is. The agent does the writing, so it takes minutes. It gives the plan one clean input, and it forces the questions that find gaps before anyone builds.

**Proposed exception (not agreed yet):** skip it for small bugs and chores, like a typo or a one-line config change.

1. Create the feature branch, named after the ticket, for example `BILL-123-invoice-csv`. All files for this ticket go on this branch.
2. Give the agent the ticket through the Atlassian MCP server, or paste it in. It reads the description, all comments, the attachments and any linked Confluence page.
3. **Already built?** The agent searches the code for the requested behaviour, by meaning and not only by the ticket's words, and says where it looked. If it already exists, tell the product owner. If the ticket claims something about the code ("the API already returns X"), the agent checks it in the code.
4. **For a bug,** follow the bug process below: try to reproduce it first.
5. **Grilling.** The agent interviews the engineer in rounds. Each round lists every question it can ask now, numbered, each with its recommended answer. It looks up facts in the code itself and only asks the engineer for decisions. New project terms go into `GLOSSARY.md` straight away. It stops when nothing is left unclear.
6. The agent writes the intent from the ticket and the answers.
7. Questions only the product owner can answer go to them as a Jira comment in questionnaire shape: most important first, one idea per question, each with a default, and a short "why this matters" where it could be misread. Example: "Should it include invoices older than 2 years? Default if I hear nothing: no."
8. Update the intent with the answers. Stop when the problem, outcome, constraints and scope are clear, and the rest are answered or written down as assumptions. One or two rounds is normal. If it takes more, have a short call. The product owner confirms the intent with a Jira comment.
9. Commit it as `intent/<ticket-key>-<short-name>.md` and link it from the ticket.

**The intent has these parts:** Source (Jira key, the ticket's last-updated time, the Confluence page version, when we last synced), Problem, Outcome, Affected systems, Constraints, Decisions from comments (who said what, and when), From attachments, Open questions, and a Changelog.

**A separate spec, for big tasks only.** Most tickets don't need one: the plan starts with a "What we build" part instead (step 2). The engineer decides, using this guide: the change spans several services, needs a security or privacy review, or takes more than a few days. They can ask a tech lead. For a big task, still in this session:
1. Ask the agent for a spec for our codebase, following our skills (security, UX, compliance). Until we have skills, it follows the instruction file and the existing code.
2. Concerns the agent flags go to the policy owners, such as security or privacy, before anyone builds.
3. Commit it as `specs/<ticket-key>-<short-name>.md` and link it from the ticket.

The spec, or the plan's "What we build" part, has: decisions, rules, what we will not do, open questions, and a **Testing** section. The Testing section says which behaviour we test, at which points (for example, one integration test through the endpoint), and which existing tests to copy. The product owner doesn't read it. The engineer checks it, and coworkers see it in the PR.

**Prototype (optional).** When a UI or logic question can't be settled on paper, the agent builds throwaway code that answers it: for UI, a few very different versions on one page. It lives on a throwaway branch, and only the answer goes into the intent, spec or plan.

## Rule for every step: the refresh (keeping in sync with Jira)

The ticket keeps changing after the intent is written: new comments, edits, a changed Confluence page. So **before each step (plan, build, PR)** the agent refreshes the intent **and every file after it** that exists.

1. **Quick check.** Compare the ticket's last-updated time and the Confluence page version with the ones stored in the intent. If both are the same, the agent says "no change" and stops. This costs almost nothing.
2. **Compare, don't edit yet.** If something changed, the agent lists every change: description edits, new comments, new or changed attachments, Confluence edits.
3. **Update the intent.** The engineer confirms the proposed changes. The agent updates the intent, adds a changelog line, and sets the new sync time.
4. **Cascade.** The agent shows what must change in the spec, if there is one, then in the plan, and the engineer confirms each.
5. **Code can't be refreshed automatically.** If building has started, the agent lists the parts of the code the change affects. We stop, bring intent, spec and plan up to date, and only then continue.

Prompt to reuse:
> "Re-read BILL-123 and its Confluence page. Compare them with `intent/BILL-123-invoice-csv.md` (last synced: <time>). List every change since then. Don't edit yet. Then show what must change in the spec and the plan."

**Rules**
- **Jira wins.** If a file and the ticket disagree, the ticket is right.
- **Comments can override the description.** That is why the intent keeps "Decisions from comments", with names and dates.
- **A file that is behind its parent says so** at the top, for example "Stale: intent changed on 3 Oct", until it is refreshed.

## Rule for every step: one session per step

Use a new session for each step: intake, plan, build. The build session ends by opening the PR. The committed files carry the state, not the chat. A fresh session has no leftover assumptions, can't use anything that isn't written down, and doesn't suffer from a long, compacted conversation. You can also stop and resume, or hand over to someone else. If a fresh session can't continue from the files alone, the file is missing something, so fix the file.

Every new session starts the same way: "Read the intent (and the spec and plan if they exist), then refresh them against Jira."

**Exceptions**
- **Intake and spec share one session.** The spec needs the reasoning from the grilling, and a summary loses it. If the product owner takes days to answer, resume the same session.
- Small tickets can stay in one session.
- After the plan is approved, you can carry on building in the same session, because it already understands the code.

## Rule for bug tickets: the bug process

1. **One failing command first.** Before any theory, the agent shows one command it has already run that fails on this exact bug: fast, and the same result every time. In order of preference: a failing test locally, then a script against the dev env. **Try, don't block:** if neither works, it confirms the symptom from the production logs (read-only), writes "not reproduced" in the intent, and carries on.
2. **Ranked causes.** The agent lists 3 to 5 possible causes, each with a check that would prove it wrong, and shows them to the engineer before testing them. If two fixes based on the same assumption fail, it writes the assumption down and tests it before a third try.
3. **Fix.** Fix the cause, not the symptom: no null checks or retries that only hide the error. The failing test is committed first, then the fix. Debug logs carry a unique tag so they can be removed with one search. Secrets are hidden in everything the agent shows.
4. **The real cause goes into the PR**, so the next person learns from it. If there is no good place for a regression test, note it for the architecture scan (Part 2).

The same process is used in intake (step 1), in the build (step 3) and for production findings (step 6).

## 2. Plan: what we build, and how in our code

This is the first time the agent reads the code in depth. The intent (or spec) says what is wanted. The plan says what we build, unless there is a spec, and how, in our codebase.

**Who reads the code, and why**

| Step | Reads code? | Why |
|---|---|---|
| Intake | Lightly | Checks whether the feature already exists, and looks up facts during the grilling. |
| Plan | **Yes, this is the analysis** | Decides *where* the change goes and *how*: which files, what to reuse, how similar code is written, what could break. The result goes into the plan. |
| Build | Yes, in detail | Reads the files the plan names closely enough to write the code. It doesn't decide where things go. |

1. Start the agent in plan mode, where it can read code but not change it, and give it the intent and the spec if there is one.
2. **No spec?** The plan starts with a "What we build" part: decisions, what we will not do, and the Testing section (see step 1). The "How and where" part comes below it.
3. Ask hard questions: where does the change belong, what can we reuse, how is similar code written today, what could break? For "what could break", the agent lists who calls or uses what we change, beyond the files in the diff. Use our design words (module, interface, seam, deep or shallow; see Part 2) so plans and reviews talk the same way.
4. Split the work into **tasks**, with the files each task touches.
   - **Prefactor first:** if the code is awkward for the change, task 0 makes it easy, with no change in behaviour and the tests still passing. Remove dead code before adding new code.
   - **Sketch first** for a new module: types and function signatures with empty bodies, in the plan or as task 0. If the build shows the sketch is wrong, change the sketch, not only the code.
   - **How to split** is the engineer's choice per ticket. Thin end-to-end slices (for example, endpoint to button) when tasks run one after another. Split by layer (`api/`, `web/`) when we want parallel subagents, because they touch different files.
   - **Each task** can be checked on its own, fits in one session, and has a "Blocked by" line: "Blocked by: A", or "Blocked by: nothing". Too big for one session means split it.
5. Repeat until someone who never saw the chat could build from the plan alone.
6. Commit it as `plans/<ticket-key>-<short-name>.md` and link it from the ticket.

If the plan shows the spec was wrong, update the spec too. Small changes are approved by the engineer. Risky ones go to a tech lead.

## 3. Build: one main session, tasks to subagents

One main session reads the plan and hands out the tasks (proposed).

- **Independent tasks** go to subagents that run in parallel, each in its own git worktree, a separate checkout on its own branch, so edits can't collide. In Claude Code this is `isolation: worktree`. In Copilot CLI, `/fleet` runs subagents and `/worktree` makes worktrees. We still need to check whether Copilot can give each subagent its own worktree.
- **Start a task as soon as its blockers are done,** not in fixed rounds.
- **Give subagents pointers, not copies:** the paths to the intent, spec, plan and earlier commits.
- **Models (our choice for now):** the main session runs on the strongest model (Opus) for planning, merging and reviewing. Task subagents use the built-in general-purpose subagent, and we tell it the model in the prompt, for example: "Build tasks A and B in parallel, each with a general-purpose subagent on Sonnet, each in its own worktree. Then merge and build task C." Check the model with `/tasks`. If Claude forgets the model, set `CLAUDE_CODE_SUBAGENT_MODEL=sonnet` as the default, or later move to a custom subagent with `model: sonnet`.
- **Dependent tasks** run as subagents one after another in the normal checkout, so each sees the earlier result. Don't use worktrees for them: a subagent's worktree branches from the default branch, not from your current work (in Claude Code, unless `worktree.baseRef` is set to `"head"`).
- **Helper subagents** look and report but don't build. Research into the code belongs in the plan. A researcher (built-in Explore, read-only) is only needed during the build if the plan missed something. A verifier runs **after** a task or the merge, starts the app and compares it with the plan. With built-in subagents, "don't change files" is only an instruction. A custom verifier with only read and run tools would enforce it.
- **The agent checks its own work.** While building it runs the cheap checks often: the type check and the one test file it is working on. At the end it runs the full build, test and lint once, and pastes the output. A failing test means it fixes the code, never the test. For a bug, it follows the bug process. For UI work, it compares a screenshot with the design mock, usually in two or three rounds. "Done" means checked on the real thing (run it, read the value), not "it compiles" or a subagent's own summary.
- **Repeated edits get a script.** For the same change across many files, the agent writes a script or codemod and runs it, instead of editing each file by hand. The script goes in the PR, so a reviewer can rerun it.
- **Small choices don't wait.** On small choices that are easy to undo, the agent decides and carries on, and adds one line to a "Build log" at the end of the plan: what, why. The engineer corrects it later. It still stops for anything the plan doesn't cover or that is hard to undo.
- **Test rules:**
  - Test only at the points in the Testing section.
  - Write one failing test, then just enough code to pass it, then the next test. Not all tests first.
  - Test behaviour through the public interface. Don't test private methods or check the database directly.
  - Expected values are known values, like `15`, not worked out the same way the code does it.
  - Mock only external systems (external APIs, time, sometimes the database). Never mock our own code.
- **Each subagent commits** its work on its own task branch, with the Jira key in the commit message. Before it reports done, it merges the latest feature branch into its own branch, so conflicts show up early.
- **The main session merges** the task branches into the feature branch and runs the full suite on the combined result.
- **Watch out:** a worktree holds only files git tracks. Tests that need untracked files (fixtures, a local database, secrets) can skip without saying so and still pass. Run those in the main checkout.
- **Remove the task worktrees** when the build is done.
- **Clean up before the PR.** The agent removes AI leftovers from the diff: comments that repeat the code, needless defensive checks, style that doesn't match the file. It tidies the commits so they read in order: prefactor, failing test, then the change. No change in behaviour.
- **Push the feature branch** regularly, so work isn't only on one laptop. The build is done when everything is merged on the feature branch, the full suite passes, the engineer has reviewed the diffs, and the branch is pushed. The same session then opens the PR (step 4).
- **The engineer reviews the actual diffs,** not only the subagents' summaries.
- **Start with two or three parallel subagents.** Add more only while you can still review the results well. Review is the limit, not the tools.
- **If the build finds the plan was wrong** (a file isn't where the plan says, or the change belongs somewhere else), stop and update the plan first, then continue. Otherwise the plan and the code drift apart, and the reviewer can't trust the plan.
- **Large or long tasks** that need back-and-forth get their own session in a worktree, so the engineer can steer them.

## 4. PR: one PR per ticket

Today our PRs are reviewed by coworkers, and that stays. We add an **optional AI review before them**, so coworkers get a cleaner PR and can focus on intent and risk.

**Sessions:** opening the PR is the last step of the build session (session 3), which knows the work and can write a good description. The AI self-review runs in a **new session** (session 4): a reviewer that didn't write the code isn't biased toward it.

1. Refresh once more, because the reviewer will compare the PR with the intent.
2. Open one PR from the feature branch as a **draft**, with the Jira key in the title, for example "BILL-123: invoice CSV export". The PR contains the intent, the spec if any, the plan and the code, so the reviewer sees what was asked, what was decided, how it was planned, and what was built.
3. **The PR description** has three parts:
   - **Summary:** the smallest picture that shows the change, such as a call tree, a file tree or a small diff.
   - **Evidence:** before and after, such as a screenshot or the test output.
   - **Merge danger:** can we roll it back easily (a "two-way door") or not (a "one-way door"), and what it could affect.
4. Link the PR to the ticket.
5. **Optional AI review, in a new session.** Run the agent's code review on the branch, for example `/code-review` in Claude Code. It gives **two separate reports**, so one can't hide the other:
   - **Standards:** our written rules (`CODING_STANDARDS.md`) plus common code smells, as judgement calls.
   - **Spec:** what the spec or plan asked for that is missing, what was built but not asked for, and what looks wrong. Each finding quotes the line it refers to.

   Fix what it finds in the same session and push. For big tasks or a one-way door, run the same review on a second, different model too. Different models miss different things.
6. **Optional: ask Copilot to review the PR on GitHub,** by adding Copilot as a reviewer on the PR page, if our organisation has it turned on.
7. Mark the PR ready, move the ticket to "In review", and coworkers review it as today. The agent that wrote the code can never approve it.
8. **Follow through until it can merge.** Resume session 4, or start a new one. The agent summarises the coworkers' comments, fixes failing CI checks and merge conflicts, and makes the simple requested changes, then pushes. The engineer answers the rest and resolves the threads. Each fix is a new commit, so reviewers see what changed.

**Retro, when something went wrong.** If the build or review hit problems, the agent looks back over the session and suggests changes to our setup, not the code. A mistake a tool could catch becomes a check. Prefer, in this order: a type or code structure that makes the mistake impossible, then a lint rule or hook whose message says the fix, then a test. A judgement call goes into `CODING_STANDARDS.md`. Show that a new check fails on the real past mistake. The engineer picks what to apply.

## 5. Release: merge, deploy, check (session 5)

A new session, after coworkers approve the PR. It reads the intent, spec and plan, so it knows what changed and what "working" means. Our services run on AWS.

1. **Merge the approved PR.** The agent merges it, for example with `gh pr merge`. Branch protection makes sure the approvals are there. It can't merge an unapproved PR.
2. **Deploy through our pipeline, not by hand.** The merge, or a pipeline run the agent starts, deploys to production. The agent never deploys with its own AWS credentials. A human approves the production deploy: the engineer or a release manager, depending on our process. A hook blocks any production deploy command that lacks that approval. If the PR says "one-way door", a named approver signs off and the log check below runs longer.
3. **Check the logs and metrics, read-only.** The agent uses a read-only AWS role, with short-lived credentials, to read CloudWatch: errors in the service logs since the deploy, the 5xx rate and latency compared with before the deploy, and the new endpoint's own log lines. It can use the AWS CLI (for example `aws logs tail` or a Logs Insights query) or an AWS MCP server.
4. **Smoke test.** If we have a safe test account in production, the agent calls the new feature once and checks the result against the plan's "Done when".
5. **Report.** The agent posts a short summary to the Jira ticket: what was deployed, what it checked, and what it saw. If everything is fine, the ticket moves to "Done".
6. **If something looks wrong,** the agent reports it and proposes a rollback. A human decides. The rollback runs through the pipeline's rollback step, not by hand.

**Guardrails:** the agent's AWS access is read-only. Hooks and permissions deny any AWS command that changes something (deploy, delete, update). Everything the agent reads and reports is logged to the engineer's session.

## 6. Back to the start

When a metric in production goes out of its normal range, the agent diagnoses it (read-only), following the bug process, and writes its finding. The finding becomes a new Jira ticket, linked to the old one, and the flow starts again at step 1.

---

# Part 2: One-time setup

Done once by tech leads and the platform team, then kept up to date.

## The instruction file (AGENTS.md)

One file at the root of each repo that tells the agent how the project works. The agent reads it at the start of every session. Both Copilot CLI and Claude Code read `AGENTS.md`, so we use that name (proposed).

1. Ask the agent to write a first draft from the codebase.
2. Cut it to what a new teammate needs on day one: **commands** (build, test, lint, with what success looks like), a few **rules** that matter, and **pointers** to other files: `GLOSSARY.md`, `CODING_STANDARDS.md`, `docs/adr/`, and our design words.
3. Add the rule: "Run the build, tests and lint before reporting a task complete, and paste the output. If a test fails, fix the code, not the test."
4. Keep it short. Every line is loaded in every session and costs tokens each turn. Details go in other files, behind a pointer that says when to read them.
5. Commit it at the repo root. Code owners review changes to it like any code.
6. When the agent makes the same mistake twice, run a retro (step 4). A mistake a tool could catch becomes a check. Only what the agent can't look up itself goes into this file.

**Writing rules** for this file and for every skill: say what to do, not what not to do, because a ban puts the idea in the agent's head. Delete lines that don't change what the agent does. Don't copy facts the agent can look up (scripts, config). Give each step a clear "done when".

**Design words.** A short linked doc with five words and one-line meanings, used in plans and reviews: **module** (anything with an interface and code behind it), **interface** (everything a caller must know to use it), **seam** (where the interface sits, and where tests go), **deep** (a lot of behaviour behind a small interface), **shallow** (an interface almost as complex as the code behind it).

**Old (brownfield) repos.** Don't try to document everything. Start from the draft and add lines only when the agent makes a real mistake. Add the "don't touch" rules early: frozen packages, code owned by another team, odd patterns that are there on purpose. The engineer who knows the code must review the draft. In a big repo, keep a short root file and add a small file in each folder that has its own rules. Copilot CLI reads instruction files from the repo root down to the working folder.

**How we know it works:** the agent repeats fewer mistakes, and new people merge their first PR sooner.

## Glossary and decision records

**`GLOSSARY.md`**, one per repo at the root. Each project term gets one or two sentences that say what it is, plus an "Avoid" list of other words for the same thing. Example: **Invoice**: a request for payment sent to a customer after delivery. _Avoid_: bill, payment request. General programming words don't belong in it.
- It grows from the intake grilling: the agent adds a term when it is settled, and the engineer confirms it in the session. Code owners review it in the PR.
- No big upfront effort. The first sessions in a repo are slower, until the main terms are in.
- Shared words make intents, plans and code names shorter and consistent, and the agent spends fewer tokens.

**ADRs (decision records)** in `docs/adr/`, numbered `0001-short-name.md`. One to three sentences: the context, what we decided, and why. Write one only when all three are true: it is hard to reverse, it would surprise a future reader, and it was a real trade-off. Example: "Exports never include tax IDs, because the privacy team treats them as personal data." The agent reads the ADRs in the area it touches and doesn't argue them again.

## Check commands

Each repo needs one command each for build, test and lint, that fails when something is wrong, such as `make test`. If it takes several commands today, wrap them. List them in the instruction file. For UI work, the agent needs a browser or screenshot tool through MCP.

**How we know it works:** more agent-written changes pass CI the first time, and review time per PR goes down.

## Skills for company rules

A skill is a folder with a `SKILL.md` file. It teaches the agent one company rule, such as our API security standard, and loads when the task matches. Use a skill for rules that must be applied the same way every time. Use the instruction file for general project facts.

1. Pick one rule that isn't applied consistently today, with a named owner and a written source.
2. An engineer writes the skill from the owner's document, with the agent's help. The `description` says when it triggers. The body lists the rules and says what to run or report at the end.
3. Put it in `.github/skills/<name>/` so it ships with the repo. Copilot CLI also reads `.claude/skills/`, `.agents/skills/` and `~/.copilot/skills/`. To share across repos, use a plugin.
4. Test it by asking for the task in several different ways, and check that it loads each time.
5. When the policy changes, update the skill. The policy owner signs off before it is merged.

**A skill is advice, not a guarantee.** It makes a violation rare. For a rule that must always hold, add a hook or a check on the PR.

**How we know it works:** review findings about that policy fall towards zero. If they don't, the skill isn't triggering, or it no longer matches the policy.

**Our own flow skills, later.** Once the flow is stable, we write three skills of our own:
- A **setup skill**, run once per repo: it creates `AGENTS.md` with pointers, an empty `GLOSSARY.md`, the Jira settings and the check commands.
- A **router** ("ask our SDLC"): a teammate describes their situation, and it points to the right step.
- A **bug diagnosis skill** that runs the bug process from Part 1.

## Build hooks (hard stops)

A hook is a script that runs before or after the agent acts, and can allow or block the action. During the build they run on every edit and command, so keep them fast and limited to the changed files.

- Block edits to test files during a fix.
- Block edits to protected paths: generated code, frozen packages.
- Run the formatter and linter after edits.
- Remove secrets from diffs.

Full test suites belong at commit or PR time. Hooks that need a human approval belong in the release setup below.

## Custom agents and permissions

Turn jobs we repeat into custom agents (Claude Code calls them subagents): a small file with a name, when to use it, the tools it may use, and its instructions. Commit them so the whole team uses the same ones.

**First one: a verifier.** It starts the app, tries the changed behaviour plus two neighbouring flows, and reports what it ran, what it saw, and where it differs from the plan. It fixes nothing. Its tools are limited to running commands and reading files. pstack's `create-verification-skill` can write a first draft for a repo: how to start the app, use each feature, and capture evidence.

**Permissions:** pre-approve the commands we consider safe (git, build, test, lint), so parallel subagents don't stop the main session with a prompt for each one. Hooks and permission settings in the repo apply to every session. What each session does is logged to the engineer who ran it.

## Evals for our agent setup

An eval is a test for the agent setup, not for the product code. It checks that the agent still does a good job after we change the instruction file, a skill or a hook.

1. Collect 20 to 50 real tasks from recent work, each with the result we accept.
2. Turn each into an eval: the prompt, plus how to judge it (tests pass, lint clean, behaviour unchanged, policy followed).
3. Run the suite in CI without a person present, nightly and on any change to the instruction file, skills or hooks.
4. Block the change if the pass rate drops.
5. After every production incident, add an eval for it.

**How we know it works:** more regressions are caught in CI than found after release.

## AI review of PRs

Our PRs are reviewed by coworkers. The AI review is an optional extra before them (see step 4).

1. Agree the review prompt for the self-review session, so everyone checks the same things. It gives two separate reports: **Standards** (our rules and common code smells) and **Spec** (missing, not asked for, looks wrong).
2. Check whether Copilot code review on GitHub is turned on for our organisation.
3. Later: a `CODING_STANDARDS.md` at the repo root, read only by the reviewer, so `AGENTS.md` stays short. It says what counts as **Important** (breaks behaviour, leaks data, breaks a policy), what is only a **nit** (style, naming), and what to skip (generated files, anything CI already checks). It starts small and grows when the same review finding shows up twice. Both the self-review and an automated review in CI can use it.
4. When the same mistake shows up twice in review, by the AI or a coworker, run a retro: a mistake a tool could catch becomes a check, and a judgement call goes into `CODING_STANDARDS.md`.

**How we know it works:** coworkers find fewer basic problems, and review rounds per PR go down.

## Architecture scan

Once a month, a tech lead runs a read-only scan of each repo. It looks first at the code that changed most, finds shallow modules that make changes hard, and writes an HTML report with a before and after picture for each candidate. Nothing in the repo changes. The tech lead picks candidates, and each one becomes a Jira ticket that goes through the normal flow. It uses the glossary and respects the ADRs. Bug fixes that found no good place for a regression test feed into it.

**How we know it works:** fewer bug fixes without a regression test, and changes in the scanned areas get smaller.

## Release gates and locked-down settings

1. Engineering leadership, with change management and compliance, writes down the approvals that must stay: change sign-off, release authorization, edits to protected paths.
2. The platform engineer turns each into a hook. Example: block any production deploy unless a named release authorization is present. Exit code 2 blocks the action, and the message goes back to the agent. The message must say why it stopped and how to get approval.
3. Team hooks live in the repo. Hooks nobody may switch off live in managed settings. In Copilot, org policy hooks and managed settings live in the organisation's `.github-private` repo, and take about an hour to apply.
4. For sensitive repos, lock down the setup: no reading of secrets files, no web fetches, safe commands pre-approved, a sandbox that must be running, network limited to an allowlist, credentials hidden from commands, and only approved hooks, MCP servers and plugins. Each restriction removes some capability, so match it to how sensitive the repo is.

Every allow or block decision is logged with a timestamp. Idea for us (not from the course): the hook could check that the Jira release ticket is approved.

**Manual steps (optional).** For setup only a human can do, such as creating the read-only AWS role or adding CI secrets, the agent can write a small bash script that walks the person through it: it opens each page, asks for each value, writes it to `.env` or GitHub secrets, and asks to confirm before anything that can't be undone. Commit it if the setup repeats.

## Agents in CI/CD

1. Start read-only: the agent triages failed builds, summarises flaky tests and drafts changelogs. Example: when a build fails, it reads the log, says whether the failure looks flaky or real, and writes a three-line summary for the PR.
2. Add write steps behind our gates, such as fixing lint. The agent only writes PRs. It can never push straight to main.
3. Run agent jobs in a sandbox with short-lived, narrow tokens and no production credentials.
4. Give deploy, status and rollback to the agent as MCP tools, limited per environment.
5. Less freedom closer to production: free in dev, limited in staging, and a release manager must approve production.
6. Practise rollback more than anything else. It should be one command the agent runs often in staging.

Each run uses the agent's own identity, so logs separate agent actions from human ones.

**How we know it works:** more pipeline failures are triaged without paging a person, and our DORA metrics improve (deployment frequency, lead time, change failure rate, time to restore).

## The metrics loop

1. Pick one metric with a stable baseline, such as CI test failure rate or the 5xx rate after a deploy.
2. Write a detection script with plain statistics (average and standard deviation over a rolling window), version-controlled and unit-tested. No AI is used for detection.
3. Set response levels in a config file: a small move (1σ) is only logged. A bigger one (2σ) runs the agent read-only to diagnose. A serious one (3σ) lets the agent propose a fix, only as a PR or a pre-approved runbook such as a rollback.
4. Trigger it from a scheduled CI job, a webhook from our monitoring, or cron.
5. The agent diagnoses it with the bug process and writes its finding (the anomaly and evidence, the likely causes, the wanted outcome, affected systems, open questions). It becomes a Jira ticket.
6. A person triages: fix now, schedule, or dismiss. Dismissals tune the levels and cut noise.

**How we know it works:** findings reach the queue quickly, more of them become merged fixes, and repeat incidents fall.

The course also shows an agent on call in Slack (Claude Tag). For us, the GitHub app for Slack is the nearest match, and we need to check what it can do.

---

## Rollout: where to start

Proposed order (not from the course, for discussion). Each phase adds one thing, and humans stay in control of decisions and approvals at every step.

1. **Start now:** a short `AGENTS.md` in each repo, one check command per repo, the hook that blocks test edits during a fix, and the per-ticket flow (no company skills yet): intake with grilling, refresh, plan with a Testing section, build with the test rules, the bug process, and the PR template.
2. **Next:** `GLOSSARY.md`, the first skill, a verifier agent, parallel subagents with worktrees, the two-report AI self-review, PR follow-through, the retro, and evals.
3. **Then:** ADRs, `CODING_STANDARDS.md`, the monthly architecture scan, agents in CI/CD (read-only first), release gates and locked-down settings.
4. **Last:** the metrics loop, once we have a metrics store and a review gate we trust, and our own flow skills (setup, router, bug diagnosis).

For the Copilot admin setup (managed settings, permissions, sandboxing), see Part 1 of the training, Tab 4 (Administration).

## Open questions

**Access and tools**
- Is the Atlassian MCP server allowed at work, and can it read attached images and linked Confluence pages?
- Is Copilot code review on GitHub turned on for us, and what is the Copilot CLI command for a code review in a session?
- Can our CI run Copilot CLI without a person, and which model and cloud access is allowed from CI?
- Can Copilot `/fleet` give each subagent its own worktree?
- Which browser or screenshot tool may we use for UI checks?
- Do we use only `AGENTS.md`, or also `.github/copilot-instructions.md`?
- Do skills copied from other agents (such as Matt Pocock's) load properly in Copilot CLI?
- Do we install the pstack plugin for Copilot CLI (`copilot plugin install pstack@pstack-claude`), or only copy its ideas? Its README says `copilot -p` loses plugin skills on 1.0.92.
- Which second model can we use for the second review?

**Ownership**
- Who owns the agent setup in each repo (instruction file, glossary, skills, hooks, coding standards) and approves changes?
- Who owns company-wide skills, managed settings and policy hooks, and who signs off when a policy changes?
- Who approves a spec for a big task: the engineer, or a tech lead?
- Who confirms a refresh: always the engineer, or the product owner for big changes?
- Who triages findings from the metrics loop?

**Process**
- Which tickets count as small and skip the intent?
- Is the "big task" guide for a separate spec right?
- How do we stop people building from a file marked stale?
- Which approvals in our change process must stay, and who approves each?
- Is the AI self-review optional for everyone, or required for some repos?

**Release on AWS**
- How are production deploys triggered today, and who approves them?
- Can we give the agent a read-only AWS role (CloudWatch logs and metrics only), and is an AWS MCP server allowed?
- Do we have a safe test account in production for a smoke test?

**Readiness and cost**
- Can every repo run build, test and lint with one command each?
- Are our rules written down well enough to become skills?
- Where are our metrics stored, and how often do we practise rollback today?
- What is the budget for daily agent use (parallel subagents multiply token use) and for eval runs?

**First picks:** our first skill, our first 20 evals, our first metric, and the first deploy target for MCP tools.

---

## Example: the whole flow, BILL-123

**The ticket.** "Customers want to download invoices as CSV." The description says customers keep asking for an Excel-friendly export. A support lead commented "credit notes too please", and the product owner commented "nothing older than 2 years". A screenshot shows the Excel layout customers use (Invoice no, Date, Customer, Net, Tax, Total). A Confluence page, "Billing export requirements", says dates are UTC.

**Session 1: intake and spec.** The engineer creates the branch `BILL-123-invoice-csv`. The agent reads the ticket, comments, screenshot and Confluence page, and finds no existing export in the code. Then it grills the engineer:

> **Q1. Drafts:** does "invoice" include draft invoices? ➡️ Recommended: no, only issued ones.
> **Q2. Who can export:** only the customer's own invoices, or also an admin view? ➡️ Recommended: own invoices only.

The engineer answers, and the agent adds **Invoice** ("an issued request for payment; _Avoid_: bill") to `GLOSSARY.md`. It writes `intent/BILL-123-invoice-csv.md`:

```markdown
# Intent: invoice CSV export (BILL-123)
Source: BILL-123, Jira updated 2 Oct 14:10; Confluence "Billing export requirements" v4; synced 2 Oct 14:30
## Problem
Customers copy invoices by hand into spreadsheets.
## Outcome
A "Download CSV" button on the invoices page.
## Affected systems
Billing service, web app.
## Constraints
Customers see only their own invoices. Dates in UTC (Confluence).
## Decisions from comments
- Product owner, 1 Oct: nothing older than 2 years.
- Support lead, 1 Oct: include credit notes.
## From attachments
- Screenshot: columns Invoice no, Date, Customer, Net, Tax, Total.
## Open questions
- Credit notes in the same file or a separate one? (default: same file, negative amounts)
## Changelog
- 2 Oct: first version from the ticket.
```

The agent posts the open question to Jira in questionnaire shape, with its default.

The next day the product owner answers "same file is fine" and confirms the intent. The engineer resumes the same session. The refresh shows the new comment, the engineer confirms, and the intent gets a changelog line. This ticket needs a privacy review, so the engineer decides it is a big task and asks for a separate spec. The agent writes `specs/BILL-123-invoice-csv.md`: endpoint `GET /invoices/export`, the columns, a 10,000-row limit, own invoices only, every export logged. The security skill flags that tax IDs are personal data, and the privacy team says to leave them out. That decision lasts beyond this ticket, so it also becomes an ADR.

```markdown
# Spec: invoice CSV export (BILL-123)
Intent: intent/BILL-123-invoice-csv.md
## What we build
- `GET /invoices/export` returns a CSV of the customer's own invoices and credit notes from the last 2 years.
- Columns: Invoice no, Date (UTC), Customer, Net, Tax, Total. Credit notes have negative amounts.
- A "Download CSV" button on the invoices page.
## Rules
- At most 10,000 rows. Every export is logged: who, when, how many rows.
- No tax IDs in the file (privacy team, 3 Oct).
## What we will not do
- No Excel (.xlsx) file, no scheduled exports, nothing older than 2 years.
## Testing
- Test through `GET /invoices/export` with one integration test, like the existing endpoint tests.
- Cases: own invoices only, credit notes negative, the 10,000-row limit, a customer name with a comma.
## Open questions
- None.
```

**Session 2: plan.** The refresh finds no change. Plan mode reads the code, finds the existing `formatDate()` helper, the invoice repository and how existing endpoints are written, and writes `plans/BILL-123-invoice-csv.md` with three tasks: **A** the endpoint and CSV writer (`api/`, `core/`), **B** the "Download CSV" button (`web/`), and **C** the integration test, which needs A and B. A and B touch different files, so they can run in parallel.

```markdown
# Plan: invoice CSV export (BILL-123)
Spec: specs/BILL-123-invoice-csv.md
## Approach
Stream the CSV from the existing invoice repository. Reuse `formatDate()` for UTC dates.
Follow the existing endpoints, for example `api/InvoiceController`: gateway auth, errors through `ApiError`, one integration test per endpoint.
## Tasks
- A. Endpoint and CSV writer. Files: `api/InvoiceExportController`, `core/InvoiceCsvWriter`. Blocked by: nothing.
- B. "Download CSV" button. Files: `web/invoices/InvoicesPage`. Blocked by: nothing.
- C. Integration test. Files: `itest/InvoiceExportIT`. Blocked by: A and B.
Run A and B in parallel, then C.
## Risks
- Accounts near 10,000 rows may be slow. Stream the rows, don't build the file in memory.
## Done when
- `make build`, `make test` and `make lint` pass, and the verifier downloads a CSV with the columns from the screenshot.
```

**Session 3: build.** The refresh finds a new comment, "can we add a currency column?". The agent shows that the intent, spec and plan each need one more column. The engineer confirms, and the three files are updated before any code is written. Then:

- The main session gives tasks A and B to two subagents on Sonnet that run in parallel, each in its own worktree.
- In task A the agent writes one test at a time through the CSV writer, using known values. The test for a customer name with a comma fails. The agent fixes the code, and a hook stops it from editing the test instead.
- Each subagent merges the latest feature branch into its own, then commits on its own task branch. The main session merges A and B into the feature branch. Task C then runs in the normal checkout: the integration test is written, and the full suite (`make build`, `make test`, `make lint`) runs on the combined result.
- **Then verify.** A verifier subagent runs the app, downloads a CSV, checks the columns against the screenshot and tries a customer with a comma in the name. It reports what works and what doesn't, and changes no files. The main session decides what to fix.
- The engineer reviews the diffs of each task, not only the subagents' summaries, and pushes the feature branch.
- **Last step of session 3: open the PR.** One last refresh finds no change. The engineer opens "BILL-123: invoice CSV export" as a draft PR with the intent, spec, plan and code, and links it to the ticket. The PR body shows a small call tree of the new endpoint, the test output before and after, and "Merge danger: two-way door, only the invoices page and one new endpoint". The task worktrees are removed.

**Session 4: AI self-review (optional).** A fresh session runs the code review. The Standards report finds only a vague function name. The Spec report finds that the export query has no row limit, although the spec says 10,000. The agent fixes it in this session and pushes. Then the engineer adds Copilot as a reviewer on the PR page, and it only finds a naming nit. The engineer marks the PR ready and moves the ticket to "In review".

**Coworker review.** A coworker reviews the PR as today. Because the basic problems were already fixed, the review is about intent and risk. They leave two comments: rename a variable, and "why not reuse the PDF export's query?". The engineer resumes session 4. The agent renames the variable and fixes a lint check that failed after a rebase. The engineer answers the question, and the coworker approves.

**Session 5: release.** A new session reads the intent, spec and plan. The agent merges the approved PR. The pipeline deploys to dev and staging, then waits: the engineer approves the production deploy, and it goes out. With a read-only AWS role, the agent reads CloudWatch for 30 minutes after the deploy: no new errors in the billing service logs, the 5xx rate and latency are the same as before, and the log shows the first real exports (largest one 2,400 rows, 1.1 seconds). It posts this summary to BILL-123 and the ticket moves to "Done". The team adds an eval for the new export task.

**Back to the start.** A week later the 5xx rate on the billing service goes above its normal range. The detection script runs the agent read-only, following the bug process. A script against the dev env with a large test account reproduces the slow export. It finds timeouts for customers with more than 10,000 invoices, and its finding becomes BILL-140, linked to BILL-123: "export in the background and email a link". The flow starts again at intake.

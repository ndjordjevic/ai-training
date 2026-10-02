# Our AI-native SDLC (draft)

Work in progress, built while reading Anthropic's [AI-native SDLC Playbook](https://academy.claude.com/courses/ai-native-sdlc-playbook/introduction) (all 14 lessons). The course's own flow is summarised in [ai-native-sdlc-playbook.md](ai-native-sdlc-playbook.md). This file is how it could work for us. What is left is to answer the open questions and agree the rollout.

**Words used here**
- **The agent** means Copilot CLI, which is what we have. Claude Code works the same way, and some features below are named in both.
- **intent, spec, plan** are three Markdown files per ticket: what is wanted (`intent/`), what we decided to build (`specs/`), and how we build it in our code (`plans/`).
- The course calls its first stage "Plan", and that stage produces the **intent**. Our `plan.md` is something else: the implementation plan made at the start of the build.

## Our starting point

All our work comes from Jira tickets, and the product team will keep writing them as they do today. The change starts when an engineer picks up the ticket. In the course, the person with the idea writes the intent. For us, **the ticket is the first draft, and the engineer and the agent turn it into an intent.**

**Jira stays the source of truth.** It tracks status, assignee and sprint, and the product owner keeps working there. The Markdown files are working copies, with the Jira key in each one and links back from the ticket. (The course offers three options: repo as truth, old tool as truth, or both linked. We use the second, plus links.)

## The flow in one view

1. **Intake:** the agent reads the ticket and writes the intent. Gaps go to the product owner in Jira.
2. **Refresh, then spec:** what we will build, following our company rules.
3. **Refresh, then plan:** the agent reads the code and writes how to build it, split into tasks.
4. **Refresh, then build:** one main session builds the tasks with subagents. The agent checks its own work.
5. **PR:** one PR with the intent, spec, plan and code. AI review first, then a code owner approves.
6. **Release:** CI deploys, and a human approves production.
7. **Back to the start:** problems found in production become new Jira tickets.

Steps 1 to 6 happen on every ticket (Part 1). The tools behind them are set up once (Part 2).

---

# Part 1: Per ticket

## 1. Intake: ticket to intent

**Default:** write an intent for every feature or story, however good or bad the ticket is. The agent does the writing, so it takes minutes. It gives the spec one clean input, and it forces the questions that find gaps before anyone builds.

**Proposed exception (not agreed yet):** skip it for small bugs and chores, like a typo or a one-line config change.

1. Create the feature branch, named after the ticket, for example `BILL-123-invoice-csv`. All files for this ticket go on this branch.
2. Give the agent the ticket through the Atlassian MCP server, or paste it in. It reads the description, all comments, the attachments and any linked Confluence page.
3. Ask: "Turn this ticket into an intent using our template. List anything missing or unclear: users, constraints, scope, edge cases."
4. Send the open questions to the product owner as a Jira comment, each with a default. Example: "Should it include invoices older than 2 years? Default if I hear nothing: no."
5. Update the intent with the answers. Stop when the problem, outcome, constraints and scope are clear, and the rest are answered or written down as assumptions. One or two rounds is normal. If it takes more, have a short call.
6. Commit it as `intent/<ticket-key>-<short-name>.md` and link it from the ticket.

**The intent has these parts:** Source (Jira key, the ticket's last-updated time, the Confluence page version, when we last synced), Problem, Outcome, Affected systems, Constraints, Decisions from comments (who said what, and when), From attachments, Open questions, and a Changelog.

## 2. The refresh: keeping everything in sync with Jira

The ticket keeps changing after the intent is written: new comments, edits, a changed Confluence page. So **before each step (spec, plan, build, PR)** the agent refreshes the intent **and every file after it** that exists.

1. **Quick check.** Compare the ticket's last-updated time and the Confluence page version with the ones stored in the intent. If both are the same, the agent says "no change" and stops. This costs almost nothing.
2. **Compare, don't edit yet.** If something changed, the agent lists every change: description edits, new comments, new or changed attachments, Confluence edits.
3. **Update the intent.** The engineer confirms the proposed changes. The agent updates the intent, adds a changelog line, and sets the new sync time.
4. **Cascade.** The agent shows what must change in the spec, then in the plan, and the engineer confirms each.
5. **Code can't be refreshed automatically.** If building has started, the agent lists the parts of the code the change affects. We stop, bring intent, spec and plan up to date, and only then continue.

Prompt to reuse:
> "Re-read BILL-123 and its Confluence page. Compare them with `intent/BILL-123-invoice-csv.md` (last synced: <time>). List every change since then. Don't edit yet. Then show what must change in the spec and the plan."

**Rules**
- **Jira wins.** If a file and the ticket disagree, the ticket is right.
- **Comments can override the description.** That is why the intent keeps "Decisions from comments", with names and dates.
- **A file that is behind its parent says so** at the top, for example "Stale: intent changed on 3 Oct", until it is refreshed.

## 3. Sessions: one per step

Use a new session for each step: intent, spec, plan, build. The committed files carry the state, not the chat. A fresh session has no leftover assumptions, can't use anything that isn't written down, and doesn't suffer from a long, compacted conversation. You can also stop and resume, or hand over to someone else. If a fresh session can't continue from the files alone, the file is missing something, so fix the file.

Every new session starts the same way: "Read the intent (and the spec and plan if they exist), then refresh them against Jira."

**Exceptions:** small tickets can stay in one session. After the plan is approved, you can carry on building in the same session, because it already understands the code.

## 4. Spec: what we will build

1. Give the agent the intent and ask for a requirements and design spec for our codebase, following our skills (security, UX, compliance). Until we have skills, it follows the instruction file and the existing code.
2. Concerns the agent flags go to the policy owners, such as security or privacy, before anyone builds.
3. The product owner reads the spec, at least the open questions and the "what we will not do" part, and confirms in Jira with a comment. They don't need to use Git.
4. Commit it as `specs/<ticket-key>-<short-name>.md` and link it from the ticket.

## 5. Plan: how to build it in our code

This is the first time the agent reads the real code. Until now it only worked with documents. The spec says what to build. The plan says how, in our codebase.

1. Start the agent in plan mode, where it can read code but not change it, and give it the intent and the spec.
2. Ask hard questions: where does the change belong, what can we reuse, what could break?
3. Ask it to split the work into **tasks**, with the files each task touches, and which tasks depend on others. Tasks that touch different files can be built in parallel. Tasks that need another task's result come after it.
4. Repeat until someone who never saw the chat could build from the plan alone.
5. Commit it as `plans/<ticket-key>-<short-name>.md` and link it from the ticket.

If the plan shows the spec was wrong, update the spec too. Small changes are approved by the engineer. Risky ones go to a tech lead.

## 6. Build: one main session, tasks to subagents

One main session reads the plan and hands out the tasks (proposed).

- **Independent tasks** go to subagents that run in parallel, each in its own git worktree, a separate checkout on its own branch, so edits can't collide. In Claude Code this is `isolation: worktree`. In Copilot CLI, `/fleet` runs subagents and `/worktree` makes worktrees. We still need to check whether Copilot can give each subagent its own worktree.
- **Dependent tasks** run as subagents one after another in the normal checkout, so each sees the earlier result. Don't use worktrees for them: a subagent's worktree branches from the default branch, not from your current work (in Claude Code, unless `worktree.baseRef` is set to `"head"`).
- **Helper subagents** check and report but don't build: a verifier runs the app and compares it with the plan, a researcher looks up how existing code does something.
- **The agent checks its own work:** it runs build, test and lint and pastes the output. A failing test means it fixes the code, never the test. For a bug, the failing test is written and committed first. For UI work, it compares a screenshot with the design mock, usually in two or three rounds.
- **Each subagent commits** its work on its own task branch, with the Jira key in the commit message.
- **The main session merges** the task branches into the feature branch and runs the full suite on the combined result.
- **Push the feature branch** regularly, so work isn't only on one laptop. The build is done when everything is merged on the feature branch, the full suite passes, the engineer has reviewed the diffs, and the branch is pushed. Opening the PR is the next step.
- **The engineer reviews the actual diffs,** not only the subagents' summaries.
- **Start with two or three parallel subagents.** Add more only while you can still review the results well. Review is the limit, not the tools.
- **Large or long tasks** that need back-and-forth get their own session in a worktree, so the engineer can steer them.

## 7. PR: one PR per ticket

1. Refresh once more, because the reviewer will compare the PR with the intent.
2. Open one PR from the feature branch, with the Jira key in the title, for example "BILL-123: invoice CSV export". The PR contains the intent, spec, plan and code, so the reviewer sees what was asked, what was decided, how it was planned, and what was built.
3. Link the PR to the ticket and move the ticket to "In review".
4. The AI review runs first and ranks its findings. Tag the agent on a comment to get a finding fixed.
5. A code owner approves. The agent that wrote the code can never approve it.

## 8. Release

CI deploys to dev and staging. For production, the agent may prepare the release, but a hook blocks the deploy until a named release manager approves. After release, the ticket moves to "Done".

## 9. Back to the start

When a metric in production goes out of its normal range, the agent diagnoses it (read-only) and writes its finding. The finding becomes a new Jira ticket, linked to the old one, and the flow starts again at step 1.

---

# Part 2: One-time setup

Done once by tech leads and the platform team, then kept up to date.

## The instruction file (AGENTS.md)

One file at the root of each repo that tells the agent how the project works. The agent reads it at the start of every session. Both Copilot CLI and Claude Code read `AGENTS.md`, so we use that name (proposed).

1. Ask the agent to write a first draft from the codebase.
2. Cut it to what a new teammate needs on day one: **commands** (build, test, lint, with what success looks like), **conventions** that matter, a short **architecture** map, and **things the agent gets wrong**.
3. Add the rule: "Run the build, tests and lint before reporting a task complete, and paste the output. If a test fails, fix the code, not the test."
4. Keep it under one page. Old lines waste context.
5. Commit it at the repo root. Code owners review changes to it like any code.
6. When the agent makes the same mistake twice, add the fix to the file.

**Old (brownfield) repos.** Don't try to document everything. Start from the draft and add lines only when the agent makes a real mistake. Add the "don't touch" rules early: frozen packages, code owned by another team, odd patterns that are there on purpose. The engineer who knows the code must review the draft. In a big repo, keep a short root file and add a small file in each folder that has its own rules. Copilot CLI reads instruction files from the repo root down to the working folder.

**How we know it works:** the agent repeats fewer mistakes, and new people merge their first PR sooner.

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

## Build hooks (hard stops)

A hook is a script that runs before or after the agent acts, and can allow or block the action. During the build they run on every edit and command, so keep them fast and limited to the changed files.

- Block edits to test files during a fix.
- Block edits to protected paths: generated code, frozen packages.
- Run the formatter and linter after edits.
- Remove secrets from diffs.

Full test suites belong at commit or PR time. Hooks that need a human approval belong in the release setup below.

## Custom agents and permissions

Turn jobs we repeat into custom agents (Claude Code calls them subagents): a small file with a name, when to use it, the tools it may use, and its instructions. Commit them so the whole team uses the same ones.

**First one: a verifier.** It starts the app, tries the changed behaviour plus two neighbouring flows, and reports what it ran, what it saw, and where it differs from the plan. It fixes nothing. Its tools are limited to running commands and reading files.

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

1. Choose the review tool: a managed service that an admin turns on, or the agent running in our CI.
2. The tech lead writes a `REVIEW.md` at the repo root. It lists the review passes: bugs, security, and compliance with the spec, the plan and our design rules. It says what counts as **Important** (breaks behaviour, leaks data, breaks a policy) and what is only a **nit** (style, naming). It lists what to skip, such as generated files and anything CI already checks.
3. Findings don't approve or block a PR. Branch protection requires a code owner's approval.
4. When the same mistake shows up twice in review, add the fix to the instruction file.
5. Once a month, the tech lead rates the findings and caps nits (for example five per review).

**How we know it works:** time to first review drops to minutes, and more defects are caught before merge than found in production.

## Release gates and locked-down settings

1. Engineering leadership, with change management and compliance, writes down the approvals that must stay: change sign-off, release authorization, edits to protected paths.
2. The platform engineer turns each into a hook. Example: block any production deploy unless a named release authorization is present. Exit code 2 blocks the action, and the message goes back to the agent. The message must say why it stopped and how to get approval.
3. Team hooks live in the repo. Hooks nobody may switch off live in managed settings. In Copilot, org policy hooks and managed settings live in the organisation's `.github-private` repo, and take about an hour to apply.
4. For sensitive repos, lock down the setup: no reading of secrets files, no web fetches, safe commands pre-approved, a sandbox that must be running, network limited to an allowlist, credentials hidden from commands, and only approved hooks, MCP servers and plugins. Each restriction removes some capability, so match it to how sensitive the repo is.

Every allow or block decision is logged with a timestamp. Idea for us (not from the course): the hook could check that the Jira release ticket is approved.

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
5. The agent writes its finding (the anomaly and evidence, the wanted outcome, affected systems, open questions). It becomes a Jira ticket.
6. A person triages: fix now, schedule, or dismiss. Dismissals tune the levels and cut noise.

**How we know it works:** findings reach the queue quickly, more of them become merged fixes, and repeat incidents fall.

The course also shows an agent on call in Slack (Claude Tag). For us, the GitHub app for Slack is the nearest match, and we need to check what it can do.

---

## Rollout: where to start

Proposed order (not from the course, for discussion). Each phase adds one thing, and humans stay in control of decisions and approvals at every step.

1. **Start now:** `AGENTS.md` in each repo, one check command per repo, the hook that blocks test edits during a fix, and the per-ticket flow with a basic spec (no company skills yet): intake, refresh, spec, plan, build, PR.
2. **Next:** the first skill, used in specs and builds, a verifier agent, parallel subagents with worktrees, AI review of PRs, and evals.
3. **Then:** agents in CI/CD (read-only first), release gates and locked-down settings.
4. **Last:** the metrics loop, once we have a metrics store and a review gate we trust.

For the Copilot admin setup (managed settings, permissions, sandboxing), see Part 1 of the training, Tab 4 (Administration).

## Open questions

**Access and tools**
- Is the Atlassian MCP server allowed at work, and can it read attached images and linked Confluence pages?
- Which AI review tool do we use with Copilot, and can it read a `REVIEW.md`-style rules file?
- Can our CI run Copilot CLI without a person, and which model and cloud access is allowed from CI?
- Can Copilot `/fleet` give each subagent its own worktree?
- Which browser or screenshot tool may we use for UI checks?
- Do we use only `AGENTS.md`, or also `.github/copilot-instructions.md`?

**Ownership**
- Who owns the agent setup in each repo (instruction file, skills, hooks, review rules) and approves changes?
- Who owns company-wide skills, managed settings and policy hooks, and who signs off when a policy changes?
- Who approves a spec when the product owner can't judge the technical part?
- Who confirms a refresh: always the engineer, or the product owner for big changes?
- Who triages findings from the metrics loop?

**Process**
- Which tickets count as small and skip the intent?
- Should the agent read the code already in the spec step, or only in plan mode?
- How do we stop people building from a file marked stale?
- Which approvals in our change process must stay, and who approves each?
- Do review findings stay advice only, or do we ever gate merges on them?

**Readiness and cost**
- Can every repo run build, test and lint with one command each?
- Are our rules written down well enough to become skills?
- Where are our metrics stored, and how often do we practise rollback today?
- What is the budget for daily agent use (parallel subagents multiply token use) and for eval runs?

**First picks:** our first skill, our first 20 evals, our first metric, and the first deploy target for MCP tools.

---

## Example: the whole flow, BILL-123

**The ticket.** "Customers want to download invoices as CSV." The description says customers keep asking for an Excel-friendly export. A support lead commented "credit notes too please", and the product owner commented "nothing older than 2 years". A screenshot shows the Excel layout customers use (Invoice no, Date, Customer, Net, Tax, Total). A Confluence page, "Billing export requirements", says dates are UTC.

**Session 1: intake.** The engineer creates the branch `BILL-123-invoice-csv`. The agent reads the ticket, comments, screenshot and Confluence page, and writes `intent/BILL-123-invoice-csv.md`:

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

The agent posts the open question to Jira with its default.

**Session 2: spec.** The next day the product owner has answered "same file is fine". The refresh shows the new comment, the engineer confirms, and the intent gets a changelog line. The agent writes `specs/BILL-123-invoice-csv.md`: endpoint `GET /invoices/export`, the columns, a 10,000-row limit, own invoices only, every export logged. The security skill flags that tax IDs are personal data, and the privacy team says to leave them out. The product owner confirms the spec with a Jira comment.

**Session 3: plan.** The refresh finds no change. Plan mode reads the code, finds the existing `formatDate()` helper and the invoice repository, and writes `plans/BILL-123-invoice-csv.md` with three tasks: **A** the endpoint and CSV writer (`api/`, `core/`), **B** the "Download CSV" button (`web/`), and **C** the integration test, which needs A and B. A and B touch different files, so they can run in parallel.

**Session 4: build.** The refresh finds a new comment, "can we add a currency column?". The agent shows that the intent, spec and plan each need one more column. The engineer confirms, and the three files are updated before any code is written. Then:

- The main session gives tasks A and B to two subagents that run in parallel, each in its own worktree.
- A verifier subagent runs the app and reports what works and what doesn't. A researcher subagent looks up how existing endpoints are written. They fix nothing.
- In task A the tests catch that a customer name with a comma breaks the columns. The agent fixes the code, and a hook stops it from editing the test instead.
- Each subagent commits on its own task branch. The main session merges A and B into the feature branch. Task C then runs in the normal checkout: the integration test is written, and the full suite (`make build`, `make test`, `make lint`) runs on the combined result.
- The engineer reviews the diffs of each task, not only the subagents' summaries, and pushes the feature branch.

**PR.** One last refresh finds no change. The engineer opens "BILL-123: invoice CSV export" with the intent, spec, plan and code, links it to the ticket and moves the ticket to "In review". The AI review finds that the export query has no row limit, although the spec says 10,000. The engineer tags the agent, it fixes the query, and a code owner approves.

**Release.** CI deploys to dev and staging. In production the hook blocks the deploy until the release manager approves. They approve, it goes out, and the ticket moves to "Done". The team adds an eval for the new export task.

**Back to the start.** A week later the 5xx rate on the billing service goes above its normal range. The detection script runs the agent read-only. It finds timeouts for customers with more than 10,000 invoices, and its finding becomes BILL-140, linked to BILL-123: "export in the background and email a link". The flow starts again at intake.

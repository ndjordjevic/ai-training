# The AI-native SDLC Playbook: Summary

Course: [academy.claude.com/courses/ai-native-sdlc-playbook](https://academy.claude.com/courses/ai-native-sdlc-playbook/introduction)

A short summary of Anthropic's free course. It is not part of our training, but it is worth reading. How this could work for us, starting from Jira tickets, is in [our-sdlc.md](our-sdlc.md).

## The idea

AI now writes code much faster, but the process around the code is still the old one: the same approvals, reviews, handoffs and meetings. The slow part is no longer writing code. The delays move to the stages before and after the build. An AI-native SDLC keeps the old control goals but enforces them in new ways, with AI in every stage. The course has six stages: Plan, Design, Build, Test, Deploy and Maintain. Each stage ends by committing a file to Git, and that file starts the next stage. People spend their time reviewing those files.

The examples below follow one feature through all six stages: **customers want to download their invoices as a CSV file.**

## Stage 1: Plan

**Capture as intent.md.** Instead of weeks of backlog refinement, the person with the idea brainstorms with Claude. Claude then writes an `intent.md` file covering the problem, the outcome they want, who and what is affected, constraints and open questions. The author fixes anything Claude got wrong and commits the file to an `intent/` folder in the repo. Turn the `intent.md` template into a skill, so everyone uses the same format. The product owner reviews the file and approves it before design starts. The goal is to go from first conversation to committed `intent.md` in hours, not weeks.

> **Example:** A support lead keeps getting asked "can I get my invoices in Excel?". They talk it through with Claude for 15 minutes. Claude writes `intent/invoice-csv-export.md`. Problem: customers copy invoices by hand into spreadsheets. Outcome: a "Download CSV" button on the invoices page. Affected: the billing service and the web app. Open question: should it include invoices older than 2 years? The support lead fixes one line and commits. The product owner approves it the same day.

## Stage 2: Design

**Requirements and design.** Claude reads `intent.md` and writes `spec.md`, a requirements and design spec. Skills keep the spec in line with brand, security, compliance and UX rules. This merges the old separate requirements and design phases into one. The product owner reviews the spec, settles any flagged issues with the policy owners, and approves it for the build. You can later automate this as a slash command that runs when an `intent.md` is approved and opens `spec.md` as a pull request. Track how long it takes from `intent.md` to `spec.md`, and how often the spec changes after the build starts.

> **Example:** The product owner runs the prompt on the intent file. Claude writes `spec.md`: a new API endpoint `GET /invoices/export`, the CSV columns, a limit of 10,000 rows, and a button placed by the UX skill. The security skill adds "only the customer's own invoices; log every export". It also flags that tax IDs count as personal data. The product owner checks with the privacy team, who say to leave tax IDs out. The spec is updated and approved.

## Stage 3: Build

**Plan mode as the default start.** The engineer gives Claude `intent.md` and `spec.md` in plan mode. Claude asks questions and writes an implementation plan, and nothing is edited yet. Push back on risks and alternatives until someone who never saw the chat could build from the plan alone. Then commit it as `plan.md`. Fixing a design in a document is cheap, while fixing it in code is not. Once your guardrails are good (`CLAUDE.md`, skills, hooks and tests), you can let Claude carry out the plan in auto mode.

**The CLAUDE.md.** `CLAUDE.md` is the file Claude reads at the start of every session. Run `/init` to create a first version, then cut it down to what a new teammate would need on day one: build, test and lint commands, key conventions, the architecture, and the mistakes Claude often makes. Keep it under a page, because stale lines waste context. Commit it so changes are reviewed like code. Rule of thumb: when Claude makes the same mistake twice, add the fix to `CLAUDE.md`.

**Skills as institutional knowledge.** Use skills for company rules that must be applied the same way everywhere, such as security or API standards. A skill lives in `.claude/skills/<name>/SKILL.md`, and you can share it across repos with a plugin. Start with one policy that isn't being enforced today. Write the skill from the policy owner's source, test that it triggers, and update it when the policy changes. Skills are advice, not guarantees, so use hooks for anything that must never happen.

**Parallel sessions and subagents.** One engineer can run several Claude sessions at once, each in its own Git worktree (`claude --worktree <name>`) on its own task. The sessions don't know about each other, so split the work so they don't touch the same files. Start with two or three sessions, and add more only as fast as you can review the results. Subagents are helpers defined in `.claude/agents/`, with their own instructions and limited tools, for repeated jobs like checking work. Commit them so the whole team uses the same ones.

> **Example:** The engineer starts Claude in plan mode with `intent.md` and `spec.md`. Claude asks: "stream the CSV, or build it in memory?" They pick streaming, and Claude writes `plan.md` with three steps: the endpoint, the CSV writer and the button. `CLAUDE.md` already says "dates are always UTC, use `formatDate()`", so Claude doesn't invent its own date format. The `secure-api-review` skill makes sure the endpoint checks the user's token and logs the export. The engineer runs two sessions in parallel, `claude --worktree export-api` for the backend and `claude --worktree export-button` for the UI, because they touch different files. A `verifier` subagent checks each one against the plan.

## Stage 4: Test

**Give Claude a feedback loop.** Let Claude check its own work before a person sees it. Give it one command, such as `make test`, that fails when something is wrong, and list it in `CLAUDE.md`. Set clear targets like "all tests pass" or "the screenshot matches the mock". Use hooks to stop Claude from editing tests to make them pass. For a bug, write the failing test first, then let Claude fix only the code. For UI work, give Claude a browser or screenshot tool and the design mock, so it can compare and improve over two or three rounds.

**Continuous evals in CI.** Evals are tests for your agent setup. Collect 20 to 50 real tasks with known good results and write each as an eval. Run them in CI with `claude -p` whenever `CLAUDE.md` or the `.claude/` folder changes, and also on a schedule. Block a config change if the pass rate drops. When something breaks in production, add it as a new eval so it can't happen again.

> **Example:** `CLAUDE.md` says "run `make test` before you say you're done". Claude writes the export code, runs the tests, and sees one fail: a customer name with a comma breaks the CSV columns. It adds quoting and runs the tests again, and they pass. A hook stops it from "fixing" the test instead of the code. For the button, it takes a screenshot and compares it with the mock. Later, someone edits `CLAUDE.md`. The eval suite runs 30 past tasks, including "add a CSV export", and the pass rate drops from 93% to 80%, so the change is blocked until it's fixed.

## Stage 5: Deploy

**AI in the PR review loop.** Claude reviews every PR against your rules and ranks its findings by severity. People then focus on intent and risk, not small details. Write a `REVIEW.md` file that says what to check (bugs, security, compliance), what counts as important, and what to skip. Use the managed Code Review service or `claude-code-action` in CI, and still require code owner approval. Tag `@claude` on a review comment to get it fixed. When the same issue comes up twice, add it to `CLAUDE.md`.

**Hooks as approval gates.** Hooks can allow, block or pause what Claude does, so they enforce approvals instead of just asking for them. Leaders decide which gates are needed, for example release sign-off or edits to protected files. Platform engineers then write them as hook scripts. Team hooks go in `.claude/settings.json`. Hooks that must never be turned off go in managed settings, with `allowManagedHooksOnly` set. Example: a hook blocks any production deploy unless a release approval is present. Log every decision for audits.

**CI/CD integration and deployment.** Run Claude in pipelines with `claude -p`. Start with read-only work like triaging failed builds, summarising flaky tests or drafting changelogs. Run agent jobs in sandboxed containers with short-lived tokens and no standing production access. Give deploy, status and rollback to Claude as MCP tools, limited per environment. Let Claude deploy freely to dev, give it less freedom in staging, and require a human release manager for production. Practise rollback often, so Claude can run it when needed.

> **Example:** The engineer opens a PR. Within minutes Claude reviews it using `REVIEW.md` and finds one Important issue: the export query has no row limit. The engineer comments `@claude fix this`, Claude pushes a fix, and a code owner approves. CI deploys to dev and staging on its own. When Claude tries to deploy to production, the hook blocks it with "release approval missing". The release manager approves, and the deploy goes out. Later a nightly build fails, and Claude triages it in CI: "flaky test, not related to the export". Nobody gets paged.

## Stage 6: Maintain

**Closing the loop on metrics.** Pick one stable metric, such as test failure rate, error rate after deploys, or PR cycle time, and watch it with a simple detection script. Respond in tiers: a small change is only logged, a bigger one has Claude look into it read-only, and a serious one lets Claude propose a fix as a PR. In the last case, Claude writes a new `intent.md`, which restarts the loop at Stage 1 without anyone having to start it. People still approve the findings.

> **Example:** The team watches the 5xx error rate on the billing service. A week after release, it jumps far above normal. The detection script sees this and runs Claude read-only. Claude finds that large customers with over 10,000 invoices hit a timeout on export. It writes `intent/export-timeout-large-accounts.md`, with the evidence and a proposed fix ("export in the background and email a link"). The product owner approves it, and the loop starts again at Stage 1.

## Closing

Humans stay in charge of decisions and governance. Platform teams should add controls step by step: admin setup first, then security, monitoring (OpenTelemetry) and compliance.

# Agentic AI wiki resources on software / dark factories

Scope: the user's local wiki at `/Users/nenaddjordjevic/LLMProjects/agentic-ai-wiki/` (376 source pages, git-pulled). Wiki page paths are relative to that repo. `inbox.md` has **no pending items**. Every factory-related URL in it is already ingested. Each finding gives the wiki page plus the original source URL.

Searches that found nothing: **StrongDM** (its "Software Factory" / dark factory rules, digital twin universe) is not in the wiki or in `raw/`. "Digital twin" has no factory-related hits. Langfuse appears only as a LiteLLM integration. GitHub Copilot coding agent appears only in passing.

## 1. Factory / autonomous pipeline architectures: sources and key ideas

### Takeaway
The wiki has seven core factory sources:
- a conceptual explainer (MindStudio "dark factory");
- Anthropic's harness-design research;
- Google's "factory model" whitepaper;
- three working factories (Cole Medin's AI Software Factory, ZazenCodes' Claude Code factory, Warp Factories);
- the Ralph-loop family.

They agree on four practices:
- keep generation and evaluation in separate agents;
- carry state in files, not in context;
- use git worktree isolation;
- use deterministic gates.

The two production-grade factories reject full "lights-out" operation. Humans keep "what to build" and "is what landed right", plus irreversible actions.

### Cited Findings

**Dark factory concept** (`wiki/sources/dark-factory-autonomous-ai-codebase.md`)
- A dark factory is a fully autonomous software development system where agents plan, code, test and deploy without human intervention. The name comes from lights-out manufacturing. — [MindStudio](https://www.mindstudio.ai/blog/what-is-dark-factory-autonomous-ai-codebase)
- It names five components:
  - Planning Agent (goals become structured tasks with dependencies);
  - Code Generation Agents (grounded in the existing codebase);
  - Validation Layer (automated tests plus validator agents);
  - Deployment System (automated shipping with rollback);
  - Orchestration Layer.

  — [MindStudio](https://www.mindstudio.ai/blog/what-is-dark-factory-autonomous-ai-codebase)
- Its patterns:
  - a Planner-Generator-Evaluator loop kept adversarial, so agents do not approve their own output;
  - a mix of deterministic and agentic nodes;
  - parallel agent teams on different parts of the codebase;
  - harnesses that bound what agents can access.

  — [MindStudio](https://www.mindstudio.ai/blog/what-is-dark-factory-autonomous-ai-codebase)
- Its failure-mode checklist: cascading failures from flawed plans, irreversible actions by overprivileged agents, evaluation gaming (agents grading their own work), and agent sprawl. — [MindStudio](https://www.mindstudio.ai/blog/what-is-dark-factory-autonomous-ai-codebase)
- "True production dark factories remain rare." Most organizations run factory components inside human-supervised pipelines. Its example is Stripe's 1,000+ AI-generated PRs per week, which still get human review. — [MindStudio](https://www.mindstudio.ai/blog/what-is-dark-factory-autonomous-ai-codebase)
- The wiki's raw capture of this article is only about 2 KB. The wiki page is close to everything the article says.

**Anthropic harness design for long-running apps** (`wiki/sources/anthropic.com-managed-agents.md`; video explainer `wiki/sources/9d5bzxVsocw-anthropic-just-dropped-the-new-blueprint.md`)
- Failure mode 1, **context anxiety**: as context fills, models rush, declare done early and wrap up. Sonnet 4.5 did this even with compaction.
  - Fix: context resets with a structured handoff artifact.
  - Opus 4.6 largely removed the need for resets.

  — [Anthropic engineering](https://www.anthropic.com/engineering/harness-design-long-running-apps)
- Failure mode 2, **poor self-evaluation**: agents praise their own mediocre work. A separate evaluator tuned to be skeptical is "far more tractable" than making the generator self-critical. — [Anthropic engineering](https://www.anthropic.com/engineering/harness-design-long-running-apps)
- The GAN-inspired three-agent design:
  - **Planner**: turns a 1–4 sentence prompt into a full spec.
  - **Generator**: builds in sprints or one continuous session.
  - **Evaluator**: uses Playwright MCP to drive the running app like a user, and grades against explicit criteria, each with a hard threshold.
  - **Sprint contracts**: generator and evaluator agree on what "done" means before building.
  - Communication between agents is file-based.

  — [Anthropic engineering](https://www.anthropic.com/engineering/harness-design-long-running-apps)
- Results:

  | Run | Model | Time | Cost | Outcome |
  |---|---|---|---|---|
  | Retro game maker, full harness | Opus 4.5 | 6 h | $200 | Working game (a solo run gave a broken $9 result) |
  | Browser DAW, simplified harness | Opus 4.6 | 3 h 50 min | $124 | Working app after three build/QA cycles |

  — [Anthropic engineering](https://www.anthropic.com/engineering/harness-design-long-running-apps)
- Harness evolution principle: "every harness component encodes an assumption about what the model cannot do on its own." Those assumptions go stale. Read traces, remove components that no longer carry weight, and add new ones. — [Anthropic engineering](https://www.anthropic.com/engineering/harness-design-long-running-apps)
- Three lessons for evaluators, from the video:
  - make subjective quality gradable with explicit criteria;
  - weight the criteria toward the model's known weak spots;
  - give the evaluator interactive tools.

  Quote: "Out of the box, Claude is a poor QA agent… talked itself into deciding they weren't a big deal." — [The AI Automators video](https://youtu.be/9d5bzxVsocw)

**Google whitepaper "The New SDLC with Vibe Coding"** (Osmani, Saboo, Kartakis, May 2026; `wiki/sources/the-new-sdlc-with-vibe-coding.md`)
- **Agent = Model + Harness.** The harness has six parts: instructions/rule files, tools, sandboxes, orchestration logic, guardrails/hooks, and observability. — [Whitepaper (Google Drive)](https://drive.google.com/file/d/1IR7CddF_2FyQo_PdfBNTaEA50EGiVt2r/view)
- Evidence that the harness matters:
  - On Terminal Bench 2.0, one team went from outside the Top 30 to the Top 5 by changing only the harness.
  - A LangChain study gained 13.7 points by changing only the prompt, tools and middleware.
  - "Most agent failures… are configuration failures."

  — [Whitepaper](https://drive.google.com/file/d/1IR7CddF_2FyQo_PdfBNTaEA50EGiVt2r/view)
- **Factory model**: the developer's output becomes the system that produces code (specs, agents, test suites, feedback loops, guardrails). Developers give success criteria, not step-by-step instructions. — [Whitepaper](https://drive.google.com/file/d/1IR7CddF_2FyQo_PdfBNTaEA50EGiVt2r/view)
- **Conductor vs. orchestrator** roles. The orchestrator delegates async work to background agents. There is an "80% problem": agents produce about 80% fast, and the last 20% (edge cases, integration, correctness) needs human judgment. — [Whitepaper](https://drive.google.com/file/d/1IR7CddF_2FyQo_PdfBNTaEA50EGiVt2r/view)
- Verification is the sharpest dividing line. Tests check deterministic outputs. Evals check non-deterministic trajectories. "Generation is solved. Verification, judgment, and direction are the new craft." — [Whitepaper](https://drive.google.com/file/d/1IR7CddF_2FyQo_PdfBNTaEA50EGiVt2r/view)

**Cole Medin's AI Software Factory** (`wiki/sources/coleam00-ai-software-factory.md`), the most detailed production example
- It is explicitly **not a dark factory**. Humans own two places: deciding what to build (PRD or issues) and judging what landed in staging. Triage through merge runs on Archon workflows. — [coleam00/ai-software-factory](https://github.com/coleam00/ai-software-factory)
- The flow:
  - `archon-backlog` slices a PRD into linked, ordered issues. The first issue makes the product runnable end to end.
  - `archon-loop` works the backlog unattended, one move per lap.
  - Reviewers that did not write the code decide whether it merges.
  - Merged work lands in staging, and defects become new issues.

  — [coleam00/ai-software-factory](https://github.com/coleam00/ai-software-factory)
- Three human-owned files:
  - `MISSION.md`: the product and an out-of-scope list of 5+ items, used to spot drift.
  - `harness/END-TO-END.md`: 2–5 real user journeys. "Page loads" is rejected as a bar.
  - `.factory/holdout/HOLDOUT.md`: independent scenarios written from the product document. A Claude Code hook fences them, so builders cannot read them. Only the `holdout-writer` and `holdout-verifier` agents can see them.

  This holdout idea is the closest thing in the wiki to StrongDM-style "scenarios". — [coleam00/ai-software-factory](https://github.com/coleam00/ai-software-factory)
- A **deterministic merge gate** merges only what an evidence record supports.
  - **Protected paths** (MISSION.md, FACTORY_RULES.md, `harness/**`, `.factory/**`, `.claude/settings.json`) cannot be changed by a factory delivery.
  - **Irreversible actions** stop the factory for a human: identity, auth, impersonation, migrating or deleting stored data.

  — [coleam00/ai-software-factory](https://github.com/coleam00/ai-software-factory)
- Check depth scales with risk (light, normal, deep). At normal depth, only the holdouts the work item touches run. The manager runs all of them on the default branch. — [coleam00/ai-software-factory](https://github.com/coleam00/ai-software-factory)
- Design decisions from its `DECISIONS.md` log:
  - Evidence-checked gates were added after an audit found escaped defects graded PASS.
  - Parallel laps claim work through GitHub comments.
  - The scheduler abandons a lap whose log is silent for 60 minutes and keeps the branch.
  - Pin commits carry `Hypothesis` and `Measure` trailers, so each factory version can be scored.

  — [coleam00/ai-software-factory](https://github.com/coleam00/ai-software-factory)
- Operations:
  - It runs on an always-on VPS (8 GB RAM minimum) with systemd, launchd or Task Scheduler timers.
  - `IS_SANDBOX=1` lets Claude Code run unattended as root, and the token sits in a mode-600 env file.
  - `parallel` laps can be set from 1 to 8.
  - `pause` and `halt` commands exist, and `merge=approve` lets you watch the first lap before enabling auto-merge.
  - "Leave scheduling off until that lap has been seen."

  — [coleam00/ai-software-factory](https://github.com/coleam00/ai-software-factory)

**ZazenCodes "Software Factory for Claude Code"** (`wiki/sources/software-factory-claude-code.md`)
- Built only from Claude Code primitives: one `/factory` skill and seven subagents.
  - Flow: spec-writer → builder → four reviewers in parallel (security, UX, UI, code) → a "WAIT FOR ALL" barrier → approver, which merges or escalates to needs-human.
  - On CHANGES, the builder is resumed at most twice, so a job gets at most three review rounds.

  — [zazencodes software-factory-claude-code](https://github.com/zazencodes/zazencodes-season-3/tree/main/src/software-factory-claude-code)
- Model tiers: spec-writer, builder, security reviewer and approver run on Opus. The UX, UI and code reviewers run on Sonnet. — [same](https://github.com/zazencodes/zazencodes-season-3/tree/main/src/software-factory-claude-code)
- File contracts: every review starts `VERDICT: PASS|CHANGES`, and the decision starts `APPROVE|ESCALATE`. Each job gets one `job.json` and one worktree, to avoid write contention. — [same](https://github.com/zazencodes/zazencodes-season-3/tree/main/src/software-factory-claude-code)
- The approver escalates anything touching money, auth, permissions, deploy/CI/build config, schema migrations, email, production data, new dependencies, or business decisions. In the example, a job was escalated because it edited a prerender script, which counts as deploy config. — [same](https://github.com/zazencodes/zazencodes-season-3/tree/main/src/software-factory-claude-code)

**Warp Factories** (`wiki/sources/warpdotdev-warp-factory-examples.md`, `wiki/sources/warp.dev.md`)
- Declarative `factory.yaml` pipelines on Warp's Oz cloud platform.
  - Triggers: GitHub issues/PRs, Slack, Linear, schedules, webhooks.
  - Each agent has its own model or harness, compute, secrets and MCP servers.
  - Exactly one `FOREMAN` agent per factory.

  — [warpdotdev/warp-factory-examples](https://github.com/warpdotdev/warp-factory-examples)
- Example `02-sdlc-issue-to-pr` runs intake → triage → spec → implement → review, with a model and compute choice per stage. — [warpdotdev/warp-factory-examples](https://github.com/warpdotdev/warp-factory-examples)
- Example `03-multi-harness` uses a Warp Agent foreman, a Claude Code implementer and a Codex reviewer. — [warpdotdev/warp-factory-examples](https://github.com/warpdotdev/warp-factory-examples)
- Example `05-ui-verification` uses a computer-use agent to check UI behavior in a browser. — [warpdotdev/warp-factory-examples](https://github.com/warpdotdev/warp-factory-examples)

**Harness engineering and Ralph loops**
- Harness engineering means building the context and workflows around an agent so it follows the team's process, instead of "a clever stranger guessing". (`wiki/sources/coleam00-harness-engineering-demo.md`) — [coleam00/harness-engineering-demo](https://github.com/coleam00/harness-engineering-demo)
  - The **PIV loop** is Plan → Implement → Validate.
  - A PostToolUse hook lints after every edit.
  - A **Stop hook blocks the turn from ending until ruff and pytest pass**: "hooks, not prompts" make validation non-optional.
  - Plans and reports pass between sessions as markdown files.
- Ralph, from the same repo: headless `claude -p` sessions re-run against a spec until a `DONE.txt` sentinel appears. It commits after each iteration. `--worktree` and `--db-isolate` let parallel runs work safely. `claude -p` draws on a separate Agent SDK credit pool. — [coleam00/harness-engineering-demo](https://github.com/coleam00/harness-engineering-demo)
- snarktank/ralph (`wiki/sources/snarktank-ralph.md`), based on Geoffrey Huntley's pattern: — [snarktank/ralph](https://github.com/snarktank/ralph)
  - Each iteration is a **fresh agent with a clean context** that implements one `prd.json` story, runs typecheck, lint and tests, and commits only if they pass.
  - Memory lives only in git, an append-only `progress.txt` and the `prd.json` flags.
  - The default is a 10-iteration cap.
  - Stories must fit in one context window.
  - It is unsuitable without automated quality gates, because "broken code compounds silently".
- frankbria/ralph-claude-code (`wiki/sources/frankbria-ralph-claude-code.md`) adds production safeguards: — [frankbria/ralph-claude-code](https://github.com/frankbria/ralph-claude-code)
  - a dual exit gate (heuristics plus an explicit `EXIT_SIGNAL`);
  - a **circuit breaker** that opens after 3 no-progress loops or 5 same-error loops, with a 30-minute cooldown;
  - a rate limit (100 calls/hour) and `MAX_TOKENS_PER_HOUR`;
  - GitHub issue import with a 0–100 completeness score (it writes a plan if the score is below 60);
  - issue lifecycle actions: progress comments, close the issue, open a draft PR, file follow-up issues for TODO/FIXME;
  - a priority/dependency queue;
  - Docker or E2B sandboxes.

### Inferences
- The wiki's practical consensus is a "dim factory": autonomous in the middle, with humans at intent, acceptance, and irreversible or risky changes. Fully lights-out operation is described as rare (MindStudio) or rejected outright (Cole Medin).
- Holdout scenarios that builders cannot see, plus independent evaluators, are the wiki's answer to "evaluation gaming". They work like StrongDM's scenario/holdout idea, but the wiki has no StrongDM source.

### Gaps
- StrongDM's dark factory (its rules and digital-twin test environments) is not in the wiki. It needs a web source.
- The MindStudio article itself is short and gives no implementation detail.

## 2. Orchestrating many agents, triggering from issue trackers, background/cloud agents

### Takeaway
OpenAI Symphony is the reference design for ticket-driven dispatch. It polls Linear, GitHub, Jira, Asana or GitLab, runs one isolated workspace per issue, and puts policy in an in-repo `WORKFLOW.md`. Archon, Warp Oz, Factory.ai Droid, Devin, Paperclip, Orca, firstmate and Vibe Kanban cover other parts of the fleet and trigger story.

### Cited Findings

**OpenAI Symphony** (`wiki/sources/openai-symphony.md`, plus the SPEC.md fetched for detail)
- A long-running service:
  - polls the tracker;
  - claims eligible issues;
  - creates a deterministic per-issue workspace;
  - runs the coding agent in app-server mode;
  - stops and reconciles when issue state changes.

  It ships as a language-agnostic `SPEC.md` plus a reference Elixir implementation. It is labeled an "engineering preview for trusted environments". — [openai/symphony](https://github.com/openai/symphony)
- Adapters cover Linear, GitHub Issues, Jira Cloud, Asana and GitLab. Tracker tools (`linear_graphql`, `jira_rest`, ...) run on the host, so the agent never holds tracker credentials. — [openai/symphony](https://github.com/openai/symphony)
- Defaults from the spec:

  | Setting | Default / rule |
  |---|---|
  | Poll interval | 30000 ms |
  | `agent.max_concurrent_agents` | 10 |
  | Per-state caps | optional |
  | Dispatch order | priority, then oldest, then identifier |
  | Failure backoff | `min(10000*2^(n-1), max_retry_backoff_ms=300000)` |
  | `agent.max_turns` | 20 |
  | `codex.stall_timeout_ms` | 300000 (kills a silent worker) |
  | `codex.turn_timeout_ms` | 3600000 |

  — [Symphony SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md)
- Reconciliation by issue state:
  - Terminal state: stop the worker and clean up the workspace.
  - Non-active state: stop the worker without cleanup.
  - The spec has no built-in "Human Review" state. It is an example handoff state a workflow can end in, short of Done.

  — [Symphony SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md)
- Workspace hooks are `after_create`, `before_run`, `after_run` and `before_remove`. The agent's working directory must equal the workspace path, which must stay under the workspace root. — [Symphony SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md)

**Archon** (`wiki/sources/coleam00-archon.md`)
- A YAML DAG workflow engine. Nodes are deterministic (bash, git, tests) or AI steps (Claude Code SDK, Codex SDK, Pi). Loop nodes run `until: ALL_TASKS_COMPLETE`, and human gates run `until: APPROVED`. — [coleam00/archon](https://github.com/coleam00/archon)
- Every run gets its own worktree, and five can run in parallel on one repo. — [coleam00/archon](https://github.com/coleam00/archon)
- Adapters: CLI, Web UI, Slack, Telegram, Discord, GitHub webhooks. — [coleam00/archon](https://github.com/coleam00/archon)
- It has 17 built-in workflows, for example `archon-fix-github-issue`: classify → investigate → plan → implement → validate → PR → review → self-fix. — [coleam00/archon](https://github.com/coleam00/archon)

**Warp Oz** (`wiki/sources/warp.dev.md`)
- Cloud agents start from Slack (`@warp`), Linear, GitHub, webhooks or schedules. They run in Docker or Kubernetes sandboxes (hosted or self-hosted) and leave auditable run transcripts. — [warp.dev](https://www.warp.dev/)
- Supervisor/worker, fan-out, DAG and swarm patterns can mix Claude Code and Codex subagents. — [warp.dev](https://www.warp.dev/)

**Factory.ai Droid** (`wiki/sources/factory.ai.md`)
- **Missions**: an orchestrator splits a plan into features and milestones, runs worker droids per feature and validator droids at each milestone. The cost heuristic is "total runs ≈ #features + 2 × #milestones". — [factory.ai](https://factory.ai/)
- Headless mode: `droid exec`. — [factory.ai](https://factory.ai/)
- Jira and Linear integrations, and a Session API. — [factory.ai](https://factory.ai/)
- A "Readiness Report" scores a repo's autonomy maturity. — [factory.ai](https://factory.ai/)

**Devin** (`wiki/sources/cognition.ai.md`)
- Works in a sandboxed Linux environment with shell, editor and browser, and opens PRs on its own. Humans can watch and steer in real time. — [cognition.ai](https://cognition.ai/)

**Fleet and control planes**
- Paperclip (`wiki/sources/paperclipai-paperclip.md`) is a control plane for "agent companies". — [paperclipai/paperclip](https://github.com/paperclipai/paperclip)
  - A ticket system with single assignees and atomic checkout before work.
  - Heartbeats: a database-backed wakeup queue.
  - Routines triggered by cron, webhook or API.
  - Board approvals, and run-ID audit headers.
- Orca (`wiki/sources/stablyai-orca.md`) is a desktop app for fleets of agents, one worktree each, with native GitHub and Linear task flows. — [stablyai/orca](https://github.com/stablyai/orca)
- firstmate (`wiki/sources/kunchenguid-firstmate.md`): one liaison session spawns worker agents in tmux, each in a worktree. It watches them with "near-zero-token bash watchers" and escalates only real captain decisions. — [kunchenguid/firstmate](https://github.com/kunchenguid/firstmate)
- Agent of Empires (`wiki/sources/njbrake-agent-of-empires.md`) runs parallel tmux sessions, worktrees and Docker sandboxes for 10+ CLIs, including Copilot CLI. — [njbrake/agent-of-empires](https://github.com/njbrake/agent-of-empires)
- Beads (`wiki/sources/gastownhall-beads.md`) is a dependency-aware task graph built for agents, replacing markdown task lists. — [gastownhall/beads](https://github.com/gastownhall/beads)

**Claude Code Dynamic Workflows** (`wiki/sources/how-to-master-dynamic-workflows-claude-code-6-patterns-14-steps.md`)
- Six patterns: classify-and-act, fan-out-and-synthesize, adversarial verification, generate-and-filter, tournament, and loop-until-done. — [@0xCodez on X](https://x.com/0xCodez/status/2062127385923776831)
- Each agent can have its own model and its own isolation (worktree or remote). — [@0xCodez on X](https://x.com/0xCodez/status/2062127385923776831)
- `/goal` and `/loop` are available, and the guide recommends explicit token budgets. — [@0xCodez on X](https://x.com/0xCodez/status/2062127385923776831)

**Claude Managed Agents** (`wiki/sources/anthropic.com-managed-agents.md`)
- One coordinator plus context-isolated threads that share a container. Limits: 20 agents per roster and 25 concurrent threads. Mid-run steering and interrupts work through events. — [Anthropic engineering](https://www.anthropic.com/engineering/harness-design-long-running-apps)

### Inferences
- A common shape across Symphony, Archon, Cole's factory, Paperclip and frankbria Ralph:
  - claim or lock the ticket (comment, checkout API, or claim state);
  - run in an isolated worktree or workspace;
  - cap concurrency;
  - retry with backoff;
  - detect stalls (Symphony 5 minutes, Cole's scheduler 60 minutes).

### Gaps
- The wiki has little on GitHub Copilot coding agent or Copilot cloud agents, which matters because the company uses Copilot. The Google whitepaper and `github-awesome-copilot.md` mention them only briefly.
- The wiki has no Jira-specific factory example. Jira appears only as an adapter in Symphony and an integration in Factory.ai.

## 3. Human-in-the-loop, approvals, dashboards

### Takeaway
The wiki's factories put humans at a few explicit gates: a resume after the iteration cap, merge-or-escalate, "needs-owner" queues, and draft-first outbound actions. Watching runs needs live dashboards. Factory Mission Control is the most detailed example, with a scorecard, an owner queue and stuck-lap health checks.

### Cited Findings
- **Factory Mission Control** (`wiki/sources/coleam00-factory-mission-control.md`) — [coleam00/factory-mission-control](https://github.com/coleam00/factory-mission-control)
  - The problem it solves: factory state was spread over Archon run history, GitHub, and the repo's `DECISIONS.md`.
  - Its answer is one Postgres database (Neon Realtime), with every panel a live query. It is read-only toward GitHub and Archon in v1.
  - It ingests GitHub webhooks for issues, comments, PRs, pushes and labels, plus a nightly reconcile.
- Mission Control views: — [coleam00/factory-mission-control](https://github.com/coleam00/factory-mission-control)
  - an architecture map with live lap counts per step;
  - an issue graph built from `Depends on: #n`;
  - one lane per running lap;
  - an **owner queue** of `needs-owner` issues;
  - per-step model, tokens and cost for each lap;
  - **health**: steps running longer than 2× their 90th-percentile duration, failed laps by cause (usage limit, auth, infrastructure), and workable issues compared with running laps;
  - 7-day rewind.
- Its scorecard metrics: — [coleam00/factory-mission-control](https://github.com/coleam00/factory-mission-control)
  - lap, merge, empty lap, failed lap;
  - send-back, gate refusal;
  - lap-hours per merge, **cost per merge**;
  - new holdout catch.

  A difference based on fewer than 10 laps is labeled "not yet meaningful".
- **Agent Control Plane** (`wiki/sources/coleam00-agent-control-plane.md`) — [coleam00/agent-control-plane](https://github.com/coleam00/agent-control-plane)
  - A loop that hits `maxIterations` parks at `awaiting_approval`. A resume API or button is "the human gate before more compute is spent".
  - Every run is stored in Neon with role, tokens, `cost_usd`, and `parent_run_id`.
  - It has a React/Retool dashboard.
- **ZazenCodes factory**: `dashboard.html` polls every 2 seconds and shows job cards moving through stages, with needs-human jobs highlighted. `/factory approve` and `/factory rework <note>` are the human actions. — [zazencodes](https://github.com/zazencodes/zazencodes-season-3/tree/main/src/software-factory-claude-code)
- **Vibe Kanban** (`wiki/sources/vibekanban.com.md`) — [vibekanban.com](https://vibekanban.com/)
  - Plan → Prompt → Review cycle. The issue text becomes the prompt, and inline diff comments go back to the agent.
  - Thesis: "planning and review [are] the new speed limit".
- **Archon** has human-approval nodes (`interactive: true`) and one monitoring sidebar across all adapters. — [coleam00/archon](https://github.com/coleam00/archon)
- **Kylon** (`wiki/sources/kylon.io.md`) — [kylon.io](https://kylon.io/)
  - **Draft-first approvals**: consequential outbound actions become editable drafts that a human sends.
  - Autonomous agent-to-agent handoffs are capped at 12 hops.
- **Factory.ai**: every change goes through a diff review step. — [factory.ai](https://factory.ai/)
- **Symphony** hands off to human-review or merge states defined in `WORKFLOW.md`, and runs can post proof artifacts (CI status, review signals, walkthrough notes). — [openai/symphony](https://github.com/openai/symphony)

### Inferences
- The recurring design is an "owner queue" plus escalation rules, not approval of each step. Review effort goes to the risky categories (auth, money, migrations, CI/deploy config, new dependencies).

### Gaps
- No source measures how much human review time these gates actually save.

## 4. Observability, tracing, cost, model selection/routing, evals

### Takeaway
In the factory sources, observability usually means per-run rows in a database (tokens, cost, parent run, status) shown on a live dashboard. OpenTelemetry and Langfuse show up only on general platforms (Trigger.dev, LiteLLM, Databricks). Model tiering is standard: Opus for spec, build, security and approval; Sonnet or Haiku for cheaper roles. Evals mean independent evaluators, holdouts, and trajectory evals in CI.

### Cited Findings
- Symphony's observability rules: — [Symphony SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md)
  - structured `key=value` logs with `issue_id` and `session_id`;
  - failures visible to operators without a debugger;
  - token accounting from absolute thread totals, to avoid double counting;
  - an optional `GET /api/v1/state` endpoint.
- frankbria Ralph writes per-loop `metrics.jsonl`, has a `ralph-stats` command and a tmux `ralph --monitor` view, and supports desktop notifications and `--dry-run`. — [frankbria/ralph-claude-code](https://github.com/frankbria/ralph-claude-code)
- Cole's factory scores each version with `Hypothesis`/`Measure` commit trailers and the dashboard scorecard (cost per merge, new holdout catch). — [coleam00/ai-software-factory](https://github.com/coleam00/ai-software-factory)
- Trigger.dev (`wiki/sources/trigger.dev.md`) uses OpenTelemetry for its trace view, and has human-in-the-loop waitpoints and checkpoint-resume. — [trigger.dev](https://trigger.dev/)
- LiteLLM (`wiki/sources/litellm.ai.md`) has one-line integrations with Langfuse, MLflow, Helicone, Arize Phoenix and OTEL. — [litellm.ai](https://www.litellm.ai/)
- Databricks (`wiki/sources/databricks.com.md`) offers MLflow tracing and eval, and Unity Gateway, which governs model, MCP, skill and coding-agent traffic. — [databricks.com](https://www.databricks.com/)
- Model tiers in practice:
  - ZazenCodes: Opus for spec, build, security review and approval; Sonnet for UX, UI and code review. — [zazencodes](https://github.com/zazencodes/zazencodes-season-3/tree/main/src/software-factory-claude-code)
  - Dynamic Workflows: Opus for hard reasoning, Haiku for cheap exploration, Sonnet in between. — [@0xCodez](https://x.com/0xCodez/status/2062127385923776831)
  - Managed Agents "escalation" pattern: consult a stronger model for a subset of subtasks. — [Anthropic](https://www.anthropic.com/engineering/harness-design-long-running-apps)
  - Google whitepaper: route frontier models to complex decisions and small fast models to deterministic tasks, as a cost strategy. — [Whitepaper](https://drive.google.com/file/d/1IR7CddF_2FyQo_PdfBNTaEA50EGiVt2r/view)
- Cross-vendor review:
  - Warp `03-multi-harness`: Claude Code implements, Codex reviews. — [warp-factory-examples](https://github.com/warpdotdev/warp-factory-examples)
  - `claudex-loop`: Claude↔Codex plan review and independent inspection. — [chaseai-yt/claudex-loop](https://github.com/chaseai-yt/claudex-loop)
  - OpenQodex: by default "the agent that wrote the code does not review it". It runs 22 deterministic scanners, then a separate reviewer that must answer every finding, then push-gate hooks. — [openqodex/openqodex](https://github.com/openqodex/openqodex)
- Evals:
  - Google whitepaper: "set the bar at the eval, not the demo". Rubrics cover task success, tool use, trajectory compliance and hallucination. Trajectory evals belong in CI before the first production agent. — [Whitepaper](https://drive.google.com/file/d/1IR7CddF_2FyQo_PdfBNTaEA50EGiVt2r/view)
  - Caliper A/B-tests skills, MCPs and rules with real agents and reports token cost. — [edonadei/caliper](https://github.com/edonadei/caliper)
- Cost data points:
  - Anthropic runs cost $124–$200 per app. — [Anthropic](https://www.anthropic.com/engineering/harness-design-long-running-apps)
  - Factory.ai Missions cost heuristic (see section 2). — [factory.ai](https://factory.ai/)
  - frankbria Ralph supports an E2B `--sandbox-max-cost`. — [frankbria/ralph-claude-code](https://github.com/frankbria/ralph-claude-code)
  - Paperclip pauses agents automatically when they exceed their budget. — [paperclipai/paperclip](https://github.com/paperclipai/paperclip)

### Inferences
- In the wiki, a factory's most useful metrics are operational (cost per merge, failed laps by cause, stuck steps, send-backs), not LLM traces alone.

### Gaps
- The wiki has no factory example wired into Langfuse, LangSmith or OTEL tracing end to end, and no source on Claude Code's own OTEL telemetry.

## 5. Security and sandboxing for unattended agents

### Takeaway
The wiki's layers:
- isolation (worktree, container, microVM);
- deterministic hooks that hold even under `--dangerously-skip-permissions`;
- credentials kept out of the agent process;
- protected paths;
- separating untrusted input from privileged action.

### Cited Findings
- **Docker Sandboxes** (`wiki/sources/docker-sandboxes.md`) — [docker.com/products/docker-sandboxes](https://www.docker.com/products/docker-sandboxes/)
  - Each agent runs in its own microVM with only the project workspace mounted and its own Docker daemon.
  - All egress goes through a host proxy that enforces network policy and injects credentials.
  - Positioned explicitly for running agents in "YOLO mode" (`sbx run claude`).
  - Paid AI Governance adds org-wide policy.
- **Harness demo security hook** (`security_guard.py`, PreToolUse) — [coleam00/harness-engineering-demo](https://github.com/coleam00/harness-engineering-demo)
  - Denies access to real `.env` files, including obfuscated globs in Bash commands.
  - Denies recursive deletes.
  - "Still fires under `--dangerously-skip-permissions`", so it holds during unattended Ralph runs.
- **Symphony** — [Symphony SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md)
  - Tracker credentials stay out of the agent's child process.
  - Avoid literal secrets in `WORKFLOW.md`, because the agent can read them.
  - "Hooks are fully trusted configuration."
  - Recommended hardening: narrow tool scope, filter eligible issues, restrict credentials and paths, and add OS or container isolation.
  - The implementation must document its approval and sandbox posture.
- **Cole's factory** blocks changes to protected paths (including `.claude/settings.json` and the harness), and stops for a human on identity, auth or data-deletion actions. — [coleam00/ai-software-factory](https://github.com/coleam00/ai-software-factory)
- **Quarantine pattern**: read-only agents take in untrusted content (support tickets, scraped pages). Separate privileged agents act. This keeps prompt injection away from high-privilege operations. — [@0xCodez](https://x.com/0xCodez/status/2062127385923776831)
- frankbria Ralph's Docker sandbox defaults to 4 GB RAM, 2 CPUs and a bridge network, and passes credentials through an env-file that is never logged. — [frankbria/ralph-claude-code](https://github.com/frankbria/ralph-claude-code)
- Factory.ai Droid Shield detects secrets in commits. The Plus tier adds prompt-injection scanning. — [factory.ai](https://factory.ai/)
- The Claude Code large-codebases article (`wiki/sources/how-claude-code-works-in-large-codebases.md`) recommends: — [claude.com blog](https://claude.com/blog/how-claude-code-works-in-large-codebases-best-practices-and-where-to-start)
  - a version-controlled `permissions.deny`;
  - an approved skills list;
  - a DRI or "agent manager" role;
  - AI code going through the same review as human code;
  - limited initial access that expands as confidence grows.
- Anthropic Managed Agents run in cloud containers with configurable network access rules. — [Anthropic](https://www.anthropic.com/engineering/harness-design-long-running-apps)

### Inferences
- A minimal safe setup from the wiki for unattended runs:
  - a worktree per ticket;
  - a container or microVM;
  - credentials injected by the host or proxy;
  - PreToolUse deny hooks;
  - protected harness files;
  - human escalation for auth, data and deploy changes.

### Gaps
- The wiki has no formal threat model for factory pipelines, and no StrongDM-style access-control discussion.

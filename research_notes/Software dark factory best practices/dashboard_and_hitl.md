# Dashboards and human-in-the-loop (HITL) for a software dark factory

Research date: 2026-11-09. Scope: how existing tools show factory state and collect human decisions, plus a simple tech stack for a one-engineer dashboard that can grow.

## What do existing agent orchestration UIs look like and show, and which views matter?

### Takeaway
Most tools have the same core: a list or board of tasks grouped by state, each task in its own git worktree or sandbox, a live log or session view, a diff or PR review step, and a "needs input" state that stands out. The newer tools (Claude Code agent view, GitHub Mission Control, Symphony) put the attention state first. Cost or token totals show up less often, and usually only in the orchestrators (Symphony, OpenSymphony).

### Cited Findings
**Vibe Kanban (BloopAI)**
- A kanban board (To Do, In Progress, In Review, Done). Each task runs a coding agent (Claude Code, Codex, Gemini CLI, OpenCode) in its own git worktree. The usual path ends with opening a PR — [GitHub](https://github.com/BloopAI/vibe-kanban), [docs](https://vibekanban.com/docs/getting-started)
- Diff review with inline comments that go back to the agent. You can run the same task on two agents and compare diffs — [VirtusLab review](https://virtuslab.com/blog/ai/vibe-kanban/)
- Status: one review says the company shut down on 10 April 2026 and the project is now community-maintained. Another source says development has stopped. By default it runs agents with permission-skipping flags — [VirtusLab](https://virtuslab.com/blog/ai/vibe-kanban/) (I did not confirm this in the repo; check before adopting)

**OpenAI Symphony (spec + reference implementation)**
- A daemon polls Linear, claims eligible issues, creates an isolated workspace for each, and runs Codex App Server. The Linear board is the control plane. Humans act by changing the tracker state — [SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md), [OpenAI](https://openai.com/index/open-source-codex-orchestration-symphony/)
- Optional HTTP server (loopback by default): `/` is a human-readable dashboard. `GET /api/v1/state` returns `counts`, `running`, `retrying`, `codex_totals` (input, output and total tokens, `seconds_running`) and `rate_limits`. `GET /api/v1/<issue>` returns the workspace path, attempts, retry info, logs and `recent_events`. `POST /api/v1/refresh` starts a poll — [SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md)
- Sources disagree on the dashboard. One describes a Phoenix LiveView dashboard with active runs, history and logs. Another says "no dashboard you log into". A later review says a Symphony Observability dashboard, with rows linked to tracker issues, was added in commits through June 2026 — [Daniel Vaughan](https://codex.danielvaughan.com/2026/04/28/openai-symphony-codex-orchestration-linear-autonomous-agent-workflows/), [rywalker](https://rywalker.com/research/symphony), [mindstudio](https://www.mindstudio.ai/blog/openai-symphony-spec-linear-agent-control-plane-500-percent-pr-increase)
- The spec defines no money cost tracking, only tokens — [SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md)
- OpenAI says some teams landed 500% more PRs. This is OpenAI's own number and is not independently checked — [OpenAI](https://openai.com/index/open-source-codex-orchestration-symphony/)
- OpenSymphony, a community Rust port, describes a dashboard with health, active runs, blocked work, retries, costs and recent events — [docs.rs PRODUCT.md](https://docs.rs/crate/opensymphony/1.6.1/source/PRODUCT.md)

**GitHub Copilot: Agent HQ, Mission Control, Agents tab**
- Mission Control (announced at Universe, Oct 2025) is one place to assign tasks across repos, pick a custom agent, watch session logs live, steer mid-run (pause, refine, restart), and jump to the PR — [GitHub changelog](https://github.blog/changelog/2025-10-28-a-mission-control-to-assign-steer-and-track-copilot-coding-agent-tasks/), [how-to blog](https://github.blog/ai-and-ml/github-copilot/how-to-orchestrate-agents-using-mission-control/)
- Agent HQ is meant to host third-party agents (Anthropic, OpenAI, Google, Cognition, xAI) for paid Copilot users. It is reachable from github.com, VS Code, mobile and CLI — [GitHub blog](https://github.blog/news-insights/company-news/welcome-home-agents/)
- Session logs show the agent's reasoning and tool calls, during or after a run. Copilot applies a steering message after its current tool call. Each steering message costs AI credits, and steering is not available for third-party agents — [GitHub docs](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/track-copilot-sessions)
- A per-repository Agents tab arrived in Jan 2026 (public preview) — [changelog](https://github.blog/changelog/2026-01-26-introducing-the-agents-tab-in-your-repository)

**Claude Code agent view (`claude agents`, research preview from May 2026)**
- One screen with every background session. Each row has a state: Working (animated), Needs input (yellow: a question, a permission decision or an MCP elicitation), Idle, Completed (green), Failed (red), Stopped (grey). You attach to a row to open the full conversation and press ← to go back — [agent view docs](https://code.claude.com/docs/en/agent-view#read-session-state), [what's new W20](https://code.claude.com/docs/en/whats-new/2026-w20)
- The VS Code sessions list has filters such as "Active" (needs input, working, unread) and filter by status — [VS Code docs](https://code.claude.com/docs/en/vs-code#filter-the-sessions-list)
- `/workflows` lists running and completed workflow runs, the phase each is in, and how many agents have finished — [agents docs](https://code.claude.com/docs/en/agents#check-on-running-work)

**Parallel-agent desktop and terminal tools**
- Conductor: Mac app (Apple Silicon), runs Claude Code or Codex agents in parallel worktrees. It seems to be moving toward cloud agents — [morphllm](https://www.morphllm.com/conductor-ai-coding), [crystl compare](https://crystl.dev/compare/conductor-vs-crystl/)
- Claude Squad: terminal UI on tmux plus worktrees, cross-platform — [agentsroom](https://agentsroom.dev/blog/best-multi-agent-coding-tools)
- Crystal: reported deprecated in Feb 2026, replaced by the paid Nimbalyst — [nimbalyst blog](https://nimbalyst-website.pages.dev/blog/best-agent-management-tools-2026/) (vendor source)
- Sculptor (Imbue): each agent gets its own branch and diff view. Sources disagree on whether it uses worktrees or containers — [imbue](https://imbue.com/product/sculptor), [agentsroom](https://agentsroom.dev/blog/best-multi-agent-coding-tools)
- Worktrees share the machine. A runaway install or migration can still damage real files. This is why some people prefer containers — [agentsroom](https://agentsroom.dev/blog/best-multi-agent-coding-tools)

### Inferences
- The views that matter, in priority order: (1) an attention queue (needs decision, failed, ready for review), (2) a board of tickets by stage, (3) a run detail page with a live log, diff or PR link, attempts and retries, (4) totals (tokens, cost, time), (5) history. Every serious tool has 1–3. Only orchestrators have 4.
- Symphony's design is a strong reference for a factory: the tracker (Jira for this user) stays the source of truth for the ticket stage, the orchestrator keeps run state, and a small loopback HTTP JSON API feeds the dashboard.
- Vibe Kanban is the closest ready-made UI, but its maintenance status makes it risky to build on.

### Gaps
- I did not research Cursor background agents, Devin, Factory.ai, OpenHands UI, Amp or Claude Code on the web (remote sessions) because of time limits. No cited facts on them here.
- I did not see screenshots, so the layouts are described from docs, not checked visually.

## HITL patterns: approval gates, decision inbox, pause and resume, notifications, timeouts, audit; how do Claude Agent SDK / headless and Copilot CLI handle questions?

### Takeaway
There are two layers. (a) Inside one agent run: the Claude Agent SDK `canUseTool` callback receives permission requests and `AskUserQuestion` (structured multiple-choice questions), so your app can show them anywhere and answer later. Plain `claude -p` with no permission host cannot ask. Copilot CLI `-p` denies anything that needs approval, and `--no-ask-user` turns questions off. (b) Across a ticket's life: durable waits (Temporal signals, Inngest `waitForEvent`, LangGraph `interrupt`) pause for hours or days at no compute cost, with timeouts. For one engineer, the simplest robust pattern is: end the agent run with a structured "needs decision" record, save the session id, and resume the session with the answer.

### Cited Findings
**Claude Agent SDK and Claude Code headless**
- When Claude calls `AskUserQuestion`, the SDK calls your `canUseTool` callback with that tool name. The input is a `questions` array. Each question has `question`, `header` (chip, at most 12 characters), 2–4 `options` (`label`, `description`, optional `preview`) and `multiSelect`. You return allow with `updatedInput` holding `questions` plus `answers` (question text → chosen label). Free text is allowed — [Agent SDK user input](https://code.claude.com/docs/en/agent-sdk/user-input#handle-clarifying-questions), [Python reference](https://code.claude.com/docs/en/agent-sdk/python#askuserquestion)
- If you restrict `tools`, you must include `AskUserQuestion` in the list, or Claude cannot ask. Questions are most common in plan mode — [user input](https://code.claude.com/docs/en/agent-sdk/user-input#handle-clarifying-questions)
- The tool output can include `afkTimeoutMs`, set when the dialog auto-resolved after user inactivity — [Python reference](https://code.claude.com/docs/en/agent-sdk/python#askuserquestion)
- In `-p` mode, Claude Code offers `AskUserQuestion` and `ExitPlanMode` only when the run has a permission host (an SDK `canUseTool` callback or `--permission-prompt-tool`). A `PreToolUse` hook can answer instead by returning `permissionDecision: "allow"` plus `updatedInput` with the answers — [hooks docs](https://code.claude.com/docs/en/hooks#allow-with-updatedinput)
- `--permission-prompts none`: the run never waits on a host. Anything that would prompt is denied unless a `PermissionRequest` hook allows it, Claude is told not to retry, and `AskUserQuestion` is removed — [headless docs](https://code.claude.com/docs/en/headless#turn-off-permission-prompts-in-unattended-runs)
- `dontAsk` mode turns every prompt into a denial and also denies `AskUserQuestion` — [permission modes](https://code.claude.com/docs/en/permission-modes#allow-only-pre-approved-tools-with-dontask-mode)
- In `auto` and `bypassPermissions`, the terminal prompt for a critical-path removal has a two-minute countdown, then denies. After three unanswered prompts it denies at once — [permission modes](https://code.claude.com/docs/en/permission-modes#time-limits-and-denials-in-auto-and-bypasspermissions-modes)
- Hard gates: an MCP tool marked `_meta["anthropic/requiresUserInteraction"]: true` prompts on every call, even in bypass mode. A `--permission-prompt-tool` "allow" for it becomes a deny, but SDK `canUseTool` can approve it. In TypeScript, custom tools can use `permission_policy: "always_ask"` — [MCP docs](https://code.claude.com/docs/en/mcp#require-approval-for-a-specific-tool), [custom tools](https://code.claude.com/docs/en/agent-sdk/custom-tools#require-approval-for-specific-tools)
- Resume: pass a saved session id as `resume`. The agent continues with full context. This also works to recover from `error_max_turns` or `error_max_budget_usd`, or after a process restart — [sessions docs](https://code.claude.com/docs/en/agent-sdk/sessions#resume-by-id)

**Copilot CLI programmatic mode**
- `-p` runs once and exits. `--allow-all-tools` / `--allow-all` (`--yolo`), `--allow-tool`, `--deny-tool`, `--available-tools`, `--excluded-tools`. `--no-ask-user` stops the agent pausing for input. `--assisted-approval` lets a safety review approve eligible requests (non-interactive only). `--output-format=json` gives JSONL. `--share=PATH` exports the transcript. "Without any permission options, requests that need approval are denied." — [Copilot CLI programmatic reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-programmatic-reference)
- The Copilot SDK has an `onUserInputRequest` handler for `ask_user`. This is the Copilot equivalent of `canUseTool` for questions — [Copilot SDK compatibility](https://docs.github.com/en/copilot/how-tos/copilot-sdk/troubleshooting/compatibility)
- `--acp` starts an Agent Client Protocol server — [CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)

**Durable execution engines**
- Temporal: the workflow pauses, and the approval arrives as a Signal. `workflow.wait_condition(..., timeout=...)` raises `TimeoutError` (TypeScript `condition()` returns false). The wait can last hours or days with no compute. The cookbook default timeout is 5 minutes. The approval pattern records approver identity, reason and timestamp for audit — [Temporal HITL cookbook](https://docs.temporal.io/ai/cookbook/human-in-the-loop-python.md), [Approval pattern](https://docs.temporal.io/design-patterns/approval)
- Inngest: `step.waitForEvent()` returns the event, or null on timeout (for example `24h`). The example takes the answer from a Slack interaction webhook, matches on `data.approvalId`, and escalates to another reviewer on timeout. It only catches events sent after the wait starts. `step.waitForSignal` gives exact 1:1 matching — [Inngest HITL](https://www.inngest.com/docs/ai-patterns/human-in-the-loop), [waitForEvent](https://www.inngest.com/docs/reference/functions/step-wait-for-event), [waitForSignal](https://www.inngest.com/docs/features/inngest-functions/steps-workflows/wait-for-signal)
- LangGraph: `interrupt(payload)` pauses. You resume with `Command(resume=value)` on the same `thread_id`. It needs a checkpointer (Postgres or SQLite in production, because in-memory loses pending approvals on deploy). The node re-runs from the start on resume, so avoid loops of interrupts — [LangGraph interrupts](https://docs.langchain.com/oss/python/langgraph/interrupts), [HITL](https://docs.langchain.com/oss/python/langgraph/human-in-the-loop)
- Symphony has a `turn_input_required` runtime event and handoff states such as `Human Review`. Operators steer by changing the tracker state. A terminal state stops the run and cleans the workspace — [SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md)

### Inferences
- For phase 1, a full durable engine is not needed. The Agent SDK session id plus `resume` already gives "pause and resume with the answer". Save the pending question and the session id in SQLite, end the run (or keep the `canUseTool` promise waiting if the process stays up), and resume when the human answers. Temporal or Inngest become worth it when there are many machines, long multi-step pipelines, or several reviewers.
- Two kinds of gate: (1) a stage gate between pipeline steps (plan approved, PR ready to merge), owned by the orchestrator, and (2) a tool gate inside a run (risky command, question), via `canUseTool` or hooks. Keep both in the same "decisions" table so one inbox shows them.
- Reuse the `AskUserQuestion` shape (question, header, 2–4 options with descriptions, multi-select, free text) as the factory's decision schema. Copilot `ask_user` can map to the same shape via the SDK handler.
- Timeouts: every decision should have a deadline and a safe default (usually "stop and park the ticket", never "approve"). This matches Temporal's and Inngest's examples and Claude Code's own deny-on-countdown behaviour.
- Audit: store who answered, when, the chosen option, a free-text reason and the channel (dashboard, Slack, Jira). Also post the answer as a Jira comment so the record lives with the ticket.
- Notifications: send only for Needs decision and Failed. Use one channel (Slack DM or push), deep-link straight to the decision. Do not notify on success (see the UX section).

### Gaps
- I found no doc on how Copilot CLI `ask_user` behaves over ACP, or what `-p` does with `ask_user` when `--no-ask-user` is not set. Check with `copilot help` or by testing.
- I did not verify Slack or Jira-comment answer flows beyond the Inngest Slack example.

## State model: which states, stages and events per ticket/run? Event sourcing or a simple SQLite table?

### Takeaway
Keep two levels: ticket stage (business flow, mirrored from Jira) and run attempt state (technical, one row per agent run). Symphony's spec gives a tested list of both and of events. For one engineer, use SQLite with current-state tables plus an append-only `events` table. This gives most of the value of event sourcing (history, audit, replay into the UI) without a full event-sourced design.

### Cited Findings
- Symphony internal claim states: `Unclaimed`, `Claimed`, `Running`, `RetryQueued`, `Released` — [SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md)
- Symphony run attempt phases: `PreparingWorkspace`, `BuildingPrompt`, `LaunchingAgentProcess`, `InitializingSession`, `StreamingTurn`, `Finishing`. Outcomes: `Succeeded`, `Failed`, `TimedOut`, `Stalled`, `CanceledByReconciliation` — [SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md)
- Symphony events: `session_started`, `startup_failed`, `turn_completed`, `turn_failed`, `turn_cancelled`, `turn_ended_with_error`, `turn_input_required`, `approval_auto_approved`, `unsupported_tool_call`, `notification`, `malformed`. Per-session fields: `session_id`, `last_codex_event`, `last_codex_timestamp`, `turn_count`, process pid — [SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md)
- Symphony retries: continuation retry after about 1 s. Failure backoff `min(10000·2^(attempt−1), max_retry_backoff_ms)`, capped at 300 s by default. Stall timeout 300 s, turn timeout 1 h, `max_turns` 20. No built-in "blocked" state, only `blocked_by` metadata — [SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md)
- Token totals should use absolute thread totals and compute deltas, to avoid double counting — [SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md)
- Claude Code session states seen by users: Working, Needs input, Idle, Completed, Failed, Stopped — [agent view](https://code.claude.com/docs/en/agent-view#read-session-state)
- The Claude Agent SDK can export traces, metrics and logs over OTLP (traces behind a beta flag) — [Agent SDK observability](https://code.claude.com/docs/en/agent-sdk/observability.md)

### Inferences
- Suggested ticket stages (these match a typical SDLC pipeline): `queued → planning → awaiting_plan_approval → implementing → verifying → pr_open → awaiting_review → done`, plus side states `needs_decision`, `blocked`, `failed`, `parked`.
- Suggested run states: `starting, running, needs_input, succeeded, failed, timed_out, stalled, cancelled`.
- Suggested SQLite tables: `tickets` (jira_key, stage, title, repo, branch, pr_url, updated_at), `runs` (id, ticket, step, agent `claude|copilot`, session_id, state, started/ended, tokens_in/out, cost_usd, worktree, log_path, trace_url), `decisions` (id, ticket, run, kind `question|approval`, payload_json in AskUserQuestion shape, status `open|answered|expired`, deadline, default, answer_json, answered_by, answered_at, channel), `events` (id, ts, ticket, run, type, data_json, append-only).
- Write every state change as an event, then update the current-state row in the same transaction. The UI reads the tables, and the live feed tails `events`. Moving to Postgres later, or to full event sourcing, is easy because the log already exists.
- Use SQLite WAL mode so the orchestrator writes while the dashboard reads (general SQLite knowledge, not from a cited source here).

### Gaps
- I found no published state models from Devin, Factory or Cursor for comparison.

## Tech stack options for a simple local-first dashboard; build or reuse?

### Takeaway
Reusing a full tool does not fit well. Vibe Kanban is near the target but its maintenance is uncertain, and it owns the agent runs itself. Langfuse is good for traces but is not a ticket board or decision inbox. The best fit is a small custom app on SQLite: a Python FastAPI (or Node) server, server-rendered HTML with HTMX and SSE for live updates, and Langfuse (self-hosted) only for deep traces, linked from each run. Also use `claude agents` for live attach.

### Cited Findings
- Langfuse has Claude Agent SDK integrations (Python and JS, via OpenInference instrumentation) and accepts OTLP. Old self-hosted v1/v2 lack the OTLP endpoint, so you need a current version — [Langfuse Claude Agent SDK](https://langfuse.com/integrations/frameworks/claude-agent-sdk), [coding agent tracing](https://langfuse.com/resources/engineering/coding-agent-tracing)
- The Agent SDK exports OTLP to Langfuse, SigNoz, OpenObserve or a collector — [Agent SDK observability](https://code.claude.com/docs/en/agent-sdk/observability.md), [SigNoz](https://signoz.io/docs/claude-agent-monitoring/)
- Symphony's reference dashboard runs on a loopback HTTP server with a JSON state API, which is a model for a small local dashboard — [SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md)
- Copilot CLI `--output-format=json` (JSONL) and `--share=PATH` give machine-readable events and transcripts to ingest — [Copilot programmatic reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-programmatic-reference)

### Inferences
Options compared (effort estimates are my own judgment):
- **FastAPI + SQLite + Jinja + HTMX + SSE** (recommended for phase 1). About 1–3 days for board, inbox and run page. One process, no JS build, and the same Python process can run the Agent SDK and hold `canUseTool` callbacks. SSE is enough because data flows server → browser, and answers go back as plain POSTs. Looks good with a classless or small CSS kit (Pico.css, or Tailwind via CDN). Growth path: Postgres, auth, more users.
- **Node/Hono or Express + SQLite + SSE**: same shape. Choose it if the orchestrator uses the TypeScript Agent SDK (some features, such as `permission_policy`, are TypeScript-only).
- **Next.js**: nicest UI ecosystem (shadcn/ui), but more moving parts (build, client state, server actions). Worth it later if the dashboard becomes a team product.
- **Streamlit / Gradio**: fastest first screen (hours), but awkward for live push, deep links and forms with many decisions, and they rerun the whole script on each interaction. Fine as a throwaway prototype only.
- **Reuse Vibe Kanban**: no build, but it runs agents itself with permission-skipping by default, uses its own board instead of Jira, and has uncertain maintenance. Good to study, risky to depend on.
- **Reuse Langfuse**: use it for traces and cost per run, not as the factory UI. Link `trace_url` from each run row.
- **Use the tracker as the UI (Symphony style)**: Jira board columns plus Jira comments for decisions. Zero UI build, but a poor live log view and slow decisions. A good complement: mirror stage and decisions into Jira.
- WebSockets are only needed if you want two-way live chat or steering inside the browser. Start with SSE.

### Gaps
- I did not benchmark HTMX against Next.js, or check current Vibe Kanban repo activity directly.

## Good UX practices for agent monitoring

### Takeaway
Route attention, do not just show a feed. Put the "needs you" queue first, show state at a glance, keep it calm (ambient state, few notifications), and make every row one click from the Jira ticket, the PR, the live session and the trace.

### Cited Findings
- Claude Code agent view is built around stepping in "only when a row needs you". Needs input is a distinct yellow state, and you attach and return with one key — [what's new W20](https://code.claude.com/docs/en/whats-new/2026-w20), [agent view](https://code.claude.com/docs/en/agent-view#read-session-state)
- An open-source tmux dashboard groups agents by state: needs attention, running, completed — [agent-dashboard](https://awesome.ecosyste.ms/projects/github.com%2Fbjornjee%2Fagent-dashboard)
- "Make state ambient — visible without demanding attention. The goal isn't more notifications; it's fewer context switches." Done-pings hurt attention like chat pings — [DEV: track multiple agents](https://dev.to/aidenwong/track-multiple-ai-agents-state-4bhj), [DEV: attention shattering](https://dev.to/xwero/ai-agent-attention-shattering-35jn)
- With more than one project, a dashboard must route attention, not only show a feed — [Junction Panel](https://junctionpanel.dev/blog/what-an-ai-coding-agent-dashboard-should-actually-do/)
- Practitioners want one "agent inbox" for all agents, and warn about yet another dashboard nobody checks — [Product Hunt thread](https://www.producthunt.com/p/pushary/how-do-you-stay-aware-of-what-your-ai-coding-agents-are-doing)
- "Attention harness" idea: decide when and how agents may interrupt humans — [besthub](https://www.besthub.dev/articles/attention-harness-how-to-preserve-human-attention-in-the-multi-agent-era-d2f7e7988fc6)
- Mission Control links each task straight to its PR. Symphony dashboard rows link back to tracker issues — [GitHub changelog](https://github.blog/changelog/2025-10-28-a-mission-control-to-assign-steer-and-track-copilot-coding-agent-tasks/), [mindstudio](https://www.mindstudio.ai/blog/openai-symphony-spec-linear-agent-control-plane-500-percent-pr-increase)
- These UX sources are mostly blogs and launch posts, not formal research — (assessment from the search)

### Inferences
- Page layout for phase 1: top = attention queue (open decisions with deadline countdowns, failed runs, PRs waiting for review), middle = board by stage, bottom or side = live event feed. A run page = summary, decision history, live log tail, diff or PR link, tokens and cost, links (Jira, PR, Langfuse trace, `claude --resume <id>` command).
- Show a short "why it stopped" line for each blocked item, written by the agent in the decision payload. The human should not need to read logs to decide.
- Answer in one click from the inbox (option buttons from the AskUserQuestion options), with an optional reason box. The same decision is also answerable from a Slack or Jira link.
- Notify only on: decision opened, decision about to expire, run failed. Use a daily digest for the rest.
- Keep a small totals strip (runs today, tokens and cost, success rate) but do not make it the focus.

### Gaps
- No usability studies found. Advice comes from practitioner posts and vendor designs.

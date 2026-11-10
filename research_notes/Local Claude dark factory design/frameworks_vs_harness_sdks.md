# Frameworks vs harness SDKs for a local Claude dark factory

Scope: a local Mac factory that polls Jira, runs the user's existing `sdlc-ticket` skill chain (intake, plan, build, review, verify, draft PR, with subagents and per-call models) unattended up to the PR, records run state, pauses for human decisions in a local dashboard and resumes. Question: build on an agent framework, on the Claude Agent SDK, or on `claude -p`?

## (a) Claude Code CLI headless (`claude -p`): what it gives a factory

### Takeaway
`claude -p` is officially "the Agent SDK via the CLI". It has everything the factory needs at the process boundary: stream-json events, session resume, cost per run, budget and turn caps, a permission host, and a `defer` hook that ends a run at a question so it can be resumed later. Two traps: `--bare` turns skills off, and `-p` now starts in Manual permission mode.

### Cited Findings
- The headless page says the Agent SDK "is available as a CLI for scripts and CI/CD, or as Python and TypeScript packages"; `claude -p` is the CLI form. Anthropic's own advice for languages other than Python/TS is to "run the CLI as a subprocess with the `-p` flag and `--output-format json`". — [Headless](https://code.claude.com/docs/en/headless); [Agent SDK overview](https://code.claude.com/docs/en/agent-sdk/overview)
- Without `--bare`, `claude -p` loads hooks, skills, custom commands, subagents, plugins, MCP servers, auto memory and CLAUDE.md just like an interactive session. `--bare` skips all of them, is "the recommended mode for scripted and SDK calls", and "will become the default for `-p` in a future release". Bare mode also ignores OAuth/keychain and needs `ANTHROPIC_API_KEY`. — [Headless: bare mode](https://code.claude.com/docs/en/headless)
- A `-p` run with no `--bare` runs the project's `.claude/settings.json` hooks and connects `.mcp.json` servers "even in a folder you've never trusted", with no trust dialog. — [Headless](https://code.claude.com/docs/en/headless)
- `--output-format json` returns `total_cost_usd` plus a cost breakdown per model. With `--resume`, it reports the whole conversation's total, earlier runs included. These are client-side estimates. — [Headless](https://code.claude.com/docs/en/headless); [Cost tracking](https://code.claude.com/docs/en/agent-sdk/cost-tracking)
- `--output-format stream-json --verbose --include-partial-messages` streams NDJSON events. In stream-json, denials show up as `permission_denied` system messages and are listed in the result's `permission_denials`. — [Headless](https://code.claude.com/docs/en/headless)
- From v2.1.302, a `claude -p` run starts in Manual mode when nothing sets a mode, and a call that needs approval is denied unless a `PermissionRequest` hook or `--permission-prompt-tool` approves it. `--permission-prompts none` is for runs with nobody to answer. — [Headless](https://code.claude.com/docs/en/headless)
- `--max-budget-usd` stops the run once estimated spend hits the cap. It is print mode only, and subagent spend counts toward it. `--max-turns` caps agentic turns and has no limit by default. `--permission-prompt-tool` names an MCP tool (`mcp__<server>__<tool>`) that handles permission prompts in non-interactive mode. — [CLI reference](https://code.claude.com/docs/en/cli-reference)
- `--resume <session-id>`, or a path to the session's `.jsonl` transcript, continues a specific conversation. — [Headless](https://code.claude.com/docs/en/headless)
- **Pause and resume across process exits:** a `PreToolUse` hook can return `permissionDecision: "defer"`. Claude Code honors this only in `-p` mode and only when the turn has a single tool call. The run then ends with `stop_reason: "tool_deferred"` and a `deferred_tool_use` {id, name, input}. The caller shows the question in its own UI, later runs `claude -p --resume <id>` with the same permission host, and the hook returns `allow` with the answer in `updatedInput`. `AskUserQuestion` is the typical case. A `-p` run offers `AskUserQuestion` only when it has a permission host such as `--permission-prompt-tool`. — [Hooks: defer](https://code.claude.com/docs/en/hooks)
- SIGTERM exits with code 143 and leaves the turn unfinished. To end the turn cleanly, send SIGINT or call the SDK's `interrupt()`. — [Headless](https://code.claude.com/docs/en/headless)

### Inferences
- For this factory, "pause for a human decision" maps directly onto `defer` + `--resume`. The process can exit while it waits, so a pause needs no long-lived process and no framework checkpointer. The factory only has to store `session_id` and `deferred_tool_use` in its own run-state DB.
- The factory must NOT use `--bare`, or the `sdlc-*` skills, subagents and CLAUDE.md won't load. If bare later becomes the `-p` default, pass the sources explicitly (the SDK's `settingSources`) or watch the changelog.
- Because `-p` defaults to Manual mode, the factory has to set the permission mode, an allow list or a permission host on every run. Otherwise build steps fail on denials, and silently from the user's point of view.

### Gaps
- I found no doc line that confirms `claude -p "/sdlc-ticket KEY-1"` dispatches a user-invoked skill the same way the SDK does. The SDK docs do say that sending `/<name>` in a prompt dispatches a skill (see b). Vibe Kanban has a `claude/slash_commands.rs` executor that uses `-p --output-format=stream-json`, which suggests it works. Check this with a quick local test.

## (b) Claude Agent SDK (Python/TypeScript): what it adds on top of the CLI

### Takeaway
The SDK is a library that runs the same Claude Code binary. By default it loads the user's and project's skills, commands, subagents, CLAUDE.md, hooks, settings and MCP, so the user's existing skill chain works unchanged. Over the raw CLI it adds typed messages, in-process callbacks (`canUseTool`, hooks, in-process MCP tools), programmatic subagents, fork, a pluggable SessionStore, per-model cost and OTel export. It is a harness, not a workflow framework: no graph and no durable checkpointer of its own.

### Cited Findings
- "When you omit `settingSources`, `query()` reads the same filesystem settings as the Claude Code CLI: user, project, and local settings, CLAUDE.md files, and `.claude/` skills, agents, and commands." Omitting it is the same as `["user","project","local"]`. Passing `[]` turns them off. Managed policy, `~/.claude.json` and auto memory load either way. — [Use Claude Code features in the SDK](https://code.claude.com/docs/en/agent-sdk/claude-code-features)
- What each source loads: "project" covers `<cwd>/.claude/settings.json` and hooks, CLAUDE.md and rules in cwd and its parents, and skills/commands/subagents up to the repo root plus `additionalDirectories`. "user" covers the `~/.claude/` settings, CLAUDE.md, rules, skills, commands and agents. — [same](https://code.claude.com/docs/en/agent-sdk/claude-code-features)
- Skills: discovered from the filesystem. They are "model-invoked", and "user-invoked: you dispatch a skill directly by sending `/<name>` in a prompt". A `skills` option takes `"all"`, a list or `[]`. There is no API to register skills in code; they must be files. — [Skills in the SDK](https://code.claude.com/docs/en/agent-sdk/skills)
- User input: tool permission requests and `AskUserQuestion` both go to the `canUseTool` callback. "The callback can stay pending indefinitely." If the human may take longer than the process can stay up, register a `PreToolUse` hook that returns `defer` "so the process can exit and resume later". If you pass a `tools` list, include `AskUserQuestion`. — [Handle approvals and user input](https://code.claude.com/docs/en/agent-sdk/user-input)
- The Python SDK docs show a "Required workaround: dummy hook keeps the stream open for can_use_tool". — [User input](https://code.claude.com/docs/en/agent-sdk/user-input)
- Sessions: continue, resume and fork are `query()` options. Fork "creates a new session that starts with a copy of the original's history". The session ID is on every result message. Transcripts are JSONL under `~/.claude/projects/`. A `SessionStore` adapter (`append`/`load`) can mirror them to a DB so another host can resume. — [Sessions](https://code.claude.com/docs/en/agent-sdk/sessions); [Session storage](https://code.claude.com/docs/en/agent-sdk/session-storage)
- Cost: the result message has `total_cost_usd` and `modelUsage`/`model_usage` (per model). Use `modelUsage` "for whole-tree token accounting"; the `usage` field "undercounts as soon as nesting occurs" (subagents). All are client-side estimates. — [Cost tracking](https://code.claude.com/docs/en/agent-sdk/cost-tracking)
- OTel: the SDK exports traces, metrics and log events over OTLP. — [Observability](https://code.claude.com/docs/en/agent-sdk/observability)
- Auth caveat: "Unless previously approved, Anthropic does not allow third party developers to offer claude.ai login or rate limits for their products, including agents built on the Claude Agent SDK." — [Agent SDK overview](https://code.claude.com/docs/en/agent-sdk/overview)
- Anthropic's Agent SDK post (29 Sep 2025): "the agent harness that powers Claude Code (the Claude Code SDK) can power many other types of agents, too… we're renaming the Claude Code SDK to the Claude Agent SDK". The loop is "gather context -> take action -> verify work -> repeat". — [Building agents with the Claude Agent SDK](https://claude.com/blog/building-agents-with-the-claude-agent-sdk)
- The Python package bundles the CLI in the wheel (`pip install claude-agent-sdk`). The transport is `_internal/transport/subprocess_cli.py`, so the SDK is itself a CLI subprocess plus JSON-stream parser. It offers `query()` and `ClaudeSDKClient`, in-process MCP servers and `HookMatcher` hooks. Programmatic subagents and session forking came in v0.1.0. — wiki: `/Users/nenaddjordjevic/LLMProjects/agentic-ai-wiki/wiki/sources/anthropics-claude-agent-sdk-python.md`

### Inferences
- SDK vs raw `claude -p` is mostly about ergonomics, not capability. Both drive the same binary and load the same skills. The SDK wins where in-process callbacks matter: an approval bridge to the dashboard without an MCP permission server, typed events and per-model cost, fork, and SessionStore.
- The auth line targets third-party *products*. A personal factory on the user's own Mac, with the user's own login, is a different case. If the factory is ever shared with colleagues, plan on API keys. Whether the employer allows Claude at all is a separate gap: the training notes say the company only has Copilot.

### Gaps
- No official numbers on SDK vs CLI startup or overhead.
- I didn't confirm whether per-subagent `model:` frontmatter in `.claude/agents/*.md` is honored identically under the SDK. It should be, since it's the same binary and the files load through `settingSources`, but test it.

## (c) General agent frameworks: what they add, what they lose

### Takeaway
LangGraph, OpenAI Agents SDK, Google ADK, Pydantic AI, CrewAI, Mastra and Microsoft Agent Framework all add graph/workflow orchestration, durable checkpoints and HITL interrupts. Each would run its own agent loop on the raw model API, so the factory would lose Claude Code's built-in tools, skills, subagents, hooks, CLAUDE.md and permissions, or would have to wrap the Claude Agent SDK as one opaque node. LangChain itself calls the Claude Agent SDK an "agent harness", a separate layer from frameworks and runtimes.

### Cited Findings
- LangChain's concepts page classifies Deep Agents as an "agent harness" alongside Claude Agent SDK and Manus. That is distinct from frameworks (abstractions and integrations) and runtimes (durable execution). Harnesses "are for more autonomous agents and agents faced with complex, non-deterministic tasks." — wiki: `/Users/nenaddjordjevic/LLMProjects/agentic-ai-wiki/wiki/sources/langchain.com-deepagents.md`
- LangGraph: durable execution with persisted checkpoints. `interrupt()` pauses and persists state via the checkpointer, `Command(resume=...)` resumes, and `thread_id` points back to the saved state. Built on `StateGraph`. — wiki: `.../wiki/sources/langchain.com-langgraph.md`
- OpenAI Agents SDK: `needsApproval` on tools pauses runs with `interruptions` and a resumable `state`. Sessions are MemorySession or SQLiteSession. — wiki: `.../wiki/sources/developers.openai.com.md`
- Microsoft Agent Framework: graph workflows with checkpointing, HITL and time travel. Durable Task hosting "survives crashes, restarts from checkpoint". Supported providers include Anthropic and the GitHub Copilot SDK. — wiki: `.../wiki/sources/microsoft-agent-framework.md`
- Mastra (TypeScript): graph workflows, suspend/resume HITL "backed by persistent storage so pauses can last indefinitely", and a local Studio UI. — wiki: `.../wiki/sources/mastra.ai.md`
- Google ADK 2.0 (Python GA May 2026): model-agnostic and supports Claude. CLI is `adk run` / `adk web`. — wiki: `.../wiki/sources/adk.dev.md`
- CrewAI: Crews inside Flows, with checkpointing for resumable execution. HITL flows are listed among the enterprise (AMP) features. — wiki: `.../wiki/sources/crewai.com.md`
- Pydantic AI: model-agnostic, type-safe, durable execution. Logfire covers OTel. — wiki: `.../wiki/sources/pydantic.dev.md`
- Anthropic, "Building effective agents": frameworks "often create extra layers of abstraction that can obscure the underlying prompts" and "make it tempting to add complexity when a simpler setup would suffice". "We suggest that developers start by using LLM APIs directly… If you do use a framework, ensure you understand the underlying code." — [Building effective agents](https://www.anthropic.com/research/building-effective-agents)
- The user's wiki has a harness-only example: harness-engineering-demo builds the harness "using only Claude Code's built-in primitives (CLAUDE.md, skills, hooks, sub-agents, MCP), with no external framework". ZazenCodes' Software Factory gets the same pipeline from "one skill (`/factory`), seven subagents, and plain markdown files". — wiki: `.../wiki/sources/coleam00-harness-engineering-demo.md`, `.../wiki/sources/software-factory-claude-code.md`

### Inferences
- What a framework would add here is a typed graph, a checkpointer and an interrupt API. The `sdlc-ticket` skill already *is* the graph (intake → … → PR), defined in markdown and run by Claude Code. Rebuilding it as a LangGraph/Mastra graph would duplicate it and split the source of truth: skills for interactive use, a graph for the factory.
- If a framework is used later, the only sane form is: framework node = one `claude -p` or SDK call to a skill stage. The framework then owns retries, fan-out and approvals between stages, and Claude Code owns everything inside a stage.

### Gaps
- I didn't verify which frameworks ship a first-party "Claude Agent SDK as an agent" adapter. Mastra's docs list an "SDK Agents" connection section, but I didn't check what it wraps.

## (d) Durable execution wrappers (DBOS, Temporal, Inngest, Trigger.dev, Flyte)

### Takeaway
I found no first-party Temporal or DBOS integration for the Claude Agent SDK. Temporal's GA agent integration is for the OpenAI Agents SDK, and its Claude recipe uses the raw tool-use API. Flyte/Union documents running a claude-agent-sdk agent durably with crash-resume. On one Mac with a single user, the factory's own SQLite run table plus Claude Code's session resume covers the same need.

### Cited Findings
- Search found no official Temporal or DBOS integration for the Claude Agent SDK. Temporal's agent integration that reached GA wraps the OpenAI Agents SDK (TemporalRunner). Temporal's cookbook has a durable loop with Claude *tool calling* (raw API). DBOS's documented agent integrations are the Vercel AI SDK and Pydantic AI. — [Temporal OpenAI Agents SDK changelog](https://temporal.io/change-log/open-ai-agents-sdk-integration-pp); [Temporal AI cookbook](https://docs.temporal.io/ai/cookbook/tags/python); [Pydantic AI DBOS](https://pydantic.dev/docs/ai/capabilities/durable_execution/dbos/index.md)
- Union.ai/Flyte documents bringing your own claude-agent-sdk agent and running it durably; on retry it resumes the conversation from the checkpoint. — [Union: Claude Agent SDK](https://www.union.ai/docs/v2/flyte/integrations/agents/claude-agent-sdk/)
- Trigger.dev v4.5: durable TypeScript tasks with CRIU checkpoint-resume, waitpoint tokens for external events, and `needsApproval`. It is serverless/Docker oriented (`npx trigger.dev deploy`). — wiki: `.../wiki/sources/trigger.dev.md`
- Cole Medin's Agent Control Plane makes a loop durable without any workflow engine. It spawns `pi --mode json --print` as a subprocess, parses NDJSON, and writes every run (role, tokens, `cost_usd`, status, `parent_run_id`) to Postgres with a React dashboard. — wiki: `.../wiki/sources/coleam00-agent-control-plane.md`

### Inferences
- Claude Code already persists transcripts and supports `--resume`/`defer`, so the durable part the factory owns is small: ticket → stage → session_id → status → pending question → cost. A SQLite table plus an idempotent poller covers it. Temporal or DBOS mainly adds value with many workers, many machines, or strict exactly-once side effects (Jira transitions, PR creation), and those can be made idempotent by hand at this scale.
- Temporal needs a server process, Inngest/Trigger.dev lean on a dev server or cloud, and DBOS needs Postgres. On a Mac with no admin rights all of these are possible in user space (Homebrew, Docker Desktop may need admin), but none is free to run.

### Gaps
- Most Temporal/DBOS + Claude material found was third-party blogs (unverified), so it is not cited as fact.

## What factories and orchestrators actually use

### Takeaway
None of the coding-agent factories I checked use a general agent framework for the agent itself. They all run the vendor's harness: a CLI subprocess with stream-json (Vibe Kanban, Agent Control Plane, Claude Squad via tmux), the Claude Agent SDK (Archon), or Codex app-server (Symphony, Archon's Codex provider). Their own code is a thin deterministic orchestrator: tracker polling, worktrees, a state DB, a UI, gates.

### Cited Findings
- **Symphony (OpenAI):** reads eligible issues, claims one, creates a deterministic workspace, and runs the agent "in app-server mode", streaming status back. It is a language-agnostic `SPEC.md` plus an Elixir reference, with Linear/GitHub/Jira/Asana/GitLab adapters and tracker tools executed on the host side. An "engineering preview intended for trusted environments". — wiki: `.../wiki/sources/openai-symphony.md`; repo README "Launches Codex in App Server mode" — [openai/symphony](https://github.com/openai/symphony)
- **Archon:** a YAML DAG workflow engine. Providers are `ClaudeProvider` (claude-agent-sdk) and `CodexProvider` (`codex app-server` over JSON-RPC), and the Docker entrypoint uses the binary bundled in `@anthropic-ai/claude-agent-sdk`. HITL gates (`until: APPROVED`, `interactive: true`) are node types. — [coleam00/Archon `.claude/commands/prime-backend.md`, `docker-entrypoint.sh`](https://github.com/coleam00/Archon); wiki: `.../wiki/sources/coleam00-archon.md`
- **ai-software-factory (Cole Medin):** "Shared Archon workflows, not factory Python, own every AI step", with a deterministic merge gate and protected paths. — wiki: `.../wiki/sources/coleam00-ai-software-factory.md`
- **Vibe Kanban:** agent processes run as subprocesses in each workspace's worktree. The Claude executor passes `--output-format=stream-json --input-format=stream-json`, and there is a separate slash-commands executor. The same CLI+stream-json pattern is used for Cursor, Droid and Amp. — [BloopAI/vibe-kanban `crates/executors/src/executors/claude.rs`](https://github.com/BloopAI/vibe-kanban); wiki: `.../wiki/sources/vibekanban.com.md`
- **Claude Squad:** a terminal manager that runs interactive agents in tmux, each in its own worktree/branch (`session/tmux/tmux.go`). — [smtg-ai/claude-squad](https://github.com/smtg-ai/claude-squad)
- **HumanLayer / CodeLayer:** the Go `hld` daemon owns the session lifecycle, stores in SQLite and exposes a REST API to a Tauri desktop app and CLI. — [DeepWiki summary via search](https://deepwiki.com/humanlayer/humanlayer); [HumanLayer docs](https://docs.humanlayer.com/explanation/remote-daemons)
- **Paperclip:** "not an agent framework; it is the organizational layer above any agent runtime (Claude Code, Codex…)". — wiki: `.../wiki/sources/paperclipai-paperclip.md`
- **Anthropic's own long-running harness** (26 Nov 2025): built on the Claude Agent SDK ("a powerful, general-purpose agent harness"). An initializer agent and a coding agent differ only in their prompts, and state is carried across fresh sessions by `claude-progress.txt`, git history and a JSON feature list with `passes` flags. — [Effective harnesses for long-running agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents); wiki on the March 2026 planner/generator/evaluator follow-up: `.../wiki/sources/9d5bzxVsocw-anthropic-just-dropped-the-new-blueprint.md`, `.../wiki/sources/anthropic.com-managed-agents.md`
- The wiki's dark-factory explainer names five parts (planner, generators, validation layer, deployment, orchestration layer) and frames harnesses as "the structured environments that bound what agents can access and do". — wiki: `.../wiki/sources/dark-factory-autonomous-ai-codebase.md`

### Inferences
- The industry pattern is "deterministic orchestrator + vendor harness per step". The orchestrator is ordinary code (Elixir, Bun/TS, Rust, Go) with a DB and a UI, not an LLM framework.
- Closest analogues to this factory: Symphony's shape (tracker poll → workspace → harness session → stream status → reconcile) combined with Agent Control Plane's persistence (run rows with cost and parent links, plus a dashboard).

### Gaps
- I couldn't confirm from source how HumanLayer's `hld` spawns Claude today. GitHub code search found no `stream-json` in the current repo, and DeepWiki returned 429. Conductor's internals: no reliable source found.

## Recommendation: which layer for phase 1, and when a framework becomes worth it

### Takeaway
Phase 1: a small deterministic orchestrator (Python or TS, SQLite, a local web dashboard) that calls the Claude Agent SDK, or `claude -p --output-format stream-json` if staying shell-first. It should run the user's own skills with settings sources loaded, use `defer` + resume for human pauses, and use budget/turn caps and per-model cost from the result message. No agent framework and no durable-execution engine. Revisit only when the triggers listed below appear.

### Cited Findings
- Anthropic's guidance: start simple, avoid framework abstraction you don't understand. — [Building effective agents](https://www.anthropic.com/research/building-effective-agents)
- The SDK loads the existing skills, subagents, hooks and CLAUDE.md unchanged. — [SDK: Claude Code features](https://code.claude.com/docs/en/agent-sdk/claude-code-features)
- `defer` lets the process exit at a question and resume later. — [Hooks: defer](https://code.claude.com/docs/en/hooks); [User input](https://code.claude.com/docs/en/agent-sdk/user-input)
- Reference factories use CLI subprocesses or the SDK, not frameworks. — see the factories section above

### Inferences
- **Pick SDK (TS or Python) over raw `-p`** when the dashboard bridge matters. `canUseTool` lets an approval or question go straight to the factory's DB/UI without writing an MCP permission server, and typed `ResultMessage` gives `session_id`, `total_cost_usd`, `model_usage` and `stop_reason`/`deferred_tool_use`. Pick raw `-p` if the orchestrator is a shell script or in a language without an SDK. Both run the same binary, so switching later is cheap.
- **Must-do settings for phase 1:** no `--bare`, and keep `settingSources` at user+project. Set the permission mode or an allow list explicitly (`-p` defaults to Manual). Set `--max-budget-usd` / `--max-turns` per stage. Use a `PreToolUse` defer hook for `AskUserQuestion` and for risky tools (push, `gh pr create`, if the user wants a gate). Store `session_id` per ticket/stage. Use one git worktree per ticket. Make Jira transitions and PR creation idempotent (check before acting).
- **Session granularity:** running the whole `sdlc-ticket` chain in one session is the simplest option. Its subagents keep the main context small. If one session per stage proves more reliable, pass state via files (plan.md, progress notes), as Anthropic's long-running harness does.
- **When a framework or durable engine becomes worth it:** (1) several machines or a shared team service, so a central queue is needed and a shared Mac is no longer enough; (2) many parallel tickets with retries/backoff and exactly-once side effects that hand-written idempotency no longer handles; (3) the stage graph moves out of skills into code (conditional branches, fan-out/fan-in across tickets, compensation steps); (4) mixing non-Claude models or runtimes per node (Copilot SDK, Codex). At that point use a thin workflow layer: Temporal/DBOS/Trigger.dev, or LangGraph/Mastra/MAF for typed graphs plus checkpoints. Each node should still be one Claude Agent SDK call, not a framework-native agent.
- **Copilot angle** (company only has Copilot): Microsoft Agent Framework lists the GitHub Copilot SDK as a provider. That is the one framework that could later host both runtimes behind one graph. The same orchestrator-plus-harness shape also works with Copilot CLI as a subprocess.

### Gaps
- No benchmark compares reliability for one long session vs one session per stage on skill chains like `sdlc-ticket`. Decide by experiment.
- Whether the employer allows Claude Code with personal or company credentials on a work Mac is outside the docs.

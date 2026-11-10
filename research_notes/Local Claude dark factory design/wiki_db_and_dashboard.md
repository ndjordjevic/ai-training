# What DBs / state stores and dashboard tech agent factories, orchestrators and monitoring dashboards use (from the agentic-ai-wiki)

Wiki root: `/Users/nenaddjordjevic/LLMProjects/agentic-ai-wiki/`. Page paths below are relative to it. Each point cites the wiki page and the original URL.

## Per source: DB/state store, dashboard stack, local vs hosted, why

### Takeaway
There is no single standard. The 20+ wiki sources split into three groups: (1) **Postgres**, either hosted (Neon) or embedded (PGlite / embedded Postgres), used by Cole Medin's newer factory tools and by Paperclip; (2) **SQLite** for local single-user tools (Vibe Kanban, Phasr, Archon's default, Ouroboros's event store); (3) **no database at all**: plain JSON/markdown/JSONL files on disk (ZazenCodes, firstmate, Ralph, oh-my-claudecode, Cabinet) or in-memory state rebuilt from the tracker (OpenAI Symphony). The user is partly right: the best-known "factory dashboard" in the wiki (Cole Medin's Mission Control) uses Postgres (Neon), not SQLite. But SQLite and plain files are just as common in local tools.

### Cited Findings

**Cole Medin: Factory Mission Control** (`wiki/sources/coleam00-factory-mission-control.md`)
- Its premise: factory state was spread across Archon run history, GitHub, and the factory repo. The hypothesis is "if every fact lands in one Postgres database and every panel is a live query", the owner stops writing throwaway metric scripts — [Factory Mission Control](https://github.com/coleam00/factory-mission-control)
- DB: a Neon project with Postgres 18, logical replication and 7-day history. Numbered SQL migrations (`bun run migrate`). Checks run on throwaway Neon branches (`check-<id>`), never on `main`. "Rewind" opens the screens read-only on a Neon branch from up to 7 days back — [Factory Mission Control](https://github.com/coleam00/factory-mission-control)
- Dashboard stack (fixed in the PRD "so the factory cannot reinvent it"): React 19, Vite 6, Tailwind v4, react-router 7. Live data comes from Neon Realtime (`@neon/realtime-react`, one `useLiveQuery` per panel on a sealed read-only SELECT). A Bun + Hono server serves the app and seals the queries (they expire every 60 s). Tooling: Bun, strict TypeScript, Biome — [Factory Mission Control](https://github.com/coleam00/factory-mission-control)
- Data paths: Archon writes laps/steps/cost into the same Neon project's `main` branch, and DB triggers on `node_started/completed/failed/skipped` copy them into dashboard tables. Errors go to `projection_errors` so a dashboard fault cannot break an Archon write. GitHub data comes in through a Neon Function webhook, a nightly reconcile and a backfill — [Factory Mission Control](https://github.com/coleam00/factory-mission-control)
- Local runtime: served on `127.0.0.1`, console at `http://localhost:3090`. Even though the UI is local, the DB is hosted Neon — [Factory Mission Control](https://github.com/coleam00/factory-mission-control)
- Performance targets: query under 100 ms on the seed data, rows on screen within 500 ms, Realtime `ready` within 2000 ms — [Factory Mission Control](https://github.com/coleam00/factory-mission-control)

**Cole Medin: Agent Control Plane** (`wiki/sources/coleam00-agent-control-plane.md`)
- DB: Neon (serverless Postgres) with three tables: `loops` (goal, mode, status, iterations), `runs` (role, tokens, `cost_usd`, `parent_run_id`), `run_events` (raw streaming event log per run). Every run is flushed to Neon before the next round — [Agent Control Plane](https://github.com/coleam00/agent-control-plane)
- Working state also lives on disk as `PROGRESS.md`, so "state is never held in a model's context" — [Agent Control Plane](https://github.com/coleam00/agent-control-plane)
- Dashboard: Vite + React (localhost:5173), backend Bun + Hono (localhost:8787). It can also be imported into Retool, which reads Neon directly through a Postgres connector, while writes (resume/pause/stop) go through the backend API so auth and audit stay in one place — [Agent Control Plane](https://github.com/coleam00/agent-control-plane)
- Stated reason: closing the observability gap that makes unattended long loops hard to trust (you see every orchestrator decision, worker output, token count and cost) — [Agent Control Plane](https://github.com/coleam00/agent-control-plane)

**Archon** (`wiki/sources/coleam00-archon.md`)
- DB: "SQLite (default) or PostgreSQL, 7 tables". The README describes it as a "single-developer tool" built with "Bun + TypeScript + SQLite/PostgreSQL" — [Archon](https://github.com/coleam00/archon)
- UI: a React web UI with Chat, Dashboard, Workflow Builder and Workflow Execution pages. Server: Hono — [Archon](https://github.com/coleam00/archon)
- In Cole's own factory setup, Archon runs on Postgres (Neon). Mission Control reads Archon's rows from the Neon `main` branch — [Factory Mission Control](https://github.com/coleam00/factory-mission-control). The ai-software-factory `DECISIONS.md` also mentions "moved the Postgres fix upstream" (2026-10-18) — [ai-software-factory](https://github.com/coleam00/ai-software-factory)

**Cole Medin: ai-software-factory** (`wiki/sources/coleam00-ai-software-factory.md`)
- State is split: Archon run history (DB), GitHub (issues, labels, claim comments, PRs) as the work queue, and files in git: `DECISIONS.md` (append-only, newest first, parsed by Mission Control), `.factory/schedule.json` and `.factory/trigger.json`. Scheduling uses OS timers (launchd/systemd) that call `archon trigger fire` — [ai-software-factory](https://github.com/coleam00/ai-software-factory)
- Its incident log records a SQLite issue: `sqlite3`'s context manager commits but does not close the handle, which caused file-lock `PermissionError`s on teardown ("On Linux nothing notices"). The raw capture does not say which component used sqlite3 — [ai-software-factory](https://github.com/coleam00/ai-software-factory) (raw: `raw/github/coleam00-ai-software-factory.md` line ~1011)

**Paperclip** (`wiki/sources/paperclipai-paperclip.md`, `wiki/sources/paperclip.ing.md`)
- DB: Postgres everywhere. Local: "a single Node.js process manages an embedded Postgres and local file storage". Dev uses embedded **PGlite** when `DATABASE_URL` is unset (reset with `rm -rf data/pglite`). Production: "point it at your own Postgres". Schema and migrations use **Drizzle** (`packages/db/`) — [Paperclip](https://github.com/paperclipai/paperclip)
- Dashboard: Express API + React + Vite "board UI" (localhost:3100). It has a full ticket system, org charts, budgets and governance — [Paperclip](https://github.com/paperclipai/paperclip)
- Stated reason: sessions and tasks "persist across reboots" ("On reboot you lose everything" is the problem it solves) — [Paperclip](https://github.com/paperclipai/paperclip)

**Vibe Kanban** (`wiki/sources/vibekanban.com.md`)
- DB: a local SQLite database (Rust backend, `sqlx-cli`, a blank DB seeded from `dev_assets_seed/`). Frontend: Node/pnpm web app, started with `npx vibe-kanban`. A separate Cloud / self-host option (Docker Compose) let teams share projects. The company is shutting down and the cloud services are being removed, so the local SQLite app remains — [Vibe Kanban](https://vibekanban.com/), [repo](https://github.com/BloopAI/vibe-kanban)

**Phasr** (`wiki/sources/phasr.sh.md`)
- DB: SQLite through `sqlx` (`src-tauri/src/store/` SQLite repos). The app is Tauri 2 (Rust) + React 19 + TanStack Router/Query + Zustand, with xterm.js terminals. Release builds need Clerk + Supabase for sign-in and cloud sync. A local-only mode (SQLite only, no sign-in) also exists — [Phasr](https://phasr.sh/), [repo](https://github.com/irishabh96/phasr)

**OpenAI Symphony** (`wiki/sources/openai-symphony.md`)
- **No database by design.** The SPEC says: "Support tracker/filesystem-driven restart recovery without requiring a persistent database; exact in-memory scheduler state is not restored." The orchestrator owns "single authoritative in-memory state". The issue tracker (Linear etc.) plus the workspace directories are the durable truth — [Symphony SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md) (fetched via gh; the wiki page only summarizes it)
- Dashboard: optional. The SPEC defines a dashboard at `/` and a JSON API `/api/v1/state`. The Elixir reference uses Phoenix LiveView + Bandit, started with `--port` — [Symphony elixir/README.md](https://github.com/openai/symphony/blob/main/elixir/README.md)

**ZazenCodes: software-factory-claude-code** (`wiki/sources/software-factory-claude-code.md`)
- State: plain files. One `job.json` per job (`stage`: spec/build/review/approve/merged/needs-human, `round`, reviewer verdicts). Job folders hold markdown artifacts. The backlog is `factory/backlog.md`. Stated reason: "Per-job state files, rather than one shared board file, let several sessions run jobs without write contention." Only the orchestrator session writes `job.json` — [software-factory-claude-code](https://github.com/zazencodes/zazencodes-season-3/tree/main/src/software-factory-claude-code)
- Dashboard: one `dashboard.html` served by `python3 -m http.server`. It polls every 2 s and shows jobs as cards moving across stages — same source

**firstmate** (`wiki/sources/kunchenguid-firstmate.md`)
- State: files on disk plus the tmux (or herdr etc.) session backend. "Restart-proof — all state lives on disk". `data/` holds durable fleet records, `state/` holds runtime records and "append-only status events". It warns that "a `state/<id>.status` line is a wake event, not current-state truth"; a reconciler script (`bin/fm-crew-state.sh`) owns the current state. No DB and no web dashboard — [firstmate](https://github.com/kunchenguid/firstmate)

**Orca** (`wiki/sources/stablyai-orca.md`)
- Electron desktop app. "The execution host owns agent status in one store, the hook server's, and every reader (sidebar, `worktree ps`, mobile, dashboard) subscribes to it." The raw capture shows PostgreSQL only for Orca's cloud skills service, not for local agent state — [Orca](https://github.com/stablyai/orca) (raw: `raw/github/stablyai-orca.md` ~line 1727, ~790)

**Beads** (`wiki/sources/gastownhall-beads.md`)
- An issue tracker for agents, stored in **Dolt** (a version-controlled SQL DB). It runs embedded (single writer, the default) or as a `dolt sql-server` (multiple writers). "Every write is an immediate Dolt commit", which gives a full audit trail. The data model covers Issues, Dependencies, Labels, Comments and Events. Stated reason: it replaces "lossy markdown task lists" — [Beads](https://github.com/gastownhall/beads)

**Ouroboros** (`wiki/sources/q00-ouroboros.md`)
- State layer: an "append-only SQLite event store, full replay, checkpoint" — the only event-sourced SQLite design in the wiki. UI is a TUI (`ourocode`) — [Ouroboros](https://github.com/Q00/ouroboros)

**Block Buzz** (`wiki/sources/block-buzz.md`)
- Postgres (`buzz-db`, Postgres full-text search with a GIN index) plus Redis pub/sub for presence and typing. Every action is one signed event in one log (Nostr relay), with a hash-chained audit log. Desktop app: Tauri + React, talking WebSocket to `ws://localhost:3000`. Built for teams and self-hosting — [Buzz](https://github.com/block/buzz)

**Agent of Empires** (`wiki/sources/njbrake-agent-of-empires.md`)
- Session state lives in tmux. The web dashboard (beta) is React 19 + xterm.js + Tailwind v4 on Vite, served by an axum (Rust) server with a REST API and a WebSocket PTY relay — [Agent of Empires](https://github.com/njbrake/agent-of-empires)

**Cabinet** (`wiki/sources/runcabinet.com.md`)
- "No database. Markdown on disk." "Every save auto-commits" to git, which gives history and restore. Next.js 16 + Tailwind + shadcn + Zustand, plus a Node daemon that handles runs, PTY, cron and WebSocket events — [Cabinet](https://github.com/hilash/cabinet)

**Ralph for Claude Code** (`wiki/sources/frankbria-ralph-claude-code.md`)
- Files only: `.ralph/logs/metrics.jsonl` (JSON Lines, one line per loop), `queue.json`, a rotating log. Analytics come from `ralph-stats`. The task source can be beads, GitHub Issues or a PRD — [ralph-claude-code](https://github.com/frankbria/ralph-claude-code)

**oh-my-claudecode** (`wiki/sources/Yeachan-Heo-oh-my-claudecode.md`)
- State under `.omc/`: `autopilot-state.json`, `ralph-state.json`, `notepad.md`, `project-memory.json` — [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode)

**evo** (`wiki/sources/evo-hq-evo.md`)
- Experiment state is "git-backed across worktrees/sandboxes", with a static HTML dashboard (`evo dashboard --port 8080`) — [evo](https://github.com/evo-hq/evo)

**Other file/log-based patterns**
- learn-claude-code: teammates talk through "append-only JSONL inboxes per teammate" (`wiki/sources/shareai-lab-learn-claude-code.md`) — [learn-claude-code](https://github.com/shareAI-lab/learn-claude-code)
- DeepSeek harness: a "durable session log — append-only `SessionEvent` log; everything model-visible is reconstructable from it" (`wiki/sources/deepseek-ai-deepseek-harness.md`) — [deepseek-harness](https://github.com/deepseek-ai/deepseek-harness)
- Herdr: a local socket API to "subscribe to events" and wait on agent state; no DB is mentioned (`wiki/sources/herdr.dev.md`) — [Herdr](https://herdr.dev/)
- Ruflo: memory lives in "AgentDB" (HNSW vector, RVF binary format). This is agent memory, not a work-state DB (`wiki/sources/ruvnet-ruflo.md`) — [Ruflo](https://github.com/ruvnet/ruflo)

**Hosted factories (storage not disclosed)**
- Warp Factories: factories are defined in files (`factory.yaml`, `agents/<name>/agent.md`) and run on Warp's Oz cloud. The page does not say how run state is stored (`wiki/sources/warpdotdev-warp-factory-examples.md`) — [warp-factory-examples](https://github.com/warpdotdev/warp-factory-examples)
- Factory.ai: a hosted SaaS. The wiki page does not mention its DB (`wiki/sources/factory.ai.md`) — [Factory.ai](https://factory.ai/)

### Inferences
- For a **local single-user** tool, the most common choice is SQLite or plain files (Vibe Kanban, Phasr local mode, Archon's default, Ouroboros, ZazenCodes, firstmate, Ralph, OMC, Cabinet, evo). Postgres-based local tools avoid needing a server by embedding it (Paperclip with PGlite/embedded Postgres).
- For **multi-user / hosted** tools, Postgres is the choice: Paperclip in production, Buzz (with Redis), Archon's Postgres option, Phasr's Supabase sync, Vibe Kanban Cloud. Cole Medin picks hosted Neon even for a single-owner factory, mainly for Neon Realtime live queries, DB branching (safe test DBs, 7-day rewind) and webhook ingestion through Neon Functions. Those are hosted features, not local ones.
- The user's belief is **partly confirmed**. The prominent factory dashboards (Mission Control, Agent Control Plane, Paperclip) use Postgres. But the wiki has just as many local orchestrators on SQLite or plain files, and OpenAI's Symphony chooses no DB at all.
- A recurring pattern is **one append-only event log plus derived current state**: `run_events` (ACP), Archon node events projected by triggers (Mission Control), Ouroboros's SQLite event store, Beads' Dolt commits, firstmate's status events with a reconciler, and Buzz's signed event log. firstmate states it directly: an event line "is a wake event, not current-state truth".

### Gaps
- cxdb is not in the wiki (no hits in `wiki/` or `raw/`).
- The wiki does not say where Archon's SQLite file lives or name its 7 tables.
- Warp Factories' and Factory.ai's storage is not documented in the wiki.
- Gas Town, Conductor, Claude Squad, Multica and other orchestrators had no relevant DB/stack pages beyond what is listed.

## Durable-execution engines or plain files for state?

### Takeaway
No factory or orchestrator in the wiki uses Temporal, Inngest, DBOS, Restate or Trigger.dev for its work state. These names appear only on platform/vendor pages. Plain files (JSON/markdown/JSONL, often in git) are widely used.

### Cited Findings
- Temporal appears only as an ADK plugin and a Render template (`wiki/sources/adk.dev.md`, `wiki/sources/render.com.md`) — [ADK](https://adk.dev/), [Render](https://render.com/). Inngest appears only as a Neon integration (`wiki/sources/neon.com.md`) — [Neon](https://neon.com/). Trigger.dev has its own vendor page (`wiki/sources/trigger.dev.md`), and Vercel's page contrasts it as "checkpoint-resume without workflow constraints" (`wiki/sources/vercel.com.md`) — [Vercel](https://vercel.com/). No hits for DBOS or Restate.
- Framework-level durable execution: LangGraph uses persisted checkpoints with `interrupt()` and resume by `thread_id` (`wiki/sources/langchain.com-langgraph.md`) — [LangGraph](https://www.langchain.com/langgraph). Vercel eve has a built-in durable execution harness (`wiki/sources/eve.dev.md`) — [eve](https://eve.dev/). Pydantic AI integrates with durable execution backends (`wiki/sources/pydantic.dev.md`) — [Pydantic](https://pydantic.dev/). None of these is a coding-agent factory.
- Plain files: ZazenCodes `job.json` + markdown, firstmate `data/` + `state/`, Ralph `metrics.jsonl` + `queue.json`, OMC `.omc/*.json`, Cabinet markdown auto-committed to git, ai-software-factory's `DECISIONS.md` + GitHub issues as the queue, ACP's `PROGRESS.md` — sources as cited above.
- Symphony uses the issue tracker plus the filesystem as its durable store, with in-memory scheduler state — [Symphony SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md)

### Inferences
- The orchestrators get durability without a workflow engine: each tick re-reads the tracker (GitHub/Linear) and the files, and reconciles (Symphony, firstmate, ai-software-factory). For a local Claude-based factory, this keeps the design simpler than adding Temporal-class infrastructure.

### Gaps
- No source compares a durable-execution engine directly with SQLite/files for a coding-agent factory.

## Trade-off notes (concurrency, live updates, migrations, simplicity)

### Takeaway
The wiki's stated trade-offs are about write contention, live updates, safe migrations/test DBs, restart recovery, and audit trails. None of the sources does a head-to-head DB comparison.

### Cited Findings
- Concurrency with files: per-job `job.json` instead of one shared board file "let several sessions run jobs without write contention", and only the orchestrator writes — [ZazenCodes](https://github.com/zazencodes/zazencodes-season-3/tree/main/src/software-factory-claude-code)
- Concurrency with an embedded DB: Beads' embedded Dolt is single-writer; a `dolt sql-server` is needed for multiple writers — [Beads](https://github.com/gastownhall/beads)
- SQLite pitfall: a handle left open by the `sqlite3` context manager caused file-lock errors on teardown — [ai-software-factory](https://github.com/coleam00/ai-software-factory)
- Live updates: Mission Control uses Neon Realtime live queries (no polling, no `initialData`). ZazenCodes simply polls `dashboard.html` every 2 s. Symphony uses Phoenix LiveView. AoE and Cabinet push over WebSocket. Orca has one status store that all readers subscribe to — sources as cited above.
- Migrations and testing: Mission Control uses numbered idempotent SQL migrations, refuses to migrate the `main` branch from checks, and uses disposable Neon branches with fixture seeds — [Factory Mission Control](https://github.com/coleam00/factory-mission-control). Paperclip uses Drizzle migrations and resets PGlite by deleting `data/pglite` — [Paperclip](https://github.com/paperclipai/paperclip)
- Isolation of the dashboard from the writer: Mission Control's triggers catch errors into `projection_errors` "so a dashboard fault cannot fail an Archon write". It never reads Archon's raw `provider_event` rows — [Factory Mission Control](https://github.com/coleam00/factory-mission-control)
- Simplicity / restart: Symphony needs no persistent DB and accepts losing exact in-memory scheduler state — [Symphony SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md). Cabinet: "No database. No vendor lock-in." — [Cabinet](https://github.com/hilash/cabinet)
- Audit trail: Dolt commits on every write (Beads), a hash-chained audit log (Buzz), DB history and rewind (Neon in Mission Control), git auto-commit (Cabinet) — sources as cited above.

### Inferences
- For the user's case (local Mac, single user, Claude Code / Agent SDK), the wiki evidence fits SQLite (or PGlite) as a single local store with an append-only events table plus current-state tables. That matches the Archon-default / Ouroboros / Vibe Kanban / Phasr pattern. The Postgres/Neon choice in Cole's tools is driven by hosted features (Realtime, branching, webhooks via Neon Functions) that a local-only factory does not need. The usual dashboard stack is React + Vite (often Tailwind) served by a small Bun/Hono or Node server, with live updates by WebSocket, SSE, or simple polling.

### Gaps
- No wiki source measures SQLite vs Postgres performance or reliability for agent factories.
- SSE is not explicitly named by any factory source. WebSocket and polling are.

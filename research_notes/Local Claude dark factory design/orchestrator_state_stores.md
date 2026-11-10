# State stores and dashboard stacks in open-source agent orchestrators (as of Nov 2026)

Method: most facts below come from reading the repos directly through the GitHub API on 2026-11-09 (default-branch trees, package.json / Cargo.toml / go.mod / pyproject / mix.exs, DB connection files). Star counts and last-push dates are from the same API call. Durable-execution facts come from web searches (vendor docs first).

## Q1. Which DB / state store does each project use, and how is SQLite used?

### Takeaway
Local, single-user orchestrators almost all use **one embedded SQLite file**, usually in WAL mode with `busy_timeout=5000`, plus plain files (JSON/JSONL/markdown) for logs and agent artifacts. Postgres shows up only when a project also targets team or server deployment (Archon via `DATABASE_URL`, Paperclip via embedded Postgres, Vibe Kanban's cloud "remote" crate, Langfuse). OpenAI Symphony keeps no database at all: the tracker plus the filesystem are the source of truth.

### Comparison table

| Project (repo, stars, last push) | Runtime / language | State store | DB access layer, migrations | SQLite mode | Dashboard stack | Live updates |
|---|---|---|---|---|---|---|
| OpenAI Symphony (openai/symphony, 28k, 2026-09) | Elixir/OTP (Phoenix 1.8, Bandit) | **None.** In-memory orchestrator state; restart recovery from tracker + workspace dirs | Ecto listed (schemas), no DB adapter | n/a | Phoenix LiveView dashboard (optional, `--port`) + terminal status dashboard + JSON API | LiveView (WebSocket) |
| Vibe Kanban (BloopAI/vibe-kanban, 28.6k, 2026-11) | Rust (axum, tokio) + `npx` launcher | SQLite `db.v2.sqlite` in asset dir; cloud "remote" crate uses **Postgres** | **sqlx 0.8** with offline query cache (`.sqlx/`), 76 migration files local, 26 remote; `sqlite-preupdate-hook` feature | **journal_mode = DELETE** (not WAL) | React 18 + Vite 7, TanStack Router/Query/DB, ElectricSQL collection (for remote sync) | SSE (axum `Sse`) for events; WebSocket (tokio-tungstenite) |
| Claude Squad (smtg-ai/claude-squad, 8.8k, 2026-08) | Go | **JSON files**: `state.json`, `instances.json` in config dir; tmux sessions + git worktrees | none | n/a | Terminal TUI (Bubble Tea) | TUI redraw from tmux panes |
| Crystal, now Nimbalyst (stravu/crystal, 3.1k, last push 2026-02) | Electron 37 + Node | SQLite via **better-sqlite3** | hand-written schema + `PRAGMA table_info` column checks; 21 migration files | no WAL pragma found in `database.ts` (default journal) | React 19 + Vite 6 in Electron | Electron IPC |
| Sculptor (imbue-ai/sculptor, 246, 2026-11) | Python (FastAPI, uvicorn) | SQLite `~/.sculptor/database.db` | **SQLAlchemy + Alembic** (plus JSON-schema migrations for pydantic blobs); append-only tables with `_latest` views via triggers | **WAL** ("avoids the DB-locking errors seen under concurrent access") | Electron 45 + React 19 + Vite 8 | WebSocket (`useWebsocket`) |
| OpenHands (OpenHands/OpenHands, 93k, 2026-11) | Main repo is now "agent-canvas": TypeScript; agents run in separate agent-server backends (local, Docker, VM, cloud) | Not verified (see gaps) | n/a | n/a | React 19 + React Router 8 + Vite 8, Electron 43 | not verified |
| Archon (coleam00/Archon, 23.9k, 2026-11, `dev` branch) | Bun + TypeScript, Hono server | **SQLite** `~/.archon/archon.db` by default; **Postgres** when `DATABASE_URL` set (dual adapter) | own adapter layer (`bun:sqlite` / `pg`), schema fingerprint + column migrations | **WAL**, `busy_timeout=5000` set *before* WAL to avoid two CLI processes fighting, foreign_keys ON, busy-retry helpers | React 19 + Vite 6 + Tailwind 4 | not verified |
| Cole Medin ai-software-factory (coleam00/ai-software-factory, 518, 2026-11) | Python scripts on top of Archon workflows | Archon's DB + **`.factory/ledger.jsonl`** (append-only ledger in repo) + markdown policy files | none of its own | via Archon | none of its own (uses Archon) | n/a |
| Paperclip (paperclipai/paperclip, 112k, 2026-11) | Node, Express 5 | **Postgres**: `embedded-postgres` (real Postgres 18 binaries, auto-created locally) or your own Postgres | **Drizzle ORM + drizzle-kit**, 452 migration files | n/a | React 19 + Vite 8 + Tailwind 4 (Storybook) | WebSocket (`ws`), `server/src/realtime` |
| Agent Control Plane (humanlayer/agentcontrolplane, 519, last push **2025-07**) | Go, Kubernetes controller-runtime | **Kubernetes CRDs** (state lives in etcd via the k8s API) | n/a | n/a | kubectl / screenshots of a UI; no local DB | k8s watches |
| Claude Code UI / CloudCLI (siteboon/claudecodeui, 14.5k, 2026-11) | Node, Express 4 | SQLite via **better-sqlite3** (`DATABASE_PATH`), repositories for users, sessions, projects, push subs | hand-written schema + `migrations.ts` | WAL in use (code copies `-wal`/`-shm` files on legacy migration) | React 18 + Vite 7 (Electron devDep) | WebSocket (`ws`) |
| opcode, formerly Claudia (winfunc/opcode, 22.4k, 2026-11) | Tauri 2 (Rust) | SQLite via **rusqlite (bundled)** | hand-written | not verified | Tauri + React 18 + Vite 6; axum web mode | Tauri events; axum `ws` in web mode |
| Ralph Orchestrator (mikeyobrien/ralph-orchestrator, 3.2k, 2026-11) | Rust core | `.ralph/` files (specs, decisions.md) + SQLite `~/.ralph/web/ralph.db` for the web server | **Drizzle ORM + better-sqlite3**, Fastify 5 | **WAL** | Ratatui terminal TUI + web server | WebSocket (tungstenite) |
| Agent Orchestrator (OrchestratorInc/agent-orchestrator, ex-ComposioHQ, 14.3k, 2026-11) | Go daemon (static binary, CGO-free) | SQLite | **modernc.org/sqlite** (pure Go) + **sqlc** generated queries + goose migrations (222 files) | **WAL**, `synchronous=NORMAL`, `busy_timeout=5000`, `foreign_keys=ON`, `journal_size_limit=32MiB`, separate read-only connections | Electron desktop (macOS/Win/Linux) + iOS/Android apps | SSE (with backoff helper) |
| Mission Control (builderz-labs/mission-control, 6.5k, 2026-11) | Next.js 16 App Router, React 19 | SQLite via **better-sqlite3** ("SQLite stores local control-plane state") | hand-written | **WAL**, `synchronous=NORMAL`, `busy_timeout=5000` | Next.js 16 | WebSocket + SSE (both listed) |
| Langfuse (langfuse/langfuse, 37k, 2026-11) | Node/TS web + worker | **Postgres 17** (metadata, Prisma, 471 migrations) + **ClickHouse** (traces, 112 migrations) + **Redis 7** (queues/cache) + **MinIO/S3** (blobs) | Prisma + raw ClickHouse SQL | n/a | Next.js | polling / API |
| Conductor (Melty Labs) | Closed-source macOS app | not public | n/a | n/a | native Mac app | n/a |

### Cited Findings
- Symphony SPEC: "Support tracker/filesystem-driven restart recovery without requiring a persistent database; exact in-memory scheduler state is not restored"; the orchestrator "owns the in-memory runtime state"; the SPEC does not prescribe a dashboard — [SPEC.md](https://github.com/openai/symphony/blob/main/SPEC.md)
- Symphony README: blocked entries (agent asked for approval) "are in memory only; restarting the orchestrator clears that blocked map"; `--port` starts the Phoenix observability service — [elixir/README.md](https://github.com/openai/symphony/blob/main/elixir/README.md); deps phoenix 1.8, phoenix_live_view 1.1, bandit, ecto — [mix.exs](https://github.com/openai/symphony/blob/main/elixir/mix.exs)
- Vibe Kanban local DB: sqlx with `sqlite` + `sqlite-preupdate-hook`, file `db.v2.sqlite`, `journal_mode(SqliteJournalMode::Delete)` — [crates/db/src/lib.rs](https://github.com/BloopAI/vibe-kanban/blob/main/crates/db/src/lib.rs), [crates/db/Cargo.toml](https://github.com/BloopAI/vibe-kanban/blob/main/crates/db/Cargo.toml); remote crate uses sqlx `postgres` — [crates/remote/Cargo.toml](https://github.com/BloopAI/vibe-kanban/blob/main/crates/remote/Cargo.toml); SSE route in [crates/server/src/routes/events.rs](https://github.com/BloopAI/vibe-kanban/blob/main/crates/server/src/routes/events.rs); frontend React 18 + Vite 7 + TanStack + `@tanstack/electric-db-collection` — [packages/local-web/package.json](https://github.com/BloopAI/vibe-kanban/blob/main/packages/local-web/package.json)
- Claude Squad: `StateFileName = "state.json"`, `InstancesFileName = "instances.json"` — [config/state.go](https://github.com/smtg-ai/claude-squad/blob/main/config/state.go); Bubble Tea in [go.mod](https://github.com/smtg-ai/claude-squad/blob/main/go.mod)
- Crystal: repo description says "Crystal is now Nimbalyst"; Electron 37 + better-sqlite3 — [package.json](https://github.com/stravu/crystal/blob/main/package.json), [main/src/database/database.ts](https://github.com/stravu/crystal/blob/main/main/src/database/database.ts)
- Sculptor: "It uses SQLite as its database", path `~/.sculptor/database.db`, Alembic — [database/README.md](https://github.com/imbue-ai/sculptor/blob/main/sculptor/sculptor/database/README.md); WAL set once "PROD-540: WAL avoids the DB-locking errors seen under concurrent access" — [database/core.py](https://github.com/imbue-ai/sculptor/blob/main/sculptor/sculptor/database/core.py); fastapi, sqlalchemy, websockets — [pyproject.toml](https://github.com/imbue-ai/sculptor/blob/main/sculptor/pyproject.toml)
- Archon: "If DATABASE_URL is set: Use PostgreSQL ... Otherwise: Use SQLite at ~/.archon/archon.db" — [packages/core/src/db/connection.ts](https://github.com/coleam00/Archon/blob/dev/packages/core/src/db/connection.ts); bun:sqlite, `busy_timeout = 5000` set before WAL because "opening two CLI processes can make journal_mode = WAL itself contend" — [adapters/sqlite.ts](https://github.com/coleam00/Archon/blob/dev/packages/core/src/db/adapters/sqlite.ts); Hono + pg — [packages/server/package.json](https://github.com/coleam00/Archon/blob/dev/packages/server/package.json)
- ai-software-factory: "All AI work runs through Archon's SDLC pack"; repo contains `.factory/ledger.jsonl` — [README](https://github.com/coleam00/ai-software-factory)
- Paperclip: "An embedded PostgreSQL database is created automatically — no setup required"; "Locally, a single Node.js process manages an embedded Postgres and local file storage. For production, point it at your own Postgres" — [README](https://github.com/paperclipai/paperclip); drizzle-orm 0.45 + embedded-postgres 18.1 beta + postgres.js — [packages/db/package.json](https://github.com/paperclipai/paperclip/blob/master/packages/db/package.json)
- Agent Control Plane: "cloud-native orchestrator for AI Agents built on Kubernetes"; controller-runtime — [README](https://github.com/humanlayer/agentcontrolplane); last push 2025-07-02 (GitHub API)
- Claude Code UI: better-sqlite3 + express + ws + React/Vite — [package.json](https://github.com/siteboon/claudecodeui/blob/main/package.json); `DATABASE_PATH` and `-wal`/`-shm` handling — [server/modules/database/connection.ts](https://github.com/siteboon/claudecodeui/blob/main/server/modules/database/connection.ts)
- opcode: Tauri 2, `rusqlite = { version = "0.32", features = ["bundled"] }`, axum with ws — [src-tauri/Cargo.toml](https://github.com/winfunc/opcode/blob/main/src-tauri/Cargo.toml)
- Ralph Orchestrator: ratatui + tungstenite — [Cargo.toml](https://github.com/mikeyobrien/ralph-orchestrator/blob/main/Cargo.toml); "better-sqlite3 and Drizzle ORM ... WAL mode enabled", default `~/.ralph/web/ralph.db` — [connection.ts](https://github.com/mikeyobrien/ralph-orchestrator/blob/main/backend/ralph-web-server/src/db/connection.ts)
- Agent Orchestrator: "modernc.org/sqlite is the pure-Go (CGO-free) SQLite driver — chosen so the daemon cross-compiles and ships as a static binary"; pragmas WAL, busy_timeout(5000), synchronous(NORMAL), journal_size_limit — [backend/internal/storage/sqlite/db.go](https://github.com/OrchestratorInc/agent-orchestrator/blob/main/backend/internal/storage/sqlite/db.go); sqlc in [package.json](https://github.com/OrchestratorInc/agent-orchestrator/blob/main/package.json); SSE helpers in `frontend/src/renderer/lib/sse-backoff.ts`
- Mission Control: "Enable WAL mode for better concurrent access", `synchronous = NORMAL`, `busy_timeout = 5000` ("prevents contention") — [src/lib/db.ts](https://github.com/builderz-labs/mission-control/blob/main/src/lib/db.ts); "one local dashboard backed by SQLite", interfaces "Web UI, CLI, MCP server, OpenAPI REST API, WebSocket, and SSE", Next.js 16 — [README](https://github.com/builderz-labs/mission-control)
- Langfuse compose: langfuse-web, langfuse-worker, clickhouse, minio, redis:7, postgres:17 — [docker-compose.yml](https://github.com/langfuse/langfuse/blob/main/docker-compose.yml); Prisma migrations in `packages/shared/prisma/migrations`, ClickHouse migrations in `packages/shared/clickhouse/migrations`
- OpenHands main repo: "Run OpenHands, Claude Code, Codex ... across local, remote, and cloud backends"; React 19, React Router 8, Vite 8, Electron 43 — [README](https://github.com/OpenHands/OpenHands), [package.json](https://github.com/OpenHands/OpenHands/blob/main/package.json)
- Conductor: closed-source macOS app by Melty Labs, each agent in its own git worktree, uses your Claude Code login — [conductor.build](https://www.conductor.build/workflows/run-parallel-claude-codes), [The New Stack review](https://thenewstack.io/a-hands-on-review-of-conductor-an-ai-parallel-runner-app/)

### Inferences
- The dominant pattern for local tools is a single SQLite file in the user's home dir, WAL + `busy_timeout=5000` + `synchronous=NORMAL`. Four independent projects (Archon, Agent Orchestrator, Mission Control, Ralph web) converged on almost identical pragmas.
- Nobody among these uses libSQL/Turso. ORMs are split: Drizzle (Paperclip, Ralph), sqlx (Vibe Kanban), sqlc (Agent Orchestrator), SQLAlchemy/Alembic (Sculptor), and raw driver calls (Crystal, Mission Control, Claude Code UI, Archon). No Prisma in the local tools; Prisma only in Langfuse (server product).
- Projects that keep the tracker as source of truth (Symphony) avoid a DB but lose "blocked / waiting for human" state on restart. A factory that pauses on human decisions needs that state persisted somewhere.
- Langfuse's 4-service stack (Postgres + ClickHouse + Redis + S3) is the opposite end: right for team observability, too heavy as the core store of a single-user factory.

### Gaps
- OpenHands: the agent-canvas repo's persistence layer (local conversations, automation backend) was not checked in code; earlier OpenHands versions stored conversations as files, but I did not verify the current state.
- Archon and opcode live-update mechanism (SSE vs WebSocket vs polling) not verified.
- Crystal: no WAL pragma found in `database.ts`; could be set elsewhere.
- Conductor's local storage is not public.
- "Mission Control style" dashboards: only builderz-labs/mission-control checked; there are other repos with the same name.
- Trigger.dev / Inngest / DBOS / Temporal agent *examples* from GitHub were not individually inspected; covered at the engine level in Q3.

## Q2. Dashboard stacks and live updates

### Takeaway
React + Vite is the default UI (Vibe Kanban, Archon, Paperclip, Crystal, Sculptor, Claude Code UI, opcode, OpenHands). It is wrapped in Electron (Crystal, Sculptor, OpenHands, Agent Orchestrator) or Tauri (opcode) when a desktop app is wanted. Next.js is rare (Mission Control, Langfuse). Terminal TUIs are used by Claude Squad (Bubble Tea) and Ralph (Ratatui). Symphony is the only server-rendered option (Phoenix LiveView). For live updates, SSE and WebSocket are both common. Nobody relies on plain polling for the main view.

### Cited Findings
- SSE: Vibe Kanban (axum `Sse`, [events.rs](https://github.com/BloopAI/vibe-kanban/blob/main/crates/server/src/routes/events.rs)); Agent Orchestrator (`sse.ts`, `sse-backoff.ts` in [frontend](https://github.com/OrchestratorInc/agent-orchestrator)); Mission Control (SSE + WebSocket, [README](https://github.com/builderz-labs/mission-control))
- WebSocket: Paperclip (`ws`, `server/src/realtime`, [server/package.json](https://github.com/paperclipai/paperclip/blob/master/server/package.json)); Claude Code UI (`ws`); Sculptor (`websockets`, `useWebsocket.ts`); Ralph (tungstenite); opcode (axum `ws`)
- LiveView: Symphony `dashboard_live.ex` — [elixir/lib/symphony_elixir_web/live](https://github.com/openai/symphony/tree/main/elixir/lib/symphony_elixir_web/live)
- TUI: Claude Squad Bubble Tea ([go.mod](https://github.com/smtg-ai/claude-squad/blob/main/go.mod)), Ralph Ratatui ([Cargo.toml](https://github.com/mikeyobrien/ralph-orchestrator/blob/main/Cargo.toml))

### Inferences
- For a local factory, SSE from the poller/server to a small React+Vite page is the simplest fit. It is one-way (server to browser), works with plain HTTP, and auto-reconnects. Human actions (approve/reject) can be ordinary POSTs. WebSocket is only needed for interactive terminals (several projects use it for PTY streaming).
- Vibe Kanban's `sqlite-preupdate-hook` suggests a "DB change -> event stream" pattern: write to SQLite, hook emits an event, SSE pushes it. A simpler version is: the writer process publishes an in-process event after each commit.

### Gaps
- Did not measure how each SSE implementation handles reconnect or replay (Last-Event-ID).

## Q3. Durable execution for pause/resume on human decisions — local setup effort on a Mac

### Takeaway
For a single-user Mac factory, the lightest durable options are **DBOS with a SQLite system DB** (a library, no server) and **LangGraph with SqliteSaver** (only if the flow is a LangGraph graph). **Temporal** is next: one `temporal server start-dev --db-filename` binary with a UI. **Restate** is also light (single server, awakeables for approvals). **Inngest** self-host runs single-node on SQLite. **Trigger.dev** self-host is the heaviest (Docker Compose with Postgres + Redis, 3+ vCPU / 6+ GB RAM). Many real orchestrators skip all of these and use a DB table of runs with a status column (`waiting_human`) plus a poller.

### Cited Findings
- DBOS: Python quickstart config defaults to a SQLite system database ("for production use, switch to Postgres"); DBOS Go v0.17 added a SQLite backend; human approval via `DBOS.recv` with timeout — [DBOS June 2026 update](https://dbos.dev/blog/new-in-dbos-june-2026), [Why DBOS](https://docs.dbos.dev/why-dbos), [DBOS March 2026 update](https://www.dbos.dev/blog/dbos-new-features-march-2026) (OpenAI Agents SDK integration on SQLite or Postgres). The June post says TypeScript/Go feature parity is still in progress.
- Temporal: `temporal server start-dev` uses an in-memory SQLite DB by default; `--db-filename temporal.db` persists state; Web UI at localhost:8233, gRPC 7233 — [Temporal CLI server reference](https://docs.temporal.io/cli/command-reference/server), [CLI setup](https://docs.temporal.io/cli/setup-cli)
- Restate: an agent creates an awakeable (durable promise with an ID), sends the ID to a reviewer, suspends, and resumes after restart — [Restate human-in-the-loop](https://docs.restate.dev/ai/patterns/human-in-the-loop); server can be installed from npm in the try-it section.
- Inngest: `step.waitForEvent` resolves with the event or null on timeout — [Inngest docs](https://www.inngest.com/docs/features/inngest-functions/steps-workflows/wait-for-event); self-hosted `inngest start --sqlite-dir /data` single node — [Railway template](https://railway.com/deploy/inngest-single-node-sqlite) (community source); dev server reportedly in-memory, resets on restart — third-party, unverified.
- Trigger.dev: `wait.forToken()` pauses a run until a token is completed (SDK or HTTP POST) — [wait for token](https://trigger.dev/docs/wait-for-token); v4 self-host needs Docker 20.10+, Compose 2.20+, webapp host with Postgres + Redis, 3+ vCPU and 6+ GB RAM — [self-hosting docker](https://trigger.dev/docs/self-hosting/docker)
- LangGraph: `interrupt()` + `Command(resume=...)` on the same thread id; a checkpointer is required (SqliteSaver locally, PostgresSaver in production) — [LangGraph interrupts](https://docs.langchain.com/oss/javascript/langgraph/interrupts)

### Setup-effort summary (Mac, single user)

| Option | What runs | Store | HITL primitive | Effort |
|---|---|---|---|---|
| DIY: runs table + poller | your process | SQLite | `status='waiting_human'` row, resume on next poll | lowest; you own retries/idempotency |
| DBOS (Python/TS/Go lib) | in your process | SQLite file (or Postgres) | `recv` / `send` with timeout | low; library only |
| LangGraph | in your process | SqliteSaver | `interrupt()` / `Command(resume)` | low, but ties flow to LangGraph |
| Temporal dev server | 1 extra binary (`brew install temporal`) | SQLite file via `--db-filename` | signals / updates | low-medium; workers + SDK model |
| Restate | 1 extra server | its own embedded log | awakeables / durable promises | low-medium |
| Inngest self-host | 1 extra server | SQLite dir | `step.waitForEvent` | medium; event-driven model |
| Trigger.dev self-host | Docker Compose stack | Postgres + Redis | `wait.forToken` | high for local |

### Inferences
- None of the 16 inspected orchestrators uses Temporal, DBOS, Inngest, Restate or Trigger.dev. They all persist run state in their own DB (or none). So durable-execution engines are optional for this kind of factory, not standard.
- Claude Code / Agent SDK sessions are already resumable by session id (transcripts on disk). Plain DB state plus "resume session X with the human's answer" covers most pause/resume needs without a workflow engine. DBOS-on-SQLite is the cheapest upgrade if exactly-once steps become important.

### Gaps
- No official confirmation that DBOS `recv` works on the Go SQLite backend (DBOS's own post flags feature parity as in progress).
- Restate single-binary install on macOS (brew) not confirmed in the sources found.
- Inngest dev-server persistence: only third-party sources.

## Q4. SQLite vs Postgres (Docker) vs embedded Postgres (PGlite / embedded-postgres) vs JSON files — for a local factory with a poller, a few concurrent agent runs and a live dashboard

### Takeaway
**SQLite in WAL mode** is the right default. This is what most local orchestrators converged on: one file, no daemon, readers do not block the writer, and `busy_timeout` absorbs short write contention between the poller, agent hooks and the dashboard. Use JSON/JSONL files only for append-only logs and transcripts next to the DB. Do not use them for the state you query. Postgres (Docker or embedded) only pays off if the factory later moves to a team server or needs `LISTEN/NOTIFY`.

### Cited Findings
- WAL + `synchronous=NORMAL` "lets readers run concurrently with the writer; busy_timeout absorbs brief writer contention" — [Agent Orchestrator db.go](https://github.com/OrchestratorInc/agent-orchestrator/blob/main/backend/internal/storage/sqlite/db.go)
- Two CLI processes opening the same DB can contend on setting WAL itself, so set `busy_timeout` first and retry — [Archon sqlite.ts](https://github.com/coleam00/Archon/blob/dev/packages/core/src/db/adapters/sqlite.ts)
- Sculptor switched to WAL because of "DB-locking errors seen under concurrent access" — [Sculptor core.py](https://github.com/imbue-ai/sculptor/blob/main/sculptor/sculptor/database/core.py)
- Mission Control hit "SQLITE_BUSY on cold start" from build-time vs runtime state conflicts and native-module ABI mismatches ("better-sqlite3 compiled for wrong Node version. Run: pnpm rebuild") — [mission-control db.ts / package.json](https://github.com/builderz-labs/mission-control/blob/main/src/lib/db.ts)
- PGlite is single-connection; older pglite-socket allows one client at a time; newer versions multiplex queries over one connection with `maxConnections` and "not all cases may be covered" — [PGlite Socket docs](https://pglite.dev/docs/pglite-socket), [pglite-socket 0.2.7 README](https://unpkg.com/@electric-sql/pglite-socket@0.2.7/README.md)
- Paperclip uses `embedded-postgres` (real Postgres binaries, not PGlite) to give zero-setup local Postgres, with the option to point at an external Postgres — [Paperclip README](https://github.com/paperclipai/paperclip)
- Symphony shows the cost of no DB: blocked/approval state is lost on restart — [Symphony README](https://github.com/openai/symphony/blob/main/elixir/README.md)
- Claude Squad stores everything in two JSON files — [config/state.go](https://github.com/smtg-ai/claude-squad/blob/main/config/state.go)

### Pros / cons

| Option | Pros | Cons |
|---|---|---|
| **SQLite (WAL)** | single file, no daemon, easy backup (copy file / `.backup`), fast, SQL for the dashboard, used by most peers; `sqlite3` CLI built into macOS | one writer at a time (fine for a few runs); must set WAL + busy_timeout; native driver rebuilds in Node (better-sqlite3) — avoid with `node:sqlite`/`bun:sqlite`/Python `sqlite3`; no push notifications (emit events in-process) |
| **Postgres in Docker** | real concurrency, `LISTEN/NOTIFY` for live updates, same as a future team server, PostgresSaver/DBOS/Trigger all native | Docker Desktop must run (licensing/RAM on Mac), a daemon to start/upgrade, more moving parts for one user |
| **Embedded Postgres** (`embedded-postgres` npm, as in Paperclip) | Postgres semantics with zero setup, multi-connection | downloads/ships Postgres binaries (~tens of MB), a child process to manage, beta packages; heavier than SQLite |
| **PGlite** (WASM Postgres) | in-process, no binaries, Postgres SQL | single connection: poller + agent hooks + dashboard in separate processes need pglite-socket multiplexing (edge cases); less proven for this use |
| **JSON / JSONL files** | zero deps, human-readable, git-diffable (ASF's `ledger.jsonl`, Claude Squad), good for append-only logs | no transactions, races between concurrent writers, whole-file rewrite, hard to query for a dashboard, state lost on partial write unless you do atomic rename |

### Recommendation (local single-user factory on a Mac, built on Claude Code / Agent SDK)
- One **SQLite** file (for example `~/.factory/factory.db`) with `journal_mode=WAL`, `synchronous=NORMAL`, `busy_timeout=5000`, `foreign_keys=ON`. Set busy_timeout before WAL. Use one writer process (the poller/daemon); agents and hooks report through it (HTTP or CLI) rather than opening the DB themselves where possible.
- Tables: tickets/work items, runs (status incl. `waiting_human`, Claude session id, worktree path, PR url), events (append-only, which feeds the dashboard), decisions (human answers). Keep big transcripts and logs as JSONL files on disk and store only their paths.
- Use the built-in driver of your runtime (`bun:sqlite`, `node:sqlite`, or Python `sqlite3`) to avoid better-sqlite3 rebuild pain. Add Drizzle (TS) or plain SQL migrations. Keep it to a migrations folder from day one: every peer has dozens to hundreds of migrations.
- Dashboard: small React + Vite page (or HTMX if you want no build), served by the same process. Use **SSE** for the live event feed and POST for approve/reject.
- Pause/resume: model human waits as a `waiting_human` run row and resume the Claude session by id when the answer arrives. Add DBOS (SQLite system DB) only if you need exactly-once multi-step workflows. Keep Temporal dev server as the next step up. Skip Trigger.dev and Langfuse-style multi-service stacks for local use.
- Keep a `DATABASE_URL` seam like Archon's (SQLite default, Postgres optional) if a team server might come later.

### Inferences
- The recommendation follows from peer convergence (Archon, Agent Orchestrator, Mission Control, Ralph, Sculptor, Vibe Kanban all on SQLite) and from the small scale (one user, a few concurrent runs). It is a judgment, not a benchmark.

### Gaps
- No published benchmarks found comparing SQLite WAL vs PGlite vs Postgres for this workload.
- `node:sqlite` stability status as of Nov 2026 not checked.

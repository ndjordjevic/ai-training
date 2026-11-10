# Supabase as state store / backend for a local Claude agent factory

Research date: 2026-11-09. Sources: GitHub (gh API search and READMEs), Supabase docs and blog, the agentic AI wiki at `/Users/nenaddjordjevic/LLMProjects/agentic-ai-wiki/`.

## Q1. Which agent orchestrators, factories and dashboards use Supabase, and for what?

### Takeaway
The user is partly right. People do use Supabase in agent tooling. But the big, mature local orchestrators (Archon today, Vibe Kanban, Phasr's local mode, Agent Orchestrator, Mission Control, and others) use SQLite. Supabase shows up in three places: (a) Archon v1, the old Python version; (b) small hobby dashboards and remote-control apps, 0–30 stars, where Supabase is the *cloud* relay between a local Claude Code and a phone or web UI; (c) optional cloud sync and auth (Phasr, GBrain). I found no well-known coding-agent orchestrator that runs on local Supabase as its main store today.

### Cited Findings
**Bigger or well-known projects**
- **Archon v1 (coleam00/Archon, now 23.9k stars).** The original Python "knowledge base + task management MCP server" used Supabase Postgres + PGVector as its only database. Services were a React UI, a FastAPI + Socket.IO server, an MCP server and a PydanticAI agents service. Live updates went over Socket.IO, not Supabase Realtime. Setup asked for a "Supabase account (free tier or local Supabase both work)"; for local Supabase you set `SUPABASE_URL=http://host.docker.internal:8000`; the schema came from `migration/complete_setup.sql` pasted into the SQL editor — [Archon archive/v1-task-management-rag README](https://github.com/coleam00/Archon/tree/archive/v1-task-management-rag)
- **Archon today (TypeScript rewrite).** "Self-hosted. One install on your machine or server. SQLite by default, PostgreSQL if you want it." The README sends readers looking for "the original Python-based Archon (task management and RAG)" to the archive branch — [Archon README](https://github.com/coleam00/Archon). So the most famous Supabase-based agent tool *moved away* from Supabase to SQLite-first, with plain Postgres as an option.
- **Phasr** (Tauri desktop app for parallel coding agents in worktrees). Uses SQLite for workspaces. Clerk + Supabase are only for sign-in and cloud sync. CONTRIBUTING documents a local-only mode with no cloud credentials. The wiki notes release builds need Clerk/Supabase at runtime — wiki `wiki/sources/phasr.sh.md`, [phasr repo](https://github.com/irishabh96/phasr) (22 stars)
- **GBrain** (garrytan/gbrain, 31.9k stars, agent memory). One `BrainEngine` interface with two engines: PGLite (Postgres 17 in WASM, the default, "personal brains up to ~50K pages") and standard Postgres + pgvector "(Supabase or self-hosted, for shared/large/multi-machine)" — wiki `wiki/sources/garrytan-gbrain.md`, [repo](https://github.com/garrytan/gbrain)
- **Ruflo** (ruvnet/ruflo, 81k stars). Only its hosted demo UI `goal.ruv.io` is "Vite + Supabase, self-hostable" (`v3/goal_ui/` has a `supabase/` folder). The core harness is not on Supabase — wiki `raw/github/ruvnet-ruflo.md`, [repo](https://github.com/ruvnet/ruflo)
- **claude-code-templates** (davila7, 33k stars). Supabase is used only for install analytics (`/api/track-download-supabase`), not for agent state — wiki `wiki/sources/davila7-claude-code-templates.md`
- **pgflow** (pgflow-dev/pgflow, 312 stars). "Postgres-centric workflow engine with deep integration with Supabase": TypeScript workflows with retries and "realtime progress", "Built on Postgres + Edge Functions" (on top of pgmq). The Supabase CEO calls it "A workflow engine built on Supabase primitives" — [pgflow README](https://github.com/pgflow-dev/pgflow). This is a general AI-workflow engine, not a coding-agent factory.

**Small projects that match the "Claude Code + dashboard" shape (all low-star, mostly 2026)**
- **metarelay** (dsifry, 7 stars). "Event-driven orchestration for Claude Code." Flow: GitHub webhooks → Supabase Edge Function → Postgres → Realtime WebSocket → local daemon → agents. On startup the daemon catches up through cursor pagination, then subscribes live, with dedup in the cloud and locally. It has hexagonal ports with "Supabase, SQLite, subprocess" adapters — [repo](https://github.com/dsifry/metarelay). It uses Edge Functions + DB + Realtime as a *webhook relay to replace polling*.
- **agent-hub** (nachoeguillor, 0 stars). "Mission control for personal Claude Code agent fleets." A Node daemon on each machine "polls a Supabase command queue", heartbeats every 45 s, and syncs cost and usage aggregates parsed from Claude Code JSONL transcripts. A React PWA on Cloudflare reads with the anon key under read-only RLS — [repo](https://github.com/nachoeguillor/agent-hub). Uses DB, a table used as a command queue, and RLS.
- **agent-team-monitor** (rezaan6, 1 star). "Real-time dashboard for monitoring Claude Code agents." Claude Code hooks POST to Next.js API routes, which write to Supabase Postgres; the browser subscribes to `agents`, `agent_events` and `global_state` through Supabase Realtime. It uses Auth + RLS. It also ships a GitHub Actions keep-alive cron because "Supabase free-tier projects auto-pause after ~7 days of zero database activity" — [repo](https://github.com/rezaan6/agent-team-monitor)
- **Mana Hub** (jacobjessesteinberger, 8 stars). A self-hosted operations dashboard for your own agents: Next.js 16 + Supabase + Claude Code. Supabase gives "Postgres, auth, realtime channel for the dashboard"; agents run locally through a file-drop "Bridge"; migrations are pasted into the SQL editor — [repo](https://github.com/jacobjessesteinberger/mana-hub)
- Others, each 0–16 stars: hermes-os by joelwhittle94 ("AI agent fleet management dashboard — Next.js 16 + Supabase with real-time monitoring"), claude-notify-web ("Vercel + Supabase realtime"), and ruloCode/hermes-os (local-first personal assistant on the Claude Agent SDK with pgvector memory) — found by gh repository search (`supabase claude agents dashboard`, `agent monitoring supabase`, `claude agent sdk supabase`). Not read in depth.
- **pgmq without Supabase:** mushroom-slack-agents uses "Postgres + pgmq as store and queue" for opencode agents — [repo](https://github.com/pujunru/mushroom-slack-agents) (0 stars).

**Ecosystem signal**
- Supabase's official Agent Skills pack covers "Database, Auth, Edge Functions, Realtime, Storage, Vectors, Cron, Queues". That is about agents *building apps* on Supabase, not about orchestrator state — wiki `wiki/sources/supabase-agent-skills.md`
- Supabase's blog (2026-10-14) is aimed squarely at coding agents: "Each git worktree can run its own project", so one agent can reset or migrate its DB without touching others. This is Supabase as the *app under test*, not as the factory's own store — [Supabase blog](https://supabase.com/blog/local-supabase-project-per-agent-with-or-without-docker)
- Third-party "Supabase agent architecture" guides describe Postgres as the source of truth for agent state, Realtime for updates, Edge Functions for agent logic and pgmq for background work. They warn that RLS, pgmq and Realtime channels are Supabase-specific and costly to migrate off. These are SEO-style posts, so treat them as weak evidence — [markaicode](https://markaicode.com/architecture/supabase-agent-architecture/)

### Inferences
- The common Supabase pattern in agent dashboards is **cloud relay**: local Claude Code runs, while a hosted Supabase gives a phone or web dashboard live status (Realtime), login (Auth + RLS) and a command queue. That pattern exists *because* the dashboard lives off the machine. A local-only factory does not need it.
- Archon's move from Supabase (v1) to SQLite-default plus optional Postgres is the strongest real-world signal. The author of a popular factory decided that a hard Supabase dependency was too much friction for a self-hosted, single-user tool.
- If a team version comes later, the agent-hub and agent-team-monitor designs (hooks or a daemon writing to Postgres, Realtime for the UI, RLS per user) are workable templates.

### Gaps
- GitHub code search (`gh search code`) returned nothing usable, so the findings rely on repository search plus READMEs. Private or enterprise use is invisible.
- I did not check whether Vibe Kanban Cloud, Paperclip or Conductor use Supabase internally. An adjacent note in this folder says they use Postgres or SQLite.

## Q2. Running Supabase locally on a Mac: footprint, Realtime, pgmq, RLS, offline, licence

### Takeaway
`supabase start` runs the full stack locally (Postgres, Auth, PostgREST, Realtime, Storage, Edge Functions, Studio, and more). As of CLI v2.119 (Oct 2026), idle memory dropped to about 290 MiB, and an experimental Docker-free native runtime exists for Apple silicon. That runtime matters with no admin rights, since Docker Desktop or OrbStack may not be installable. Everything is open source (Apache-2.0 / MIT / PostgreSQL licence). After the first download it should run offline, but no Supabase doc says so outright.

### Cited Findings
- Install: `brew install supabase/tap/supabase` or `npx supabase` (Node 20+). You need a container runtime; "for macOS, we recommend OrbStack instead of Docker Desktop"; Rancher Desktop, Podman and colima also work. Default ports: 54321 API gateway (REST, GraphQL, Functions, Auth, Storage, Realtime, plus MCP at `/mcp`), 54322 Postgres, 54323 Studio, 54324 Mailpit. With the default ports you can run only one project per machine — [Supabase CLI getting started](https://supabase.com/docs/guides/local-development/cli/getting-started)
- The classic container set (12): kong, postgrest, gotrue (auth), realtime, storage-api, imgproxy, edge-runtime, studio, postgres-meta, logflare, vector, db. One third-party measurement: 2,291 MB install and 1,626 MB memory under load — [DEV Community](https://dev.to/russel_dsouza_bd584a3cb2a/why-supabase-local-dev-needs-23-gb-of-docker-and-how-we-got-it-to-58-mb-5303). That measurement predates the new engine (see next point).
- **New engine (CLI ≥ v2.119.0, 2026-10-14).** Start times (old default / Docker / native): 37 s / 5.2 s / 3.9 s. Restart: 32 s / 2.1 s / 1.4 s. First start with an empty cache: 93 s / 18 s / 16 s. Idle memory: "2.6 GiB on the default engine and 290 MiB on both Docker and native". Download size: 1.9 GB / 550 MB / 360 MB. The CLI now picks a port per project and remembers it — [Supabase blog](https://supabase.com/blog/local-supabase-project-per-agent-with-or-without-docker)
- **Native runtime.** Runs "all 13 Supabase services as plain processes" at the same pinned versions, pgvector included. macOS 14+ on Apple silicon only. Experimental: turn it on with `SUPABASE_EXPERIMENTAL_STACK=1` or config, then `supabase start --runtime native`. Its flags and output are not covered by the CLI compatibility promise. It "doesn't run as root". Postgres starts at once; other services start on first request and stop after 60 s idle (Studio after 5 min); `--eager` starts everything up front. The first start needs network access to download service archives — [Docker and native runtimes](https://supabase.com/docs/guides/local-development/docker-and-native-runtimes), [native runtime search summary](https://supabase.com/features/native-local-runtime)
- **Realtime Postgres Changes.** You turn it on per table with `alter publication supabase_realtime add table ...`. It "authorizes every event against each subscriber" (RLS), and "Changes are also processed on a single thread to preserve their order". Example limit: about 3,000 msgs/s on a Micro instance with RLS. For large fan-out, Broadcast is recommended — [Realtime Postgres Changes docs](https://supabase.com/docs/guides/realtime/postgres-changes)
- **Queues.** Supabase Queues is "built on top of the `pgmq` database extension". It offers guaranteed delivery, "delivered exactly once to a consumer within a customizable visibility window", optional archive, and RLS control for client-side consumers — [Supabase Queues docs](https://supabase.com/docs/guides/queues). The pgmq project is itself under the PostgreSQL licence (5.4k stars) — [pgmq/pgmq](https://github.com/pgmq/pgmq). A third-party analysis says some pgmq functions (send_batch, read, pop) were not reachable through the Data API and needed workarounds — [airframe.ai analysis](https://www.airframe.ai/product/supabase-com-queues/analysis)
- **Licences** (GitHub API): supabase/supabase Apache-2.0, supabase/cli MIT, supabase/realtime Apache-2.0, pgmq PostgreSQL licence. The local stack costs nothing.
- The free hosted tier auto-pauses after about 7 days without activity — [agent-team-monitor README](https://github.com/rezaan6/agent-team-monitor)

### Inferences
- **No admin rights.** Homebrew or npx install the CLI as a normal user. The native runtime avoids needing Docker Desktop or OrbStack, which often need admin rights or company approval. But it is experimental, Apple-silicon-only, and does not promise a stable interface. That is a risk for a factory's *core* store.
- **Offline.** The docs only say the first start downloads images or archives. Once cached, nothing in the docs suggests a cloud call is needed, but this is unverified.
- For a single-user factory, most of the stack is dead weight: Auth, Storage, imgproxy, Kong and PostgREST are not needed when the poller and the dashboard talk to the DB directly. The useful parts are Postgres, Realtime (live dashboard with no custom SSE code), pgmq (job queue with visibility timeout) and pg_cron.
- Lazy start (services sleep until first request, stop after 60 s idle) cuts memory but adds cold-start delay to the first dashboard Realtime connection.

### Gaps
- No official RAM figure under real load for the new engine. No measurement for OrbStack vs native on a Mac.
- No Supabase doc states plainly that the local stack works fully offline.
- Hosted pricing (Pro plan and so on) was not checked in this pass.

## Q3. Supabase vs one SQLite file (WAL) vs plain Postgres in Docker, for this factory and a later team version

### Takeaway
For the first version (one user, one Mac, a poller, a few concurrent Claude runs, a live dashboard), one SQLite file in WAL mode is the simplest fit and matches what peer tools do. Supabase adds about 13 services to get Realtime, pgmq and a hosted path. That is worth it only if the hosted team version is close and you want Realtime, Auth and RLS ready-made. Plain Postgres in Docker sits between the two. Its main gain is the same SQL dialect as a hosted Postgres or Supabase later. Keeping a DB adapter seam, as Archon and metarelay do, keeps all options open.

### Cited Findings
- Peer local orchestrators converge on SQLite with WAL and `busy_timeout=5000` (Archon, Agent Orchestrator, Mission Control, Ralph). Archon sets busy_timeout *before* WAL, because two CLI processes can contend on setting WAL itself. Postgres appears only when a project also targets team or server deployment — sibling note `orchestrator_state_stores.md` in this folder, citing [Archon sqlite.ts](https://github.com/coleam00/Archon/blob/dev/packages/core/src/db/adapters/sqlite.ts)
- Archon's current choice: "SQLite by default, PostgreSQL if you want it", chosen by `DATABASE_URL` — [Archon README](https://github.com/coleam00/Archon)
- metarelay keeps Supabase, SQLite and subprocess adapters behind abstract ports — [metarelay README](https://github.com/dsifry/metarelay)
- GBrain uses embedded PGLite by default and Supabase/Postgres for "shared/large/multi-machine" — wiki `wiki/sources/garrytan-gbrain.md`
- Lock-in warning: RLS, pgmq and Realtime channels are Supabase-specific to migrate off — [markaicode](https://markaicode.com/architecture/supabase-agent-architecture/) (weak source)
- Local idle cost: Supabase about 290 MiB idle (new engine), versus about 1.6 GB under load for the old 12-container stack — [Supabase blog](https://supabase.com/blog/local-supabase-project-per-agent-with-or-without-docker), [DEV](https://dev.to/russel_dsouza_bd584a3cb2a/why-supabase-local-dev-needs-23-gb-of-docker-and-how-we-got-it-to-58-mb-5303)

### Inferences (comparison)
| Concern | SQLite (WAL) | Plain Postgres (Docker) | Local Supabase |
|---|---|---|---|
| Setup / no admin | One file, no daemon, nothing to install | Needs a container runtime (or Homebrew Postgres) | CLI via brew/npx; Docker/OrbStack, or experimental native runtime |
| Concurrent writers (poller + a few agents) | Fine at this scale; one writer at a time, busy_timeout handles it | Full MVCC | Full MVCC |
| Live dashboard | Build your own SSE/WebSocket, or poll | LISTEN/NOTIFY + your own SSE | Realtime built in (Postgres Changes / Broadcast) |
| Job queue | Your own table with a lease column | `SELECT ... FOR UPDATE SKIP LOCKED` or pgmq extension | pgmq (Queues) + pg_cron built in |
| Backup / inspect | Copy the file; `sqlite3` CLI | pg_dump | pg_dump + Studio UI |
| Moving parts | 0 | 1 | about 13 services |
| Path to a hosted team version | Needs a port to Postgres (seam helps) | Same dialect as any hosted Postgres | Same stack hosted; Auth + RLS ready |
- An agent run takes minutes and writes rarely, so the write load is tiny. SQLite's single-writer limit does not matter here.
- Supabase's best extra for this factory is Realtime: the dashboard gets live run status with no hand-written SSE layer. pgmq is nice but easy to copy with a leased-jobs table in either DB.
- A sensible middle path: write SQLite-first behind a small repository interface with Postgres-compatible SQL (no SQLite-only types). Later, point it at hosted Supabase (or any Postgres) for the team version, and only then add Realtime, Auth and RLS.

### Gaps
- No benchmark of SQLite vs Postgres at this exact workload. The recommendation is a judgment based on scale and peer choices.

## Q4. Data residency and compliance if hosted Supabase is used later (Australian fintech)

### Takeaway
Supabase offers a Sydney region (`ap-southeast-2`), and the database, Auth, Storage and backups stay in the chosen region. But logs and telemetry go to EU data centres, support staff work worldwide, the contracting processor is Supabase Pte. Ltd. in Singapore, and the Storage CDN may cache content globally. An Australian fintech's risk team (APRA CPS 234 / CPS 230 thinking) would need to review that. Agent transcripts and code may contain customer data or secrets, so logging matters.

### Cited Findings
- The regions list includes "Oceania (Sydney) ap-southeast-2"; the chosen region sets where primary data lives — [Supabase regions](https://supabase.com/docs/guides/platform/regions)
- "Your PostgreSQL database, as well as Auth service and Storage objects are hosted in that region, alongside backups." — [Data Residency and Transfers FAQ](https://supabase.com/legal/privacy-resources/data-residency-and-transfers-faq)
- Data that may leave the region: account and billing data; support access ("Our support team is distributed globally to provide 24/7 coverage"); "Logs are ingested and stored at EU-based data centers"; Storage may be served through a global CDN; sub-processors "in multiple regions" — same FAQ
- "Supabase Pte. Ltd. (Singapore) is the primary data processor"; Supabase, Inc. (US) gives support. Transfers rely on SCCs in the DPA, and a Transfer Impact Assessment is in the Trust Center. Supabase is "ISO 27001 and SOC 2 certified". HIPAA is "if applicable to your plan". The FAQ says nothing specific about Australia — same FAQ
- Edge Functions can run in the same region as the database (regional invocations) — same FAQ, [regional invocations](https://supabase.com/features/regional-invocations)

### Inferences
- For a fintech, the EU log store and global support access are the main questions, more than where the primary DB sits. Avoid writing customer data or secrets into anything that shows up in Postgres logs (for example, SQL statements that carry prompt or transcript text).
- A self-hosted Supabase, or plain Postgres on the company's own AWS ap-southeast-2 account, avoids the processor and log questions. The Apache-2.0 licence allows that.
- The local-only first version has no residency issue: nothing leaves the Mac except the Claude API calls themselves, which have their own residency questions.

### Gaps
- No check of Supabase's APRA-specific documentation, IRAP status, or whether Australian-only log storage is offered on Team or Enterprise plans.
- The sub-processor list was not reviewed.

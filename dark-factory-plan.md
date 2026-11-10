# Dark factory: rough high-level plan

The first version runs everything on my Mac: agents, SDK, dashboard and database. It uses Claude, needs no admin help, and has no plan gate. It goes all the way to verify and a draft PR, like `sdlc-ticket`. No auto release, no auto-merge.

Full research: [reports/Local Claude dark factory design.md](reports/Local%20Claude%20dark%20factory%20design.md)

## Phase 0: Prove it runs on its own (a few days)

- Run `claude -p "/sdlc-ticket KEY factory"` by hand on a small ticket, with `dontAsk`, an allow list and a $20 cap.
- Check that the skill starts, that subagent models are used, that nothing gets blocked, and that `SendMessage` back to a subagent works.
- Set `CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS=0`, so long subagents aren't cut off at 10 minutes.
- Add a `factory` mode to the skill. It reads a per-repo settings file instead of asking the start-round questions. It also writes the end report as JSON.
- **Done when:** 3 tickets reach a draft PR with no prompts.

## Phase 1: Minimal factory (one ticket at a time)

- A launchd job polls Jira with my token, locks the ticket and makes a worktree.
- An Agent SDK runner with pinned models, cost and time caps, and the macOS sandbox. It blocks merge, marking a PR ready, force push and Jira writes.
- One SQLite file with 4 tables: tickets, runs, decisions, events.
- A FastAPI + HTMX dashboard: a "needs you" inbox, a board and a run page, with live updates. Resume continues a stopped run.
- The factory writes nothing to Jira. I copy drafted comments and post them myself.
- Only a script writes run state. A small `factory` CLI (`job create`, `advance`, `feedback`, …) is the only writer to SQLite. Claude calls it and never edits the state itself.
- A cheap scripted gate (lint, type check, tests, build) runs before the review step. If it fails, the work goes back to the builder without spending tokens on reviewers.
- Every round keeps its files: round output, `decision.md` (why it stopped) and `feedbackN.md` (my answer), next to the events in SQLite. This is for debugging and for judging the factory over time.
- **Done when:** 10 tickets have run and I know the success rate, pauses and cost per ticket.

## Phase 2: Fewer interruptions

- 2–3 runs in parallel, but only one lower-env deploy at a time.
- The `defer` hook handles questions in the middle of a run.
- Watchers for Jira answers, PR comments and CI, plus a follow-through skill.
- I approve posts in the inbox, then the factory posts them with my token.
- Intake writes a risk level (low, medium, high) into the JSON end report, and that sets the later steps. For example, the security review runs only for medium and high risk.
- A chat way to answer: in any Claude session with a `factory` skill, I ask "what's blocked on KEY?" and answer there. The answer is saved through `factory job feedback`, the same as a dashboard click.
- macOS notifications only for decisions and failures.
- Guard hooks for protected paths and for edits to tests.
- A test set of 20–50 past tickets that must pass before any skill or model change.
- **Done when:** nothing needs me in a terminal, and a bad skill change gets caught.

## Phase 3: Later, only when allowed

- Service accounts and Jira push triggers, once admins can help.
- A container or VM runner.
- Postgres for a team server. Hosted Supabase in Sydney is one option, after a risk review.
- A release skill with a human merge and a prod gate. Still no auto-merge.
- **Done when:** security and compliance have agreed.

## Dashboard options for later

Phase 1 stays FastAPI + HTMX + SSE in the browser. These are options for later, if the dashboard grows or becomes a desktop app. Most come from my agentic AI wiki.

| Option | What it is | Who uses it | Fit |
|---|---|---|---|
| [nanoui](https://github.com/justrach/nanoui) | Zig desktop apps (~0.7 MB). Native GPU UI or a system webview with a typed Zig↔TS bridge. The `nui` CLI tests and snapshots without a window, built for coding agents. MIT, 0.x | nanoterm, nanomon | Small native Mac app. Means learning Zig, and the API may still change |
| React + Vite + Tailwind | Most common web dashboard stack | Factory Mission Control, Agent of Empires, Agent Control Plane, Paperclip | Safe default if HTMX gets too limited |
| Tauri 2 + React | Rust desktop shell with a web UI, small binaries | Phasr (with SQLite) | Desktop app that reuses a web UI |
| Electron | Desktop shell with Chromium, heavy but simple | Orca, Open Dot, Cabinet, Sculptor | Only if Tauri doesn't fit |
| pywebview | Python desktop window over a web UI | Hermes Agent Desktop | Easiest desktop step from a Python + FastAPI factory |
| Streamlit | Python script becomes a web app | Data dashboards | Quick prototype only. Reruns the whole script on each click, weak for live feeds |
| Next.js | React framework with a server | Cabinet, builderz Mission Control | Only for a team or hosted version |

Helpers for making it look good: design skills from the wiki such as Impeccable (`pbakaus-impeccable`), taste-skill (`leonxlnx-taste-skill`) and Hallmark (`Nutlope-hallmark`). Reticle (`reticlehq-reticle`) lets an agent check the running UI.

Not a fit: Retool. It's hosted and enterprise, and the factory stays local.

## Lessons from ZazenCodes factory v2

Source: [video](https://www.youtube.com/watch?v=RiaTyJ2POVo), 9 Nov 2026.

- Never review with a weaker model than the builder. Haiku reviewers sent good work back for picky reasons, which can cost more.
- Don't make an interactive Claude session the orchestrator. One Ctrl-C killed all running work, and every step started again from scratch.
- More steps aren't always better. Keep it simple.

## Decided

- Claude is allowed on work code.
- Auth: my Claude subscription, not an API key. Factory runs share my usage limits, so the factory runs one ticket at a time to start.

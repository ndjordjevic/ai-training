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
- **Done when:** 10 tickets have run and I know the success rate, pauses and cost per ticket.

## Phase 2: Fewer interruptions

- 2–3 runs in parallel, but only one lower-env deploy at a time.
- The `defer` hook handles questions in the middle of a run.
- Watchers for Jira answers, PR comments and CI, plus a follow-through skill.
- I approve posts in the inbox, then the factory posts them with my token.
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

## Decided

- Claude is allowed on work code.
- Auth: my Claude subscription, not an API key. Factory runs share my usage limits, so the factory runs one ticket at a time to start.

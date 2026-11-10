# Jira intake and triggering for an AI coding factory

Scope: how a factory gets work from Jira Cloud (for example "ticket assigned to user X") and starts an agent run, locally or in CI or cloud. Context: one engineer at an Australian fintech, probably without Jira admin rights, company licenses GitHub Copilot, user also uses Claude Code. Current as of November 2026.

## Q1. Intake options and their pros and cons for a single engineer without Jira admin

### Takeaway
There are five ways in: admin webhooks, dynamic webhooks via an app, Jira Automation "Send web request", polling with JQL over REST, and vendor agents (Copilot coding agent for Jira, Rovo Dev, Cursor, "Agents in Jira"). Without site admin rights, the only options one person can set up alone are **polling with a personal API token** and (if you are a project admin) a **project-scoped Automation rule**. Admin webhooks and the vendor apps need a Jira site admin to install or register them.

### Cited Findings

**Admin-registered webhooks**
- Created in Jira Administration or via `/rest/webhooks/1.0/webhook`. Can carry an optional `secret` for signing — [Atlassian webhooks](https://developer.atlassian.com/cloud/jira/platform/webhooks/)
- JQL filter is supported for issue, issue property, worklog, comment and attachment events. Empty JQL matches all issues — [Atlassian webhooks](https://developer.atlassian.com/cloud/jira/platform/webhooks/)
- `changelog` is only present on `jira:issue_updated`. Payload has `webhookEvent`, `timestamp`, `issue_event_type_name`, a condensed `user` (includes `accountType`), and `issue` in the shape of the REST API without expands. Bulk operations add `bulkOperationMetaData`. Payloads over 25 MB are not delivered. Admin webhooks can be set to exclude the body — [Atlassian webhooks](https://developer.atlassian.com/cloud/jira/platform/webhooks/)
- Known gaps: post-function webhooks do not fire on the Create transition; project deletion does not send `issue_deleted`; attachments added in the create dialog do not fire `attachment_created` — [Atlassian webhooks](https://developer.atlassian.com/cloud/jira/platform/webhooks/)

**Dynamic webhooks (Connect and OAuth 2.0 apps, `/rest/api/3/webhook`)**
- Only a subset of events (issue, comment, issue property, sprint, version). JQL supports only `issueKey`, `project`, `issuetype`, `status`, `priority`, `assignee`, `reporter`, `issue.property`, `cf[id]` (Epic only), with operators `=`, `!=`, `IN`, `NOT IN` — [Atlassian webhooks](https://developer.atlassian.com/cloud/jira/platform/webhooks/)
- Limits: 100 webhooks per Connect app per tenant; **5 per OAuth 2.0 app per user per tenant**. Webhooks **expire after 30 days** and must be extended with a PUT. OAuth 2.0 webhooks are authenticated with a bearer JWT signed with the app's client secret. Dynamic payloads add `matchedWebhookIds` — [Atlassian webhooks](https://developer.atlassian.com/cloud/jira/platform/webhooks/)

**Jira Automation "Send web request"**
- Monthly automation allowance is counted in **steps** (each trigger, condition, action, branch counts as one): Free 150 per subscription; Standard 400 per user; Premium 750 per user; Enterprise 1,000 per user, pooled across apps. Runs with no actions don't count from 5 November 2026. With extra usage off, flows stop until the reset date; with it on, $0.50 per 1,000 extra steps — [Atlassian: how usage is calculated](https://support.atlassian.com/cloud-automation/docs/how-is-my-usage-calculated/)
- Service limits: concurrent flows Free 5 / Standard 10 / Premium 20 / Enterprise 30; 65 steps per flow; daily processing time 60 minutes per 12 hours; loop detection limit 10 (a flow that triggers itself too often is stopped as LOOP); throttled breaches show as `THROTTLED` in the audit log — [Atlassian automation service limits](https://support.atlassian.com/cloud-automation/docs/automation-service-limits/)
- Send web request timeout: a feature request says the default is 30 seconds with no UI override, but this is from the Server/DC product and may not apply to Cloud — [JIRAAUTOSERVER-273](https://jira.atlassian.com/browse/JIRAAUTOSERVER-273)
- Response body is only available in `{{webResponse.body}}` when "Wait for response" is on (community guidance) — [Atlassian KB](https://support.atlassian.com/automation/kb/getting-an-empty-value-when-using-the-webhookresponse-smart-value/); [Community](https://community.atlassian.com/forums/Jira-Service-Management/What-is-the-proper-syntax-to-read-a-web-request-response-string/qaa-p/3088068)
- OpenAI's Codex cookbook uses exactly this pattern: rule triggers on label change, condition label `aswe`, Send web request POSTs to GitHub `workflow_dispatch` with issue key, summary and description. It lists "Jira: project admin rights + ability to create automation rules" as the requirement — [OpenAI cookbook: Jira to GitHub with codex-cli](https://developers.openai.com/cookbook/examples/codex/jira-github)
- JetBrains Junie documents the same: Send web request POST to `https://api.github.com/repos/{owner}/{repo}/actions/workflows/junie-jira.yml/dispatches` — [Junie Jira integration](https://junie.jetbrains.com/docs/junie-jira-integration.html)

**Polling via REST / JQL**
- Points-based rate limits for Jira Cloud apps were enforced from 2 March 2026. **API-token traffic is not affected** and stays under existing burst limits — [Atlassian rate limiting](https://developer.atlassian.com/cloud/jira/platform/rate-limiting)
- Quotas are per hour, per tenant, and per API path; the new `/rest/api/3/search/jql` endpoint uses an opaque `nextPageToken` instead of `startAt` (community reports, not verified against the changelog) — [Atlassian Community](https://community.atlassian.com/forums/App-Central-articles/Heads-up-Jira-s-new-API-rate-limits-kick-in-tomorrow-Here-s-how/ba-p/3199366); [Atlassian dev community](https://community.developer.atlassian.com/t/jira-cloud-search-rate-limit-jira-api/98318)
- A third-party site claims the API-token exemption is temporary; not confirmed by Atlassian — [supergood.ai](https://supergood.ai/api-report-card/atlassian-jira)

**Vendor agents inside Jira**
- **GitHub Copilot coding agent for Jira**: public preview 5/6 March 2026 — [GitHub changelog](https://github.blog/changelog/2026-03-05-github-copilot-coding-agent-for-jira-is-now-in-public-preview/). Marketplace listing v12.3.0 (25 June 2026) says "Generally Available"; GitHub's docs page does not state GA — [Marketplace](https://marketplace.atlassian.com/apps/2210929719/github-copilot-for-jira)
- Copilot for Jira requirements: paid Copilot plan; Jira Cloud as an AI-enabled app with **Rovo activated**; installation needs a **Jira site administrator** plus a GitHub org owner or GitHub App manager; only users with repo write access can trigger it — [GitHub docs](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/integrate-coding-agent-with-jira)
- Copilot for Jira triggers: set assignee to `GitHub Copilot`, comment `@GitHub Copilot`, or the "Use GitHub Copilot" Automation action. Context used: title, description, labels, comments, custom fields like acceptance criteria. Target repo is named in description or comment (`owner/repo`) or set as a workspace default. Progress streams into the Jira agent panel. Uses Actions minutes and AI credits. SSO orgs need an active SAML session — [GitHub docs](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/integrate-coding-agent-with-jira)
- **Agents in Jira** (open beta, 27 April 2026): assign a work item to an agent from the assignee dropdown, @mention it in comments, or add agents to workflow transitions. Named agents: Rovo agents, GitHub Copilot coding agent, Figma — [Jira releases](https://jirareleases.atlassian.com/announcements/put-ai-teammates-to-work-right-inside-jira)
- **Cursor in Jira** (20 May 2026): assign to Cursor or mention it; a cloud agent picks it up; PR auto-linked to the work item; "available now with every paid Jira subscription" — [Jira releases](https://jirareleases.atlassian.com/announcements/assign-work-directly-to-cursor-in-jira)
- **Rovo Dev in Jira**: start Rovo Dev cloud sessions from any work item; needs Rovo Dev credits, enabled at org and site level, and a connected Bitbucket Cloud or GitHub Cloud repo; can be triggered from Automation (for example, a label) — [Atlassian blog](https://www.atlassian.com/blog/announcements/rovo-dev-in-jira)
- Atlassian's Jira dev page says you can assign work items to Claude, Cursor, Codex, GitHub Copilot, or the native Jira Coding Agent (undated marketing page) — [Atlassian Jira dev](https://www.atlassian.com/software/jira/dev)

### Inferences
- **Fit for one engineer without admin, regulated company:**
  - Polling with a personal API token: no admin needed, nothing exposed to the internet, outbound HTTPS only, easy to explain to security. Cons: latency equals the poll interval; the token acts as you (all actions audited as you); a personal token in a service may break company policy, so check it.
  - Project-scoped Automation rule + Send web request: only possible if you are a project admin; pushes in seconds; spends the automation step allowance shared by the whole company; it sends ticket text to an external URL (GitHub API), which may need a data-flow review.
  - Admin webhooks / dynamic OAuth webhooks: need a site admin or a registered app; dynamic webhooks expire every 30 days; best for a team-level phase 2.
  - Copilot coding agent for Jira: the company already pays for Copilot, so this is the most "approved-vendor" path, but needs a Jira site admin to install and Rovo turned on (Rovo is an AI data-processing decision for a bank). Runs on GitHub's cloud, not your local Claude Code setup.
  - Rovo Dev / Cursor / Claude via Agents in Jira: new vendors, need procurement and admin; probably not phase 1 in a bank.
- A typical poll JQL: `assignee = currentUser() AND status = "To Do" AND labels = agent-ready ORDER BY priority, created` (standard JQL, not verified in a doc fetch here). A label opt-in is safer than "anything assigned to me".
- Jira → GitHub issue sync (and then Copilot or `@claude` on the GitHub issue) is an indirect route; it doubles the state to keep in sync and still needs admin to install a sync app.

### Gaps
- Atlassian Remote MCP server / Rovo MCP as an intake mechanism (polling through MCP tools): not checked in this session. It is suitable for an agent reading tickets, but not a push trigger.
- Whether project admins (not site admins) can create project-scoped rules with Send web request on the user's plan; Atlassian's limits pages do not say.
- Send web request timeout on Cloud: no official figure found.
- Whether a custom agent (your own Claude Code factory) can be registered as an assignable "agent" in Agents in Jira: no developer docs found.
- Forge apps (`trigger` module for `avi:jira:updated:issue`) not checked here; they also need admin install.

## Q2. Receiving webhooks on a laptop vs a server, and security

### Takeaway
If Jira pushes, the receiver should be a public HTTPS endpoint that only acknowledges fast and queues. On a laptop use a tunnel (Cloudflare Tunnel, Tailscale Funnel, ngrok; smee.io only for dev). In a company setting, the cleanest path with no inbound endpoint at all is Jira Automation → GitHub `workflow_dispatch`/`repository_dispatch` → run in GitHub Actions.

### Cited Findings
- Jira wants a fast ack: Primary webhooks arrive within 30 seconds; Secondary (bulk/cascade) up to 15 minutes; concurrency limit 20 Primary and 10 Secondary per tenant/host pair; "acknowledge quickly and process asynchronously" — [Atlassian webhooks](https://developer.atlassian.com/cloud/jira/platform/webhooks/)
- Signing: with a secret, Jira sends `X-Hub-Signature: method=signature` (HMAC, sha256 in examples), computed over the raw UTF-8 body. The secret can't be read back after saving — [Atlassian webhooks](https://developer.atlassian.com/cloud/jira/platform/webhooks/)
- OAuth 2.0 dynamic webhooks are verified with a bearer JWT signed with the app's client secret — [Atlassian webhooks](https://developer.atlassian.com/cloud/jira/platform/webhooks/)
- GitHub `repository_dispatch`: `POST /repos/{owner}/{repo}/dispatches`; classic PAT needs `repo` scope; `event_type` max 100 chars; `client_payload` max 10 top-level properties and under 64 KB; returns 204 — [GitHub REST docs](https://docs.github.com/en/rest/repos/repos#create-a-repository-dispatch-event)
- Codex cookbook workflow: `workflow_dispatch` with inputs `issue_key`, `issue_summary`, `issue_description`; branch `codex/<ISSUE_KEY>`; secrets `JIRA_BASE_URL`, `JIRA_EMAIL`, `JIRA_API_TOKEN`, `OPENAI_API_KEY`; permissions `contents: write`, `pull-requests: write`. The ticket description is put into shell via `${{ }}` with only newline/quote escaping — a script-injection risk; pass inputs via `env:` instead — [OpenAI cookbook](https://developers.openai.com/cookbook/examples/codex/jira-github)
- Claude Code GitHub Action: giving a `prompt` input puts it in automation mode (runs without `@claude`, no tracking comment). Support for `repository_dispatch` changed over time across versions — [claude-code-action custom automations (mirror)](https://git.bjxgj.com/anthropics/claude-code-action/src/tag/v1/docs/custom-automations.md); official docs at [code.claude.com GitHub Actions](https://code.claude.com/docs/en/github-actions)
- Tunnels: Cloudflare Tunnel (`cloudflared`) opens outbound connections only, no inbound ports, Cloudflare Access can add edge identity checks; Tailscale Funnel gives a public HTTPS URL to a local port (`tailscale serve` is tailnet-only and can't receive third-party webhooks); smee.io channels are ephemeral, no replay — dev only. These are blog sources, not vendor docs — [freeCodeCamp](https://www.freecodecamp.org/news/how-to-choose-the-right-tunneling-tool/); [dev.to Tailscale](https://dev.to/chrisshennan/tailscale-as-an-ngrok-local-tunnel-cloudflare-tunnel-alternative-4bd7); [happier.dev comparison](https://guides.happier.dev/cloudflare-tunnel-vs-tailscale-funnel-vs-ngrok-for-claude-code-codex-opencode)

### Inferences
- In a bank, running a public tunnel from a corporate laptop is likely to break security policy. Polling (outbound only) or GitHub Actions dispatch avoids any inbound endpoint.
- For a server path: API Gateway (or Lambda function URL) → verify HMAC → put to SQS (FIFO with issue key as message group gives per-ticket ordering) → return 200 → worker pulls. Standard AWS pattern; not fetched in this session.
- Jira Automation Send web request has no built-in HMAC signing; secure it with a secret header (for GitHub, the PAT in `Authorization`), and treat the payload as untrusted text.
- Use a fine-grained PAT or GitHub App token scoped to one repo for the dispatch call; store it as an Automation secret header where possible.
- IP allowlisting is possible using Atlassian's published egress IP ranges, but those ranges are shared by all Atlassian tenants, so allowlisting does not authenticate; HMAC/JWT does.

### Gaps
- Atlassian outbound IP ranges URL and whether Automation web requests use the same egress ranges: not fetched.
- Official vendor docs for ngrok / Cloudflare / Tailscale webhook verification features: not fetched.
- Whether the current claude-code-action v1 officially supports `repository_dispatch` in automation mode: conflicting sources; `workflow_dispatch` is the safe choice.

## Q3. Reliability patterns

### Takeaway
Jira webhooks are at-least-once with duplicates and no ordering promise, so the receiver must dedupe and re-read the ticket before acting. Every serious orchestrator (Symphony) also runs a reconcile loop that re-reads tracker state each tick and stops runs whose ticket left an active state.

### Cited Findings
- Jira retries up to 5 times, 5–15 minutes apart with random back-off, on 408, 409, 425, 429, 5xx, timeouts and connection errors. **Duplicates are possible.** `X-Atlassian-Webhook-Identifier` stays the same across retries (dedupe key); `X-Atlassian-Webhook-Retry` gives the retry count. After 30 minutes without success, only one attempt per webhook until a delivery succeeds. Failed deliveries can be fetched with the "Get failed webhooks" API. No ordering guarantee is documented — [Atlassian webhooks](https://developer.atlassian.com/cloud/jira/platform/webhooks/)
- OpenAI Symphony SPEC (polling orchestrator):
  - Poll every `polling.interval_ms` (default 30000). Each tick: reconcile running issues, validate config, fetch candidates, sort, dispatch while slots remain.
  - Candidates must be in `tracker.active_states`, not in `tracker.terminal_states`, and match `tracker.required_labels`. Sort: priority, then oldest created, then identifier.
  - Concurrency: `agent.max_concurrent_agents` (default 10), plus per-state caps. A `running` map and `claimed` set are checked before launch; only the orchestrator changes scheduling state.
  - One workspace per issue under `workspace.root`, kept across runs, with hooks `after_create`, `before_run`, `after_run`, `before_remove`.
  - Reconcile: stall timeout `codex.stall_timeout_ms` (default 300000) kills and retries; issue in a terminal state → stop worker and clean workspace; issue no longer active or missing → stop worker, keep workspace; if the refresh call fails, keep running.
  - Retries: failure back-off `min(10000 * 2^(attempt-1), 300000)` ms; on retry, refresh the issue and release the claim if no longer eligible.
  - No persistent DB: after restart, recovery is by cleanup plus fresh polling (persisted retry queue is a TODO).
  - Source: [Symphony SPEC.md](https://raw.githubusercontent.com/openai/symphony/main/SPEC.md)
- Symphony is an "experimental preview" for trusted environments — [Symphony README](https://github.com/openai/symphony)

### Inferences
- Minimal set of rules for a factory:
  - Dedupe on `X-Atlassian-Webhook-Identifier` (webhooks) or on `issueKey + updated timestamp` (polling).
  - Treat any event as a hint only: re-fetch the issue by key and decide from current state (assignee, status, label). This makes ordering and duplicates harmless.
  - One lock per ticket key (a file lock locally, a DynamoDB conditional write or SQS FIFO group on a server). Claim it in Jira too (transition to In Progress or set an "agent status" field) so humans see it.
  - Global concurrency cap (start with 1–2).
  - Poll as backup even when you use push: a reconcile loop every few minutes catches missed webhooks or Automation throttling.
  - Before each step and before push/PR, re-check the ticket: if unassigned, reassigned, or moved to Done/Cancelled, stop and leave the branch; post one comment saying why.
  - Cancellation: a label like `agent-stop` or unassign = cancel, picked up by the reconcile loop.

### Gaps
- Whether Jira webhooks for a single issue can arrive out of order in practice: not documented either way.

## Q4. How existing tools trigger agents from trackers

### Takeaway
They converge on the same shape: **assign (or @mention / label) = start**, the tool builds context from the ticket, works in an isolated cloud sandbox or per-ticket workspace, opens a draft PR, links it back, and streams status into the ticket. Comments are the follow-up channel. The trigger is a tracker-native identity (an "agent user" in the assignee field).

### Cited Findings
- Copilot for Jira: assign / `@GitHub Copilot` / Automation action; draft PR; progress in the Jira agent panel; new `@GitHub Copilot` comment = new PR — [GitHub docs](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/integrate-coding-agent-with-jira)
- Cursor in Jira: assign or mention; cloud agent; PR auto-linked; notifies when it needs input — [Jira releases](https://jirareleases.atlassian.com/announcements/assign-work-directly-to-cursor-in-jira)
- Agents in Jira: agents in the assignee dropdown, @mention, and on workflow transitions; work within Jira permissions and audit trail — [Jira releases](https://jirareleases.atlassian.com/announcements/put-ai-teammates-to-work-right-inside-jira)
- Rovo Dev: session from the work item; plan you can review, then code, tests, PR; Automation trigger by label — [Atlassian blog](https://www.atlassian.com/blog/announcements/rovo-dev-in-jira)
- Symphony: polls the tracker, per-issue workspace, agent writes back with provider tools run host-side so the child process never sees the raw token — [Symphony SPEC.md](https://raw.githubusercontent.com/openai/symphony/main/SPEC.md)
- Linear Agents API (Developer Preview): agents are app users; a `created` AgentSessionEvent webhook carries the issue, comment and context; first activity (a `thought`) must be sent within 10 seconds or the agent shows as unresponsive; another page says the webhook receiver must respond within 5 seconds — [Linear agents](https://linear.app/developers/agents); [Linear agent interaction](https://linear.app/developers/agent-interaction)
- Codex cookbook / Junie: label-triggered Jira Automation → GitHub workflow → PR → Jira transition + comment — [OpenAI cookbook](https://developers.openai.com/cookbook/examples/codex/jira-github); [Junie](https://junie.jetbrains.com/docs/junie-jira-integration.html)
- Claude Code GitHub Actions: `@claude` mentions in issues/PRs (interactive) or a `prompt` input (automation) — [code.claude.com GitHub Actions](https://code.claude.com/docs/en/github-actions)

### Inferences
- Patterns they share: an explicit opt-in signal (assign to the agent identity, a label, or a mention), never "every ticket"; an acknowledgement within seconds; per-ticket isolation; PR as the output; ticket comments as the chat channel; tracker permissions as the guard (Copilot: only repo writers can trigger).
- For a home-made factory without an agent identity in Jira, "assigned to me + label `agent-ready`" is the closest equivalent.

### Gaps
- Devin and Factory.ai Jira integrations: not researched in this session.
- Claude (Anthropic) as an assignable agent in Jira: only mentioned on an Atlassian marketing page; no setup doc found.

## Q5. Writing back to Jira and avoiding feedback loops

### Takeaway
Write back with REST v3 (comments in ADF, transitions by ID, labels, an "agent status" field or issue property). Avoid loops by filtering out events caused by the factory's own account and by only reacting to specific changelog items (assignee or label added), not to any update.

### Cited Findings
- Write-back calls: `POST /rest/api/3/issue/{key}/transitions` with a transition id; `POST /rest/api/3/issue/{key}/comment` with an Atlassian Document Format body; basic auth with email + API token — [OpenAI cookbook](https://developers.openai.com/cookbook/examples/codex/jira-github)
- Webhook payload includes the actor `user` (with `accountType`) and `changelog` on updates — [Atlassian webhooks](https://developer.atlassian.com/cloud/jira/platform/webhooks/)
- Dynamic webhooks can filter on `issue.property`, so an issue property is a filterable place to store agent state — [Atlassian webhooks](https://developer.atlassian.com/cloud/jira/platform/webhooks/)
- Automation stops rules that trigger themselves too often (loop limit 10, marked LOOP) — [Atlassian automation service limits](https://support.atlassian.com/cloud-automation/docs/automation-service-limits/)
- Symphony leaves all tracker writes to the agent via host-side tools, and the orchestrator only reads — [Symphony SPEC.md](https://raw.githubusercontent.com/openai/symphony/main/SPEC.md)

### Inferences
- Loop guards:
  - Trigger only on a changelog item `field = assignee` changing **to** the target user, or a label being **added**; ignore all other updates.
  - Drop events whose actor `user.accountId` is the factory's account (if the factory writes as you, this also drops your own manual edits; a separate service account is better).
  - Factory writes (comments, transitions, its own labels like `agent-running`) must never match the trigger condition.
  - Keep state in one place (issue property or a label set) and make state changes idempotent.
- Custom fields need admin to create; labels, comments, transitions and issue properties do not, so they suit phase 1.
- Transition IDs differ per workflow; look them up with `GET /rest/api/3/issue/{key}/transitions`.

### Gaps
- Whether Jira Automation's "allow other rules to trigger this rule" option prevents loops from Send web request → GitHub → REST write-back: not verified in docs here.
- Using a service account (needs admin) vs personal token in a regulated company: policy question, not researchable.

## Q6. Recommendation: minimal reliable intake for phase 1

### Takeaway
Phase 1: **poll Jira every 1–5 minutes with a personal API token and a JQL like "assigned to me, To Do, label agent-ready"**, re-read each ticket before acting, lock per ticket key, run one agent at a time locally with Claude Code (or in GitHub Actions), and write back with a comment + transition + label. This needs no admin, no inbound endpoint, and survives restarts. Add push (Automation → `workflow_dispatch`, or the Copilot for Jira app) in phase 2 with the poll kept as the reconcile backup.

### Cited Findings
- API-token traffic is outside the new points-based app quotas (still under burst limits) — [Atlassian rate limiting](https://developer.atlassian.com/cloud/jira/platform/rate-limiting)
- Symphony, a reference orchestrator from OpenAI, uses plain polling (30 s default) with reconcile, claims and concurrency caps, and no database — [Symphony SPEC.md](https://raw.githubusercontent.com/openai/symphony/main/SPEC.md)
- Push alternatives need admin rights (webhooks, Copilot for Jira) or project admin (Automation rules) — [Atlassian webhooks](https://developer.atlassian.com/cloud/jira/platform/webhooks/); [GitHub docs](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/integrate-coding-agent-with-jira); [OpenAI cookbook](https://developers.openai.com/cookbook/examples/codex/jira-github)
- Automation runs spend a company-wide monthly step allowance and stop when it runs out (if extra usage is off) — [Atlassian usage](https://support.atlassian.com/cloud-automation/docs/how-is-my-usage-calculated/)

### Inferences
- Phase 1 loop (one script, launched by cron/launchd or Claude Code `/loop`):
  1. JQL search via `/rest/api/3/search/jql`.
  2. For each hit not in the local lock dir: create lock, transition to In Progress, add label `agent-running`, comment "picked up by factory, run id X".
  3. Create a worktree per ticket, run `claude -p` with the ticket text as data (not shell-interpolated).
  4. Between steps and before opening the PR, re-read the ticket; stop if unassigned, label removed, or status changed.
  5. On finish: PR link comment, transition to In Review, swap label to `agent-done` (or `agent-failed` with the reason).
  6. On restart: anything labelled `agent-running` with no live process gets re-checked and either resumed or marked failed.
- Phase 2 options, in order of fit for this company: (a) Copilot coding agent for Jira, since Copilot is already licensed, if a Jira admin will install it and Rovo is approved; (b) project Automation rule → GitHub `workflow_dispatch` → Claude Code action or Copilot in Actions; (c) admin webhook with HMAC → API Gateway → SQS → worker, with the poller kept as a reconcile loop.
- Note the trade-off: the vendor path (Copilot for Jira) is the least code to own but runs the vendor's agent, not your own factory's skills and checks. A self-run factory keeps control (good for audit in a bank) but you own reliability.

### Gaps
- Company policy on personal API tokens in automation, Rovo enablement, and Copilot for Jira install status at Basiq/Cuscal: unknown, must be asked internally.

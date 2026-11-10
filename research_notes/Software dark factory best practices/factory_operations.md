# Factory operations: running an autonomous AI coding factory

Scope: model selection, observability, cost control, sandboxing and security, quality gates and evals, reliability. Current as of 9 Nov 2026. Each practice ends with a phase tag: **[P1]** must have, **[P2]** next, **[P3]** later. Sources are mostly primary docs (code.claude.com via the docs MCP, the github/docs repo via `gh`). Phase tags are my inferences.

## Model selection and routing

### Takeaway
Both tools let you set the model and the reasoning effort for each run and for each subagent or custom agent. A sensible default: plan on Opus 5.5 (or Fable for the hardest work), write code on Sonnet 5.5, triage and explore on Haiku 5.5, and review on a different model family (for example a GPT-6.x model in Copilot). Copilot now bills tokens as "AI credits" (1 credit = $0.01). Premium-request billing is legacy.

### Cited Findings
**Claude line-up and aliases (Claude Code)**
- On the Anthropic API the aliases resolve as: `opus` = Opus 5.5, `sonnet` = Sonnet 5.5, `haiku` = Haiku 5.5. Other providers lag. Bedrock/Google: Opus 5.5, Sonnet 4.5, Haiku 4.5. Microsoft Foundry: Opus 4.6. — [Claude Code model config](https://code.claude.com/docs/en/model-config)
- Other aliases: `best` (Fable where you have access, otherwise Opus), `opusplan` (Opus in plan mode, Sonnet for execution), `sonnet[1m]` / `opus[1m]` (1M context). Fable 5.1 is selected with `--model fable`. — [Model config](https://code.claude.com/docs/en/model-config)
- To pin versions, use full IDs (for example `claude-opus-5-5`) or `ANTHROPIC_DEFAULT_OPUS_MODEL` / `_SONNET_` / `_HAIKU_` / `_FABLE_`. Aliases "update over time". Minimum versions: Opus 5.5 needs Claude Code v2.1.280+, Sonnet 5.5 needs v2.1.284+, Haiku 5.5 needs v2.1.293+. — [Model config](https://code.claude.com/docs/en/model-config)
- Admins can limit models with `availableModels`, `deniedModels` (v2.1.283+, for example to hold back a new release) and `enforceAvailableModels`. These also cover subagent `model` fields and `CLAUDE_CODE_SUBAGENT_MODEL`. — [Model config](https://code.claude.com/docs/en/model-config)

**Claude Code: per-run and per-subagent controls**
- `--model <alias|id>`, `--effort low|medium|high|xhigh|max|ultracode`, and `--fallback-model sonnet,haiku`, which tries an ordered chain when the primary model is overloaded or retired. The persistent version is the `fallbackModel` setting. — [CLI reference](https://code.claude.com/docs/en/cli-reference)
- `--advisor opus|sonnet|fable` turns on a server-side advisor model for the session. — [CLI reference](https://code.claude.com/docs/en/cli-reference)
- Subagent frontmatter supports `model`, `effort`, `maxTurns`, `permissionMode`, `isolation: worktree`, `tools`/`disallowedTools`, `hooks` and `mcpServers`. Claude Code silently ignores fields it does not recognize, so typos fail without warning. — [Subagents](https://code.claude.com/docs/en/sub-agents)
- Subagents that inherit the model follow `/model` switches. To keep one on a cheaper model, set `model` in its definition. Defining your own `Explore` with `model: haiku` makes exploration cheaper. — [Subagents](https://code.claude.com/docs/en/sub-agents); [Model config](https://code.claude.com/docs/en/model-config)

**GitHub Copilot line-up (all GA, from github/docs)**
- Anthropic: Claude Haiku 4.5/5.5, Sonnet 4.6/5/5.5, Opus 4.8 (plus a fast-mode preview), Opus 5/5.5, Fable 5/5.1. OpenAI: GPT-5.3-Codex, GPT-5.4 nano, GPT-5.6 Luna/Sol/Terra, GPT-6 Astra/Luna/Sol, GPT-6.1 Sol/Terra. Google: Gemini 3.8 Flash, Gemini 4 Argon. Also MAI-Code-1.1-Flash, Kimi K3 and Grok 4.5/4.6/4.7. — [github/docs model-release-status.yml](https://github.com/github/docs/blob/main/data/tables/copilot/model-release-status.yml)
- GPT-5.3-Codex is the "long term support" model. Auto model selection falls back to it when no other model is available. — [Supported models](https://docs.github.com/en/copilot/reference/ai-models/supported-models)
- Fable 5/5.1 in Copilot: Anthropic keeps prompts and outputs by default for safety classifiers. Zero data retention (ZDR) is available only under a time-bound exemption that runs to the end of 2026; after that, Enterprise Frontier Safeguards (EFS) are required. An admin must also enable each model. Other Claude models run under ZDR. This matters for a regulated fintech. — [Supported models](https://docs.github.com/en/copilot/reference/ai-models/supported-models)
- Configurable reasoning levels work in VS Code, Copilot CLI and the cloud agent. The 1M context option is in VS Code and the CLI only. Both cost more credits. GitHub recommends the default context and reasoning, raised only for complex tasks. — [Supported models](https://docs.github.com/en/copilot/reference/ai-models/supported-models)

**Copilot per-token prices (per 1M tokens, input / cached input / output)**
- Claude Haiku 5.5: $0.10 / $0.01 / $0.50. Sonnet 5.5: $2.00 / $0.10 / $10.00 (cache write $2.50). Opus 5.5: $4.00 / $0.20 / $20.00 (cache write $5.00). Fable 5.1: $10.00 / $0.25 / $50.00. — [github/docs models-and-pricing.yml](https://github.com/github/docs/blob/main/data/tables/copilot/models-and-pricing.yml)
- GPT-6 Luna: $0.10 / $0.01 / $0.50. GPT-6.1 Terra: $1 / $0.05 / $5. GPT-6.1 Sol: $2 / $0.10 / $10. GPT-6 Astra: $10 / $1 / $50. GPT-5.3-Codex: $1.75 / $0.175 / $14. Long-context tiers cost about 2x. — [models-and-pricing.yml](https://github.com/github/docs/blob/main/data/tables/copilot/models-and-pricing.yml)
- Gemini 4 Argon: $2 / $0.10 / $10. Gemini 3.8 Flash: $0.75 / $0.075 / $3.75 (both carry promo footnotes). — [models-and-pricing.yml](https://github.com/github/docs/blob/main/data/tables/copilot/models-and-pricing.yml)
- 1 AI credit = $0.01. Business and Enterprise plans give per-user credit allowances, pooled at the billing entity. Overage is billed at the per-token rates. Request-based billing (premium requests and model multipliers) remains only for legacy annual Pro/Pro+ plans. — [Models and pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing)
- Copilot code review picks its model automatically and does not disclose it. Each review is billed in AI credits (scaled by review effort level) plus Actions minutes. — [Models and pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing)

**Copilot CLI: per-run and per-agent controls**
- `--model=MODEL` or `COPILOT_MODEL`, with `--model auto` for auto selection. `/model auto efficiency|balance|intelligence` picks an Auto tier. `--effort` / `--reasoning-effort` takes `low|medium|high|xhigh|max`. `/model --repo` pins a default in repository settings. — [Copilot CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
- Custom agent profiles have a `model` field (it inherits the default if unset), plus `tools`, `mcp-servers` (not in IDEs) and `target` (`vscode` or `github-copilot`). — [Custom agents configuration](https://docs.github.com/en/copilot/reference/custom-agents-configuration)
- `--plan --mode autopilot` (or `COPILOT_PLAN_THEN_AUTOPILOT=1`) plans first and then runs without waiting for human approval. `--no-ask-user` removes the ask_user tool. — [CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)

### Inferences
- [P1] Routing table: triage/classify = Haiku 5.5 or GPT-6 Luna at low effort. Plan = Opus 5.5 at high effort. Code = Sonnet 5.5 at medium/high. Review = a different family (GPT-6.1 Sol in Copilot, or Opus if the writer was Sonnet) at high effort. Haiku 5.5 is 20x cheaper than Sonnet 5.5 on output.
- [P1] In unattended runs, pin full model IDs, not aliases, so a silent alias upgrade cannot change factory behaviour. Treat a model upgrade like a skill change: run the regression evals first.
- [P1] Set `--fallback-model` on every headless Claude run.
- [P2] Leave Fable off in Copilot until the ZDR/EFS terms pass compliance review.
- [P2] Avoid Copilot `auto` model in the factory: it makes runs hard to reproduce and to attribute cost to.

### Gaps
- I did not confirm how the Copilot cloud agent (the github.com coding agent) lets you pick a model per task, beyond the custom agent `model` field.
- I did not fetch Anthropic direct-API prices. The Copilot table is the Copilot rate, which may differ.
- I found no primary benchmark data comparing these specific 5.x and 6.x models on coding.

## Observability (logging, tracing, metrics)

### Takeaway
Both Claude Code and Copilot CLI export OpenTelemetry natively using GenAI semantic convention attributes, and both accept an inbound W3C `TRACEPARENT`. A factory orchestrator can therefore own the root span (ticket → run → stage) and have each agent's spans nest under it. Prompt and tool content capture is off by default in both and must be opted into. That is a data-governance decision for a fintech.

### Cited Findings
**Claude Code**
- Required to enable: `CLAUDE_CODE_ENABLE_TELEMETRY=1`. Then set `OTEL_METRICS_EXPORTER` / `OTEL_LOGS_EXPORTER` (`otlp`, `prometheus`, `console`, `none`), `OTEL_EXPORTER_OTLP_PROTOCOL` (no default, so you must set it) and `OTEL_EXPORTER_OTLP_ENDPOINT`. Default export interval is 60s for metrics and 5s for logs. — [Monitoring](https://code.claude.com/docs/en/monitoring-usage)
- Traces are beta. They need `CLAUDE_CODE_ENHANCED_TELEMETRY_BETA=1` plus `OTEL_TRACES_EXPORTER=otlp`. — [Monitoring](https://code.claude.com/docs/en/monitoring-usage)
- Span tree: `claude_code.interaction` (root, one per prompt) → `claude_code.llm_request`, plus `claude_code.tool` → `tool.blocked_on_user` and `tool.execution`. Subagent spans nest under the parent's Agent tool span. LLM spans carry `gen_ai.system`, `gen_ai.request.model`, `gen_ai.response.id` and `gen_ai.response.finish_reasons`. Each retry is a `gen_ai.request.attempt` span event. — [Monitoring](https://code.claude.com/docs/en/monitoring-usage)
- In `-p` and Agent SDK sessions, Claude Code reads `TRACEPARENT`/`TRACESTATE` from its environment, so its interaction span becomes a child of the caller's span. Event log records also get `trace_id`/`span_id` even when no traces exporter is set. Bash subprocesses inherit `TRACEPARENT`. Interactive sessions ignore an inbound TRACEPARENT. — [Monitoring](https://code.claude.com/docs/en/monitoring-usage)
- Metrics include `claude_code.session.count`, `cost.usage` (USD), `token.usage`, `lines_of_code.count`, `pull_request.count`, `commit.count` and `active_time.total`. Events include `user_prompt`, `tool_result`, `tool_decision` and `api_request`. — [Monitoring](https://code.claude.com/docs/en/monitoring-usage)
- Content gates are all off by default: `OTEL_LOG_USER_PROMPTS`, `OTEL_LOG_ASSISTANT_RESPONSES`, `OTEL_LOG_TOOL_DETAILS` (Bash commands, MCP/skill names, tool input), `OTEL_LOG_TOOL_CONTENT` (tool output, 60 KB cap) and `OTEL_LOG_RAW_API_BODIES` (full request and response, or `file:<dir>` for untruncated bodies on disk). `CLAUDE_CODE_OTEL_CONTENT_MAX_LENGTH` sets the cap (default 61440). — [Monitoring](https://code.claude.com/docs/en/monitoring-usage)
- Attribute toggles include `OTEL_METRICS_INCLUDE_SESSION_ID` (default true) and `OTEL_METRICS_INCLUDE_REPOSITORY` (vcs.*, v2.1.269+). `OTEL_RESOURCE_ATTRIBUTES` keys are added to metric datapoints, which is a way to tag ticket and run IDs. — [Monitoring](https://code.claude.com/docs/en/monitoring-usage)
- Repository `.claude/settings.json` cannot turn telemetry on or redirect it. Set it in managed settings, the user's `~/.claude/settings.json`, or the environment. Managed OTLP endpoint and header settings strip conflicting developer settings. — [Monitoring](https://code.claude.com/docs/en/monitoring-usage)

**Copilot CLI**
- OTel is off by default. It turns on with `COPILOT_OTEL_ENABLED=true`, by setting `OTEL_EXPORTER_OTLP_ENDPOINT`, or by setting `COPILOT_OTEL_FILE_EXPORTER_PATH` (JSON-lines file). Default protocol is `http/json`. `OTEL_INSTRUMENTATION_GENAI_CAPTURE_MESSAGE_CONTENT=false` by default. Default service name is `github-copilot`. It can also be set from an enterprise managed settings file. — [Copilot CLI reference: OpenTelemetry](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
- Span tree: an `invoke_agent` root with `chat` and `execute_tool` children. Subagents also produce `invoke_agent` spans. Attributes include `gen_ai.agent.id/name/version`, `gen_ai.conversation.id`, `gen_ai.usage.input_tokens/output_tokens/cache_read/cache_creation`, `github.copilot.turn_count`, `github.copilot.nano_aiu` (AI units) and `error.type`. `github.copilot.cost` is a multiplier, not money. — [CLI reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
- Logs: `--log-dir` (default `~/.copilot/logs/`) and `--log-level`. `--share=PATH` writes the session as Markdown after a programmatic run, and `--share-gist` sends it to a secret gist. — [CLI reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)

**OTel GenAI semconv and backends**
- The GenAI conventions are still "Development" (not stable), according to several mid-2026 sources. In June 2026 they moved to the dedicated `open-telemetry/semantic-conventions-genai` repo (deprecated in core semconv v1.42.0). Agent operations include `invoke_agent`, `create_agent`, `execute_tool` and `invoke_workflow`. One article claims they were stabilized in June 2026, which the other sources contradict. — [Greptime, May 2026](https://greptime.com/blogs/2026-05-09-opentelemetry-genai-semantic-conventions); [TrueFoundry](https://www.truefoundry.com/blog/opentelemetry-genai-semantic-conventions)
- Langfuse documents integrations for the Claude Agent SDK (Python/JS, via OpenInference) and publishes a Claude Code plugin on the Claude marketplace. A community thread reports that Langfuse's OTLP endpoint accepted traces but not Claude Code's logs; this may be outdated. — [Langfuse Claude Agent SDK](https://langfuse.com/integrations/frameworks/claude-agent-sdk); [Langfuse plugin](https://claude.com/marketplace/plugins/langfuse-observability); [Langfuse discussion #9242](https://github.com/orgs/langfuse/discussions/9242)

### Inferences
- [P1] The orchestrator creates a root span per ticket and a child span per stage, then passes `TRACEPARENT` plus `OTEL_RESOURCE_ATTRIBUTES=ticket.id=…,run.id=…,stage=…,skill.version=<git sha>` to each `claude -p` / `copilot -p` call. That gives the ticket → run → stage → tool-call structure for free.
- [P1] Minimum record per stage: ticket ID, run ID, stage, agent tool and version, model ID, effort, skill/prompt git SHA, start and end time, tokens (input/output/cache), cost (USD or nano-AIU), turn count, exit status, outcome (PR URL / CI result / escalated), and the session ID for resume.
- [P1] Store transcripts per run: Claude's `--output-format stream-json` output and `~/.claude/projects/*.jsonl`, and Copilot's `--share` Markdown. Keep them in an access-controlled bucket with retention aligned to audit policy.
- [P1] Leave content capture off in OTel. Keep full transcripts in the controlled store instead. Turn on `OTEL_LOG_TOOL_DETAILS` (commands, no outputs) for audit.
- [P2] A self-hosted OTel Collector feeding Grafana (Tempo traces, Loki logs, Prometheus/Mimir metrics) or Langfuse self-hosted keeps data in an Australian region.
- [P3] LLM-specific evaluation UIs (Langfuse, Phoenix, LangSmith, Datadog LLM Obs) once eval volume justifies them.

### Gaps
- I did not verify current Phoenix, LangSmith, Honeycomb or Datadog support for Claude Code or Copilot CLI OTLP. Langfuse support for logs is uncertain.
- I did not check Copilot cloud agent (github.com) telemetry export beyond session logs on the PR.

## Cost and limits

### Takeaway
Claude Code headless runs have hard caps: `--max-budget-usd` and `--max-turns`. Copilot CLI has `--max-ai-credits` (soft, per response) and an autopilot credit cap on goals. Wrap both in an orchestrator-level wall-clock timeout and a per-ticket budget, because the built-in caps can be overshot.

### Cited Findings
- `--max-budget-usd` works in print mode only. It is checked against the client-side cost estimate and includes subagent spend. Spend can pass the cap by up to one response plus running subagents, so leave headroom. Once the cap is hit, new subagents fail with `Budget limit reached`. Costs restored by `--resume` don't count toward the cap. — [CLI reference](https://code.claude.com/docs/en/cli-reference); [Agent loop: budget headroom](https://code.claude.com/docs/en/agent-sdk/agent-loop)
- `--max-turns` (print mode) has no limit by default. Subagent `maxTurns` returns partial output that can be resumed. — [CLI reference](https://code.claude.com/docs/en/cli-reference); [Subagents](https://code.claude.com/docs/en/sub-agents)
- `API_TIMEOUT_MS` sets the API request timeout (the docs example uses 1200000). — [Env vars](https://code.claude.com/docs/en/env-vars)
- Prompt caching: `/cost` and similar views show cache hit %, misses and TTL (5 minutes or 1 hour). The first message after an idle gap longer than the TTL reprocesses the full context. — [Costs](https://code.claude.com/docs/en/costs)
- Copilot CLI: `--max-ai-credits=N` is a soft cap per response that resets per user message. `/goal … --max-ai-credits N` pauses autopilot at the cap. `--max-autopilot-continues` defaults to 5. — [Copilot CLI reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
- In Copilot, cached input is about 10-20x cheaper than fresh input (for example Sonnet 5.5: $2.00 vs $0.10). Cache writes are charged on Anthropic models and newer OpenAI models. — [models-and-pricing.yml](https://github.com/github/docs/blob/main/data/tables/copilot/models-and-pricing.yml)

### Inferences
- [P1] Starting caps, to tune from measured data: triage $0.25 / 10 turns; plan $2 / 30 turns; implement $8 / 150 turns; review $2 / 40 turns. Per-ticket ceiling $20. Wall-clock timeout of 45-60 minutes per stage, enforced by the orchestrator. Cap at most 3 implement-fix cycles per ticket, then escalate.
- [P1] Runaway-loop detection: the same failing test or command more than N times, no git diff progress across K turns, or the same tool call repeated. Use a PostToolUse hook or have the orchestrator watch the stream-json output.
- [P2] Keep prompt caching effective: a stable system prompt and skill text first, ticket-specific content last. Avoid idle gaps longer than the TTL between stages of one session.
- [P2] Weekly cost dashboard by stage, model and skill version from the OTel cost metric.

### Gaps
- I did not research API rate limits or tiers (Anthropic org limits, Copilot rate limits) for concurrent runs.

## Sandboxing and security (regulated fintech)

### Takeaway
Run unattended agents only in an isolated container or VM as a non-root user, with OS-level sandboxing and an egress allowlist. Use least-privilege, short-lived tokens. Never use `--dangerously-skip-permissions` or `--yolo` on a developer host. Treat ticket text as untrusted input and break the "lethal trifecta" (private data + untrusted content + outbound channel).

### Cited Findings
**Claude Code**
- Permission modes: `default`, `acceptEdits`, `plan`, `auto` (a classifier model reviews actions), `dontAsk` (only pre-approved tools; everything else is denied, intended for "locked-down CI and scripts") and `bypassPermissions` ("isolated containers and VMs only"). Deny rules apply in every mode, including bypass. — [Permission modes](https://code.claude.com/docs/en/permission-modes)
- For CI the docs recommend `claude -p "…" --permission-mode dontAsk --allowedTools "Bash(npm test)" "Read"`. Fully unattended `--dangerously-skip-permissions` requires a container, VM or the sandbox runtime, and a non-root user. — [Permission modes](https://code.claude.com/docs/en/permission-modes)
- `bypassPermissions` and `auto` set in a repository's `.claude/settings.json` don't take effect, so a repo can't escalate itself. — [Permission modes](https://code.claude.com/docs/en/permission-modes)
- Bash sandbox: Seatbelt on macOS, bubblewrap + socat on Linux. Network goes through a proxy whose `allowedDomains` list starts empty. `filesystem.denyRead` / `allowWrite` and `credentials` can deny or mask secrets: masked values are replaced by a sentinel, and the proxy swaps in the real value only for allowed hosts. — [Sandboxing](https://code.claude.com/docs/en/sandboxing)
- Hardening: `allowUnsandboxedCommands: false` (no unsandboxed retry) and `failIfUnavailable: true` (exit if the sandbox can't start). Set in managed settings, these make repo settings unable to loosen the sandbox. The sandbox does not cover the built-in Read/Edit/WebFetch tools; permission rules govern those. — [Sandboxing](https://code.claude.com/docs/en/sandboxing)
- `permissions.blockReadsOutsideWorkingDirectories` prompts on file reads outside the working directory even in bypass and auto mode (v2.1.257+). — [Permission modes](https://code.claude.com/docs/en/permission-modes)
- Subagents with `isolation: worktree` get their own git worktree. — [Subagents](https://code.claude.com/docs/en/sub-agents)

**Copilot**
- Copilot CLI: `--allow-tool` / `--deny-tool` take patterns such as `shell(git:*)` and `write(PATH)`. Deny always wins, even over `--allow-all`. Managed `permissions.disableBypassPermissionsMode: "disable"` suppresses `--allow-all*` and `--yolo`. `COPILOT_ALLOW_ALL=true` also trusts the directory's hooks, plugins and MCP servers. `--assisted-approval` lets a safety review approve eligible requests in non-interactive runs. — [Copilot CLI reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
- The cloud agent firewall is on by default, with a recommended allowlist (OS package repos, container registries, language package registries, CAs). It is configured under org "Internet access" settings, separately for the cloud agent and for code review. Orgs can block repository custom rules. Blocked requests are reported in the PR. — [Customize the firewall](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-the-firewall)
- Firewall limits: it covers only processes the agent starts through its Bash tool, not MCP server processes or setup steps. It works only inside the agent's environment. GitHub warns that "sophisticated attacks may bypass the firewall". — [Customize the firewall](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-the-firewall)

**Threat model**
- The OWASP Top 10 for Agentic Applications 2026 (released 9 Dec 2025) has ten entries, ASI01-ASI10. Confirmed titles: ASI01 Agent Goal Hijack, ASI02 Tool Misuse, ASI07 Insecure Inter-Agent Communication, ASI08 Cascading Failures, ASI09 Human-Agent Trust Exploitation, ASI10 Rogue Agents. ASI03-06 cover identity, supply chain, code execution and memory (exact titles not verified). — [OWASP GenAI](https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026); [Giskard summary](https://www.giskard.ai/knowledge/owasp-top-10-for-agentic-application-2026)
- Simon Willison's "lethal trifecta": access to private data + exposure to untrusted content + ability to communicate externally. Cutting network access removes the exfiltration leg. He argues that sandboxing is the only credible defence and that AI-based injection detectors are not reliable. — [Simon Willison, Oct 2025](https://simonwillison.net/2025/Oct/22/living-dangerously-with-claude/) (older, 2025)

### Inferences
- [P1] Runner: an ephemeral container per stage, non-root, git worktree or fresh clone, no host mounts beyond the workspace. Claude in `dontAsk` with an explicit `--allowedTools` list, plus managed `sandbox.enabled`, `allowUnsandboxedCommands:false` and `failIfUnavailable:true`. Copilot CLI with explicit `--allow-tool`/`--deny-tool`, and `disableBypassPermissionsMode: disable` on developer machines.
- [P1] Egress allowlist: the model API, GitHub, the Jira host and internal package mirrors. Nothing else.
- [P1] Tokens: a GitHub App installation token scoped to one repo (contents and pull requests write, no admin, no workflow write), expiring in 1 hour. A Jira service account limited to the factory projects, able to comment and transition but not delete. Branch protection so the factory can never merge to main.
- [P1] Ticket and PR text are untrusted. Pass them in as data (quoted and delimited) and never let them choose tools. The stage that reads the ticket should not hold deploy or secret access.
- [P1] Audit trail: commit trailers with ticket and run ID, OTel `tool_decision` events, and transcripts kept for N years per the compliance retention policy (APRA CPS 234 and the bank's own policy apply; I did not research the specifics).
- [P2] A credential sentinel or mask for any secret the build needs. A PreToolUse hook that blocks writes to CI config, `.github/workflows` and infrastructure folders.

### Gaps
- I did not fetch the full Copilot cloud agent recommended allowlist or the Claude Code devcontainer reference.
- Australian regulatory specifics (APRA CPS 234/230, data residency for model providers) are not covered.

## Quality gates and evals

### Takeaway
Use deterministic gates first (build, tests, lint, SAST, CI must pass), then an independent reviewer agent on a different model, then a human approval before merge. Measure the factory with pass^k style reliability, human intervention rate, cycle time and rework. Run a fixed regression eval set before shipping any skill or model change.

### Cited Findings
- Anthropic's "Demystifying evals for AI agents" (9 Jan 2026) separates pass@k (succeeds at least once in k tries) from pass^k (succeeds on all k tries). pass@k = 1−(1−p)^k and pass^k = p^k, so with p = 0.75, pass^3 ≈ 42%. Reliability-critical agents should use pass^k. — [Anthropic engineering](https://anthropic.com/engineering/demystifying-evals-for-ai-agents); formulas from secondary write-ups: [Idlir Shkurti](https://idlirshkurti.github.io/tutorials/agent_evals.html)
- Copilot code review bills AI credits by effort level plus Actions minutes, and is eligible on PRs authored by bots and the cloud agent. — [Models and pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing)
- Claude Code metrics include `pull_request.count`, `commit.count` and `lines_of_code.count` for throughput tracking. — [Monitoring](https://code.claude.com/docs/en/monitoring-usage)

### Inferences
- [P1] Gate order: (1) CI green: build, unit/integration tests, lint, type check, SAST/secret scan. (2) Reviewer agent on another model, with fresh context and access to the ticket intent, so it does not just grade its own work. (3) A human approves every PR. The factory never auto-merges in phase 1.
- [P1] Factory KPIs per week: ticket success rate (PR merged without human code edits), human intervention rate (escalations or manual commits per ticket), cycle time (ticket ready → PR ready), rework (QA bounce-backs, reverts within 14 days), and cost per merged PR.
- [P2] Golden set of 20-50 past tickets with known-good outcomes and hidden holdout tests that the agent cannot see. Run each skill or model change 3x and report pass^3, not a single run.
- [P2] Reviewer findings sampled and human-graded monthly to measure the reviewer's precision.
- [P3] Scenario tests per service (contract tests, replayed production-like data) as a separate gate that the coding agent cannot edit.

### Gaps
- I found no published numbers for typical factory success or intervention rates. The Anthropic evals article's primary text was not fully fetched.

## Reliability

### Takeaway
Make every stage idempotent and resumable: key the stage on ticket ID + stage + attempt, persist the session ID, and resume rather than restart. Retry transient API errors with model fallback, bound attempts, and send exhausted work to a human queue with a short failure summary.

### Cited Findings
- Claude Code supports `--continue` / `--resume`. Subagents that hit `maxTurns` return partial output and can be resumed. Deferred tool calls (PreToolUse defer) re-join their original trace on resume. — [CLI reference](https://code.claude.com/docs/en/cli-reference); [Subagents](https://code.claude.com/docs/en/sub-agents); [Monitoring](https://code.claude.com/docs/en/monitoring-usage)
- Claude Code records each API retry attempt as a `gen_ai.request.attempt` span event, and `--fallback-model` handles overload or retirement. — [Monitoring](https://code.claude.com/docs/en/monitoring-usage); [CLI reference](https://code.claude.com/docs/en/cli-reference)
- Copilot CLI autopilot pauses at a credit cap and resumes with `/goal --max-ai-credits N`. Plan-then-autopilot and `--resume`/`--continue` exist. — [Copilot CLI reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)

### Inferences
- [P1] Stage state machine in the orchestrator (a Jira field or a small DB): `queued → running → succeeded | failed | escalated`, with the attempt count, session ID and branch stored.
- [P1] Idempotency: deterministic branch names (`factory/<ticket>`), PR create-or-update, and Jira comments tagged with run ID so a rerun edits rather than duplicates.
- [P1] Retries: at most 2 retries for infrastructure or API errors with backoff. Do not blindly retry logic failures. Escalate to a "needs-human" Jira status with a summary and transcript link (the dead-letter queue).
- [P2] Checkpoints: commit work in progress to the branch at the end of each stage, so a crash loses at most one stage.

### Gaps
- I did not verify Copilot cloud agent retry or resume behaviour, or Claude Code's exact built-in API retry count (an env var for max retries probably exists but was not confirmed).

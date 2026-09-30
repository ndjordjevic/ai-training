# Part 1, Tab 5: Configuration

← [Back to the Part 1 index](part1-reading-map.md). How to read this map (priorities, columns) is explained there.

This tab is about tuning the agent: where settings live, what it may do without asking, how it is sandboxed, which model it uses, and how the terminal looks. Pages 119–124 and 134 are the core. Most of the rest is lookup material.

### Group: Settings

---

#### 119. Settings files and precedence (Study)

- Claude Code: [Settings files and precedence](https://code.claude.com/docs/en/settings)
- Copilot CLI: [CLI config directory → Configuration file settings](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference#configuration-file-settings)

**Why:** Where each setting lives, who it affects, and which one wins when two files disagree.

| Section | Focus | Copilot section |
|---|---|---|
| Settings files and who they affect | ⭐ Read | [User settings](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference#user-settings-copilotsettingsjson) |
| Change a setting | Skim | [Opening the settings editor](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/change-settings#opening-the-settings-editor) |
| Settings precedence | ⭐ Read | [Configuration file settings](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference#configuration-file-settings) |
| Settings in cloud sessions | Skip | — |
| What's next | Skip | — |

**Pay attention to:**

- **Three files you edit:** `~/.claude/settings.json` (you, every project), `.claude/settings.json` (team, committed) and `.claude/settings.local.json` (you, this project, not committed).
- **Order, highest first:** managed → command-line flags → local → project → user.
- **Change settings** with `/config`, by editing the file, or with a flag for one session.
- **Settings are not instructions.** Rules for Claude go in CLAUDE.md.
- **Copilot has the same layers:** `~/.copilot/settings.json`, `.github/copilot/settings.json` and `.github/copilot/settings.local.json`. Change them with `/settings`.

**Copilot note:** In Copilot, company (MDM) settings are the lowest layer, and your own settings can override most keys. In Claude Code, company settings always win.

---

#### 120. All settings (Glance)

- Claude Code: [All settings](https://code.claude.com/docs/en/settings-reference)
- Copilot CLI: [CLI config directory → settings.json](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference#settingsjson)

**Why:** The full list of every settings key. A lookup page, not a read.

| Section | Focus | Copilot section |
|---|---|---|
| Settings index | ⭐ Read | [settings.json](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference#settingsjson) |
| Model and responses | Skim | — |
| Permission settings | Skim | — |
| Sandbox settings | Skip | — |
| Memory and context | Skip | — |
| Interface and terminal | Skip | — |
| Git and attribution | Skim | — |
| Hooks and automation | Skip | — |
| Plugins and skills | Skip | — |
| MCP | Skip | — |
| Agents, sessions, and worktrees | Skip | — |
| Remote, desktop, and notifications | Skip | — |
| Authentication and providers | Skip | — |
| Updates and versioning | Skip | — |
| Tools | Skip | — |
| Privacy and telemetry | Skip | — |
| Enterprise and managed settings | Skip | — |
| Global config settings | Skip | — |
| See also | Skip | — |

**Pay attention to:**

- **Scan the index once** so you know what can be changed.
- **Each key shows** where it can go, its type, its default and an example.
- **Some keys are managed-only.** Setting them in your own file does nothing.
- **Come back here** when you need one key.

---

#### 121. Example settings files (Glance)

- Claude Code: [Example settings files](https://code.claude.com/docs/en/settings-example)
- Copilot CLI: [Settings you might want to change](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/change-settings#settings-you-might-want-to-change)

**Why:** Three ready-to-copy files: one for you, one for a team repo, one for a company.

| Section | Focus | Copilot section |
|---|---|---|
| Your own settings | ⭐ Read | [Settings you might want to change](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/change-settings#settings-you-might-want-to-change) |

**Pay attention to:**

- **Personal file:** model, effort, terminal options, a few pre-approved safe commands.
- **Team file:** shared permission rules, hooks and plugins, committed to the repo.
- **Company file:** locked rules nobody can override.
- **Copy one and delete what you don't need.**

---

### Group: Permissions and sandboxing

---

#### 122. Configure permissions (Study)

- Claude Code: [Configure permissions](https://code.claude.com/docs/en/permissions)
- Copilot CLI: [Allowing and denying tool use](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/allowing-tools)

**Why:** Allow, ask and deny rules decide what the agent can do without stopping you.

| Section | Focus | Copilot section |
|---|---|---|
| Permission system | ⭐ Read | [Layers of tool controls](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/allowing-tools#layers-of-tool-controls) |
| Manage permissions | ⭐ Read | [Persisted permissions](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/allowing-tools#persisted-permissions) |
| Permission modes | Skim | — |
| Permission rule syntax | ⭐ Read | [Tool permission patterns](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#tool-permission-patterns) |
| Tool-specific permission rules | Skim | [Allowing or denying permission for specific tools](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/allowing-tools#allowing-or-denying-permission-for-specific-tools) |
| Extend permissions with hooks | Skip | — |
| Working directories | Skim | [Setting path permissions](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/configure-copilot-cli#setting-path-permissions) |
| How permissions interact with sandboxing | Skim | — |
| Managed settings | Skip | — |
| Settings precedence | Skim | — |
| Project allow rules and workspace trust | Skim | [Setting trusted directories](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/configure-copilot-cli#setting-trusted-directories) |
| Example configurations | Skip | — |
| See also | Skip | — |

**Pay attention to:**

- **Reads are free.** Edits and shell commands ask the first time.
- **Three kinds of rules:** allow (no prompt), ask (always prompt), deny (never). Deny wins, then ask, then allow.
- **Rule format:** `Tool(specifier)`, for example `Bash(npm test *)` or `Read(./.env)`.
- **Manage rules in `/permissions`.** Commit safe rules to `.claude/settings.json` for the team.
- **Access starts at the launch folder.** Add more with `--add-dir` or `/add-dir`.
- **Copilot rule format:** `shell(git:*)`, `write(src/*.ts)`, `url(github.com)`, used with `--allow-tool` and `--deny-tool`. Deny always wins there too.

---

#### 123. Choose a permission mode (Study)

- Claude Code: [Choose a permission mode](https://code.claude.com/docs/en/permission-modes)
- Copilot CLI: [About autopilot mode](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/autopilot)

**Why:** One switch for how often the agent asks you. Pick the right mode for the task.

| Section | Focus | Copilot section |
|---|---|---|
| Available modes | ⭐ Read | [Comparing autopilot mode, --allow-all, and --no-ask-user](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/autopilot#comparing-autopilot-mode---allow-all-and---no-ask-user) |
| Common setups | ⭐ Read | [Typical workflow for using autopilot mode](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/autopilot#typical-workflow-for-using-autopilot-mode) |
| Switch permission modes | Skim | [Global shortcuts](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#global-shortcuts-in-the-interactive-interface) (Shift+Tab) |
| Auto-approve file edits with acceptEdits mode | Skim | — |
| Analyze before you edit with plan mode | ⭐ Read | [Plan mode](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#plan-mode) |
| Allow only pre-approved tools with dontAsk mode | Skip | — |
| Skip all checks with bypassPermissions mode | Skim | [Permissions](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/autopilot#permissions) |
| Protected paths | Skip | — |
| Critical paths | Skip | — |
| See also | Skip | — |

**Pay attention to:**

- **Modes:** manual (asks for everything), accept edits, plan (reads only), auto (safety checker instead of you), don't ask (CI), bypass (containers only).
- **Press Shift+Tab** to cycle modes during a session.
- **Plan mode first** for anything bigger than a small fix.
- **Accept edits** when you are watching and reviewing the diff.
- **Bypass only inside a container or VM.** Some paths (like `.git`) still ask in most modes.
- **Copilot:** Shift+Tab cycles standard, plan and autopilot. `--allow-all` is its bypass.

---

#### 124. Configure the sandboxed Bash tool (Study)

- Claude Code: [Configure the sandboxed Bash tool](https://code.claude.com/docs/en/sandboxing)
- Copilot CLI: [Understanding local sandboxing](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/understanding-local-sandboxing)

**Why:** The sandbox lets the agent run commands without asking, while the OS limits which files and sites it can reach.

| Section | Focus | Copilot section |
|---|---|---|
| Get started | ⭐ Read | [Enabling local sandboxing](https://docs.github.com/en/copilot/concepts/security-governance-and-network-settings/about-cloud-and-local-sandboxes#enabling-local-sandboxing) |
| Configure sandboxing | Skim | [Customizing the policy](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/understanding-local-sandboxing#customizing-the-policy) |
| How sandboxing works | ⭐ Read | [Permission levels](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/understanding-local-sandboxing#permission-levels) |
| How sandboxing relates to permissions and permission modes | Skim | — |
| Configure the sandbox for your organization | Skip | [Enterprise-managed policies](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/understanding-local-sandboxing#enterprise-managed-policies) |
| Troubleshooting | Skim | — |
| Limitations | ⭐ Read | — |
| See also | Skip | — |

**Pay attention to:**

- **Turn it on with `/sandbox`.** Works on macOS and Linux (and WSL2), not native Windows.
- **Writes are limited to your project** (and temp). Network is limited to allowed domains.
- **Auto-allow mode:** sandboxed commands run with no prompt. This cuts most permission prompts.
- **It covers shell commands only,** not the file tools or MCP servers.
- **It is not a full wall.** For untrusted code, use a container or VM.
- **Copilot has `/sandbox` too.** It is deny-by-default and also covers MCP servers and file tools.

---

#### 125. Choose a sandbox environment (Glance)

- Claude Code: [Choose a sandbox environment](https://code.claude.com/docs/en/sandbox-environments)
- Copilot CLI: [About cloud and local sandboxes](https://docs.github.com/en/copilot/concepts/security-governance-and-network-settings/about-cloud-and-local-sandboxes)

**Why:** Compares isolation options, from the built-in sandbox to a full VM, and when to use each.

| Section | Focus | Copilot section |
|---|---|---|
| Compare sandboxing approaches | ⭐ Read | [Introduction](https://docs.github.com/en/copilot/concepts/security-governance-and-network-settings/about-cloud-and-local-sandboxes#introduction) |
| Choose an approach | ⭐ Read | — |
| Sandboxed Bash tool | Skim | [Local sandboxing](https://docs.github.com/en/copilot/concepts/security-governance-and-network-settings/about-cloud-and-local-sandboxes#local-sandboxing) |
| Sandbox runtime | Skip | — |
| Dev containers | Skim | — |
| Custom container | Skip | — |
| Virtual machine | Skip | — |
| Cloud sessions | Skim | [Cloud sandboxing](https://docs.github.com/en/copilot/concepts/security-governance-and-network-settings/about-cloud-and-local-sandboxes#cloud-sandboxing) |
| Enforce isolation across an organization | Skip | — |
| See also | Skip | — |

**Pay attention to:**

- **Options, weakest to strongest:** sandboxed Bash, sandbox runtime, dev container, custom container, VM.
- **Fewer prompts in daily work:** the built-in sandbox.
- **Unattended or bypass mode:** a dev container, container or VM.
- **Untrusted code:** a VM.
- **Copilot offers two:** local sandboxing and cloud sandboxes.

---

### Try it (in Copilot CLI): Settings, permissions and sandbox

1. Run `/settings` and look around. Then open `~/.copilot/settings.json` and see what it saved.
2. Start with `copilot --allow-tool 'shell(git:*)' --deny-tool 'shell(git push)'`. Ask it to commit, then to push. See the difference.
3. Press Shift+Tab to cycle standard, plan and autopilot. Plan a small change in plan mode before any edit.
4. Run `/sandbox enable`, then `/sandbox policy` to see what it can read and write.
5. Run `/permissions` and reset anything you allowed by mistake.

---

### Group: Environments

Cloud sessions run on Anthropic's machines, or on your company's own machines (self-hosted). This group sets those machines up. The Copilot match is the cloud agent's environment, which runs on GitHub Actions. We don't use either from the CLI, so the whole group is Skip.

---

#### 126. Configure cloud environments (Skip)

- Claude Code: [Configure cloud environments](https://code.claude.com/docs/en/cloud-environments)
- Copilot CLI: [Customizing the development environment for Copilot cloud agent](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/customize-the-agent-environment)

**Why:** Set network access, variables and setup scripts for cloud sessions.

| Section | Focus | Copilot section |
|---|---|---|
| The Default environment | Skim | — |
| Configure your environment | Skip | — |
| Network access | Skim | [Customizing the firewall](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-the-firewall#overview) |
| What's available in cloud sessions | Skim | — |
| Setup scripts | Skim | [Customizing with copilot-setup-steps](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/customize-the-agent-environment#customizing-copilots-development-environment-with-copilot-setup-steps) |
| Default allowed domains | Skip | — |
| Related resources | Skip | — |

**Pay attention to:**

- **Each cloud session gets a fresh Ubuntu VM** with your repo cloned and common tools installed.
- **Network levels:** Trusted (package registries and similar) or Custom (your own list).
- **Setup scripts** install what the session needs before Claude starts.
- **Copilot's version:** a `copilot-setup-steps.yml` workflow and a firewall allowlist.

---

#### 127. Self-hosted environments (Skip)

- Claude Code: [Self-hosted environments](https://code.claude.com/docs/en/self-hosted-environments)
- Copilot CLI: [Using self-hosted GitHub Actions runners](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/customize-the-agent-environment#using-self-hosted-github-actions-runners)

**Why:** Run cloud sessions on your company's own machines instead of Anthropic's.

| Section | Focus | Copilot section |
|---|---|---|
| How self-hosted environments work | Skim | — |
| Availability and limitations | Skip | — |
| Why self-host | Skim | — |
| Environments, runners, and sessions | Skip | — |
| What stays on your infrastructure | Skim | — |
| Get started | Skip | — |

**Pay attention to:**

- **Three parts:** an environment (a named group), runners (programs on your machines), sessions.
- **Code, secrets and build output stay on your machines.** The conversation still goes to Anthropic.
- **Most teams don't need this.** It means running and maintaining the runners yourself.

---

#### 128. Self-hosted environments quickstart (Skip)

- Claude Code: [Self-hosted environments quickstart](https://code.claude.com/docs/en/self-hosted-environments-quickstart)
- Copilot CLI: —

**Why:** Set up a first environment and runner, and send a session to it.

| Section | Focus | Copilot section |
|---|---|---|
| Prerequisites | Skip | — |
| Set up an environment and runner | Skip | — |
| Send a follow-up message to a running session | Skip | — |
| What's next | Skip | — |

**Pay attention to:**

- **An Owner must turn on self-hosted environments** in claude.ai admin settings.
- **A guided Claude Code session** walks you through the setup.
- **Send follow-ups from any machine** with `claude -p "..." --cloud`.

---

#### 129. Deploy self-hosted environments to production (Skip)

- Claude Code: [Deploy self-hosted environments to production](https://code.claude.com/docs/en/self-hosted-environments-deploy)
- Copilot CLI: —

**Why:** Run runners safely at scale: hardening, network, git, Kubernetes and Compose.

| Section | Focus | Copilot section |
|---|---|---|
| Harden your deployment | Skim | — |
| Network requirements | Skip | — |
| Configure git | Skip | — |
| Build the runner image | Skip | — |
| Size CPU and memory for sessions | Skip | — |
| Kubernetes | Skip | — |
| Docker Compose | Skip | — |
| Shutdown timing | Skip | — |
| Keep the base directory and capacity identical across runners | Skip | — |
| Reuse a pre-warmed checkout | Skip | — |
| Pin the version | Skip | — |
| Scale the fleet | Skip | — |
| Known issues and limitations | Skip | — |
| Troubleshooting | Skip | — |
| What's next | Skip | — |

**Pay attention to:**

- **A runner runs model-directed code** for anyone in your org. Harden it and block unneeded network traffic.
- **You build the runner image yourself,** with your tools inside.
- **Recipes for Kubernetes and Docker Compose** are included.

---

#### 130. Customize sessions in self-hosted environments (Skip)

- Claude Code: [Customize sessions in self-hosted environments](https://code.claude.com/docs/en/self-hosted-environments-configuration)
- Copilot CLI: —

**Why:** Wrapper scripts, lifecycle hooks and on-demand runners.

| Section | Focus | Copilot section |
|---|---|---|
| Wrapper scripts | Skip | — |
| Lifecycle hooks | Skip | — |
| On-demand runners | Skip | — |
| MCP servers | Skip | — |
| Prompt sessions to push their work | Skim | — |
| Permissions and tool approval | Skip | — |
| What's next | Skip | — |

**Pay attention to:**

- **Wrapper scripts** give each session its own short-lived credentials.
- **On-demand runners** start one machine per session instead of a fixed fleet.
- **Add a Stop hook that pushes the work,** or it stays only on the runner's disk.

---

#### 131. Test self-hosted environments end to end (Skip)

- Claude Code: [Test self-hosted environments end to end](https://code.claude.com/docs/en/self-hosted-environments-testing)
- Copilot CLI: —

**Why:** Check a new runner image from CI before using it for real.

| Section | Focus | Copilot section |
|---|---|---|
| Install the capture hook on your test runner | Skip | — |
| Run the test loop | Skip | — |
| Example script | Skip | — |
| Remote test runners | Skip | — |
| Authenticate from CI | Skip | — |
| Create a dedicated test environment | Skip | — |

**Pay attention to:**

- **The script starts a session,** reads Claude's replies through a Stop hook, and checks them.
- **CI needs a claude.ai login token.** API keys don't work here.
- **Use a fresh test environment** for each run.

---

#### 132. Self-hosted environments reference (Skip)

- Claude Code: [Self-hosted environments reference](https://code.claude.com/docs/en/self-hosted-environments-reference)
- Copilot CLI: —

**Why:** Every runner flag, environment variable and metric.

| Section | Focus | Copilot section |
|---|---|---|
| Runner CLI flags | Skip | — |
| Orchestrator CLI flags | Skip | — |
| Environment-variable-only settings | Skip | — |
| Telemetry | Skip | — |
| Health endpoint | Skip | — |
| Prometheus metrics | Skip | — |
| What's next | Skip | — |

**Pay attention to:**

- **A lookup page** for people who run the runners.
- **`/healthz` and `/metrics`** endpoints for monitoring.

---

#### 133. Verify session identity in self-hosted environments (Skip)

- Claude Code: [Verify session identity in self-hosted environments](https://code.claude.com/docs/en/self-hosted-environments-identity)
- Copilot CLI: —

**Why:** Let your internal services trust requests from a session, using its signed token.

| Section | Focus | Copilot section |
|---|---|---|
| The session token | Skip | — |
| Verify the token | Skip | — |
| Claims reference | Skip | — |
| Scope derived credentials | Skip | — |
| Related environment variables | Skip | — |
| What's next | Skip | — |

**Pay attention to:**

- **Each session gets a signed token (JWT)** saying who started it and where.
- **Services verify it** against Anthropic's public keys.
- **Any code in the session can read the token,** so give it narrow access only.

---

### Group: Model and responses

---

#### 134. Model configuration (Study)

- Claude Code: [Model configuration](https://code.claude.com/docs/en/model-config)
- Copilot CLI: [CLI reference → Slash commands](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#slash-commands-in-the-interactive-interface) (`/model`)

**Why:** Pick the model and effort for the job. This is the biggest lever on quality, speed and cost.

| Section | Focus | Copilot section |
|---|---|---|
| Available models | ⭐ Read | [Supported AI models in Copilot](https://docs.github.com/en/copilot/reference/ai-models/supported-models#supported-ai-models-in-copilot) |
| Restrict model selection | Skip | — |
| Organization default model | Skip | — |
| Organization effort limits | Skip | — |
| Special model behavior | ⭐ Read | [Auto model selection](https://docs.github.com/en/copilot/concepts/models/auto-model-selection#overview) |
| Context window and auto-compaction | Skim | — |
| Checking your current model | Skim | — |
| Add a custom model option | Skip | — |
| Environment variables | Skip | — |
| Version history | Skip | — |

**Pay attention to:**

- **Aliases:** `sonnet` (daily coding), `opus` (hard reasoning), `haiku` (simple, fast), `fable` (hardest, longest tasks).
- **`opusplan`:** Opus while planning, then Sonnet to write the code.
- **Effort** (`/effort`): low to max. Lower is faster and cheaper; higher thinks more.
- **`[1m]` models** give a 1 million token context window for long sessions.
- **Switch with `/model`.** `/status` shows what you are on.
- **Copilot:** `/model` picks the model and reasoning effort. `auto` lets Copilot choose (and costs less).

---

#### 135. Speed up responses with fast mode (Glance)

- Claude Code: [Speed up responses with fast mode](https://code.claude.com/docs/en/fast-mode)
- Copilot CLI: [Supported AI models in Copilot](https://docs.github.com/en/copilot/reference/ai-models/supported-models#supported-ai-models-in-copilot)

**Why:** A faster Opus for live work, at a higher price.

| Section | Focus | Copilot section |
|---|---|---|
| Toggle fast mode | Skim | — |
| Understand the cost tradeoff | ⭐ Read | — |
| Decide when to use fast mode | ⭐ Read | — |
| Requirements | Skip | — |
| Handle rate limits | Skip | — |
| Research preview | Skip | — |
| See also | Skip | — |

**Pay attention to:**

- **Same Opus quality, faster answers, higher price per token.**
- **Turn it on with `/fast`.**
- **Use it for live debugging and quick back-and-forth.** Don't use it for long or background tasks.
- **Turning it on mid-session reprices the whole context,** so decide early.
- **Copilot lists an Opus "fast mode" model (preview)** in its model picker.

---

#### 136. Escalate hard decisions with the advisor tool (Glance)

- Claude Code: [Escalate hard decisions with the advisor tool](https://code.claude.com/docs/en/advisor)
- Copilot CLI: [About the rubber duck agent](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/rubber-duck)

**Why:** A stronger second model gives advice at key moments, while a cheaper model does the work.

| Section | Focus | Copilot section |
|---|---|---|
| When to use the advisor | ⭐ Read | [Why rubber duck?](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/rubber-duck#why-rubber-duck) |
| Enable the advisor | Skim | — |
| Choose an advisor model | Skip | [Second opinion from another model](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/rubber-duck#second-opinion-from-another-model) |
| When Claude consults the advisor | Skim | [When Copilot consults the rubber duck agent](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/rubber-duck#when-copilot-consults-the-rubber-duck-agent) |
| What you see during a session | Skip | — |
| Cost | Skim | — |
| Impact on prompt caching | Skip | — |
| Requirements | Skip | — |
| Turn the advisor off | Skip | — |
| Compare with related features | Skim | — |
| See also | Skip | — |

**Pay attention to:**

- **Turn it on with `/advisor`.** Claude asks it before choosing an approach, when stuck, and before saying "done".
- **Best for long tasks** where the plan decides the result.
- **Each call costs extra tokens,** at the advisor model's price.
- **Experimental, and only on the Anthropic API.**
- **Copilot's rubber duck is the same idea,** but it uses a different model family (for example GPT to review Claude). Ask for it with `/rubber-duck`.

---

#### 137. Output styles (Glance)

- Claude Code: [Output styles](https://code.claude.com/docs/en/output-styles)
- Copilot CLI: —

**Why:** Change the agent's tone, length and role for a whole session.

| Section | Focus | Copilot section |
|---|---|---|
| Built-in output styles | ⭐ Read | — |
| Change your output style | Skim | — |
| Create a custom output style | Skim | — |
| Choose between an output style and other features | Skim | — |
| How output styles work | Skip | — |
| Related resources | Skip | — |

**Pay attention to:**

- **Built-in styles:** Default, Proactive, Concise, Explanatory, Learning.
- **Explanatory and Learning** are good for learning a new codebase or language.
- **Switch with `/output-style concise`.**
- **A custom style is a Markdown file.** It drops the built-in coding instructions unless you keep them.

**Copilot note:** No output styles in Copilot CLI. Put tone and format rules in custom instructions instead.

---

### Try it (in Copilot CLI): Model and responses

1. Run `/model`. Do one small task on `auto`, then the same task on a big model. Compare quality and `/usage`.
2. Change the reasoning effort in `/model` for a simple task, and see if the answer gets worse.
3. Ask Copilot to plan a change, then run `/rubber-duck review the plan`. Read the critique.

---

### Group: Interface

---

#### 138. Configure your terminal for Claude Code (Glance)

- Claude Code: [Configure your terminal for Claude Code](https://code.claude.com/docs/en/terminal-config)
- Copilot CLI: [CLI reference → Global shortcuts](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#global-shortcuts-in-the-interactive-interface)

**Why:** Small fixes that make daily use nicer: newlines, notifications, tmux, theme, Vim.

| Section | Focus | Copilot section |
|---|---|---|
| Enter multiline prompts | ⭐ Read | [Global shortcuts](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#global-shortcuts-in-the-interactive-interface) |
| Enable Option key shortcuts on macOS | Skim | — |
| Get a terminal bell or notification | ⭐ Read | — |
| Configure tmux | Skim | — |
| Fix Backspace deleting a whole word on Windows | Skip | — |
| Match the color theme | Skim | — |
| Switch to fullscreen rendering | Skip | — |
| Cap response width in wide terminals | Skip | — |
| Paste large content | Skim | — |
| Edit prompts with Vim keybindings | Skim | — |
| Related resources | Skip | — |

**Pay attention to:**

- **New line without sending:** Ctrl+J, or `\` then Enter. Shift+Enter works in most terminals.
- **Get notified when a long task ends:** set the terminal bell or a desktop notification.
- **tmux needs three config lines** for Shift+Enter and notifications.
- **Paste huge logs into a file** and point the agent at it.
- **Theme with `/theme`.** Vim mode is in `/config`.
- **Copilot:** Shift+Enter for a newline, `/theme`, and `/vim`.

---

#### 139. Fullscreen rendering (Glance)

- Claude Code: [Fullscreen rendering](https://code.claude.com/docs/en/fullscreen)
- Copilot CLI: —

**Why:** A flicker-free screen mode with mouse support and search.

| Section | Focus | Copilot section |
|---|---|---|
| Enable fullscreen rendering | ⭐ Read | — |
| What changes | Skim | — |
| Use the mouse | Skim | — |
| Scroll the conversation | Skim | — |
| Search and review the conversation | Skim | [Timeline shortcuts](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#timeline-shortcuts-in-the-interactive-interface) |
| Watch your changes in the diff panel | Skim | — |
| Clear the conversation | Skip | — |
| Use with tmux | Skip | — |
| Keep native text selection | Skip | — |
| Troubleshooting | Skip | — |
| Research preview | Skip | — |

**Pay attention to:**

- **Turn it on with `/tui fullscreen`** (back with `/tui default`).
- **The input box stays at the bottom.** No flicker, and memory stays flat in long sessions.
- **Click, scroll and search inside the app.** Ctrl+O shows the full transcript.
- **`/diff` opens a live panel** of changes next to the chat.

**Copilot note:** No matching page in the Copilot docs. In Copilot CLI, Ctrl+F searches the timeline and Ctrl+O expands recent items.

---

#### 140. Use Claude Code with a screen reader (Skip)

- Claude Code: [Use Claude Code with a screen reader](https://code.claude.com/docs/en/accessibility)
- Copilot CLI: [CLI reference → Command-line options](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#command-line-options) (`--screen-reader`)

**Why:** A plain-text mode for screen readers, plus options for low vision and color blindness.

| Section | Focus | Copilot section |
|---|---|---|
| Turn on screen reader mode | Skim | [Command-line options](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#command-line-options) |
| Turn off screen reader mode | Skip | — |
| Accessibility settings | Skim | — |
| What your screen reader hears | Skip | — |
| Answer menus and prompts | Skip | — |
| Hear when Claude Code needs you | Skip | — |
| Known limitations | Skip | — |
| Report an issue | Skip | — |

**Pay attention to:**

- **Turn it on with `claude --ax-screen-reader`,** or `"axScreenReader": true` in settings.
- **Output becomes plain text:** no boxes, no color-only cues, and menus become numbered lists.
- **There are also colorblind themes and a reduced-motion option.**
- **Copilot:** `--screen-reader`, and a `colorblind` theme.

---

#### 141. Voice dictation (Glance)

- Claude Code: [Voice dictation](https://code.claude.com/docs/en/voice-dictation)
- Copilot CLI: [Using voice input](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/voice-input)

**Why:** Speak your prompts instead of typing them. Good for long explanations.

| Section | Focus | Copilot section |
|---|---|---|
| Requirements | Skim | [Prerequisites](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/voice-input#prerequisites) |
| Enable voice dictation | ⭐ Read | [Enabling voice input](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/voice-input#enabling-voice-input) |
| Hold to record | Skim | [For short prompts](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/voice-input#for-short-prompts) |
| Tap to record and send | Skim | [For longer prompts](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/voice-input#for-longer-prompts) |
| Cancel a recording | Skip | — |
| Change the dictation language | Skip | — |
| Rebind the dictation key | Skip | — |
| Troubleshooting | Skip | — |
| See also | Skip | — |

**Pay attention to:**

- **Turn it on with `/voice`.** Hold Space to talk, or use `/voice tap` to tap on and off.
- **Audio is sent to Anthropic** to be turned into text. It needs a claude.ai login.
- **You can mix voice and typing** in one prompt.
- **Copilot has `/voice`** too.

---

#### 142. Customize your status line (Glance)

- Claude Code: [Customize your status line](https://code.claude.com/docs/en/statusline)
- Copilot CLI: [CLI reference → Slash commands](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#slash-commands-in-the-interactive-interface) (`/statusline`)

**Why:** A bar at the bottom that always shows model, context use, cost or git branch.

| Section | Focus | Copilot section |
|---|---|---|
| Set up a status line | ⭐ Read | [statusLine setting](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference#user-settings-copilotsettingsjson) |
| Build a status line step by step | Skip | — |
| How status lines work | Skim | — |
| Available data | Skim | — |
| Examples | Skim | — |
| Subagent status lines | Skip | — |
| Tips | Skip | — |
| Troubleshooting | Skip | — |

**Pay attention to:**

- **Easiest way:** `/statusline show model and context percentage`. Claude writes the script for you.
- **It is any script** that reads session data (JSON) and prints one line.
- **Show context use.** It tells you when to `/clear` or `/compact`.
- **Keep the script fast.** Cache slow commands like `git status`.
- **Copilot's `/statusline`** turns built-in items on or off. A custom script also works, through the `statusLine` setting.

---

#### 143. Customize keyboard shortcuts (Glance)

- Claude Code: [Customize keyboard shortcuts](https://code.claude.com/docs/en/keybindings)
- Copilot CLI: —

**Why:** Remap any shortcut in a `keybindings.json` file.

| Section | Focus | Copilot section |
|---|---|---|
| Configuration file | ⭐ Read | — |
| Contexts | Skim | — |
| Available actions | Skim | — |
| Keystroke syntax | Skip | — |
| Unbind default shortcuts | Skip | — |
| Reserved shortcuts | Skip | — |
| Terminal conflicts | Skim | — |
| Text fields | Skip | — |
| Vim mode interaction | Skip | — |
| Validation | Skip | — |

**Pay attention to:**

- **Open the file with `/keybindings`** (`~/.claude/keybindings.json`). Changes apply without a restart.
- **Bindings are grouped by context** (chat, menus, transcript) and map keys to actions.
- **Ctrl+C and Ctrl+D can't be changed.**
- **Watch for tmux (Ctrl+B) and screen (Ctrl+A) conflicts.**

**Copilot note:** The Copilot docs have no keybindings file. Its shortcuts are listed in the CLI reference.

---

### Try it (in Copilot CLI): Interface

1. Type a two-line prompt with Shift+Enter.
2. Run `/theme` and pick one that fits your terminal.
3. Run `/statusline` and turn on the items you want to see all the time.
4. Try `/voice` and dictate a prompt.

---

**End of Tab 5: Configuration.**

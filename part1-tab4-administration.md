# Part 1, Tab 4: Administration

← [Back to the Part 1 index](part1-reading-map.md). How to read this map (priorities, columns) is explained there.

This tab is written for admins who roll Claude Code out to a company. Most of it is not for us. Our company runs Copilot, and our admins set its policies. Read it to learn **what an admin can control**, and why some things may be blocked for you.

Three pages matter for everyone: **Manage costs** (112), **Security** (114) and the **Champion kit** (118).

### Group: Setup and access

---

#### 84. Set up Claude Code for your organization (Glance)

- Claude Code: [Set up Claude Code for your organization](https://code.claude.com/docs/en/admin-setup)
- Copilot CLI: [Administering Copilot CLI for your enterprise](https://docs.github.com/en/copilot/how-tos/copilot-cli/administer-copilot-cli-for-your-enterprise)

**Why:** A one-page map of everything a company can control: provider, policy, monitoring and data.

| Section | Focus | Copilot section |
|---|---|---|
| Choose your API provider | Skim | [Model selection](https://docs.github.com/en/copilot/how-tos/copilot-cli/administer-copilot-cli-for-your-enterprise#model-selection) |
| Decide how settings reach devices | Skim | [Choosing a deployment method](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/use-managed-settings/deploy-managed-settings#choosing-a-deployment-method) |
| Decide what to enforce | ⭐ Read | [Copilot CLI enablement](https://docs.github.com/en/copilot/how-tos/copilot-cli/administer-copilot-cli-for-your-enterprise#copilot-cli-enablement) |
| Set up usage visibility | Skim | [Audit logging](https://docs.github.com/en/copilot/how-tos/copilot-cli/administer-copilot-cli-for-your-enterprise#audit-logging) |
| Review data handling | Skim | [Content exclusion](https://docs.github.com/en/copilot/how-tos/copilot-cli/administer-copilot-cli-for-your-enterprise#content-exclusion) |
| Verify and onboard | Skim | [Why can't my developers access Copilot CLI?](https://docs.github.com/en/copilot/how-tos/copilot-cli/administer-copilot-cli-for-your-enterprise#why-cant-my-developers-access-copilot-cli) |
| Next steps | Skip | [Further reading](https://docs.github.com/en/copilot/how-tos/copilot-cli/administer-copilot-cli-for-your-enterprise#further-reading) |

**Pay attention to:**

- **Managed settings beat every other setting.** Developers can't override them.
- **An admin can lock:** permission rules, the sandbox, MCP servers, plugin sources and hooks.
- **Run `/status` to see which company policy is active** on your machine.
- **Copilot works the same way:** admins turn Copilot CLI on or off and pick the models you can use.

**Copilot note:** only some org controls reach Copilot CLI: turning it on or off, the model list, content exclusion, MCP policies and org-wide custom agents. IDE-only policies don't apply. If you can't start the CLI, check that the org that gives you your Copilot license has it turned on. `/delegate` also needs the cloud agent policy.

---

#### 85. Advanced setup (Glance)

- Claude Code: [Advanced setup](https://code.claude.com/docs/en/setup)
- Copilot CLI: [Installing GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/install-copilot-cli)

**Why:** System needs, install options, updates and uninstall.

| Section | Focus | Copilot section |
|---|---|---|
| System requirements | Skim | [Prerequisites](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/install-copilot-cli#prerequisites) |
| Install Claude Code | Skim | [Installing or updating Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/install-copilot-cli#installing-or-updating-copilot-cli) |
| Verify your installation | ⭐ Read | — |
| Authenticate | Skim | [Authenticating with Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/install-copilot-cli#authenticating-with-copilot-cli) |
| Update Claude Code | ⭐ Read | [Slash commands](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#slash-commands-in-the-interactive-interface) (`/update`) |
| Advanced installation options | Skip | — |
| Uninstall Claude Code | Skip | — |

**Pay attention to:**

- **Install with one command** (native installer). It updates itself in the background.
- **Check the install:** `claude --version`, then `claude doctor` for a full health check.
- **Release channel:** `latest` gets new versions first; `stable` waits about a week.
- **Homebrew and WinGet installs don't auto-update.** Update them yourself.
- **Copilot:** install with Homebrew, npm or WinGet. Update with `/update`.

**Copilot note:** every Copilot installer has a prerelease version (for example `npm install -g @github/copilot@prerelease`), which is like Claude's `latest` channel. The npm install needs Node.js 22 or later. On macOS and Linux there's also a script: `curl -fsSL https://gh.io/copilot-install | bash`.

---

#### 86. Authentication (Glance)

- Claude Code: [Authentication](https://code.claude.com/docs/en/authentication)
- Copilot CLI: [Authenticating GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/authenticate-copilot-cli)

**Why:** How you log in, and where your login is stored.

| Section | Focus | Copilot section |
|---|---|---|
| Log in to Claude Code | ⭐ Read | [Authenticating with OAuth](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/authenticate-copilot-cli#authenticating-with-oauth) |
| Set up team authentication | Skip | [Authenticating with environment variables](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/authenticate-copilot-cli#authenticating-with-environment-variables) |
| Credential management | Skim | [How Copilot CLI stores credentials](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/authenticate-copilot-cli#how-copilot-cli-stores-credentials) |

**Pay attention to:**

- **First run opens the browser** to log in. `/login` and `/logout` switch accounts.
- **If `ANTHROPIC_API_KEY` is set, it wins over your login** and you pay API prices. A common surprise.
- **Credentials live in the macOS Keychain,** or in a file only you can read on Linux.
- **Copilot:** you log in with your GitHub account. `/user switch` changes accounts.

**Copilot note:** Copilot has the same trap. `COPILOT_GITHUB_TOKEN`, `GH_TOKEN` or `GITHUB_TOKEN` in your shell silently wins over your login, so a token set for another tool can log you in as the wrong account. Classic tokens (`ghp_`) don't work at all; use a fine-grained token with the Copilot Requests permission.

---

#### 87. Deploy managed settings (Glance)

- Claude Code: [Deploy managed settings](https://code.claude.com/docs/en/managed-settings)
- Copilot CLI: [Deploying managed settings](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/use-managed-settings/deploy-managed-settings)

**Why:** How a company pushes one policy file to every developer's machine.

| Section | Focus | Copilot section |
|---|---|---|
| Deploy a managed settings file | Skim | [Deploying file-based settings](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/use-managed-settings/deploy-managed-settings#deploying-file-based-settings) |
| Choose a delivery mechanism | Skim | [Choosing a deployment method](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/use-managed-settings/deploy-managed-settings#choosing-a-deployment-method) |
| How Claude Code combines managed sources | Skip | [Precedence of deployment methods](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/use-managed-settings/deploy-managed-settings#precedence-of-deployment-methods) |
| Check that a policy is in force | ⭐ Read | [Check settings on clients](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/use-managed-settings/get-started#check-settings-on-clients) |
| Keys only a managed source can set | Skip | [Supported keys](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference#supported-keys) |
| Turn telemetry off for your organization | Skip | — |
| See also | Skip | — |

**Pay attention to:**

- **Four ways to deliver:** the admin console (server), MDM (plist or registry), or a file on disk.
- **Managed settings sit above everything,** including command-line flags.
- **Debug a policy:** `/status` shows which source won; `claude doctor` shows what was dropped.
- **Copilot now has managed settings too,** with the same three delivery paths, and Copilot CLI reads them.

**Copilot note:** server-managed settings live in `copilot/managed-settings.json` in the enterprise's `.github-private` repo, and reach users within about an hour (a restart applies them at once). If the CLI can't reach the server and has no cached copy, those settings are off for that session. Rules that must always hold go through MDM or a file.

---

#### 88. Configure server-managed settings (Skip)

- Claude Code: [Configure server-managed settings](https://code.claude.com/docs/en/server-managed-settings)
- Copilot CLI: [Deploying server-managed settings](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/use-managed-settings/deploy-managed-settings#deploying-server-managed-settings)

**Why:** Push policy from the claude.ai admin console, with no device management needed.

| Section | Focus | Copilot section |
|---|---|---|
| Requirements | Skip | — |
| Choose between server-managed and endpoint-managed settings | Skim | [Choosing a deployment method](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/use-managed-settings/deploy-managed-settings#choosing-a-deployment-method) |
| Configure server-managed settings | Skip | [2. Create the managed-settings.json file](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/use-managed-settings/get-started#2-create-the-managed-settingsjson-file) |
| Settings delivery | Skip | — |
| Platform availability | Skip | — |
| Audit logging | Skip | — |
| Security considerations | Skim | — |
| See also | Skip | — |

**Pay attention to:**

- **Settings come from Anthropic's servers** at startup and refresh every hour.
- **Good for companies without device management.**
- **It is not a security wall.** On an unmanaged laptop a user can get around it.
- **Copilot:** server-managed settings live in a private GitHub repo that admins control.

---

#### 89. Control MCP server access for your organization (Glance)

- Claude Code: [Control MCP server access for your organization](https://code.claude.com/docs/en/managed-mcp)
- Copilot CLI: [Administering Copilot CLI → MCP server policies](https://docs.github.com/en/copilot/how-tos/copilot-cli/administer-copilot-cli-for-your-enterprise#mcp-server-policies)

**Why:** How a company limits which MCP servers you can use. Explains the "blocked by your organization" messages.

| Section | Focus | Copilot section |
|---|---|---|
| Choose a pattern | ⭐ Read | [MCP allowlists](https://docs.github.com/en/copilot/concepts/enterprise/mcp-management#mcp-allowlists) |
| Exclusive control with managed-mcp.json | Skip | [Managed MCP server allow/deny list](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference#managed-mcp-server-allowdeny-list) |
| Provide servers through managed settings | Skip | — |
| Policy-based control with allowlists and denylists | Skim | [Configuring the MCP allowlist policy for an enterprise](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-mcp-usage/restrict-based-on-registry#configuring-the-mcp-allowlist-policy-for-an-enterprise) |
| How restrictions appear to users | ⭐ Read | [Enterprise MCP allowlist](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#enterprise-mcp-allowlist) |
| Monitor MCP usage | Skip | — |
| Configuration summary | Skip | — |
| Related resources | Skip | — |

**Pay attention to:**

- **By default anyone can add any MCP server.** Companies often limit this.
- **Levels:** no MCP, a fixed company set, or your own servers filtered by an allowlist or denylist.
- **The denylist always wins,** wherever the server came from.
- **Copilot:** the enterprise MCP allowlist is fail-closed. If the policy can't be checked, extra servers are blocked.

**Copilot note:** in Copilot, the admin sets an MCP registry and an allowlist. The approved servers show up as a source you can browse when you add a server, and only allowed servers can run.

---

#### 90. Configure auto mode (Skip)

- Claude Code: [Configure auto mode](https://code.claude.com/docs/en/auto-mode-config)
- Copilot CLI: [CLI reference → Command safety analysis](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#command-safety-analysis)

**Why:** Tell auto mode's safety checker which repos, buckets and domains your company trusts.

| Section | Focus | Copilot section |
|---|---|---|
| Common boundaries | Skim | — |
| Where the classifier reads configuration | Skim | — |
| Define trusted infrastructure | Skip | — |
| Override the block and allow rules | Skip | — |
| Route all shell commands through the classifier | Skip | — |
| Inspect the defaults and your effective config | Skip | — |
| Review denials | Skim | — |
| See also | Skip | — |

**Pay attention to:**

- **Auto mode runs each action past a classifier** that blocks risky or outside-your-environment actions.
- **It reads your CLAUDE.md,** so "never force push" there steers the checker too.
- **`autoMode.environment` lists trusted places.** Anything not listed counts as external.
- **See and retry blocked actions** in `/permissions` → Recently denied.

**Copilot note:** Copilot CLI has no classifier-based auto mode. The closest things are command safety analysis (extra warnings for risky commands) and the sandbox.

---

### Group: Deployment

---

#### 91. Enterprise deployment overview (Glance)

- Claude Code: [Enterprise deployment overview](https://code.claude.com/docs/en/third-party-integrations)
- Copilot CLI: [Using your own LLM models in Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/use-byok-models)

**Why:** Compares the ways a company can buy and run Claude Code, plus rollout tips.

| Section | Focus | Copilot section |
|---|---|---|
| Compare deployment options | Skim | [Supported providers](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/use-byok-models#supported-providers) |
| Configure proxies and gateways | Skip | — |
| Best practices for organizations | ⭐ Read | — |
| Next steps | Skip | — |

**Pay attention to:**

- **Options:** a Claude Teams or Enterprise plan, the API Console, or a cloud (AWS, Google, Microsoft).
- **Invest in CLAUDE.md files** so the agent understands your code.
- **Make install one click.** Easy setup drives adoption.
- **Start new users on Q&A and small fixes,** then bigger tasks.
- **Copilot:** you can plug your own model keys into Copilot CLI (OpenAI, Azure OpenAI, Anthropic).

**Copilot note:** to use your own model, set `COPILOT_PROVIDER_BASE_URL`, `COPILOT_PROVIDER_TYPE` (`openai`, `azure` or `anthropic`) and `COPILOT_PROVIDER_API_KEY` before you start `copilot`. It works with local models like Ollama too. The model must support tool calling. Company policies don't control these local keys, so check our rules before you send work code to another provider.

---

#### 92. Feature availability (Skip)

- Claude Code: [Feature availability](https://code.claude.com/docs/en/feature-availability)
- Copilot CLI: [Supported AI models → Per Copilot plan](https://docs.github.com/en/copilot/reference/ai-models/supported-models#supported-ai-models-per-copilot-plan)

**Why:** Which features work on which plan or cloud provider.

| Section | Focus | Copilot section |
|---|---|---|
| Availability by model provider | Skim | [Supported AI models per client](https://docs.github.com/en/copilot/reference/ai-models/supported-models#supported-ai-models-per-client) |
| Availability by subscription plan | Skim | [Supported AI models per Copilot plan](https://docs.github.com/en/copilot/reference/ai-models/supported-models#supported-ai-models-per-copilot-plan) |
| Model availability | Skip | — |
| Related resources | Skip | — |

**Pay attention to:**

- **The CLI and all local features work everywhere.**
- **Cloud features need a Claude subscription:** web sessions, routines, Remote Control, and more.
- **On Team and Enterprise plans,** some features must be turned on by an admin.

---

#### 93. Claude Code on Amazon Bedrock (Skip)

- Claude Code: [Claude Code on Amazon Bedrock](https://code.claude.com/docs/en/amazon-bedrock)
- Copilot CLI: —

**Why:** Run Claude Code with Claude models from your company's AWS account.

| Section | Focus | Copilot section |
|---|---|---|
| Prerequisites | Skip | — |
| Sign in with Bedrock | Skim | — |
| Set up manually | Skip | — |
| Startup model checks | Skip | — |
| Cross-region inference profile prefixes | Skip | — |
| IAM configuration | Skip | — |
| 1M token context window | Skip | — |
| Service tiers | Skip | — |
| AWS Guardrails | Skip | — |
| Use the Mantle endpoint | Skip | — |
| Troubleshooting | Skip | — |
| Additional resources | Skip | — |

**Pay attention to:**

- **`/login` has a Bedrock wizard.** Or set `CLAUDE_CODE_USE_BEDROCK=1` and AWS credentials.
- **Billing goes to your AWS account,** at AWS prices.
- **Some features are missing on Bedrock** (see page 92).

---

#### 94. Claude Code on Claude Platform on AWS (Skip)

- Claude Code: [Claude Code on Claude Platform on AWS](https://code.claude.com/docs/en/claude-platform-on-aws)
- Copilot CLI: —

**Why:** Use Anthropic's own API, but log in and pay through AWS.

| Section | Focus | Copilot section |
|---|---|---|
| Prerequisites | Skip | — |
| Setup | Skip | — |
| Use the Agent SDK | Skip | — |
| Route through a corporate proxy | Skip | — |
| Troubleshooting | Skip | — |
| Additional resources | Skip | — |

**Pay attention to:**

- **Anthropic runs the models; AWS handles login and billing.**
- **Set `CLAUDE_CODE_USE_ANTHROPIC_AWS`** to use it.
- **More features work here than on Bedrock,** because it is Anthropic's API.

---

#### 95. Claude Code on Google Cloud's Agent Platform (Skip)

- Claude Code: [Claude Code on Google Cloud's Agent Platform](https://code.claude.com/docs/en/google-vertex-ai)
- Copilot CLI: —

**Why:** Run Claude Code with Claude models from your Google Cloud project (formerly Vertex AI).

| Section | Focus | Copilot section |
|---|---|---|
| Prerequisites | Skip | — |
| Sign in with Agent Platform | Skim | — |
| Region configuration | Skip | — |
| Set up manually | Skip | — |
| Startup model checks | Skip | — |
| IAM configuration | Skip | — |
| 1M token context window | Skip | — |
| Troubleshooting | Skip | — |
| Additional resources | Skip | — |

**Pay attention to:**

- **`/login` has a wizard,** or set `CLAUDE_CODE_USE_VERTEX=1` with a project and region.
- **Not every model is in every region.** Check before you pick one.
- **Billing goes to your Google Cloud account.**

---

#### 96. Claude Code on Microsoft Foundry (Skip)

- Claude Code: [Claude Code on Microsoft Foundry](https://code.claude.com/docs/en/microsoft-foundry)
- Copilot CLI: [Connecting to Azure OpenAI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/use-byok-models#connecting-to-azure-openai)

**Why:** Run Claude Code with Claude models through your company's Azure account.

| Section | Focus | Copilot section |
|---|---|---|
| Prerequisites | Skip | — |
| Setup | Skip | [Configuring your provider](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/use-byok-models#configuring-your-provider) |
| Azure RBAC configuration | Skip | — |
| Troubleshooting | Skip | — |
| Additional resources | Skip | — |

**Pay attention to:**

- **Set `CLAUDE_CODE_USE_FOUNDRY=1`** and your Foundry resource.
- **Log in with an API key or Microsoft Entra ID.**
- **Worth knowing for a Microsoft shop:** Claude can run inside the company's Azure account.

---

#### 97. Enterprise network configuration (Glance)

- Claude Code: [Enterprise network configuration](https://code.claude.com/docs/en/network-config)
- Copilot CLI: [Network settings for Copilot](https://docs.github.com/en/copilot/concepts/security-governance-and-network-settings/network-settings)

**Why:** How to make the agent work behind a corporate proxy or firewall.

| Section | Focus | Copilot section |
|---|---|---|
| Proxy configuration | ⭐ Read | [Proxy settings for Copilot](https://docs.github.com/en/copilot/concepts/security-governance-and-network-settings/network-settings#proxy-settings-for-copilot) |
| CA certificate store | Skim | [Custom certificates](https://docs.github.com/en/copilot/concepts/security-governance-and-network-settings/network-settings#custom-certificates) |
| Custom CA certificates | ⭐ Read | [Custom certificates](https://docs.github.com/en/copilot/concepts/security-governance-and-network-settings/network-settings#custom-certificates) |
| mTLS authentication | Skip | — |
| Verify your configuration | Skim | [Diagnosing network issues](https://docs.github.com/en/copilot/how-tos/troubleshoot-copilot/troubleshoot-network-errors#diagnosing-network-issues) |
| Apply network settings to background agents | Skip | — |
| Streaming idle watchdogs | Skip | — |
| Network access requirements | Skim | [Copilot allowlist reference](https://docs.github.com/en/copilot/reference/copilot-allowlist-reference#copilot-on-githubcom) |
| Additional resources | Skip | — |

**Pay attention to:**

- **Proxy:** set `HTTPS_PROXY`. Use `NO_PROXY` for internal hosts.
- **Company certificate:** set `NODE_EXTRA_CA_CERTS=/path/to/ca.pem`. The OS trust store is also read.
- **Background agents don't see your shell variables.** Put network settings in `settings.json`.
- **The firewall must allow** `api.anthropic.com` and a few other domains (listed on the page).
- **Copilot uses the same variables:** `HTTPS_PROXY` and `NODE_EXTRA_CA_CERTS`.

**Copilot note:** Copilot reads the OS trust store plus `NODE_EXTRA_CA_CERTS`, so it works behind Zscaler-style proxies. It supports Kerberos proxy login, but not proxy URLs that start with `https://`. The firewall list is in the [Copilot allowlist reference](https://docs.github.com/en/copilot/reference/copilot-allowlist-reference).

---

#### 98. Run Claude Code behind a corporate launcher (Skip)

- Claude Code: [Run Claude Code behind a corporate launcher](https://code.claude.com/docs/en/corporate-launcher)
- Copilot CLI: —

**Why:** For companies where every program must start through a required wrapper script.

| Section | Focus | Copilot section |
|---|---|---|
| What the launcher covers | Skip | — |
| Set up the launcher | Skip | — |
| The launcher contract | Skip | — |
| Relationship to `CLAUDE_CODE_SHELL_PREFIX` | Skip | — |
| Related resources | Skip | — |

**Pay attention to:**

- **`CLAUDE_CODE_PROCESS_WRAPPER`** starts every Claude Code process through your launcher script.
- **The script must end with `exec "$@"`.** If it can't run, Claude Code refuses to start.
- **Different from `CLAUDE_CODE_SHELL_PREFIX`,** which wraps the shell commands Claude runs.

---

#### 99. Development containers (Glance)

- Claude Code: [Development containers](https://code.claude.com/docs/en/devcontainer)
- Copilot CLI: [About Copilot CLI → Risk mitigation](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli#risk-mitigation)

**Why:** Run the agent inside a container, so it can work without prompts and can't touch the rest of your machine.

| Section | Focus | Copilot section |
|---|---|---|
| Add Claude Code to your dev container | Skim | — |
| Persist authentication and settings across rebuilds | Skim | — |
| Enforce organization policy | Skip | — |
| Restrict network egress | ⭐ Read | — |
| Run without permission prompts | ⭐ Read | [Risk mitigation](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli#risk-mitigation) |
| Try the reference container | Skim | — |
| Next steps | Skip | — |

**Pay attention to:**

- **Commands run inside the container.** File edits still show up in your repo.
- **Add Claude Code with the Dev Container Feature.** Mount a volume for `~/.claude` to keep your login.
- **A container is the safe place for `--dangerously-skip-permissions`,** as a non-root user.
- **Also limit network traffic** (the reference container has a firewall script).
- **Copilot:** its docs say the same: use a container or VM with `--allow-all`.

**Copilot note:** Copilot has two lighter options than a container, both in public preview: `/sandbox enable` limits file, network and system access on your machine, and a cloud sandbox runs the whole session on GitHub's machines.

---

### Try it (in Copilot CLI): Setup, access and deployment

1. Run `/version`, then `/update` if you are behind.
2. Run `/model` and look at the list. Those are the models our admins enabled.
3. Run `/env` to see what is loaded (instructions, MCP servers, skills, plugins).
4. If you are behind the company proxy, check that `HTTPS_PROXY` and `NODE_EXTRA_CA_CERTS` are set in your shell.
5. Try `/mcp add` with any server. If our company has an MCP allowlist, you will see the "blocked" message here.

---

### Group: Gateways

A gateway is a proxy between the agent and the model provider. The company holds the real keys, and each developer gets a gateway key. Useful for usage tracking and budgets. It is admin work, so the whole group is Skip.

---

#### 100. Run Claude Code through a gateway (Skip)

- Claude Code: [Run Claude Code through a gateway](https://code.claude.com/docs/en/gateways)
- Copilot CLI: [Connecting to an OpenAI-compatible endpoint](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/use-byok-models#connecting-to-an-openai-compatible-endpoint)

**Why:** What a gateway is, and how to choose between Anthropic's gateway and one you already run.

| Section | Focus | Copilot section |
|---|---|---|
| How a gateway works | Skim | — |
| Choose a gateway | Skip | — |
| Subscriptions and gateways | Skim | — |
| Configure separately from the gateway | Skip | — |
| Next steps | Skip | — |

**Pay attention to:**

- **The gateway holds the provider key.** Developers get their own gateway key.
- **One place for budgets, usage tracking and audit logs.**
- **Gateway traffic is billed at API prices,** not from your claude.ai subscription.
- **Two choices:** Anthropic's Claude apps gateway, or another gateway product.

---

#### 101. Claude apps gateway (Skip)

- Claude Code: [Claude apps gateway for Amazon Bedrock, Claude Platform on AWS, Google Cloud, and Microsoft Foundry](https://code.claude.com/docs/en/claude-apps-gateway)
- Copilot CLI: —

**Why:** Anthropic's own gateway, built into the `claude` binary, with company SSO login.

| Section | Focus | Copilot section |
|---|---|---|
| Why Claude apps gateway | Skim | — |
| Quickstart | Skip | — |
| Connect developers | Skip | — |
| Availability and limitations | Skip | — |
| Next steps | Skip | — |

**Pay attention to:**

- **Developers log in with their work account.** No claude.ai account or API key is needed.
- **Admins control models per group** and send usage data out with OpenTelemetry.
- **It needs a Postgres database** and runs in Docker, Kubernetes or Cloud Run.

---

#### 102. Claude apps gateway configuration (Skip)

- Claude Code: [Claude apps gateway configuration](https://code.claude.com/docs/en/claude-apps-gateway-config)
- Copilot CLI: —

**Why:** A reference for every option in the gateway's `gateway.yaml` file.

| Section | Focus | Copilot section |
|---|---|---|
| File structure | Skip | — |
| Secret expansion | Skip | — |
| Required sections | Skip | — |
| Optional sections | Skip | — |
| Complete example | Skim | — |
| Client-side managed settings | Skip | — |
| Related | Skip | — |

**Pay attention to:**

- **One `gateway.yaml` file:** login (OIDC), database, upstream providers, model routing, policies.
- **Keep secrets out of the file.** It reads them from environment variables.
- **Look up a key when you need it.** Don't read this page end to end.

---

#### 103. Claude apps gateway spend limits (Skip)

- Claude Code: [Claude apps gateway spend limits](https://code.claude.com/docs/en/claude-apps-gateway-spend-limits)
- Copilot CLI: [Budgets for usage-based billing](https://docs.github.com/en/copilot/concepts/billing-and-usage/organizations-and-enterprises/budgets)

**Why:** Cap how much each developer can spend.

| Section | Focus | Copilot section |
|---|---|---|
| Set a cap | Skim | [User-level budget](https://docs.github.com/en/copilot/concepts/billing-and-usage/organizations-and-enterprises/budgets#user-level-budget) |
| How enforcement works | Skim | [What happens when a user is blocked](https://docs.github.com/en/copilot/concepts/billing-and-usage/organizations-and-enterprises/budgets#what-happens-when-a-user-is-blocked) |
| Admin API reference | Skip | — |
| Data lifecycle | Skip | — |
| Related | Skip | — |

**Pay attention to:**

- **Limits are per developer,** per day, week or month.
- **The gateway checks every request live,** and blocks once the limit is hit.
- **Copilot has the same idea:** user-level budgets set by admins.

---

#### 104. Claude apps gateway deployment and operations (Skip)

- Claude Code: [Claude apps gateway deployment and operations](https://code.claude.com/docs/en/claude-apps-gateway-deploy)
- Copilot CLI: —

**Why:** Run the gateway in production and keep it healthy.

| Section | Focus | Copilot section |
|---|---|---|
| Identity provider setup | Skip | — |
| Deployment | Skip | — |
| Operations | Skip | — |
| Security | Skip | — |
| Troubleshooting | Skip | — |
| Related | Skip | — |

**Pay attention to:**

- **Register the gateway with your company login system** (Okta, Entra ID, and so on).
- **Deploy on Kubernetes or Cloud Run.**
- **Day-to-day work:** health checks, rotating secrets, upgrades.

---

#### 105. Deploy Claude apps gateway on AWS (Skip)

- Claude Code: [Deploy Claude apps gateway on AWS](https://code.claude.com/docs/en/claude-apps-gateway-on-aws)
- Copilot CLI: —

**Why:** A worked AWS example, with Terraform.

| Section | Focus | Copilot section |
|---|---|---|
| Architecture | Skim | — |
| Prerequisites | Skip | — |
| Deploy the gateway | Skip | — |
| Terraform reference | Skip | — |
| Troubleshooting | Skip | — |
| Telemetry | Skip | — |
| Next steps | Skip | — |

**Pay attention to:**

- **Stack:** ECS Fargate or EKS, RDS Postgres, Secrets Manager.
- **The gateway reaches Bedrock with an IAM role.** No long-lived keys.
- **Ready-made Terraform** is included.

---

#### 106. Deploy Claude apps gateway on Google Cloud (Skip)

- Claude Code: [Deploy Claude apps gateway on Google Cloud](https://code.claude.com/docs/en/claude-apps-gateway-on-gcp)
- Copilot CLI: —

**Why:** A worked Google Cloud example, with Terraform.

| Section | Focus | Copilot section |
|---|---|---|
| What you'll build | Skim | — |
| Prerequisites | Skip | — |
| Deploy the gateway | Skip | — |
| Terraform reference | Skip | — |
| Troubleshooting | Skip | — |
| Next steps | Skip | — |

**Pay attention to:**

- **Stack:** Cloud Run or GKE, Cloud SQL Postgres, Secret Manager.
- **The gateway reaches Google's models with a service account.**
- **Ready-made Terraform** is included.

---

#### 107. Other LLM gateways (Skip)

- Claude Code: [Other LLM gateways](https://code.claude.com/docs/en/llm-gateway)
- Copilot CLI: [Connecting to an OpenAI-compatible endpoint](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/use-byok-models#connecting-to-an-openai-compatible-endpoint)

**Why:** Use a gateway your company already runs (for example LiteLLM).

| Section | Focus | Copilot section |
|---|---|---|
| What a gateway provides | Skim | — |
| Roll out a gateway | Skip | — |
| Subscriptions and gateways | Skim | — |
| Related pages | Skip | — |

**Pay attention to:**

- **A gateway gives:** keys kept on the server, usage tracking, budgets, audit logs, provider switching.
- **Rollout:** deploy it, give each developer a key, push the config through managed settings.
- **While a gateway key is active,** your subscription is not used.

---

#### 108. Connect Claude Code to an LLM gateway (Skip)

- Claude Code: [Connect Claude Code to an LLM gateway](https://code.claude.com/docs/en/llm-gateway-connect)
- Copilot CLI: [Configuring your provider](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/use-byok-models#configuring-your-provider)

**Why:** The developer side: point Claude Code at the gateway and fix errors.

| Section | Focus | Copilot section |
|---|---|---|
| Check for an existing configuration | Skim | — |
| Configure Claude Code yourself | Skim | [Configuring your provider](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/use-byok-models#configuring-your-provider) |
| Configure each surface | Skip | — |
| Additional configuration | Skip | — |
| Troubleshoot gateway errors | Skip | — |
| Related resources | Skip | — |

**Pay attention to:**

- **Your admin may have set it up already.** If `claude` opens a session without a login screen, it's done.
- **Two things to set:** `ANTHROPIC_BASE_URL` and a key (`ANTHROPIC_AUTH_TOKEN` or `apiKeyHelper`).
- **Copilot's version:** `COPILOT_PROVIDER_BASE_URL` and a key, for your own model endpoint.

---

#### 109. Roll out an LLM gateway for your organization (Skip)

- Claude Code: [Roll out an LLM gateway for your organization](https://code.claude.com/docs/en/llm-gateway-rollout)
- Copilot CLI: —

**Why:** The admin checklist for rolling a gateway out.

| Section | Focus | Copilot section |
|---|---|---|
| Prerequisites | Skip | — |
| Rollout steps | Skim | — |
| Maintain the gateway | Skip | — |
| Related resources | Skip | — |

**Pay attention to:**

- **Steps:** deploy, give out keys, push settings, check that it works.
- **One key per developer,** so usage is tracked and leavers are easy to cut off.
- **Keep the gateway updated** as Claude Code adds new headers.

---

#### 110. Claude Code gateway compatibility guide (Skip)

- Claude Code: [Claude Code gateway compatibility guide](https://code.claude.com/docs/en/llm-gateway-protocol)
- Copilot CLI: —

**Why:** For gateway builders: what Claude Code sends and what must be passed through.

| Section | Focus | Copilot section |
|---|---|---|
| API formats | Skip | — |
| How the connection method changes client behavior | Skip | — |
| Request headers | Skip | — |
| Response headers | Skip | — |
| System prompt attribution block | Skip | — |
| Feature pass-through | Skip | — |
| Model discovery | Skip | — |
| Related resources | Skip | — |

**Pay attention to:**

- **The gateway must pass through certain headers and body fields,** or features break.
- **The page lists what breaks** when each one is stripped.
- **Only needed if your gateway gives errors.**

---

### Group: Usage and costs

---

#### 111. Monitoring (Skip)

- Claude Code: [Monitoring](https://code.claude.com/docs/en/monitoring-usage)
- Copilot CLI: [CLI reference → OpenTelemetry monitoring](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#opentelemetry-monitoring)

**Why:** Send usage, cost and tool activity to your company's monitoring system with OpenTelemetry.

| Section | Focus | Copilot section |
|---|---|---|
| Quick start | Skim | [OTel environment variables](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#otel-environment-variables) |
| Administrator configuration | Skip | — |
| Configuration details | Skip | — |
| Telemetry from cloud sessions and Claude Tag | Skip | — |
| Available metrics and events | Skip | [Metrics](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#metrics) |
| Interpret metrics and events data | Skim | — |
| Audit security events | Skip | — |
| Backend considerations | Skip | — |
| Service information | Skip | — |
| ROI measurement resources | Skim | — |
| Security and privacy | Skim | [Content capture](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#content-capture) |
| Monitor Claude Code on Amazon Bedrock | Skip | — |

**Pay attention to:**

- **Off by default.** Turn it on with `CLAUDE_CODE_ENABLE_TELEMETRY=1` and an OTLP endpoint.
- **You get:** tokens, cost, sessions, lines of code, and every tool call, per user.
- **Your code and file contents are not sent** unless you turn that on.
- **Copilot CLI also exports OpenTelemetry** (`COPILOT_OTEL_ENABLED=true`).

---

#### 112. Manage costs effectively (Study)

- Claude Code: [Manage costs effectively](https://code.claude.com/docs/en/costs)
- Copilot CLI: [Optimizing your AI usage](https://docs.github.com/en/copilot/tutorials/optimize-ai-usage)

**Why:** Our Copilot tokens are limited. Every tip on this page saves tokens in Copilot too.

| Section | Focus | Copilot section |
|---|---|---|
| Track your costs | ⭐ Read | [Slash commands](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#slash-commands-in-the-interactive-interface) (`/usage`) |
| Manage costs for your organization | Skip | [How can I control costs with budgets?](https://docs.github.com/en/copilot/concepts/billing-and-usage/organizations-and-enterprises/billing#how-can-i-control-costs-with-budgets) |
| Reduce token usage | ⭐ Read | [3. Keep your context lean](https://docs.github.com/en/copilot/tutorials/optimize-ai-usage#3-keep-your-context-lean) |
| Background token usage | Skim | — |
| Why usage climbs in a long session | ⭐ Read | [4. Preserve the cache](https://docs.github.com/en/copilot/tutorials/optimize-ai-usage#4-preserve-the-cache) |
| Understanding changes in Claude Code behavior | Skip | — |

**Pay attention to:**

- **Every message resends the whole conversation.** Big context means big cost.
- **`/clear` between tasks** is free. `/compact` itself costs a big request.
- **Pick the model for the job:** Sonnet for most work, Opus for hard problems. Lower `/effort` for simple tasks.
- **Cut the extras:** disable unused MCP servers, prefer CLI tools like `gh`, move rarely used CLAUDE.md content into skills.
- **Send noisy work (tests, logs) to subagents,** and be specific. "Improve this code" makes it read everything.
- **After a long break the cache expires,** and the next message costs full price.
- **Check spend** with `/usage` (both tools).

**Copilot note:** Copilot now bills by tokens, in AI credits (1 credit = $0.01). So the same habits save money there. Copilot also has `/limits set max-ai-credits N` to cap a session, and `/goal ... --max-ai-credits N` to cap an autopilot run.

---

#### 113. Track team usage with analytics (Skip)

- Claude Code: [Track team usage with analytics](https://code.claude.com/docs/en/analytics)
- Copilot CLI: [Viewing usage and adoption](https://docs.github.com/en/copilot/how-tos/administer-copilot/view-usage-and-adoption)

**Why:** The admin dashboard for adoption and usage.

| Section | Focus | Copilot section |
|---|---|---|
| Access analytics for Team and Enterprise | Skim | [Accessing the dashboard](https://docs.github.com/en/copilot/how-tos/administer-copilot/view-usage-and-adoption#accessing-the-dashboard) |
| Access analytics for API customers | Skip | — |
| Related resources | Skip | — |

**Pay attention to:**

- **The dashboard shows:** active users, sessions, accepted lines, and PRs made with Claude Code.
- **Admins and Owners** can see it.
- **Copilot has its own dashboard,** with Copilot CLI numbers in it ([CLI metrics fields](https://docs.github.com/en/copilot/reference/copilot-usage-metrics/copilot-usage-metrics#copilot-cli-metrics-fields)).

---

### Try it (in Copilot CLI): Usage and costs

1. Do a small task, then run `/usage`. Note the tokens and AI credits per model.
2. Run `/context` and see what fills the context before you type anything.
3. Set a cap: `/limits set max-ai-credits 5`. Start a task and see what happens when it hits the cap.
4. Do the same task twice: once with a vague prompt, once with an exact file and function named. Compare `/usage`.
5. Run `/clear` when you switch tasks. Make it a habit.

---

### Group: Security and data

---

#### 114. Security (Study)

- Claude Code: [Security](https://code.claude.com/docs/en/security)
- Copilot CLI: [About Copilot CLI → Security considerations](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli#security-considerations)

**Why:** The agent runs commands on your machine. Know what protects you and what is still your job.

| Section | Focus | Copilot section |
|---|---|---|
| How we approach security | ⭐ Read | [Trusted directories](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli#trusted-directories) |
| Protect against prompt injection | ⭐ Read | [Command safety analysis](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#command-safety-analysis) |
| MCP security | Skim | [Known MCP server policy limitations](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli#known-mcp-server-policy-limitations) |
| IDE security | Skip | — |
| Cloud execution security | Skip | — |
| Security best practices | ⭐ Read | [Risk mitigation](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli#risk-mitigation) |
| Related resources | Skim | — |

**Pay attention to:**

- **It starts read-only.** Edits and commands need your approval, unless you allow them.
- **You are responsible** for what you approve. Read commands before you say yes.
- **Prompt injection:** a web page, file or issue can hide instructions. `curl` and `wget` are not auto-approved.
- **New folders and new MCP servers need your trust first.** Only use MCP servers you trust.
- **For risky or unattended work,** use the sandbox, a dev container or a VM.
- **Share safe permission rules with your team** through the repo, and check yours with `/permissions`.

**Copilot note:** Same model in Copilot CLI: trusted folders, tool approval, and `--allow-all` only inside a sandbox, container or VM. Copilot also respects the company's content exclusion rules.

---

#### 115. Data usage (Glance)

- Claude Code: [Data usage](https://code.claude.com/docs/en/data-usage)
- Copilot CLI: [Session data](https://docs.github.com/en/copilot/concepts/security-governance-and-network-settings/session-data)

**Why:** What data leaves your machine, how long it is kept, and whether it trains models.

| Section | Focus | Copilot section |
|---|---|---|
| Data policies | ⭐ Read | [Access and retention of session data](https://docs.github.com/en/copilot/concepts/security-governance-and-network-settings/session-data#access-and-retention-of-session-data) |
| Data access | Skip | — |
| Local Claude Code: Data flow and dependencies | Skim | [Locally run sessions](https://docs.github.com/en/copilot/concepts/security-governance-and-network-settings/session-data#locally-run-sessions) |
| Telemetry services | Skim | [Session syncing](https://docs.github.com/en/copilot/concepts/security-governance-and-network-settings/session-data#session-syncing) |
| Default behaviors by API provider | Skip | — |

**Pay attention to:**

- **Business plans (Team, Enterprise, API): no training on your code.** Data is kept for 30 days.
- **Personal plans (Pro, Max):** you choose in privacy settings whether your data trains models.
- **Session transcripts sit on your disk as plain text** in `~/.claude/projects/` for 30 days.
- **Turn off extra traffic** with `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1`.
- **Copilot CLI syncs your sessions to your GitHub account by default.** You can turn that off.

**Copilot note:** Copilot saves each session in `~/.copilot/session-state/`. For Business and Enterprise users, syncing to GitHub happens only if the org's "Store local sessions in the Cloud" policy allows it. Synced sessions are visible only to you; admins can't read them. Cloud agent sessions are different: anyone with access to the repo can see them.

---

#### 116. Zero data retention (Skip)

- Claude Code: [Zero data retention](https://code.claude.com/docs/en/zero-data-retention)
- Copilot CLI: [Hosting of models → Anthropic models](https://docs.github.com/en/copilot/reference/ai-models/model-hosting#anthropic-models)

**Why:** An Enterprise option where Anthropic stores nothing after each request.

| Section | Focus | Copilot section |
|---|---|---|
| ZDR scope | Skim | — |
| Features disabled under ZDR | Skim | — |
| Data retention for policy violations | Skip | — |
| Request ZDR | Skip | — |

**Pay attention to:**

- **Only for approved Claude for Enterprise accounts,** turned on per organization.
- **Features that need stored data are off,** such as cloud sessions.
- **Flagged abuse can still be kept** for up to 2 years.

---

### Try it (in Copilot CLI): Security and data

1. Start `copilot` in a new folder and read the trust prompt. Then open `/permissions` and look at what you have allowed so far.
2. Run `/sandbox status`. Turn it on with `/sandbox enable` and ask Copilot to read a file outside the project. See it get blocked.
3. Ask Copilot to `curl` some URL. Note that it asks first. Say no.
4. Check the `remote` setting in `~/.copilot/settings.json`. It is `"on"` by default, which syncs your sessions to GitHub. Set it to `"off"` to keep them local.

---

### Group: Adoption

---

#### 117. Communications kit (Glance)

- Claude Code: [Communications kit](https://code.claude.com/docs/en/communications-kit)
- Copilot CLI: [Driving Copilot adoption in your company](https://docs.github.com/en/copilot/tutorials/roll-out-at-scale/enable-developers/drive-adoption)

**Why:** Ready-to-send launch messages, weekly tips and FAQ answers. Good material for this training.

| Section | Focus | Copilot section |
|---|---|---|
| Launch communications | Skim | [Communicating expectations](https://docs.github.com/en/copilot/tutorials/roll-out-at-scale/enable-developers/drive-adoption#communicating-expectations) |
| Tips and tricks campaign | ⭐ Read | [Providing learning resources](https://docs.github.com/en/copilot/tutorials/roll-out-at-scale/enable-developers/drive-adoption#providing-learning-resources) |
| Quick reference | ⭐ Read | [Creating onboarding resources](https://docs.github.com/en/copilot/tutorials/roll-out-at-scale/enable-developers/drive-adoption#creating-onboarding-resources) |

**Pay attention to:**

- **Before launch:** create a channel, test the install command, pick people who answer questions.
- **Tips campaign:** short posts, one or two a week. Each has a hook, the payoff and a "try it now".
- **The tips cover:** models, CLAUDE.md, plan mode, MCP, hooks, skills. Most apply to Copilot CLI too.
- **The FAQ table** gives one-line answers to the usual questions.

**Copilot note:** GitHub's page has a sample timeline: start 45 days before launch (success metrics, train champions), send announcements 14 days out, run a workshop 7 days out, and open a channel and wiki on launch day. Useful for planning this training.

---

#### 118. Champion kit (Glance)

- Claude Code: [Champion kit](https://code.claude.com/docs/en/champion-kit)
- Copilot CLI: [Driving agentic adoption on a team](https://docs.github.com/en/copilot/tutorials/roll-out-at-scale/enable-developers/drive-team-agentic-adoption)

**Why:** How one engineer can help a whole team adopt an agent. Useful for anyone who wants to help others after this training.

| Section | Focus | Copilot section |
|---|---|---|
| The champion role | Skim | [Select and equip an initial team](https://docs.github.com/en/copilot/tutorials/roll-out-at-scale/enable-developers/drive-team-agentic-adoption#select-and-equip-an-initial-team) |
| Share what you discover | ⭐ Read | [Week one: launch and complete the first workflows](https://docs.github.com/en/copilot/tutorials/roll-out-at-scale/enable-developers/drive-team-agentic-adoption#week-one-launch-and-complete-the-first-workflows) |
| Be the person people ask | Skim | — |
| Grow the circle | Skim | [Decide how to scale](https://docs.github.com/en/copilot/tutorials/roll-out-at-scale/enable-developers/drive-team-agentic-adoption#decide-how-to-scale) |
| Respond to common concerns | ⭐ Read | — |
| Quick-reference sheet | ⭐ Read | — |

**Pay attention to:**

- **Share real wins from our own code.** They convince people more than any docs.
- **When someone asks how, share the prompt you used,** not a long explanation.
- **Common pushback and answers:** "it hallucinates" is usually missing context; "I don't trust it" is solved by plan mode plus normal review.
- **Top habits:** give the right files, review the plan first, run `/init`, save repeated workflows as skills.
- **Success is when others answer the questions** in the channel, not you.

**Copilot note:** GitHub suggests a two-week team sprint. Give the team two or three approved workflows instead of "use AI more", aim for use on 3 or more days a week, and measure outcomes like time to open a PR. Never measure the amount of generated code.

---

### Try it (in Copilot CLI): Adoption

1. Pick one tedious task you have been avoiding (tests, a legacy file). Do it with Copilot CLI in plan mode.
2. Save the prompt that worked. Post it in the team channel with a one-line result.
3. If you repeat a workflow, turn it into a skill in `.github/skills/` so the team can reuse it.

---

**End of Tab 4: Administration.**

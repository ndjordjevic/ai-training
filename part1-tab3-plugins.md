# Part 1, Tab 3: Plugins

← [Back to the Part 1 index](part1-reading-map.md). How to read this map (priorities, columns) is explained there.

A plugin is a package that bundles skills, subagents, hooks and MCP servers so a whole setup can be installed with one command. For our team, the main uses are: **install** good plugins, and maybe **share our own setup** as a plugin through a team marketplace.

### Group: Plugins

---

#### 63. Plugins overview (Study)

- Claude Code: [Plugins overview](https://code.claude.com/docs/en/plugins/overview)
- Copilot CLI: [Comparing features → Plugins](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features#plugins)

**Why:** What a plugin is and when you need one instead of a single skill or MCP server.

| Section | Focus | Copilot section |
|---|---|---|
| Understand what a plugin is | ⭐ Read | [What is a plugin?](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features#what-is-a-plugin) |
| Get plugins from a marketplace | ⭐ Read | [Finding plugins](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-finding-installing#finding-plugins) |
| Tell Anthropic's marketplaces from third-party ones | Skim | — |
| Understand install scopes | ⭐ Read | — |
| Next steps | Skip | — |

**Pay attention to:**

- **A plugin bundles skills, subagents, hooks and MCP servers** into one installable package.
- **Use one to get someone's full setup in one command,** or to share yours with the team.
- **An enabled plugin is in every session:** it costs context and runs as you. Disable the ones you don't use.
- **A marketplace is a catalog** (a git repo). Install with `plugin@marketplace`.
- **Scopes:** you (all projects), the whole repo (project), or you in this repo (local).

**Copilot note:** Copilot can also install a plugin straight from a GitHub repo, with no marketplace: `copilot plugin install owner/repo`. If a plugin has a skill or agent with the same name as one in your repo or your personal setup, yours wins and the plugin's is ignored.

---

### Group: Use plugins

---

#### 64. Install and manage plugins (Study)

- Claude Code: [Install and manage plugins](https://code.claude.com/docs/en/plugins/install)
- Copilot CLI: [Finding and installing plugins](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-finding-installing)

**Why:** How to add a marketplace, install a plugin, and keep it updated.

| Section | Focus | Copilot section |
|---|---|---|
| Install a plugin | ⭐ Read | [Installing plugins](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-finding-installing#installing-plugins) |
| Add a marketplace | ⭐ Read | [Adding plugin marketplaces](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-finding-installing#adding-plugin-marketplaces) |
| Manage installed plugins | Skim | [Managing installed plugins](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-finding-installing#managing-installed-plugins) |
| Keep plugins updated | Skim | [Slash commands](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#slash-commands-in-the-interactive-interface) (`/plugin update`) |
| Manage marketplaces | Skip | [Removing plugin marketplaces](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-finding-installing#removing-plugin-marketplaces) |
| Next steps | Skip | — |

**Pay attention to:**

- **Install:** `/plugin install <name>@<marketplace>`. Review what it adds and its context cost first.
- **Add other marketplaces** with `/plugin marketplace add owner/repo`.
- **Manage** in `/plugin` → Installed (enable, disable, update, uninstall).
- **Third-party marketplaces don't auto-update** by default.
- **Copilot CLI has almost the same commands** (`/plugin`, `copilot plugin install`).

**Copilot note:** in Copilot, the shell commands are `copilot plugin list`, `update --all`, `disable`, `enable` and `uninstall`. Our org can pin plugins through managed settings; those show a **Managed** badge in `/plugin`, and you can't turn them off.

---

#### 65. Anthropic's marketplaces (Glance)

- Claude Code: [Anthropic's marketplaces](https://code.claude.com/docs/en/plugins/anthropic-marketplaces)
- Copilot CLI: [Finding plugins](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-finding-installing#finding-plugins) (for example the `awesome-copilot` marketplace)

**Why:** Where to find the official and community plugins.

| Section | Focus | Copilot section |
|---|---|---|
| Anthropic's marketplaces | Skim | — |
| Find plugins in the official marketplace | ⭐ Read | [Finding plugins](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-finding-installing#finding-plugins) |
| Browse and install from Anthropic's marketplaces | Skim | — |
| Third-party marketplaces | ⭐ Read | — |
| Next steps | Skip | — |

**Pay attention to:**

- **Anthropic's official marketplace** is added automatically. It has plugins from Anthropic and partners.
- **Community and demo marketplaces** can be added by hand.
- **Everything else is third-party.** Read it before you install.

**Copilot note:** Copilot comes with two marketplaces: `copilot-plugins` and `awesome-copilot`. Plugins from these two update by themselves at the start of each session. You can add Anthropic's marketplace too: `copilot plugin marketplace add anthropics/claude-code`.

---

#### 66. Code intelligence plugins (Glance)

- Claude Code: [Code intelligence plugins](https://code.claude.com/docs/en/plugins/code-intelligence)
- Copilot CLI: [About LSP servers](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/lsp-servers), [Adding LSP servers](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/add-lsp-servers)

**Why:** Connect the agent to a language server (the same thing your IDE uses). The agent then sees type errors right after an edit and can jump to definitions instead of searching text.

| Section | Focus | Copilot section |
|---|---|---|
| Install a code intelligence plugin | ⭐ Read | [Using the lsp-setup skill](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/add-lsp-servers#using-the-lsp-setup-skill-to-add-a-language-server) |
| See what Claude gains | ⭐ Read | [What LSP servers allow Copilot CLI to do](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/lsp-servers#what-lsp-servers-allow-copilot-cli-to-do) |
| Accept or dismiss the recommendation dialog | Skip | — |
| Troubleshoot code intelligence | Skip | [Managing language servers with /lsp](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/add-lsp-servers#managing-language-servers-with-the-lsp-command) |
| Add a language without an official plugin | Skip | [Manually installing an LSP server](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/add-lsp-servers#manually-installing-and-configuring-an-lsp-server) |
| Next steps | Skip | — |

**Pay attention to:**

- **Connects the agent to a language server,** like your IDE uses.
- **The agent sees type errors right after its edits** and jumps to definitions instead of searching text.
- **Setup:** install the language server yourself, then the plugin (for example `typescript-lsp`).
- **A cheap, big win for typed languages.** Copilot CLI has this built in (`/lsp`).

**Copilot note:** Copilot CLI has LSP support built in. Run `/lsp` to see which language servers are active.

---

#### 67. Plugin security and trust (Study)

- Claude Code: [Plugin security and trust](https://code.claude.com/docs/en/plugins/security)
- Copilot CLI: — (no dedicated page; the same rules apply)

**Why:** A plugin can run code on your machine. This page explains how to decide whether to trust one.

| Section | Focus | Copilot section |
|---|---|---|
| Understand what a plugin can do | ⭐ Read | — |
| Identify Anthropic's marketplaces by name | Skim | — |
| Review a plugin before you install | ⭐ Read | — |
| Recognize when Claude Code refuses or warns | Skim | — |
| Enforce plugin controls for your organization | Skip | — |
| Find plugins in telemetry | Skip | — |
| Next steps | Skip | — |

**Pay attention to:**

- **A plugin can run any code on your machine as you.** Its hooks and servers run outside your permission rules.
- **Before installing:** check the source, and read its hooks, `.mcp.json` and `bin/` files.
- **Fake "official" marketplaces are refused;** everything not from Anthropic is third-party.
- **The same risk applies to Copilot plugins.**

**Copilot note:** Copilot has no plugin security page, so use the same checks. One extra risk: plugins from the two built-in marketplaces update by themselves at session start, so a plugin can change without you doing anything. Turn this off with the `autoUpdate` setting set to `false`.

---

### Group: Create plugins

---

#### 68. Create a plugin (Glance)

- Claude Code: [Create a Claude Code plugin](https://code.claude.com/docs/en/plugins/create)
- Copilot CLI: [Creating a plugin for Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-creating)

**Why:** Build your first plugin, test it locally, and turn an existing `.claude/` setup into a plugin.

| Section | Focus | Copilot section |
|---|---|---|
| Decide when to use a plugin | ⭐ Read | [Introduction](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-creating#introduction) |
| Create your first plugin | Skim | [Creating a plugin](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-creating#creating-a-plugin) |
| Develop without a marketplace | Skim | — |
| Test and debug | Skip | — |
| Convert an existing .claude/ setup | ⭐ Read | — |
| Next steps | Skip | [Distributing your plugin](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-creating#distributing-your-plugin) |

**Pay attention to:**

- **Make a plugin to share a setup** across repos or people. For one project, plain `.claude/` files are enough.
- **Layout:** `.claude-plugin/plugin.json` plus `skills/`, `agents/`, `hooks/hooks.json`, `.mcp.json`.
- **Develop without a marketplace:** `claude --plugin-dir ./my-plugin`. Check with `claude plugin validate`.
- **You can convert an existing `.claude/` setup** into a plugin.
- **Copilot CLI reads the same `plugin.json`.**

**Copilot note:** Copilot CLI also reads `.claude-plugin/plugin.json`. A plugin built for Claude Code can often be installed in Copilot CLI too.

---

#### 69. Add components to a plugin (Glance)

- Claude Code: [Add components to a plugin](https://code.claude.com/docs/en/plugins/components)
- Copilot CLI: [Creating a plugin → Plugin structure](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-creating#plugin-structure)

**Why:** What can go in a plugin and where each part lives in the folder.

| Section | Focus | Copilot section |
|---|---|---|
| Explore the plugin directory | ⭐ Read | [Plugin structure](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-creating#plugin-structure) |
| Add each kind of component | Skim | [plugin.json reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference#pluginjson) |
| Ask the user for configuration values | Skip | — |
| Reference plugin paths and store data | Skip | — |
| Next steps | Skip | — |

**Pay attention to:**

- **A plugin can hold:** skills, commands, subagents, hooks, MCP and language servers, executables, settings and themes.
- **Put instructions in a skill.** A `CLAUDE.md` inside a plugin is not loaded.
- **`userConfig`** asks users for values like API keys at install time.
- **After changes:** `claude plugin validate .` and `/reload-plugins`.

**Copilot note:** in a Copilot plugin, language servers go in `lsp-config/servers.json` (or `lspServers` in `plugin.json`). Skills load only from the `skills/` folder.

---

#### 70. Plugin dependencies (Skip)

- Claude Code: [Plugin dependencies](https://code.claude.com/docs/en/plugins/dependencies)
- Copilot CLI: —

**Why:** Let one plugin require another, with version ranges.

| Section | Focus | Copilot section |
|---|---|---|
| Declare dependencies | Skip | — |
| Release a plugin that others depend on | Skip | — |
| How dependencies behave for your users | Skim | — |
| See also | Skip | — |

**Pay attention to:**

- **A plugin can require other plugins,** with version ranges like `^1.2`.
- **Pin versions** so a dependency's update can't break your plugin.
- **A "bundle" plugin** with only dependencies installs a whole team toolkit in one command.

---

#### 71. Test plugins with evals (Skip)

- Claude Code: [Test plugins with evals](https://code.claude.com/docs/en/plugin-evals)
- Copilot CLI: —

**Why:** Write test cases for a plugin and check it actually helps, compared with running without it.

| Section | Focus | Copilot section |
|---|---|---|
| Requirements | Skip | — |
| How an eval run works | Skim | — |
| Create your first eval suite | Skip | — |
| Write and refine cases | Skip | — |
| Set up fixtures and mocks | Skip | — |
| Run evals | Skip | — |
| Read the results | Skip | — |
| What a run can access | Skip | — |
| Eval suite reference, Troubleshooting, See also | Skip | — |

**Pay attention to:**

- **`claude plugin eval` tests whether a plugin actually helps.**
- **Each test case runs several times, with and without the plugin,** and you compare the scores.
- **Prefer graders that give a stable result** (checks over long model judgments).
- **You can fail CI on a low score.**

---

#### 72. Publish a plugin (Skip)

- Claude Code: [Publish and distribute a plugin](https://code.claude.com/docs/en/plugins/publish)
- Copilot CLI: [Distributing your plugin](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-creating#distributing-your-plugin)

**Why:** Share a plugin through your own marketplace or Anthropic's directory.

| Section | Focus | Copilot section |
|---|---|---|
| Choose how to distribute | Skim | [Distributing your plugin](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-creating#distributing-your-plugin) |
| Prepare your plugin for release | Skip | — |
| Share a plugin without a marketplace | Skim | — |
| Publish through your own marketplace | Skip | — |
| Submit to Anthropic's directory | Skip | — |
| Ship updates, renames, and removals | Skip | — |
| Declare dependencies | Skip | — |
| Next steps | Skip | — |

**Pay attention to:**

- **Three ways to share:** send the folder or a zip, list it in your own marketplace, or submit it to Anthropic's directory.
- **For a team, your own marketplace (a git repo) is the simple path.** A private repo means a private marketplace.
- **Before each release:** check the name and version, validate, and test an install.
- **Users update** with `claude plugin update`, or automatically if auto-update is on.

---

#### 73. Measure plugin cost and usage (Skip)

- Claude Code: [Measure plugin cost and usage](https://code.claude.com/docs/en/plugins/measure)
- Copilot CLI: —

**Why:** Find out how many tokens a plugin costs and whether people still use it.

| Section | Focus | Copilot section |
|---|---|---|
| Measure what a plugin costs | Skim | — |
| Check whether a plugin is used | Skip | — |
| Measure across a fleet | Skip | — |
| Next steps | Skip | — |

**Pay attention to:**

- **Every enabled plugin costs context in every session.** `claude plugin details <name>` shows how much.
- **Find unused things:** the "Not used recently" group in `/plugin`, `/skill-doctor`, `/doctor`.
- **Remove what nobody uses.**

---

#### 74. Recommend your plugin from your CLI (Skip)

- Claude Code: [Recommend your plugin from your CLI](https://code.claude.com/docs/en/plugins/cli-hints)
- Copilot CLI: —

**Why:** For tool makers: make your own CLI suggest your plugin to Claude Code users.

| Section | Focus | Copilot section |
|---|---|---|
| Emit the hint | Skip | — |
| Hint format | Skip | — |
| Check when the prompt appears | Skip | — |
| Preview what the user sees | Skip | — |
| Next steps | Skip | — |

**Pay attention to:**

- **For tool makers:** your CLI can print a hint so Claude Code suggests installing your plugin.
- **Only for plugins in the official marketplace.** Not relevant for most teams.

---

### Group: Run a marketplace

---

#### 75. Create a marketplace (Glance)

- Claude Code: [Create a marketplace](https://code.claude.com/docs/en/plugins/create-marketplace)
- Copilot CLI: [Creating a plugin marketplace](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-marketplace)

**Why:** A marketplace is one `marketplace.json` file that lists plugins. A team marketplace is how we'd share our plugins.

| Section | Focus | Copilot section |
|---|---|---|
| Create a marketplace | ⭐ Read | [Creating a plugin marketplace](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-marketplace#creating-a-plugin-marketplace) |
| Add plugin entries | Skim | [marketplace.json reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference#marketplacejson) |
| Rules for plugin entries | Skip | — |
| Choose a plugin source | Skim | — |
| Validate and test | Skip | — |
| Host your marketplace | Skip | — |
| Next steps | Skip | — |

**Pay attention to:**

- **A marketplace is one `.claude-plugin/marketplace.json` file** listing plugins and where to get them.
- **Common mistakes:** a relative path from the wrong folder, or an entry name that differs from the plugin's own name.
- **Test locally:** `claude plugin validate`, then add and install it yourself.
- **Copilot CLI reads `.claude-plugin/marketplace.json` too.**

**Copilot note:** Copilot CLI also reads `.claude-plugin/marketplace.json`, so one marketplace repo can serve both tools.

---

#### 76. Host and maintain a marketplace (Skip)

- Claude Code: [Host and maintain a marketplace](https://code.claude.com/docs/en/plugins/host-marketplace)
- Copilot CLI: [Adding plugin marketplaces](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-finding-installing#adding-plugin-marketplaces)

**Why:** Put a marketplace where people can reach it, keep it private, and ship updates safely.

| Section | Focus | Copilot section |
|---|---|---|
| Host your marketplace | Skim | — |
| Distribute through organization settings | Skip | — |
| Grant access to a private marketplace | Skim | — |
| Roll out to a whole company | Skip | — |
| Keep users up to date | Skip | — |
| Run release channels | Skip | — |
| Rename or remove a plugin | Skip | — |
| Authenticate archive downloads | Skip | — |
| Depend on and recommend other plugins | Skip | — |
| Work around what a marketplace can't do | Skip | — |
| Next steps | Skip | — |

**Pay attention to:**

- **Host it on GitHub, another git host, a URL or a shared folder.**
- **Share it with a whole repo:** `claude plugin marketplace add … --scope project`, and commit.
- **A private repo works as a private marketplace** using people's normal git logins.
- **Don't rename or remove plugins without a plan;** it breaks existing installs.

---

#### 77. Recommend plugins for your org (Skip)

- Claude Code: [Recommend plugins for your org](https://code.claude.com/docs/en/plugins/relevance)
- Copilot CLI: —

**Why:** Make the agent suggest a plugin when someone's work matches it.

| Section | Focus | Copilot section |
|---|---|---|
| Understand how plugin relevance works | Skim | — |
| Add relevance to a plugin entry | Skip | — |
| Field reference | Skip | — |
| Validate your marketplace | Skip | — |
| Enable suggestions in managed settings | Skip | — |
| Preview what the user sees | Skip | — |
| See also | Skip | — |

**Pay attention to:**

- **Makes the agent suggest a plugin** when the work matches, for example when it reads a `.tf` file.
- **Admin feature,** set in the marketplace and managed settings.

---

### Group: Manage plugins for your organization

---

#### 78. Manage plugins for your organization (Skip)

- Claude Code: [Manage Claude Code plugins for your organization](https://code.claude.com/docs/en/plugins/org)
- Copilot CLI: —

**Why:** Admins can pre-install, require or block plugins for everyone.

| Section | Focus | Copilot section |
|---|---|---|
| Pre-install and require plugins | Skim | — |
| Seed containers and CI | Skip | — |
| Restrict what users can install | Skim | — |
| Set update policy | Skip | — |
| Recommend plugins | Skip | — |
| Audit and review | Skip | — |
| Plan for what managed settings can't enforce | Skip | — |
| Troubleshoot policy | Skip | — |
| Next steps | Skip | — |

**Pay attention to:**

- **Admins can pre-install, require or block plugins** for everyone through managed settings.
- **Per repo:** list them in `.claude/settings.json` (`extraKnownMarketplaces`, `enabledPlugins`).
- **Not needed now,** since our company is on Copilot.

---

### Group: Troubleshooting

---

#### 79. Troubleshoot plugins (Skip)

- Claude Code: [Troubleshoot plugins](https://code.claude.com/docs/en/plugins/troubleshooting)
- Copilot CLI: [Plugin reference → Loading order and precedence](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference#loading-order-and-precedence)

**Why:** Fixes for plugin errors, grouped by step: add marketplace, install, load, build.

| Section | Focus | Copilot section |
|---|---|---|
| Find where /plugin runs | Skip | — |
| Add a marketplace | Skip | — |
| Install a plugin | Skip | — |
| Plugin installed but not working | ⭐ Read | — |
| Build a plugin | Skip | — |
| Host a marketplace | Skip | — |
| Blocked by your organization | Skip | — |
| Next steps | Skip | — |

**Pay attention to:**

- **A lookup page** of plugin errors, by step: add marketplace, install, load, build.
- **Installed but not working?** Check it's enabled, run `/reload-plugins`, and look at the Errors tab in `/plugin`.

---

#### 80. Plugin loading reference (Skip)

- Claude Code: [Plugin loading reference](https://code.claude.com/docs/en/plugins/loading)
- Copilot CLI: [Plugin reference → File locations](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference#file-locations)

**Why:** Where each plugin loads from and why an update changed nothing.

| Section | Focus | Copilot section |
|---|---|---|
| Check which stage a plugin reached | Skip | — |
| Find where a plugin came from | Skip | — |
| Find where a plugin is enabled | Skip | — |
| Find plugins on disk | Skip | [File locations](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference#file-locations) |
| Versions and updates | Skip | — |
| Name conflicts | Skip | — |
| Next steps | Skip | — |

**Pay attention to:**

- **Explains where each plugin loads from** and which settings file turns it on.
- **An update changes nothing until** `/reload-plugins` or a new session.
- **Use it only when debugging.**

---

### Group: Reference

---

#### 81. Plugin manifest reference (Skip)

- Claude Code: [Plugin manifest reference](https://code.claude.com/docs/en/plugins/manifest-reference)
- Copilot CLI: [Plugin reference → plugin.json](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference#pluginjson)

**Why:** Every field in `plugin.json`.

| Section | Focus | Copilot section |
|---|---|---|
| Manifest file | Skip | [plugin.json](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference#pluginjson) |
| Fields | Skip | [Agent Plugins 1.0 manifest fields](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference#agent-plugins-10-manifest-fields) |
| Component path forms, Path rules | Skip | — |
| User configuration | Skip | — |
| Channels | Skip | — |
| Environment variables | Skip | — |
| Standard layout | Skim | — |
| Marketplace entries and the manifest | Skip | — |
| Next steps | Skip | — |

**Pay attention to:**

- **Every field of `plugin.json`.** Only `name` is required.
- **A lookup page for plugin authors.**

---

#### 82. Marketplace reference (Skip)

- Claude Code: [Marketplace reference](https://code.claude.com/docs/en/plugins/marketplace-reference)
- Copilot CLI: [Plugin reference → marketplace.json](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference#marketplacejson)

**Why:** Every field in `marketplace.json`.

| Section | Focus | Copilot section |
|---|---|---|
| Marketplace file | Skip | [marketplace.json](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference#marketplacejson) |
| Top-level fields | Skip | [marketplace.json fields](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference#marketplacejson-fields) |
| Plugin entries | Skip | — |
| Plugin sources | Skip | — |
| Marketplace sources | Skip | — |
| Validation messages | Skip | — |
| Next steps | Skip | — |

**Pay attention to:**

- **Every field of `marketplace.json`.** Required: `name`, `owner`, `plugins`.
- **A lookup page for marketplace owners.**

---

#### 83. Plugin commands reference (Glance)

- Claude Code: [Plugin commands reference](https://code.claude.com/docs/en/plugins/cli-reference)
- Copilot CLI: [Plugin reference → CLI commands](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference#cli-commands)

**Why:** All plugin commands in one place.

| Section | Focus | Copilot section |
|---|---|---|
| claude plugin commands | Skim | [CLI commands](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference#cli-commands) |
| claude plugin marketplace commands | Skim | [copilot plugin marketplace subcommands](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference#copilot-plugin-marketplace-alias-marketplaces-subcommands) |
| /plugin in a session | ⭐ Read | [Slash commands](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#slash-commands-in-the-interactive-interface) (`/plugin`) |
| /reload-plugins | Skim | — |
| Flags that load a plugin for one session | Skip | — |
| Next steps | Skip | — |

**Pay attention to:**

- **`/plugin`** opens the dashboard: browse, install, enable, disable.
- **`claude plugin …`** does the same from the shell or scripts (install, list, update, validate).
- **`/reload-plugins`** applies changes without restarting.
- **`--plugin-dir`** loads a plugin for one session.

**Copilot note:** Copilot has no `validate` command. To test a plugin, install it from its folder (`copilot plugin install ./my-plugin`) or load it with `--plugin-dir`. `/plugin` marks plugins that have a newer version and offers an Update action.

---

### Try it (in Copilot CLI): Plugins

1. Run `copilot plugin marketplace list` to see which marketplaces you have.
2. Browse one: `copilot plugin marketplace browse awesome-copilot`. Pick one plugin and **read its files first** (hooks, scripts, MCP servers).
3. Install it with `/plugin install <name>@<marketplace>`, try it, then check its cost with `/context`.
4. Run `/lsp` to see if a language server is active for your language. If not, set one up.
5. Uninstall anything you won't use.

---

**End of Tab 3: Plugins.**

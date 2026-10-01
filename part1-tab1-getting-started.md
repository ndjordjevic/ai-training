# Part 1, Tab 1: Getting started

← [Back to the Part 1 index](part1-reading-map.md). How to read this map (priorities, columns) is explained there.

### Group: Getting started

---

#### 1. Overview (Glance)

- Claude Code: [Overview](https://code.claude.com/docs/en/overview)
- Copilot CLI: [About Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli)

**Why:** What a coding agent is and what it can do, in one page.


| Section                    | Focus  | Copilot section                                                                                                                                |
| -------------------------- | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| Get started                | Skim   | [Supported operating systems](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli#supported-operating-systems)    |
| What you can do            | ⭐ Read | [Use cases for Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli#use-cases-for-github-copilot-cli) |
| Use Claude Code everywhere | Skim   | [Modes of use](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli#modes-of-use)                                  |
| Next steps                 | Skip   | [Further reading](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli#further-reading)                            |


**Pay attention to:**

- **What it is:** an AI agent that reads your code, edits files, runs commands and checks its work. You give the goal; it does the steps.
- **Good at:** boring work (tests, lint fixes, merge conflicts, release notes), features and bug fixes, commits and PRs.
- **You shape it with:** `CLAUDE.md` (rules), skills (saved workflows), hooks (automatic actions) and MCP (outside tools).
- **Scriptable:** pipe data in and use it in CI, for example `tail -200 app.log | claude -p "flag anything unusual"`.
- **Same engine everywhere:** terminal, IDE, desktop, web and phone share your setup.

**Copilot note:** the Copilot page is longer. It also covers permissions ("Allowed tools"), sandboxing and models. Skip those parts for now; they come up in later topics.

---



#### 2. Quickstart (Study)

- Claude Code: [Quickstart](https://code.claude.com/docs/en/quickstart)
- Copilot CLI: [Copilot CLI quickstart](https://docs.github.com/en/copilot/get-started/cli-quickstart)

**Why:** Your first real session, step by step. The flow is the same in both tools.


| Section                                 | Focus  | Copilot section                                                                                                                                                                                                                                                     |
| --------------------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Before you begin                        | Skim   | —                                                                                                                                                                                                                                                                   |
| Step 1: Install Claude Code             | Skim   | [Installation](https://docs.github.com/en/copilot/get-started/cli-quickstart#installation)                                                                                                                                                                          |
| Step 2: Log in to your account          | Skim   | [Starting the CLI for the first time](https://docs.github.com/en/copilot/get-started/cli-quickstart#starting-the-cli-for-the-first-time)                                                                                                                            |
| Step 3: Start your first session        | Skim   | [Starting the CLI for the first time](https://docs.github.com/en/copilot/get-started/cli-quickstart#starting-the-cli-for-the-first-time)                                                                                                                            |
| Step 4: Ask your first question         | ⭐ Read | [Starting the CLI for the first time](https://docs.github.com/en/copilot/get-started/cli-quickstart#starting-the-cli-for-the-first-time)                                                                                                                            |
| Step 5: Make your first code change     | ⭐ Read | —                                                                                                                                                                                                                                                                   |
| Step 6: Use Git with Claude Code        | ⭐ Read | —                                                                                                                                                                                                                                                                   |
| Step 7: Fix a bug or add a feature      | ⭐ Read | —                                                                                                                                                                                                                                                                   |
| Step 8: Test out other common workflows | Skim   | —                                                                                                                                                                                                                                                                   |
| Essential commands                      | ⭐ Read | [Core shortcuts to master](https://docs.github.com/en/copilot/get-started/cli-quickstart#core-shortcuts-to-master), [Using Copilot CLI non-interactively](https://docs.github.com/en/copilot/get-started/cli-quickstart#using-github-copilot-cli-non-interactively) |
| Pro tips for beginners                  | ⭐ Read | —                                                                                                                                                                                                                                                                   |
| What's next?                            | Skip   | [Next steps](https://docs.github.com/en/copilot/get-started/cli-quickstart#next-steps)                                                                                                                                                                              |
| Getting help                            | Skip   | —                                                                                                                                                                                                                                                                   |


**Pay attention to:**

- **Start:** install, log in, run `claude` in your project folder.
- **No need to add files.** Ask "what does this project do?" and it finds and reads what it needs.
- **Permission modes** decide if it asks before changes. `Shift+Tab` switches them.
- **Commands:** `claude "task"`, `claude -p` (one answer, then exit), `claude -c` (continue), `claude -r` (pick a session), `/clear`.
- **Pro tips:** be specific, split big tasks into steps, let it explore before it edits.
- **Copilot CLI works the same:** `copilot`, `-p`, `--continue`, `--resume`, `Shift+Tab`.

**Copilot note:** the Copilot quickstart has no steps 5 to 8. Try the Claude prompts in Copilot; they work the same.

---



#### 3. Changelog (Glance)

- Claude Code: [Changelog](https://code.claude.com/docs/en/changelog)
- Copilot CLI: [Copilot CLI changelog](https://github.com/github/copilot-cli/blob/main/changelog.md)

**Why:** Shows how fast these tools change. New features ship almost every day.


| Section                             | Focus                        | Copilot section                                                             |
| ----------------------------------- | ---------------------------- | --------------------------------------------------------------------------- |
| One entry per version, newest first | Skim the latest 2–3 versions | [Same format](https://github.com/github/copilot-cli/blob/main/changelog.md) |


**Pay attention to:**

- **A new version ships almost every day.** Each entry lists what was added and fixed.
- **Check your version** with `claude --version` (or `copilot --version`) and keep it updated.
- **To spot new features,** read only the "Added" lines of the last few versions.

**Copilot note:** you don't need the browser. In a session, `/changelog summarize last 3` gives a short summary of the last three versions, and `/update` installs the latest one.

---



### Try it (in Copilot CLI): Getting started

1. Run `copilot` in one of your repos.
2. Ask: `give me an overview of this project`.
3. Ask for one small change and review the diff before you approve it.
4. Ask: `what files have I changed?`, then `commit my changes with a clear message`.
5. Exit and run a one-off prompt: `copilot -p "explain what the main entry point does"`.

---



### Group: Core concepts

This is the most important group in Part 1. It explains how every coding agent works, not only Claude Code.

---



#### 4. How Claude Code works (Study)

- Claude Code: [How Claude Code works](https://code.claude.com/docs/en/how-claude-code-works)
- Copilot CLI: [About Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli), [Cancel and roll back](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/cancel-and-roll-back)

**Why:** The mental model behind every coding agent: a model plus tools, running in a loop.


| Section                                               | Focus  | Copilot section                                                                                                                                                                                                                                                                                                                                                                        |
| ----------------------------------------------------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| The agentic loop (Models, Tools)                      | ⭐ Read | [Introduction](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli#introduction), [Model usage](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli#model-usage)                                                                                                                                                             |
| What Claude can access                                | ⭐ Read | [Use cases for Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli#use-cases-for-github-copilot-cli)                                                                                                                                                                                                                                         |
| Environments and interfaces                           | Skim   | [Modes of use](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli#modes-of-use), [Local sandboxing](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli#local-sandboxing), [Cloud sandboxing](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli#cloud-sandboxing)                            |
| Work with sessions (branches, resume, context window) | ⭐ Read | [Automatic context management](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli#automatic-context-management)                                                                                                                                                                                                                                          |
| Stay safe with checkpoints and permissions            | ⭐ Read | [Allowed tools](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli#allowed-tools), [Security considerations](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli#security-considerations), [Rolling back changes](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/cancel-and-roll-back#rolling-back-changes) |
| Work effectively with Claude Code                     | ⭐ Read | [Steering the conversation](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli#steering-the-conversation)                                                                                                                                                                                                                                                |
| What's next                                           | Skip   | [Further reading](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli#further-reading)                                                                                                                                                                                                                                                                    |


**Pay attention to:**

- **The loop:** gather context → act → check the result, repeated until done. You can step in at any time.
- **Model + tools = agent.** The program around the model (Claude Code, Copilot CLI) is the **harness**.
- **It sees your whole project:** files, terminal, git state, `CLAUDE.md`, and any extensions you add.
- **Every session starts empty.** Put lasting rules in `CLAUDE.md`. Resume old sessions with `--continue` or `--resume`.
- **Context window:** everything goes in it. When full, it compacts and early details can get lost. `/context` shows usage.
- **Two safety nets:** checkpoints (`Esc Esc` undoes file edits, not deploys or databases) and permission modes (`Shift+Tab`).
- **Work style:** iterate instead of restarting, and delegate the goal, not every step.

**Copilot note:** in Copilot, press `Esc` twice while the agent is idle to open the rewind picker. You choose to rewind only the chat, or the chat and the files. It works outside git repos too. `Ctrl+C` is the hard stop: it cancels at once.

---



#### 5. Extend Claude Code (Study)

- Claude Code: [Extend Claude Code](https://code.claude.com/docs/en/features-overview)
- Copilot CLI: [Comparing Copilot CLI customization features](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features)

**Why:** A map of all the ways to extend the agent and when to use each one. Both tools have almost the same list.


| Section                         | Focus  | Copilot section                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| ------------------------------- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Overview                        | ⭐ Read | [Introduction](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features#introduction)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| Match features to your goal     | ⭐ Read | One section per feature: [Custom instructions](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features#custom-instructions), [Skills](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features#skills), [Tools](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features#tools), [MCP servers](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features#mcp-servers), [Hooks](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features#hooks), [Subagents](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features#subagents), [Custom agents](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features#custom-agents), [Plugins](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features#plugins) |
| → Build your setup over time    | ⭐ Read | [Putting it together: choosing the right option](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features#putting-it-together-choosing-the-right-option)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| → Compare similar features      | Skim   | "When should / shouldn't you use…" in each feature section, e.g. [Skills](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features#when-should-you-use-a-skill)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| → Understand how features layer | Skip   | —                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| → Combine features              | Skim   | —                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| Understand context costs        | ⭐ Read | —                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| Learn more                      | Skip   | [Further reading](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features#further-reading)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |




**Pay attention to:**

- **The options:** `CLAUDE.md` (always-on rules), skills (loaded when needed), subagents (separate context), MCP (outside tools), hooks (automatic actions), plugins (packages of all of these).
- **Add features when you hit a need.** Same mistake twice → `CLAUDE.md`. Same prompt again and again → skill. Must happen every time → hook.
- `CLAUDE.md` **vs skill:** needed every session → `CLAUDE.md`; needed sometimes → skill.
- **Hook vs skill:** a hook always runs; a skill is followed by the agent, so the result can vary.
- **Everything costs context.** Too much setup makes the agent worse, not better.

**Copilot note:** both tools use the same idea for most features: instructions, skills, MCP, hooks, plugins. Copilot also has "custom agents"; Claude Code calls them subagents.

---



#### 6. Explore the .claude directory (Glance)

- Claude Code: [Explore the .claude directory](https://code.claude.com/docs/en/claude-directory)
- Copilot CLI: [Copilot CLI configuration directory](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference)

**Why:** Shows where each config file lives. Good to know; you don't need to memorize it.


| Section                                  | Focus  | Copilot section                                                                                                                                                                                                                                                                                              |
| ---------------------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Explore the directory (interactive tree) | ⭐ Read | [Directory overview](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference#directory-overview), [User-editable files](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference#user-editable-files)                                 |
| What's not shown                         | Skim   | —                                                                                                                                                                                                                                                                                                            |
| Choose the right file                    | ⭐ Read | [Configuration file settings](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference#configuration-file-settings)                                                                                                                                                       |
| File reference                           | Skip   | —                                                                                                                                                                                                                                                                                                            |
| Frontmatter fields by file               | Skip   | —                                                                                                                                                                                                                                                                                                            |
| Troubleshoot configuration               | Skip   | —                                                                                                                                                                                                                                                                                                            |
| Application data                         | Skip   | [Automatically managed files](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference#automatically-managed-files), [What you can safely delete](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference#what-you-can-safely-delete) |
| Related resources                        | Skip   | [Further reading](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference#further-reading)                                                                                                                                                                               |


**Pay attention to:**

- **Two levels:** project files in the repo (shared with the team) and personal files in `~/.claude/` (all your projects).
- **Where things go:** rules → `CLAUDE.md`, permissions and hooks → `settings.json`, workflows → `skills/`, subagents → `agents/`, team MCP servers → `.mcp.json`.
- **Personal overrides** you don't commit go in `settings.local.json` or `CLAUDE.local.md`.
- **Company-managed settings beat everything,** then command-line flags, then your files.
- **Transcripts are plain text** and kept 30 days. A secret the agent reads ends up in them.

**Copilot note:** Copilot CLI also reads `CLAUDE.md`, `AGENTS.md`, `.claude/skills/` and parts of `.claude/settings.json`. One setup in a repo can serve both tools.

---



#### 7. Explore the context window (Study)

- Claude Code: [Explore the context window](https://code.claude.com/docs/en/context-window)
- Copilot CLI: [Managing context in Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/context-management)

**Why:** The context window is the agent's working memory. It is the main limit on how well an agent performs.


| Section                            | Focus            | Copilot section                                                                                                                                                                                                                                                                          |
| ---------------------------------- | ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Interactive timeline (top of page) | ⭐ Read (play it) | [About the context window](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/context-management#about-the-context-window)                                                                                                                                                   |
| What the timeline shows            | ⭐ Read           | [Why the context window matters](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/context-management#why-the-context-window-matters)                                                                                                                                       |
| What survives compaction           | Skim             | [What compaction does](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/context-management#what-compaction-does), [What compaction does not preserve](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/context-management#what-compaction-does-not-preserve) |
| When your context fills up         | ⭐ Read           | [Compaction](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/context-management#compaction), [Using long-running sessions](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/context-management#using-long-running-sessions)                                 |
| Check your own session             | ⭐ Read           | [Checking your context usage](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/context-management#checking-your-context-usage)                                                                                                                                             |
| Related resources                  | Skip             | [Further reading](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/context-management#further-reading)                                                                                                                                                                     |


**Pay attention to:**

- **The context window is the agent's working memory:** instructions, files read, command output and the chat.
- **Some of it is used before you type:** `CLAUDE.md`, memory, MCP tool names, skill descriptions.
- **When it fills up, the chat is summarized.** `CLAUDE.md` is reloaded, but early details can be lost.
- **Habits:** `/clear` between tasks, `/compact focus on X` before a big task, send research to a subagent.
- `/context` shows what fills it. It works in Copilot CLI too.

**Copilot note:** Copilot starts compacting by itself at about 80% full, in the background, so you rarely wait. Each summary is saved as a checkpoint; `/session checkpoints` lists them. Tool output over 20 KiB goes to a file, and the agent gets only a preview.

---



#### 8. Prompt caching (Glance)

- Claude Code: [How Claude Code uses prompt caching](https://code.claude.com/docs/en/prompt-caching)
- Copilot CLI: no page for users. Copilot only mentions that it uses caching, in [Model hosting](https://docs.github.com/en/copilot/reference/ai-models/model-hosting).

**Why:** Explains why some actions make the next reply slow and expensive. This matters when tokens are limited.


| Section                           | Focus                  | Copilot section |
| --------------------------------- | ---------------------- | --------------- |
| How the cache is organized        | ⭐ Read                 | —               |
| Actions that invalidate the cache | ⭐ Read (just the list) | —               |
| Actions that keep the cache       | Skim                   | —               |
| Resuming a session                | Skim                   | —               |
| Cache lifetime                    | Skim                   | —               |
| Cache scope                       | Skip                   | —               |
| Check cache performance           | Skip                   | —               |
| Subagents and the cache           | Skip                   | —               |
| Disable prompt caching            | Skip                   | —               |
| Related resources                 | Skip                   | —               |


**Pay attention to:**

- **The model remembers nothing.** Each turn resends the whole chat; the cache makes that fast and cheap.
- **These break the cache,** so the next turn is slower and costs more: switching models, adding or removing MCP servers or plugins, compacting.
- **Editing** `CLAUDE.md` **mid-session doesn't apply** until `/clear`, `/compact` or a restart.
- **Rule for any tool:** pick the model at the start of a task and don't switch in the middle.

**Copilot note:** Copilot uses prompt caching too, but you can't see or control it, and its docs don't list what breaks it. The same habits are a safe bet: one model per task, and no adding MCP servers in the middle.

---



### Try it (in Copilot CLI): Core concepts

1. In a repo, run `copilot` and ask it to fix a small bug. Watch the loop: it reads, edits, runs something, checks.
2. Press `Esc` in the middle of a task, then give it a new direction.
3. Run `/context` and see what fills the window.
4. Run `/compact focus on <your task>`, then `/context` again.
5. Look inside `~/.copilot/` and your repo's `.github/` folder. Find which config files you already have.

---



### Group: Use Claude Code

How to work with an agent day to day. The habits here matter more than any single feature.

---



#### 9. Store instructions and memories (Study)

- Claude Code: [How Claude remembers your project](https://code.claude.com/docs/en/memory)
- Copilot CLI: [Adding custom instructions](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-custom-instructions), [About Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory)

**Why:** The instructions file is the most important thing you set up in a repo. The agent reads it at the start of every session.


| Section                                                                    | Focus                                             | Copilot section                                                                                                                                                                                                                                                                         |
| -------------------------------------------------------------------------- | ------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CLAUDE.md vs auto memory                                                   | ⭐ Read                                            | [Types of custom instructions](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-custom-instructions#types-of-custom-instructions), [Types of memories](https://docs.github.com/en/copilot/concepts/agents/copilot-memory#types-of-memories)                 |
| CLAUDE.md files (when to add, where, set up, write effective instructions) | ⭐ Read                                            | [Creating repository-wide custom instructions](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-custom-instructions#creating-repository-wide-custom-instructions)                                                                                           |
| → Import additional files                                                  | Skim                                              | [Referencing other files](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-custom-instructions#referencing-other-files)                                                                                                                                     |
| → How CLAUDE.md files load                                                 | Skim                                              | [How multiple instruction files interact](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-custom-instructions#how-multiple-instruction-files-interact)                                                                                                     |
| → Organize rules with `.claude/rules/`                                     | Skim                                              | [Creating path-specific custom instructions](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-custom-instructions#creating-path-specific-custom-instructions)                                                                                               |
| → Manage CLAUDE.md for large teams                                         | Skip                                              | —                                                                                                                                                                                                                                                                                       |
| AGENTS.md                                                                  | ⭐ Read ("Share one file with other coding tools") | [Types of custom instructions](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-custom-instructions#types-of-custom-instructions)                                                                                                                           |
| Auto memory                                                                | Skim                                              | [How Copilot Memory stores information](https://docs.github.com/en/copilot/concepts/agents/copilot-memory#how-copilot-memory-stores-retains-and-uses-information), [Enabling Copilot Memory](https://docs.github.com/en/copilot/concepts/agents/copilot-memory#enabling-copilot-memory) |
| View and edit with `/memory`                                               | Skim                                              | [Slash commands](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#slash-commands-in-the-interactive-interface) (`/instructions`)                                                                                                                |
| Troubleshoot memory issues                                                 | Skim ("Claude isn't following my CLAUDE.md")      | —                                                                                                                                                                                                                                                                                       |
| Related resources                                                          | Skip                                              | —                                                                                                                                                                                                                                                                                       |


**Pay attention to:**

- **Two kinds of memory:** `CLAUDE.md`, which you write, and auto memory, which the agent writes. Both load every session.
- **Add to** `CLAUDE.md` **when** the agent repeats a mistake or you repeat a correction.
- **Keep it short and concrete** (under ~200 lines): commands, conventions, gotchas. `/init` writes a first draft.
- **Instructions are advice, not rules.** Use a hook for anything that must never happen.
- **Use** `AGENTS.md` **for a team on several tools.** Claude Code and Copilot CLI both read it.
- `/memory` **and** `/context` show which files actually loaded.

**Copilot note:** Copilot's version of auto memory is Copilot Memory, in public preview. It stores memories on GitHub, not on your machine, and your org may need to turn it on.

---



#### 10. Manage sessions (Glance)

- Claude Code: [Manage sessions](https://code.claude.com/docs/en/sessions)
- Copilot CLI: [Chronicle (session history)](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/chronicle), [Working with multiple sessions](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/work-with-multiple-sessions)

**Why:** How to come back to earlier work, name it, and branch it.


| Section                         | Focus  | Copilot section                                                                                                                                                                                                                                                                             |
| ------------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Resume a session                | ⭐ Read | [Resume an interactive session](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/overview#resume-an-interactive-session), [Resuming a previous session](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/chronicle#resuming-a-previous-session) |
| Name your sessions              | Skim   | [Renaming a session](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/chronicle#renaming-a-session)                                                                                                                                                                   |
| Use the session picker          | Skim   | [Session picker shortcuts](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#session-picker-shortcuts)                                                                                                                                               |
| Branch a session                | ⭐ Read | [Slash commands](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#slash-commands-in-the-interactive-interface) (`/fork`, `/branch`)                                                                                                                 |
| Manage context within a session | ⭐ Read | [Session management commands](https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-best-practices#session-management-commands)                                                                                                                                                        |
| Export and locate session data  | Skim   | [Sharing a session](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/chronicle#sharing-a-session), [Deleting sessions](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/chronicle#deleting-sessions)                                            |
| See also                        | Skip   | —                                                                                                                                                                                                                                                                                           |


**Pay attention to:**

- **Sessions are saved as you go.** `--continue` resumes the last one; `--resume` lets you pick.
- **Name sessions** (`/rename`) when you run several, then resume by name.
- `/branch` copies the chat so you can try another approach safely.
- `/clear` starts fresh, `/compact` summarizes, `/context` shows usage.
- **Copilot CLI has the same,** plus `/chronicle` to search past sessions.

**Copilot note:** Copilot has two extras here:

- **Chronicle** searches your past sessions and gives tips (`/chronicle standup`, `/chronicle cost-tips`).
- **A sessions sidebar** lets you run several sessions side by side.

---



#### 11. Common workflows (Study)

- Claude Code: [Common workflows](https://code.claude.com/docs/en/common-workflows)
- Copilot CLI: [Best practices → Common workflows](https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-best-practices#5-common-workflows), [Using Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/overview)

**Why:** Ready-made recipes for everyday tasks: understand code, fix bugs, write tests, open PRs.


| Section                                   | Focus  | Copilot section                                                                                                                                                                                                                                                  |
| ----------------------------------------- | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Prompt recipes → Understand new codebases | ⭐ Read | [Codebase onboarding](https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-best-practices#codebase-onboarding)                                                                                                                                             |
| → Fix bugs efficiently                    | ⭐ Read | [Bug investigation](https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-best-practices#bug-investigation)                                                                                                                                                 |
| → Refactor code                           | Skim   | [Refactoring](https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-best-practices#refactoring)                                                                                                                                                             |
| → Work with tests                         | ⭐ Read | [Test-driven development](https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-best-practices#test-driven-development)                                                                                                                                     |
| → Create pull requests                    | Skim   | [Creating a pull request](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/manage-pull-requests#creating-a-pull-request)                                                                                                                   |
| → Handle documentation                    | Skim   | —                                                                                                                                                                                                                                                                |
| → Work in notes and non-code folders      | Skim   | —                                                                                                                                                                                                                                                                |
| → Work with images                        | Skim   | [Attach images and PDFs](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/overview#attach-images-and-pdfs), [Using images for UI work](https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-best-practices#using-images-for-ui-work) |
| → Reference files and directories         | ⭐ Read | [Include a specific file in your prompt](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/overview#include-a-specific-file-in-your-prompt)                                                                                                 |
| → Run Claude on a schedule                | Skim   | [Schedule prompts to run later](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/overview#schedule-prompts-to-run-later)                                                                                                                   |
| → Ask Claude about its capabilities       | Skim   | [Getting help within the CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-best-practices#within-the-cli)                                                                                                                                          |
| Resume previous conversations             | Skim   | [Resume an interactive session](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/overview#resume-an-interactive-session)                                                                                                                   |
| Run parallel sessions with worktrees      | Skim   | [Working with multiple sessions](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/work-with-multiple-sessions#introduction)                                                                                                                |
| Plan before editing                       | ⭐ Read | [Plan mode](https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-best-practices#plan-mode)                                                                                                                                                                 |
| Delegate research to subagents            | Skim   | [Subagents](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features#subagents)                                                                                                                                                     |
| Pipe Claude into scripts                  | Skim   | [Using Copilot CLI non-interactively](https://docs.github.com/en/copilot/get-started/cli-quickstart#using-github-copilot-cli-non-interactively)                                                                                                                  |
| Next steps                                | Skip   | —                                                                                                                                                                                                                                                                |


**Pay attention to:**

- **New code:** start broad ("give me an overview"), then narrow ("trace the login flow").
- **Bugs:** give the error and how to reproduce it. **Tests:** say what behavior to test, then have it run them.
- **PRs:** "summarize my changes" → "create a pr". Always review before submitting.
- `@file` puts a file straight into the prompt; you can also paste screenshots.
- **Habits:** plan mode for bigger changes, worktrees for parallel work, subagents for research, `-p` for scripts.

**Copilot note:** Copilot has extra PR commands: fix review feedback, fix CI failures, resolve merge conflicts. See [Managing pull requests](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/manage-pull-requests).

---



#### 12. Prompt library (Glance)

- Claude Code: [Prompt library](https://code.claude.com/docs/en/prompt-library)
- Copilot CLI: [Prompt engineering for Copilot](https://docs.github.com/en/copilot/concepts/prompting/prompt-engineering), plus the community collection [Awesome Copilot](https://awesome-copilot.github.com/)

**Why:** Ready-to-copy prompts, filtered by task and role. Good for ideas.


| Section                                | Focus                                         | Copilot section                                                                                                                                                                                                                                                                                                                                                                                                 |
| -------------------------------------- | --------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| The library (interactive, top of page) | Skim: filter by your role and try 2–3 prompts | [Awesome Copilot](https://awesome-copilot.github.com/)                                                                                                                                                                                                                                                                                                                                                          |
| What makes these prompts work          | ⭐ Read                                        | [Start general, then get specific](https://docs.github.com/en/copilot/concepts/prompting/prompt-engineering#start-general-then-get-specific), [Break complex tasks](https://docs.github.com/en/copilot/concepts/prompting/prompt-engineering#break-complex-tasks-into-simpler-tasks), [Indicate relevant code](https://docs.github.com/en/copilot/concepts/prompting/prompt-engineering#indicate-relevant-code) |
| Where these come from                  | Skip                                          | —                                                                                                                                                                                                                                                                                                                                                                                                               |
| Related resources                      | Skip                                          | [Further reading](https://docs.github.com/en/copilot/concepts/prompting/prompt-engineering#further-reading)                                                                                                                                                                                                                                                                                                     |


**Pay attention to:**

- **50+ copy-and-paste prompts,** filtered by task and role. Try the ones you've never used.
- **The six patterns behind them:** describe the outcome; ask it to check its work; point at an example; give a measurable target; paste the real error or log; say how you want the answer.
- **These patterns work in any agent.**

**Copilot note:** Awesome Copilot is more than prompts. It has hundreds of community agents, instructions, skills and plugins. Its marketplace is already set up in Copilot CLI: `copilot plugin install <name>@awesome-copilot`. Third parties write them, so read one before you install it.

---



#### 13. Best practices (Study)

- Claude Code: [Best practices](https://code.claude.com/docs/en/best-practices)
- Copilot CLI: [Best practices for Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-best-practices)

**Why:** The most useful page in Part 1. It collects what works, from teams that use agents every day.


| Section                                                           | Focus  | Copilot section                                                                                                                                                                                                                                                                 |
| ----------------------------------------------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Intro (the context window fills up fast)                          | ⭐ Read | [Why the context window matters](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/context-management#why-the-context-window-matters)                                                                                                                              |
| Give Claude a way to verify its work                              | ⭐ Read | —                                                                                                                                                                                                                                                                               |
| Explore first, then plan, then code                               | ⭐ Read | [The explore → plan → code → commit workflow](https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-best-practices#the-explore--plan--code--commit-workflow)                                                                                                               |
| Provide specific context in your prompts                          | ⭐ Read | [Indicate relevant code](https://docs.github.com/en/copilot/concepts/prompting/prompt-engineering#indicate-relevant-code)                                                                                                                                                       |
| Configure your environment                                        | Skim   | [1. Customize your environment](https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-best-practices#1-customize-your-environment), [Recommended repository setup](https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-best-practices#recommended-repository-setup) |
| Communicate effectively (ask questions, let Claude interview you) | ⭐ Read | —                                                                                                                                                                                                                                                                               |
| Manage your session                                               | ⭐ Read | [3. Leverage infinite sessions](https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-best-practices#3-leverage-infinite-sessions), [Keep sessions focused](https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-best-practices#best-practice-keep-sessions-focused) |
| Automate and scale                                                | Skim   | [4. Delegate work effectively](https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-best-practices#4-delegate-work-effectively), [6. Advanced patterns](https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-best-practices#6-advanced-patterns)                    |
| Avoid common failure patterns                                     | ⭐ Read | —                                                                                                                                                                                                                                                                               |
| Develop your intuition                                            | ⭐ Read | —                                                                                                                                                                                                                                                                               |
| Related resources                                                 | Skip   | [Further reading](https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-best-practices#further-reading)                                                                                                                                                                    |


**Pay attention to:**

- **Context is the main limit.** The fuller it gets, the worse the agent gets.
- **Give it a way to check its work** (tests, build, screenshot). This is the biggest win.
- **Explore → plan → code → commit.** Skip the plan only for tiny changes.
- **Be specific,** and keep `CLAUDE.md` short. For each line ask: "would removing this cause mistakes?"
- **After two failed corrections,** `/clear` and write a better first prompt.
- **Scale up:** `-p` in scripts, parallel sessions, a fresh session to review the first one's work.
- **Avoid:** mixing unrelated tasks in one session, a bloated `CLAUDE.md`, trusting without checking, endless exploring.

**Copilot note:** the Copilot page has a useful "Team guidelines" part: [7. Team guidelines](https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-best-practices#7-team-guidelines). Worth reading for our team setup.

---



### Try it (in Copilot CLI): Use Claude Code

1. In a repo, run `/init`. Read the instructions file it creates and cut anything the agent could guess from the code.
2. Pick a small feature. Press `Shift+Tab` for plan mode (or run `/plan`). Explore → plan → then let it code.
3. In the same prompt, ask it to run the tests and fix any failures.
4. Run `/clear` before starting an unrelated task.
5. Exit, then run `copilot --continue` to get back to where you were.

---



### Group: Platforms and integrations

The same agent runs in many places: terminal, IDE, desktop app, web, phone and CI. We focus on the CLI, so most of this group is **Glance** or **Skip**. Know that these options exist; come back when you need one.

---



#### 14. Platforms overview (Glance)

- Claude Code: [Overview](https://code.claude.com/docs/en/platforms)
- Copilot CLI: [About Copilot CLI → Modes of use](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli#modes-of-use), [About the GitHub Copilot app](https://docs.github.com/en/copilot/concepts/agents/github-copilot-app)

**Why:** One page that shows every place the agent can run, and when to pick which.


| Section                                   | Focus  | Copilot section                                                                                                                                                                                                                                                       |
| ----------------------------------------- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Where to run Claude Code                  | ⭐ Read | [Modes of use](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli#modes-of-use), [What can I do with the Copilot app?](https://docs.github.com/en/copilot/concepts/agents/github-copilot-app#what-can-i-do-with-the-github-copilot-app) |
| Connect your tools                        | Skim   | [Integrating cloud agent with third-party tools](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent#integrating-copilot-cloud-agent-with-third-party-tools)                                                                             |
| Work when you are away from your terminal | Skim   | [When remote control helps](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-remote-control#when-remote-control-helps)                                                                                                                            |


**Pay attention to:**

- **Where it runs:** CLI (the most complete), desktop app, VS Code, JetBrains, web (cloud) and phone.
- **Local surfaces share your setup** (`CLAUDE.md`, settings, MCP servers).
- **Local vs cloud:** local uses your machine and files; cloud keeps running when your laptop is closed.
- **Integrations:** Chrome, GitHub Actions, GitLab, Code Review, Slack, and anything else through MCP.

**Copilot note:** Copilot has the same spread: the CLI, the GitHub Copilot app (a desktop app built on the CLI that runs parallel sessions, each on its own branch), Copilot in VS Code and JetBrains, and the cloud agent on GitHub. In Business and Enterprise, the app has its own admin policy, on by default.

---



#### 15. Remote Control (Glance)

- Claude Code: [Remote Control](https://code.claude.com/docs/en/remote-control)
- Copilot CLI: [About remote control](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-remote-control), [Steering a session remotely](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/steer-remotely)

**Why:** Keep a CLI session running on your machine and steer it from your phone or a browser.


| Section                          | Focus  | Copilot section                                                                                                                                                        |
| -------------------------------- | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Requirements                     | Skip   | [Prerequisites](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/steer-remotely#prerequisites)                                                   |
| Start a Remote Control session   | ⭐ Read | [Enabling remote control for a session](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/steer-remotely#enabling-remote-control-for-a-session)   |
| Connection and security          | Skim   | [Security and privacy](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-remote-control#security-and-privacy)                                       |
| Trusted Devices                  | Skip   | —                                                                                                                                                                      |
| Remote Control vs cloud sessions | ⭐ Read | —                                                                                                                                                                      |
| Mobile push notifications        | Skip   | [Accessing a session from GitHub Mobile](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/steer-remotely#accessing-a-session-from-github-mobile) |
| Limitations                      | Skim   | —                                                                                                                                                                      |
| Related resources                | Skip   | [Further reading](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/steer-remotely#further-reading)                                               |


**Pay attention to:**

- **The session keeps running on your machine;** your phone or browser is only a remote screen.
- **Start it:** `claude remote-control`, or `/remote-control` in a session, then scan the QR code.
- **Safe:** no open ports, and your files stay local.
- **Needs a claude.ai login** and the terminal must stay open.
- **Copilot CLI has the same feature** (github.com or GitHub Mobile).

**Copilot note:** turn it on with `/remote on`, or start with `copilot --remote`. `/keep-alive` stops your machine from sleeping while you're away. Your sessions sync to GitHub by default, but only as read-only views; you can steer one only with remote control on.

---



#### 16. Claude Code in the cloud: Get started (Glance)

- Claude Code: [Get started with Claude Code in the cloud](https://code.claude.com/docs/en/web-quickstart)
- Copilot CLI: [Delegating tasks to Copilot cloud agent](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/delegate-tasks-to-cca), [About Copilot cloud agent](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent)

**Why:** Hand a task to an agent in the cloud. It works on its own and comes back with a pull request.


| Section (Get started page)      | Focus  | Copilot section                                                                                                                                                             |
| ------------------------------- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| How sessions run                | ⭐ Read | [Overview of Copilot cloud agent](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent#overview-of-copilot-cloud-agent)                         |
| Compare ways to run Claude Code | ⭐ Read | [Cloud agent versus agent mode](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent#copilot-cloud-agent-versus-agent-mode)                     |
| Connect GitHub                  | Skip   | —                                                                                                                                                                           |
| Start a task                    | Skim   | [Delegate tasks to Copilot cloud agent](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/delegate-tasks-to-cca#delegate-tasks-to-copilot-cloud-agent) |
| Pre-fill sessions               | Skip   | —                                                                                                                                                                           |
| Review and iterate              | Skim   | —                                                                                                                                                                           |
| Next steps                      | Skip   | —                                                                                                                                                                           |


**Pay attention to:**

- **What it is:** Claude Code on a cloud machine. It clones your GitHub repo, does the task and pushes a branch.
- **Good for:** several tasks in parallel, repos you don't have locally, and tasks you don't need to watch.
- **Start:** claude.ai/code, the phone app, or `claude --cloud "task"`.
- **Write the task clearly:** name the file, paste the error, describe the expected result.
- **Copilot equivalent:** the Copilot cloud agent (`/delegate`).

**Copilot note:** of all these platforms, the Copilot cloud agent is the one our team is most likely to use. Check if our org has it on: [Making cloud agent available](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent#making-copilot-cloud-agent-available).

---



#### 17. Claude Code in the cloud: Reference (Skip)

- Claude Code: [Use Claude Code in the cloud](https://code.claude.com/docs/en/claude-code-on-the-web)
- Copilot CLI: [About Copilot cloud agent](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent)

**Why:** Details on how cloud sessions work. Read it only if our team starts using cloud agents.


| Section                               | Focus  | Copilot section                                                                                                                                                                                                                                                                                                                     |
| ------------------------------------- | ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Cloud environments                    | Skip   | [Customizing Copilot cloud agent](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent#customizing-copilot-cloud-agent)                                                                                                                                                                                 |
| GitHub authentication options         | Skip   | —                                                                                                                                                                                                                                                                                                                                   |
| Move tasks between terminal and cloud | ⭐ Read | [Delegate tasks to cloud agent](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/delegate-tasks-to-cca#delegate-tasks-to-copilot-cloud-agent), [Starting a cloud session from the CLI](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/use-cloud-agent-from-cli#starting-a-session) |
| Work with sessions                    | Skim   | [Tracking your sessions](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/use-cloud-agent-from-cli#tracking-your-sessions)                                                                                                                                                                                 |
| Auto-fix pull requests                | Skim   | [Fixing review feedback](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/manage-pull-requests#fixing-review-feedback)                                                                                                                                                                                        |
| Security and isolation                | Skim   | [Cloud sandboxing](https://docs.github.com/en/copilot/concepts/security-governance-and-network-settings/about-cloud-and-local-sandboxes#cloud-sandboxing)                                                                                                                                                                           |
| Troubleshooting                       | Skip   | —                                                                                                                                                                                                                                                                                                                                   |
| Limitations                           | Skip   | [Limitations of cloud agent](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent#limitations-of-copilot-cloud-agent)                                                                                                                                                                                   |
| Related resources                     | Skip   | —                                                                                                                                                                                                                                                                                                                                   |


**Pay attention to:**

- **Move work between places:** `claude --cloud` sends a task to the cloud (push your branch first); `claude --teleport` pulls a cloud session back to your terminal.
- **Tip:** plan locally, then run in the cloud.
- **Auto-fix:** it can watch a PR and fix CI failures or review comments.
- **Each session runs in an isolated VM** with limited network access.
- **Cloud sessions share your plan's usage limits.**

---



#### 18. Routines (Glance)

- Claude Code: [Routines](https://code.claude.com/docs/en/routines)
- Copilot CLI: [About automations](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-automations) (cloud), [Scheduling prompts](https://docs.github.com/en/copilot/how-tos/copilot-cli/automate-copilot-cli/schedule-prompts) (in the CLI)

**Why:** Run the agent on a schedule or on an event, with no one at the keyboard. Examples: a nightly dependency check, triage of new issues.


| Section            | Focus  | Copilot section                                                                                                     |
| ------------------ | ------ | ------------------------------------------------------------------------------------------------------------------- |
| Example use cases  | ⭐ Read | [Overview](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-automations#overview)               |
| Create a routine   | Skim   | —                                                                                                                   |
| Configure triggers | Skim   | [Triggers](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-automations#triggers)               |
| Manage routines    | Skip   | —                                                                                                                   |
| Usage and limits   | Skip   | [Billing](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-automations#billing)                 |
| Related resources  | Skip   | [Further reading](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-automations#further-reading) |


**Pay attention to:**

- **A routine is a saved prompt + repos + connectors** that runs by itself in the cloud, even with your laptop off.
- **Triggers:** a schedule, an API call (for example from an alert), or GitHub events (a new PR).
- **Create one** at claude.ai/code/routines or with `/schedule daily PR review at 9am`.
- **Write a self-contained prompt.** Nobody is there to answer questions.
- **A green run only means it didn't crash.** Open it to check the result.

**Copilot note:** Copilot has two versions:

- **Automations** run the cloud agent on a schedule (hourly, daily or weekly) or when an issue or PR opens. They work only in private or internal repos, and the cloud agent must be on for the repo.
- **In the CLI,** `/every 1h <prompt>` repeats a prompt and `/after 30m <prompt>` runs it once later. They run only while the session is open, and they are experimental (`/experimental on`).

---



#### 19. Ultrareview (Skip)

- Claude Code: [Find bugs with ultrareview](https://code.claude.com/docs/en/ultrareview)
- Copilot CLI: [Copilot code review → Review effort level](https://docs.github.com/en/copilot/concepts/agents/code-review#review-effort-level)

**Why:** A deeper, slower code review that runs many agents in the cloud and double-checks each finding. It is paid per run.


| Section                                  | Focus  | Copilot section                                                                                                                                   |
| ---------------------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| Run ultrareview from the CLI             | Skim   | —                                                                                                                                                 |
| Pricing and free runs                    | Skip   | [Code review usage](https://docs.github.com/en/copilot/concepts/agents/code-review#code-review-usage)                                             |
| Track a running review                   | Skip   | —                                                                                                                                                 |
| Run ultrareview non-interactively        | Skip   | —                                                                                                                                                 |
| How ultrareview compares to /code-review | ⭐ Read | [About agentic code review](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/agentic-code-review#about-agentic-code-review) |
| Related resources                        | Skip   | —                                                                                                                                                 |


**Pay attention to:**

- **A deep, paid code review in the cloud:** many agents, and each finding is checked before it's reported.
- **Run:** `/code-review ultra` (your branch) or `/code-review ultra 1234` (a PR). It takes about 5–10 minutes.
- **Cost:** 3 free runs on Pro and Max, then about $5–25 per review.
- **Use** `/code-review` **for quick feedback,** and ultra before merging big or risky changes.

---



#### 20. Projects (Skip)

- Claude Code: [Let Claude coordinate ongoing work with Projects](https://code.claude.com/docs/en/claude-projects)
- Copilot CLI: [Copilot Spaces](https://docs.github.com/en/copilot/concepts/context/spaces) (closest, but not the same)

**Why:** One long-running conversation where Claude starts many parallel cloud sessions for related tasks, over days or weeks. Public beta.


| Section                                           | Focus | Copilot section                                                                                                                            |
| ------------------------------------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| When to use a project                             | Skim  | [Why use Copilot Spaces?](https://docs.github.com/en/copilot/concepts/context/spaces#why-use-copilot-spaces)                               |
| How a project is organized                        | Skip  | —                                                                                                                                          |
| Create a project                                  | Skip  | —                                                                                                                                          |
| Work in a project                                 | Skip  | —                                                                                                                                          |
| Give a project standing context                   | Skim  | [Where can I use Spaces?](https://docs.github.com/en/copilot/concepts/context/spaces#where-can-i-use-spaces)                               |
| Project settings reference                        | Skip  | —                                                                                                                                          |
| Usage and cost                                    | Skip  | [How does using Spaces affect my usage?](https://docs.github.com/en/copilot/concepts/context/spaces#how-does-using-spaces-affect-my-usage) |
| How projects relate to other Claude Code features | Skim  | —                                                                                                                                          |
| Limitations, Troubleshooting, Related resources   | Skip  | —                                                                                                                                          |


**Pay attention to:**

- **One coordinator conversation** that runs many cloud threads for a stream of related work, over days.
- **Good for:** one goal across many repos, or an area you keep feeding with small tasks.
- **Set project instructions first,** then test with one small task.
- **Uses a lot of tokens** (Opus by default). Pro and Max only, public beta.
- **Copilot has no real match.**

---



#### 21. Desktop app: Get started (Skip)

- Claude Code: [Get started with the desktop app](https://code.claude.com/docs/en/desktop-quickstart)
- Copilot CLI: [Quickstart for the GitHub Copilot app](https://docs.github.com/en/copilot/get-started/quickstart-copilot-app)

**Why:** Install the desktop app and run a first session. Same agent as the CLI, with a visual interface.


| Section                  | Focus | Copilot section                                                                                                                                                                                                                                                                      |
| ------------------------ | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Install                  | Skip  | [Installing the Copilot app](https://docs.github.com/en/copilot/get-started/quickstart-copilot-app#installing-the-github-copilot-app)                                                                                                                                                |
| Start your first session | Skim  | [Connecting a repository or folder](https://docs.github.com/en/copilot/get-started/quickstart-copilot-app#connecting-a-repository-or-folder), [Making your first code changes](https://docs.github.com/en/copilot/get-started/quickstart-copilot-app#making-your-first-code-changes) |
| Now what?                | Skim  | [Orienting yourself](https://docs.github.com/en/copilot/get-started/quickstart-copilot-app#orienting-yourself)                                                                                                                                                                       |
| What's next              | Skip  | [Next steps](https://docs.github.com/en/copilot/get-started/quickstart-copilot-app#next-steps)                                                                                                                                                                                       |


**Pay attention to:**

- **Same engine as the CLI,** with a graphical interface. The Code tab works on your files.
- **Sessions can run** locally, in the cloud, over SSH, or in WSL.
- **Review changes** in a diff view and comment on single lines.
- **Copilot equivalent:** the GitHub Copilot app.

---



#### 22. Desktop app: Reference (Skip)

- Claude Code: [Desktop application](https://code.claude.com/docs/en/desktop)
- Copilot CLI: [Copilot app: agent sessions](https://docs.github.com/en/copilot/how-tos/github-copilot-app/agent-sessions)

**Why:** Everything the desktop app can do: parallel sessions, diff review, workspace layout.


| Section                      | Focus  | Copilot section                                                                                                                                 |
| ---------------------------- | ------ | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| Start a session              | Skip   | [Starting a session](https://docs.github.com/en/copilot/how-tos/github-copilot-app/agent-sessions#starting-a-session)                           |
| Work with code               | Skim   | —                                                                                                                                               |
| Arrange your workspace       | Skip   | —                                                                                                                                               |
| Let Claude use your computer | Skip   | —                                                                                                                                               |
| Manage sessions              | Skim   | [Managing sessions and chats](https://docs.github.com/en/copilot/how-tos/github-copilot-app/agent-sessions#managing-sessions-and-chats)         |
| Extend Claude Code           | Skip   | —                                                                                                                                               |
| Environment configuration    | Skip   | [Using cloud and local sandboxes](https://docs.github.com/en/copilot/how-tos/github-copilot-app/agent-sessions#using-cloud-and-local-sandboxes) |
| Enterprise configuration     | Skip   | —                                                                                                                                               |
| Coming from the CLI?         | ⭐ Read | —                                                                                                                                               |
| Troubleshooting              | Skip   | —                                                                                                                                               |


**Pay attention to:**

- **Shares setup with the CLI** (`CLAUDE.md`, settings, skills, MCP). You can use both on one project.
- **Extras:** a built-in browser preview that checks its own changes, a diff view, parallel sessions, and PR status with auto-fix.
- `/desktop` moves a CLI session into the app.
- **Use the app for visual review and parallel work; use the CLI for scripts.**

---



#### 23. Desktop app: Linux (beta) (Skip)

- Claude Code: [Claude Desktop on Linux](https://code.claude.com/docs/en/desktop-linux)
- Copilot CLI: [Copilot app → Supported operating systems](https://docs.github.com/en/copilot/concepts/agents/github-copilot-app#supported-operating-systems)

**Why:** Install notes for Ubuntu and Debian.


| Section                                  | Focus | Copilot section |
| ---------------------------------------- | ----- | --------------- |
| Requirements, Install, Update, Uninstall | Skip  | —               |
| Troubleshoot                             | Skip  | —               |
| What's not in the Linux beta yet         | Skim  | —               |


**Pay attention to:**

- **Beta** for Ubuntu 22.04+ and Debian 12+. Install with `sudo apt install claude-desktop` (after adding the repo).
- **Missing on Linux:** computer use and voice dictation. Other distros should use the CLI.

---



#### 24. Desktop app: Windows (WSL) (Skip)

- Claude Code: [Claude Code Desktop in WSL](https://code.claude.com/docs/en/desktop-wsl)
- Copilot CLI: —

**Why:** Run desktop app sessions inside WSL 2 on Windows.


| Section                     | Focus | Copilot section |
| --------------------------- | ----- | --------------- |
| Requirements                | Skip  | —               |
| Start a WSL session         | Skip  | —               |
| What works in a WSL session | Skim  | —               |
| Managed devices             | Skip  | —               |


**Pay attention to:**

- **On Windows, runs a desktop session inside WSL 2,** with Linux tools and paths.
- **Use it when your repo lives inside WSL.** Some features (terminal pane, plugins) aren't there yet.

---



#### 25. Desktop app: Scheduled tasks (Skip)

- Claude Code: [Schedule recurring tasks in Desktop](https://code.claude.com/docs/en/desktop-scheduled-tasks)
- Copilot CLI: [About automations](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-automations), [Creating automations](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/create-automations)

**Why:** Run a prompt on a schedule from the desktop app, for example a daily dependency check.


| Section                         | Focus  | Copilot section                                                                                                                                     |
| ------------------------------- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| Compare scheduling options      | ⭐ Read | —                                                                                                                                                   |
| Create a scheduled task         | Skip   | [Creating an automation](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/create-automations#creating-an-automation)       |
| Schedule options                | Skip   | [Triggers](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-automations#triggers)                                               |
| How scheduled tasks run         | Skim   | —                                                                                                                                                   |
| Missed runs                     | Skip   | —                                                                                                                                                   |
| Permissions for scheduled tasks | Skip   | [Security and safety](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-automations#security-and-safety)                         |
| Manage scheduled tasks          | Skip   | [Managing your automations](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/create-automations#managing-your-automations) |
| Related resources               | Skip   | —                                                                                                                                                   |


**Pay attention to:**

- **Runs a prompt on a schedule on your machine,** with access to local files.
- **Only while the app is open and the computer is awake.** After sleep there is one catch-up run.
- **Cloud routines** run with your laptop off; `/loop` only runs inside an open session.
- **Tip:** click "Run now" once and allow the tools it needs, so later runs don't get stuck.

---



#### 26. Desktop app: iOS simulator (beta) (Skip)

- Claude Code: [Test iOS apps in the simulator](https://code.claude.com/docs/en/desktop-ios-simulator)
- Copilot CLI: —

**Why:** The desktop app opens your iOS app in the simulator so the agent can build, run and check it.


| Section                                | Focus | Copilot section |
| -------------------------------------- | ----- | --------------- |
| Requirements                           | Skip  | —               |
| Run your app in the simulator          | Skim  | —               |
| Control the simulator yourself         | Skip  | —               |
| How sessions manage devices            | Skip  | —               |
| Grant Claude access to a device        | Skip  | —               |
| Limitations, Troubleshooting, See also | Skip  | —               |


**Pay attention to:**

- **The desktop app (macOS) shows your iOS app in the simulator** next to the chat.
- **The agent can build, tap through and screenshot the app** to check its own work.
- **Needs Xcode.** Simulated devices only, not a real iPhone.

---



#### 27. Mobile (Skip)

- Claude Code: [Claude Code on mobile](https://code.claude.com/docs/en/mobile)
- Copilot CLI: [Copilot Chat in GitHub Mobile](https://docs.github.com/en/copilot/how-tos/copilot-on-github/chat-with-copilot/chat-in-mobile), [Remote control from GitHub Mobile](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/steer-remotely#accessing-a-session-from-github-mobile)

**Why:** Start, watch and steer agent tasks from your phone.


| Section              | Focus  | Copilot section                                                                                                                                                        |
| -------------------- | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Get the app          | Skip   | —                                                                                                                                                                      |
| Work from your phone | ⭐ Read | [Accessing a session from GitHub Mobile](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/steer-remotely#accessing-a-session-from-github-mobile) |
| Limitations          | Skim   | [Limitations](https://docs.github.com/en/copilot/how-tos/copilot-on-github/chat-with-copilot/chat-in-mobile#limitations)                                               |
| Related resources    | Skip   | —                                                                                                                                                                      |


**Pay attention to:**

- **The Claude phone app is only a remote screen;** no code runs on the phone.
- **Options:** cloud sessions, Projects, Remote Control (your computer), or Dispatch (the desktop app).
- **You can start tasks, steer them and answer questions** from the phone.
- **Copilot equivalent:** GitHub Mobile.

---



#### 28. Chrome extension (Glance)

- Claude Code: [Use Claude Code with Chrome](https://code.claude.com/docs/en/chrome)
- Copilot CLI: no built-in match. Use a browser MCP server, such as Playwright MCP: [Searching and installing from the MCP registry](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-mcp-servers#searching-and-installing-from-the-registry)

**Why:** Let the agent use your real browser: open your web app, click through it, read console errors. Useful for front-end work.


| Section                | Focus  | Copilot section |
| ---------------------- | ------ | --------------- |
| Capabilities           | ⭐ Read | —               |
| Prerequisites          | Skip   | —               |
| Get started in the CLI | Skim   | —               |
| Example workflows      | ⭐ Read | —               |
| Troubleshooting        | Skip   | —               |
| See also               | Skip   | —               |


**Pay attention to:**

- **The agent can use your real Chrome:** open pages, click, and read console errors.
- **Great for front-end work:** test flows on localhost, check UI against a design, debug from console errors.
- **It uses your logged-in sessions,** so approve only the sites you trust.
- **Start:** `claude --chrome`. Needs a claude.ai login.
- **Copilot:** no built-in match; add a browser MCP server such as Playwright MCP.

**Copilot note:** with Copilot CLI you get the same result by adding a browser MCP server (for example Playwright MCP) with `/mcp add`.

---



#### 29. Computer use (preview) (Skip)

- Claude Code: [Let Claude use your computer from the CLI](https://code.claude.com/docs/en/computer-use)
- Copilot CLI: —

**Why:** Let the agent see your screen and click and type in desktop apps (macOS). For testing native apps or tools that have no API.


| Section                                                     | Focus  | Copilot section |
| ----------------------------------------------------------- | ------ | --------------- |
| What you can do with computer use                           | Skim   | —               |
| When computer use applies                                   | Skip   | —               |
| Enable computer use                                         | Skip   | —               |
| Approve apps per session                                    | Skip   | —               |
| How Claude works on your screen                             | Skip   | —               |
| Safety and the trust boundary                               | ⭐ Read | —               |
| Example workflows                                           | Skim   | —               |
| Differences from the Desktop app, Troubleshooting, See also | Skip   | —               |


**Pay attention to:**

- **The agent can see your screen and control apps on your Mac** (preview, Pro and Max).
- **For things nothing else can reach:** native apps, simulators, tools with no API. It's the slowest option, so it's tried last.
- **You approve each app per session.** `Esc` stops it at any time.
- **It isn't sandboxed.** Approve only what the task needs.

---



#### 30. Visual Studio Code (Glance)

- Claude Code: [Visual Studio Code](https://code.claude.com/docs/en/vs-code)
- Copilot CLI: [Connecting Copilot CLI to VS Code](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/connecting-vs-code)

**Why:** Use the agent inside your editor, or connect the CLI to your editor.


| Section                                                                 | Focus  | Copilot section                                                                                                                          |
| ----------------------------------------------------------------------- | ------ | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Prerequisites, Install the extension                                    | Skip   | —                                                                                                                                        |
| Get started                                                             | Skim   | [Connecting to VS Code](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/connecting-vs-code#connecting-to-vs-code) |
| Use the prompt box, Customize your workflow, Manage plugins             | Skip   | —                                                                                                                                        |
| Automate browser tasks with Chrome                                      | Skip   | —                                                                                                                                        |
| VS Code commands and shortcuts, Configure settings, Use a screen reader | Skip   | —                                                                                                                                        |
| VS Code extension vs. Claude Code CLI                                   | ⭐ Read | —                                                                                                                                        |
| Work with git, Use third-party providers                                | Skip   | —                                                                                                                                        |
| Security and privacy, Uninstall, Next steps                             | Skip   | —                                                                                                                                        |


**Pay attention to:**

- **Two ways:** the extension (a chat panel with side-by-side diffs) or the CLI in VS Code's terminal.
- **Some things are CLI-only** (all commands, the `!` shortcut).
- **They share history:** `claude --resume` in the terminal continues a panel conversation.
- **Both tools connect a CLI to VS Code with** `/ide`**.**

**Copilot note:** Copilot CLI connects by itself when you start it in a folder that is open in VS Code. Then you can select code and just say "debug this", and edits open as diffs in VS Code with accept and reject buttons. The Copilot version of the Claude extension is Copilot Chat, built into VS Code.

---



#### 31. JetBrains IDEs (Skip)

- Claude Code: [JetBrains IDEs](https://code.claude.com/docs/en/jetbrains)
- Copilot CLI: [Copilot in JetBrains](https://docs.github.com/en/copilot/concepts/agents/copilot-in-jetbrains)

**Why:** Use the agent inside IntelliJ, PyCharm, WebStorm and other JetBrains IDEs. Read it if that's your IDE.


| Section                               | Focus  | Copilot section                                                                                                                                                 |
| ------------------------------------- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Supported IDEs                        | Skip   | [Introduction](https://docs.github.com/en/copilot/concepts/agents/copilot-in-jetbrains#introduction)                                                            |
| Features                              | ⭐ Read | [Comparing entry points](https://docs.github.com/en/copilot/concepts/agents/copilot-in-jetbrains#comparing-entry-points)                                        |
| Installation                          | Skip   | [GitHub Copilot plugin](https://docs.github.com/en/copilot/concepts/agents/copilot-in-jetbrains#github-copilot-plugin)                                          |
| Usage                                 | Skim   | [Copilot CLI in the integrated terminal](https://docs.github.com/en/copilot/concepts/agents/copilot-in-jetbrains#github-copilot-cli-in-the-integrated-terminal) |
| Configuration, Special configurations | Skip   | —                                                                                                                                                               |
| Troubleshooting                       | Skip   | —                                                                                                                                                               |
| Security considerations               | Skip   | —                                                                                                                                                               |


**Pay attention to:**

- **The plugin runs the normal CLI** in the IDE terminal. Install both the CLI and the plugin.
- **You get:** the IDE's diff viewer, your selection shared automatically, and the IDE's lint errors.
- **From an outside terminal,** run `/ide` to connect.

---



#### 32. Security guidance plugin (Glance)

- Claude Code: [Catch security issues as Claude writes code](https://code.claude.com/docs/en/security-guidance)
- Copilot CLI: [Slash commands](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#slash-commands-in-the-interactive-interface) (`/security-review`)

**Why:** A plugin that makes the agent review its own changes for security bugs and fix them in the same session.


| Section                                    | Focus  | Copilot section |
| ------------------------------------------ | ------ | --------------- |
| Prerequisites, Install the plugin          | Skip   | —               |
| What the plugin checks                     | ⭐ Read | —               |
| Add your own rules                         | Skim   | —               |
| Usage cost                                 | Skip   | —               |
| Disable or uninstall                       | Skip   | —               |
| How the plugin integrates with Claude Code | Skip   | —               |
| How this fits with other security tools    | Skim   | —               |
| Troubleshooting, Related resources         | Skip   | —               |


**Pay attention to:**

- **A plugin that makes the agent check its own code for security bugs** while it writes, and fix them right away.
- **Three checks:** each edit (a quick pattern match), the end of each turn (a model review), each commit.
- **It doesn't block anything.** It's one layer, not full security.
- **Install:** `/plugin install security-guidance@claude-plugins-official`.
- **Copilot CLI:** `/security-review` on your local changes.

**Copilot note:** Copilot CLI has a built-in `/security-review` command that reviews your local changes for vulnerabilities.

---



#### 33. Claude Security plugin (Glance)

- Claude Code: [Scan your codebase for vulnerabilities](https://code.claude.com/docs/en/claude-security)
- Copilot CLI: [Slash commands](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#slash-commands-in-the-interactive-interface) (`/security-review`), [Copilot Autofix for code scanning](https://docs.github.com/en/code-security/concepts/code-scanning/autofix-for-code-scanning)

**Why:** Scan the whole codebase for vulnerabilities and turn findings into fixes you review.


| Section                                       | Focus  | Copilot section                                                                                                                  |
| --------------------------------------------- | ------ | -------------------------------------------------------------------------------------------------------------------------------- |
| Prerequisites, Models and providers           | Skip   | —                                                                                                                                |
| Install the plugin                            | Skip   | —                                                                                                                                |
| Scan and fix your codebase                    | ⭐ Read | —                                                                                                                                |
| Fix findings                                  | Skim   | [How autofix works](https://docs.github.com/en/code-security/concepts/code-scanning/autofix-for-code-scanning#how-autofix-works) |
| How the plugin fits with other security tools | Skim   | —                                                                                                                                |
| Troubleshooting, Related resources            | Skip   | —                                                                                                                                |


**Pay attention to:**

- **A deep, multi-agent security scan** of the whole codebase or just your changes (`/claude-security`).
- **Every finding is verified** before it's reported, with a report file in your repo.
- **Suggested fixes come as patch files** you apply yourself. Nothing is applied automatically.
- **Can use a lot of tokens.** Scan one area at a time on big repos.

**Copilot note:** on GitHub, Copilot Autofix suggests fixes for code scanning alerts. Check if our repos have code scanning on.

---



#### 34. Code Review (Glance)

- Claude Code: [Code Review](https://code.claude.com/docs/en/code-review)
- Copilot CLI: [About Copilot code review](https://docs.github.com/en/copilot/concepts/agents/code-review) (on PRs), [Agentic code review in the CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/agentic-code-review) (local)

**Why:** An agent reviews every pull request and leaves comments on the lines with problems.


| Section                              | Focus  | Copilot section                                                                                                                                                                                                                  |
| ------------------------------------ | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| How reviews work                     | ⭐ Read | [Introduction](https://docs.github.com/en/copilot/concepts/agents/code-review#introduction), [Agentic capabilities](https://docs.github.com/en/copilot/concepts/agents/code-review#agentic-capabilities-for-copilot-code-review) |
| Set up Code Review                   | Skip   | [Automatic pull request reviews](https://docs.github.com/en/copilot/concepts/agents/code-review#automatic-pull-request-reviews)                                                                                                  |
| Manually trigger reviews             | Skim   | —                                                                                                                                                                                                                                |
| Customize reviews                    | Skim   | [Enhancing Copilot's knowledge of a repository](https://docs.github.com/en/copilot/concepts/agents/code-review#enhancing-copilots-knowledge-of-a-repository)                                                                     |
| View usage, Pricing, Troubleshooting | Skip   | [Code review usage](https://docs.github.com/en/copilot/concepts/agents/code-review#code-review-usage)                                                                                                                            |
| Review a diff locally                | ⭐ Read | [About agentic code review](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/agentic-code-review#about-agentic-code-review)                                                                                |
| Related resources                    | Skip   | —                                                                                                                                                                                                                                |


**Pay attention to:**

- **Automatic PR reviews** by several agents, focused on real bugs, not style (Team and Enterprise).
- **Findings are ranked:** 🔴 fix before merge, 🟡 minor, 🟣 old bug.
- **Trigger on demand** with the comment `@claude review`. Tune it with `REVIEW.md`.
- **About $15–25 per review.**
- **On any plan:** `/code-review` reviews your changes locally. Copilot: code review on PRs, `/review` in the CLI.

**Copilot note:** Copilot code review on PRs is part of GitHub. We may already have it. Ask your org admin.

---



#### 35. GitHub Actions (Glance)

- Claude Code: [GitHub Actions](https://code.claude.com/docs/en/github-actions)
- Copilot CLI: [Copilot CLI in GitHub Actions](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/copilot-cli-in-github-actions), [Automating tasks with Copilot CLI and Actions](https://docs.github.com/en/copilot/how-tos/copilot-cli/automate-copilot-cli/automate-with-actions)

**Why:** Run the agent inside CI: review PRs, triage issues, fix failing builds.


| Section                          | Focus  | Copilot section                                                                                                                                                                                   |
| -------------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Setup                            | Skip   | [Setup](https://docs.github.com/en/copilot/how-tos/copilot-cli/automate-copilot-cli/automate-with-actions#setup)                                                                                  |
| Interactive and automation modes | ⭐ Read | [Using Copilot CLI in an Actions workflow](https://docs.github.com/en/copilot/how-tos/copilot-cli/automate-copilot-cli/automate-with-actions#using-copilot-cli-in-an-actions-workflow)            |
| Example use cases                | ⭐ Read | [Recommended approach: GitHub Agentic Workflows](https://docs.github.com/en/copilot/how-tos/copilot-cli/automate-copilot-cli/automate-with-actions#recommended-approach-github-agentic-workflows) |
| Use a cloud provider             | Skip   | [Authentication and billing options](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/copilot-cli-in-github-actions#authentication-and-billing-options)                             |
| Upgrade from beta                | Skip   | —                                                                                                                                                                                                 |
| What's next                      | Skip   | [Further reading](https://docs.github.com/en/copilot/how-tos/copilot-cli/automate-copilot-cli/automate-with-actions#further-reading)                                                              |


**Pay attention to:**

- **Runs Claude Code in your GitHub workflows.** Mention `@claude` in an issue or PR to get changes and commits.
- **Or run it automatically** on events or a schedule with a fixed prompt.
- **Setup:** `/install-github-app`.
- **Keep keys in GitHub Secrets,** give minimal permissions, and limit cost with `--max-turns`.
- **Copilot CLI also runs in Actions** with `-p`.

**Copilot note:** GitHub recommends [GitHub Agentic Workflows](https://docs.github.com/en/copilot/how-tos/copilot-cli/automate-copilot-cli/automate-with-actions#recommended-approach-github-agentic-workflows) over calling `copilot -p` in a workflow step, because they add guardrails. In org repos, use the built-in `GITHUB_TOKEN`, not a personal token: there's no long-lived secret, and the org pays. An org owner must turn on that billing policy.

---



#### 36. GitHub Actions with cloud providers (Skip)

- Claude Code: [Use Claude Code GitHub Actions with cloud providers](https://code.claude.com/docs/en/github-actions-cloud-providers)
- Copilot CLI: [Copilot CLI in Actions → Authentication and billing](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/copilot-cli-in-github-actions#authentication-and-billing-options), [Using your own model provider](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/use-byok-models)

**Why:** Run the Actions integration through AWS, Google Cloud or Azure instead of Anthropic's API.


| Section                      | Focus | Copilot section                                                                                                                                                       |
| ---------------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Choose your provider         | Skim  | [Authentication and billing options](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/copilot-cli-in-github-actions#authentication-and-billing-options) |
| Prerequisites                | Skip  | —                                                                                                                                                                     |
| Set up the integration       | Skip  | [Configuring your provider](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/use-byok-models#configuring-your-provider)                       |
| Troubleshooting, What's next | Skip  | —                                                                                                                                                                     |


**Pay attention to:**

- **The same GitHub Action, but billed through your cloud account** (AWS, Google Cloud or Azure).
- **Uses OIDC,** so there are no long-lived keys.
- **Only needed if the company buys models through a cloud provider.**

---



#### 37. GitHub Enterprise Server (Skip)

- Claude Code: [Claude Code with GitHub Enterprise Server](https://code.claude.com/docs/en/github-enterprise-server)
- Copilot CLI: [Setting up Copilot CLI with GitHub Enterprise Server](https://docs.github.com/en/copilot/copilot-on-ghes/set-up-copilot-cli)

**Why:** Connect the agent to a self-hosted GitHub. Only relevant if we run GitHub Enterprise Server.


| Section                                         | Focus | Copilot section                                                                                                                                            |
| ----------------------------------------------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| What works with GitHub Enterprise Server        | Skim  | [Supported capabilities](https://docs.github.com/en/copilot/copilot-on-ghes/set-up-copilot-cli#supported-capabilities-on-github-enterprise-server)         |
| Admin setup                                     | Skip  | [Configuring your GHES instance](https://docs.github.com/en/copilot/copilot-on-ghes/set-up-copilot-cli#configuring-your-github-enterprise-server-instance) |
| Developer workflow                              | Skim  | [Configuring your Copilot CLI client](https://docs.github.com/en/copilot/copilot-on-ghes/set-up-copilot-cli#configuring-your-copilot-cli-client-end-user)  |
| Plugin marketplaces on GHES                     | Skip  | —                                                                                                                                                          |
| Limitations, Troubleshooting, Related resources | Skip  | —                                                                                                                                                          |


**Pay attention to:**

- **Support for a self-hosted GitHub** (Enterprise Server). An admin connects it once.
- **Most features work;** the GitHub MCP server doesn't.
- **Check first whether your company uses github.com or its own server.**

---



#### 38. GitLab CI/CD (Skip)

- Claude Code: [Claude Code GitLab CI/CD](https://code.claude.com/docs/en/gitlab-ci-cd)
- Copilot CLI: [Running Copilot CLI programmatically → CI/CD integration](https://docs.github.com/en/copilot/how-tos/copilot-cli/automate-copilot-cli/run-cli-programmatically#cicd-integration)

**Why:** Same idea as GitHub Actions, for GitLab pipelines.


| Section                                    | Focus | Copilot section |
| ------------------------------------------ | ----- | --------------- |
| Why use Claude Code with GitLab?           | Skip  | —               |
| How it works                               | Skim  | —               |
| What can Claude do?                        | Skim  | —               |
| Setup                                      | Skip  | —               |
| Example use cases                          | Skim  | —               |
| Using with Amazon Bedrock and Google Cloud | Skip  | —               |
| Configuration examples                     | Skip  | —               |
| Best practices                             | Skim  | —               |
| Troubleshooting, Advanced configuration    | Skip  | —               |


**Pay attention to:**

- **Claude Code in GitLab pipelines:** mention `@claude` in an issue or MR and get an MR back. Beta.
- **Setup:** an API key as a masked CI variable, plus one job in `.gitlab-ci.yml`.
- **Limit cost** with `--max-turns` and job timeouts.
- **The same** `-p` **pattern works in any CI.**

---



#### 39. Claude Code in Slack (Skip)

- Claude Code: [Claude Code in Slack](https://code.claude.com/docs/en/slack)
- Copilot CLI: [Integrating Copilot cloud agent with Slack](https://docs.github.com/en/copilot/how-tos/copilot-integrations/integrate-cloud-agent-with-slack)

**Why:** Mention the agent in a Slack thread and it turns the discussion into a pull request.


| Section                                                 | Focus | Copilot section                                                                                                                                                                                                      |
| ------------------------------------------------------- | ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Use cases                                               | Skim  | [Introduction](https://docs.github.com/en/copilot/how-tos/copilot-integrations/integrate-cloud-agent-with-slack#introduction)                                                                                        |
| Prerequisites                                           | Skip  | [Prerequisites](https://docs.github.com/en/copilot/how-tos/copilot-integrations/integrate-cloud-agent-with-slack#prerequisites)                                                                                      |
| Setting up Claude Code in Slack                         | Skip  | [Connecting the GitHub app](https://docs.github.com/en/copilot/how-tos/copilot-integrations/integrate-cloud-agent-with-slack#connecting-the-github-app-to-your-github-account)                                       |
| How it works                                            | Skim  | [Using the GitHub app in Slack](https://docs.github.com/en/copilot/how-tos/copilot-integrations/integrate-cloud-agent-with-slack#using-the-github-app-in-slack)                                                      |
| User interface elements                                 | Skip  | —                                                                                                                                                                                                                    |
| Access and permissions                                  | Skip  | [Sessions, permissions and sandboxes](https://docs.github.com/en/copilot/how-tos/copilot-integrations/integrate-cloud-agent-with-slack#understanding-collaborative-sessions-permissions-code-channels-and-sandboxes) |
| What's accessible where                                 | Skip  | —                                                                                                                                                                                                                    |
| Best practices                                          | Skim  | —                                                                                                                                                                                                                    |
| Troubleshooting, Current limitations, Related resources | Skip  | —                                                                                                                                                                                                                    |


**Pay attention to:**

- **Mention** `@Claude` **in Slack** with a coding task. It starts a cloud session and posts progress in the thread.
- **Older version:** Team and Enterprise are moving to Claude Tag.
- **Be specific:** file names, the error, and what "done" means.
- **Copilot equivalent:** the GitHub app for Slack.

---



#### 40. Claude Tag (Skip)

- Claude Code: [Work with Claude Tag](https://code.claude.com/docs/en/claude-tag) (opens on claude.com)
- Copilot CLI: [Integrating Copilot cloud agent with Slack](https://docs.github.com/en/copilot/how-tos/copilot-integrations/integrate-cloud-agent-with-slack)

**Why:** Claude as a shared team member in Slack channels, set up once by an admin for everyone.


| Section                             | Focus | Copilot section                                                                                                                                                 |
| ----------------------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Plans that include Claude Tag       | Skip  | —                                                                                                                                                               |
| Where Claude Tag runs               | Skim  | —                                                                                                                                                               |
| Billing and spend limits            | Skip  | —                                                                                                                                                               |
| Put Claude Tag to work              | Skim  | [Using the GitHub app in Slack](https://docs.github.com/en/copilot/how-tos/copilot-integrations/integrate-cloud-agent-with-slack#using-the-github-app-in-slack) |
| Set Claude Tag up once for everyone | Skip  | —                                                                                                                                                               |
| Where to start with Claude Tag      | Skip  | —                                                                                                                                                               |


**Pay attention to:**

- **Claude as a shared team member in Slack.** Anyone in a channel can hand it work. Team and Enterprise.
- **Runs with the organization's access,** set by admins per channel, in a temporary sandbox.
- **Billed to the organization** with a monthly spend limit.
- **Copilot equivalent:** the GitHub app for Slack.

---



### Try it (in Copilot CLI): Platforms and integrations

1. On a branch with some changes, run `/review` and read what it finds.
2. If you use VS Code, run `/ide` to connect the CLI and see diffs in the editor.
3. If our org has the cloud agent: run `/delegate` with a small, clear task and review the PR it opens.

---

**End of Tab 1: Getting started.**

Next: [Tab 2: Build with Claude Code →](part1-tab2-build.md)
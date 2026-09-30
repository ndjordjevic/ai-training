# Part 1, Tab 2: Build with Claude Code

← [Back to the Part 1 index](part1-reading-map.md). How to read this map (priorities, columns) is explained there.

This is where the agent goes from "chat that edits code" to a tool you can shape: subagents, MCP, skills, hooks and scripting. It's the most important tab after "Core concepts".

### Group: Agents and parallel work

---

#### 41. Run agents in parallel (Study)

- Claude Code: [Run agents in parallel](https://code.claude.com/docs/en/agents)
- Copilot CLI: [About /fleet](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/fleet), [Comparing features → Subagents](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features#subagents)

**Why:** A short map of every way to run more than one agent at once, and when to pick each.


| Section                              | Focus  | Copilot section                                                                                                                                                   |
| ------------------------------------ | ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Intro (table of the five approaches) | ⭐ Read | [Introduction](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/fleet#introduction)                                                                 |
| Choose an approach                   | ⭐ Read | [When should you use /fleet?](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/fleet#when-should-you-use-fleet)                                     |
| Check on running work                | Skim   | [Slash commands](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#slash-commands-in-the-interactive-interface) (`/tasks`) |
| Learn more                           | Skip   | [Further reading](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/fleet#further-reading)                                                           |


**Pay attention to:**

- **Five ways to run several agents:** subagents, agent view, agent teams, dynamic workflows and Projects.
- **Pick by asking:** who coordinates? Do the workers need to talk? Do they edit the same files?
- **Subagents are the everyday tool;** the others are for bigger jobs.
- **Worktrees keep parallel edits apart.**
- **Every extra agent costs tokens.**

---



#### 42. Create custom subagents (Study)

- Claude Code: [Create custom subagents](https://code.claude.com/docs/en/sub-agents)
- Copilot CLI: [About custom agents](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-custom-agents), [Creating custom agents for Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-custom-agents-for-cli)

**Why:** Subagents keep your main chat clean. They do a side task in their own context window and return only a summary.


| Section                                | Focus  | Copilot section                                                                                                                                                                                                                                                                                    |
| -------------------------------------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Built-in subagents                     | ⭐ Read | [Built-in agents](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-custom-agents#built-in-agents)                                                                                                                                                                              |
| Quickstart: create your first subagent | ⭐ Read | [Creating a custom agent](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-custom-agents-for-cli#creating-a-custom-agent)                                                                                                                                           |
| Configure subagents                    | Skim   | [Agent profile format](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-custom-agents#agent-profile-format), [Where you can configure custom agents](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-custom-agents#where-you-can-configure-custom-agents) |
| Work with subagents                    | ⭐ Read | [Running agents as subagents](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-custom-agents#running-agents-as-subagents), [Using a custom agent](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-custom-agents-for-cli#using-a-custom-agent)  |
| Fork the current conversation          | Skim   | —                                                                                                                                                                                                                                                                                                  |
| Example subagents                      | Skim   | [Example agent profile](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-custom-agents#example-agent-profile)                                                                                                                                                                  |
| Next steps                             | Skip   | [Next steps](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-custom-agents#next-steps)                                                                                                                                                                                        |


**Pay attention to:**

- **A subagent works in its own context** and returns only a summary, so your chat stays clean.
- **Built-in:** Explore (read-only search), Plan, General-purpose.
- **A custom one is a Markdown file** in `.claude/agents/`: name, description, tools, model, instructions.
- **The description decides when it's used automatically.** You can also call one with `@name`.
- **Give reviewers read-only tools.**
- **Copilot:** custom agents in `.github/agents/`.

**Copilot note:** Copilot's **Rubber duck** agent asks a *different* model for a second opinion. Claude Code has nothing like it built in. See [Rubber duck](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/rubber-duck).

---



#### 43. Manage multiple agents with agent view (Glance)

- Claude Code: [Agent view](https://code.claude.com/docs/en/agent-view)
- Copilot CLI: [Working with multiple sessions](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/work-with-multiple-sessions)

**Why:** One screen to start many background sessions and see which ones need you. You hand off tasks, keep working, and check back later. Research preview.


| Section                            | Focus  | Copilot section                                                                                                                                                                                                                                                                                                      |
| ---------------------------------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Quick start                        | ⭐ Read | [Introduction](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/work-with-multiple-sessions#introduction)                                                                                                                                                                                      |
| Monitor sessions with agent view   | ⭐ Read | [Reading session status at a glance](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/work-with-multiple-sessions#reading-session-status-at-a-glance), [The Sessions tab](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/work-with-multiple-sessions#the-sessions-tab) |
| Dispatch new agents                | ⭐ Read | [Creating and closing sessions](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/work-with-multiple-sessions#creating-and-closing-sessions)                                                                                                                                                    |
| Manage sessions from the shell     | Skip   | —                                                                                                                                                                                                                                                                                                                    |
| How background sessions are hosted | Skip   | [Active and inactive sessions](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/work-with-multiple-sessions#active-and-inactive-sessions)                                                                                                                                                      |
| Troubleshooting                    | Skip   | —                                                                                                                                                                                                                                                                                                                    |
| Limitations                        | Skim   | —                                                                                                                                                                                                                                                                                                                    |
| Related resources, Version history | Skip   | —                                                                                                                                                                                                                                                                                                                    |


**Pay attention to:**

- `claude agents` **opens one screen** for all your background sessions: working, needs you, done.
- **Start background work** from that screen, with `claude --bg "task"`, or with `/bg` in a session.
- **Each session edits in its own worktree,** so they don't collide. Commit before deleting one.
- **Copilot equivalent:** the sessions sidebar.

**Copilot note:** Copilot has the same idea as a **sessions sidebar** inside the CLI. Press `n` in the sidebar to start a new background session, and use the status dots to see which session needs you. See [The sessions sidebar](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/work-with-multiple-sessions#the-sessions-sidebar).

---



#### 44. Run agent teams (Glance)

- Claude Code: [Run agent teams](https://code.claude.com/docs/en/agent-teams)
- Copilot CLI: [About /fleet](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/fleet) (closest match), [Speeding up task completion with /fleet](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/speed-up-task-completion)

**Why:** A lead agent splits a big job, hands parts to teammate agents, and they message each other. Experimental and off by default.


| Section                                  | Focus  | Copilot section                                                                                                                                                 |
| ---------------------------------------- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| When to use agent teams                  | ⭐ Read | [When should you use /fleet?](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/fleet#when-should-you-use-fleet)                                   |
| Enable agent teams                       | Skip   | —                                                                                                                                                               |
| Start your first agent team              | Skip   | [Using the /fleet slash command](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/speed-up-task-completion#using-the-fleet-slash-command) |
| Control your agent team                  | Skip   | [Monitoring progress](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/speed-up-task-completion#monitoring-progress)                      |
| How agent teams work                     | Skim   | [How /fleet works](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/fleet#how-fleet-works)                                                        |
| Use case examples                        | ⭐ Read | —                                                                                                                                                               |
| Best practices                           | Skim   | [Points to consider](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/fleet#points-to-consider)                                                   |
| Troubleshooting, Limitations, Next steps | Skip   | —                                                                                                                                                               |


**Pay attention to:**

- **A lead agent runs a team of full sessions** that share a task list and message each other. Experimental, off by default.
- **Best for:** reviews from several angles, and debugging with competing theories.
- **Tips:** 3–5 teammates, separate files for each, and put the task details in the prompt.
- **Costs much more than one session.**
- **Copilot's closest match is** `/fleet`**.**

---



#### 45. Cross-session messaging (Glance)

- Claude Code: [Message your other Claude Code sessions](https://code.claude.com/docs/en/cross-session-messaging)
- Copilot CLI: no equivalent.

**Why:** Your sessions can pass notes to each other. One session finds a breaking change and warns the session working on the affected code, so you don't copy and paste between terminals.


| Section                                  | Focus  | Copilot section |
| ---------------------------------------- | ------ | --------------- |
| When to use cross-session messaging      | ⭐ Read | —               |
| Message another session                  | ⭐ Read | —               |
| How a session treats an incoming message | Skim   | —               |
| Restrict cross-session messaging         | Skip   | —               |
| Availability                             | Skip   | —               |
| Limitations                              | Skim   | —               |
| Related resources                        | Skip   | —               |


**Pay attention to:**

- **Your sessions can send each other short text messages.** Just ask: "tell the payments session what we changed".
- **Uses:** warn about a breaking change, share a finding, get a status report.
- **A message can't approve actions or change settings.**
- **Copilot CLI has no equivalent.**

**Copilot note:** Copilot CLI can't send messages between sessions. The closest is running sessions side by side in the [sessions sidebar](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/work-with-multiple-sessions#the-sessions-sidebar) and switching between them yourself.

---



#### 46. Dynamic workflows (Glance)

- Claude Code: [Dynamic workflows](https://code.claude.com/docs/en/workflows)
- Copilot CLI: [copilot workflow run](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#using-copilot-workflow-run) (reference only), [/fleet](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/speed-up-task-completion)

**Why:** For jobs too big for a few subagents. The agent writes a script that runs many subagents and cross-checks their results. Example: audit 500 files for the same bug.


| Section                      | Focus         | Copilot section |
| ---------------------------- | ------------- | --------------- |
| When to use a workflow       | ⭐ Read        | —               |
| Run a bundled workflow       | Skip          | —               |
| Have Claude write a workflow | Skim          | —               |
| Example workflow prompts     | ⭐ Read        | —               |
| How a workflow runs          | Skip          | —               |
| Manage runs                  | Skim ("Cost") | —               |
| Related resources            | Skip          | —               |


**Pay attention to:**

- **For jobs too big for a few subagents:** Claude writes a script that runs many subagents and cross-checks their results.
- **Try it:** `/deep-research <question>`, or put `ultracode` in your prompt.
- **Good for:** audits of many files, big migrations, "keep fixing until tests pass".
- **Costs a lot of tokens.** Test on a small slice first.

---



#### 47. Isolate sessions with worktrees (Study)

- Claude Code: [Isolate sessions with worktrees](https://code.claude.com/docs/en/worktrees)
- Copilot CLI: [Command-line options](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#command-line-options) (`--worktree`), [Working with multiple sessions](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/work-with-multiple-sessions)

**Why:** Run two agents on the same repo without them overwriting each other's files.


| Section                                            | Focus  | Copilot section                                                                                                                                            |
| -------------------------------------------------- | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Start Claude in a worktree                         | ⭐ Read | [Command-line options](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#command-line-options) (`-w`, `--worktree`) |
| Clean up worktrees                                 | Skim   | —                                                                                                                                                          |
| Resume a worktree session                          | Skip   | —                                                                                                                                                          |
| How Claude Code enforces isolation                 | Skip   | —                                                                                                                                                          |
| Isolate subagents with worktrees                   | Skim   | —                                                                                                                                                          |
| Customize worktree creation                        | Skip   | —                                                                                                                                                          |
| What worktrees share with the main checkout        | ⭐ Read | —                                                                                                                                                          |
| Manage worktrees manually, Non-git version control | Skip   | —                                                                                                                                                          |
| Troubleshooting, See also                          | Skip   | —                                                                                                                                                          |


**Pay attention to:**

- **A worktree is a second copy of the repo on its own branch.** Each agent gets its own folder, so no collisions.
- **Start:** `claude --worktree <name>`, or ask "work in a worktree".
- **It's a fresh checkout:** install dependencies, and list files like `.env` in `.worktreeinclude`.
- **A clean worktree is removed on exit;** one with changes asks first.
- **Copilot CLI has the same:** `copilot --worktree <name>`.

---



### Try it (in Copilot CLI): Agents and parallel work

1. Ask: `use a subagent to find every place we call the payments API and summarize them`. Watch your main chat stay small (`/context`).
2. Run `/agent` to see the built-in agents.
3. Start a second session in a worktree: `copilot --worktree try-idea`. Make a change there; check that your main folder is untouched.
4. On a task with clear parts, try `/fleet <task>`.

---



### Group: MCP

---



#### 48. MCP quickstart (Study)

- Claude Code: [Connect to an MCP server](https://code.claude.com/docs/en/mcp-quickstart)
- Copilot CLI: [Adding MCP servers to Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-mcp-servers)

**Why:** MCP (Model Context Protocol) is the standard way to plug outside tools into an agent: GitHub, Jira, databases, browsers. One MCP server works in every agent that supports MCP.


| Section                                                  | Focus  | Copilot section                                                                                                                                                                                                                                                                                          |
| -------------------------------------------------------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Before you begin                                         | Skip   | —                                                                                                                                                                                                                                                                                                        |
| Add and verify a server                                  | ⭐ Read | [Using the /mcp add command](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-mcp-servers#using-the-mcp-add-command), [Using copilot mcp add](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-mcp-servers#using-the-copilot-mcp-add-subcommand) |
| Where servers are saved                                  | ⭐ Read | [Editing the configuration file](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-mcp-servers#editing-the-configuration-file)                                                                                                                                                |
| Change server scope                                      | ⭐ Read | [Adding per-repository MCP servers](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-mcp-servers#adding-per-repository-mcp-servers)                                                                                                                                          |
| Additional MCP server examples                           | Skim   | —                                                                                                                                                                                                                                                                                                        |
| Edit .mcp.json directly                                  | Skim   | [Adding per-repository MCP servers](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-mcp-servers#adding-per-repository-mcp-servers)                                                                                                                                          |
| Connect from other surfaces, Troubleshooting, Next steps | Skip   | [Managing MCP servers](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-mcp-servers#managing-mcp-servers)                                                                                                                                                                    |


**Pay attention to:**

- **MCP plugs outside tools into the agent:** issue trackers, databases, browsers, monitoring.
- **Add:** `claude mcp add --transport http <name> <url>`, or `claude mcp add <name> -- <command>` for a local server.
- **Check:** `claude mcp list`, or `/mcp` in a session (also used to log in).
- **Scope:** just you (default), you in all projects (`--scope user`), or the team via `.mcp.json` (`--scope project`).
- **Only add servers you trust,** and remove unused ones; they cost context.
- **Copilot CLI:** `/mcp add`; the GitHub server is built in.

---



#### 49. MCP reference (Glance)

- Claude Code: [MCP](https://code.claude.com/docs/en/mcp)
- Copilot CLI: [Adding MCP servers](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-mcp-servers), [Tool search](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/tool-search), [MCP server configuration reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#mcp-server-configuration)

**Why:** The full MCP reference. Read the first parts; use the rest when you need them.


| Section                                                       | Focus  | Copilot section                                                                                                                                                                   |
| ------------------------------------------------------------- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| What you can do with MCP                                      | ⭐ Read | [What is an MCP server?](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features#what-is-an-mcp-server)                                             |
| Find and build MCP servers                                    | Skim   | [Searching and installing from the registry](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-mcp-servers#searching-and-installing-from-the-registry) |
| Installing MCP servers                                        | Skim   | [Adding an MCP server](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-mcp-servers#adding-an-mcp-server)                                             |
| MCP installation scopes                                       | ⭐ Read | [Adding per-repository MCP servers](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-mcp-servers#adding-per-repository-mcp-servers)                   |
| Practical examples                                            | Skim   | —                                                                                                                                                                                 |
| Authenticate with remote MCP servers                          | Skip   | —                                                                                                                                                                                 |
| Add from JSON, Import from Claude Desktop, Use from claude.ai | Skip   | [MCP server configuration](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#mcp-server-configuration)                                     |
| Use Claude Code as an MCP server                              | Skip   | —                                                                                                                                                                                 |
| Output limits, Input schemas                                  | Skip   | —                                                                                                                                                                                 |
| Require approval for a specific tool                          | Skim   | [Allowed tools](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli#allowed-tools)                                                                   |
| Elicitation requests, MCP resources                           | Skip   | —                                                                                                                                                                                 |
| Scale with MCP tool search                                    | ⭐ Read | [Tool search → Introduction](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/tool-search#introduction)                                                             |
| MCP prompts as commands, Managed MCP configuration            | Skip   | —                                                                                                                                                                                 |


**Pay attention to:**

- **Connect tools to build from a Jira issue, check Sentry, query a database or use Figma designs.**
- **Only connect trusted servers.** Servers that fetch web content can carry prompt injection.
- **Use** `${ENV_VAR}` **in** `.mcp.json` so secrets stay out of git.
- **Tool search (on by default)** loads tool details only when needed, so many servers cost little context.
- **Large tool outputs can fill your context;** you get a warning above 10,000 tokens.

---



### Try it (in Copilot CLI): MCP

1. Run `/mcp` and see what's connected. The GitHub server is already there.
2. Ask: `list the open PRs in this repo that are waiting for my review`.
3. Add one MCP server that fits your work (for example, a database or Playwright for the browser) with `/mcp add`.

---



### Group: Skills

---



#### 50. Extend Claude with skills (Study)

- Claude Code: [Extend Claude with skills](https://code.claude.com/docs/en/skills)
- Copilot CLI: [Adding agent skills for Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-skills)

**Why:** A skill is a saved procedure the agent can follow, such as "how we deploy" or "how we write a migration". This is the best way to share team know-how with the agent.


| Section                         | Focus                         | Copilot section                                                                                                                                                         |
| ------------------------------- | ----------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Bundled skills                  | Skim                          | —                                                                                                                                                                       |
| Getting started                 | ⭐ Read                        | [Creating and adding a skill](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-skills#creating-and-adding-a-skill)                          |
| Choose where skills load        | ⭐ Read                        | [Creating and adding a skill](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-skills#creating-and-adding-a-skill) (skill folders)          |
| Configure skills                | ⭐ Read                        | [Example SKILL.md file](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-skills#example-skillmd-file)                                       |
| Advanced patterns               | Skim                          | [Enabling a skill to run a script](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-skills#enabling-a-skill-to-run-a-script)                |
| Evaluate and iterate on a skill | Skim                          | —                                                                                                                                                                       |
| Share skills                    | Skim                          | [Adding a skill someone else created](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-skills#adding-a-skill-that-someone-else-has-created) |
| Troubleshooting                 | Skim ("Skill not triggering") | —                                                                                                                                                                       |
| Related resources               | Skip                          | [Skills versus custom instructions](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-skills#skills-versus-custom-instructions)              |


**Pay attention to:**

- **A skill is a folder with a** `SKILL.md`**:** instructions plus optional scripts. It runs when it fits the task, or with `/skill-name`.
- **Cheap:** only the description loads each session; the body loads when used.
- **Where:** `.claude/skills/` (team) or `~/.claude/skills/` (you).
- **Key settings:** a clear `description`; `disable-model-invocation: true` for anything with side effects (like deploy).
- **Rule of thumb:** facts go in `CLAUDE.md`, procedures go in skills.
- **Same** `SKILL.md` **works in Copilot CLI** (open standard).

---



#### 51. Share session output as artifacts (Skip)

- Claude Code: [Share session output as artifacts](https://code.claude.com/docs/en/artifacts)
- Copilot CLI: [Slash commands](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#slash-commands-in-the-interactive-interface) (`/share html` exports a session as an HTML file)

**Why:** Turn the agent's output into a live web page on claude.ai that you can share: a report, a diagram, a dashboard.


| Section                                                   | Focus | Copilot section |
| --------------------------------------------------------- | ----- | --------------- |
| When to use an artifact                                   | Skim  | —               |
| Create an artifact                                        | Skim  | —               |
| Update an artifact, Find an artifact again                | Skip  | —               |
| Share an artifact, Read an artifact shared with you       | Skip  | —               |
| Collect comments on an artifact                           | Skip  | —               |
| Pull live data with MCP connectors                        | Skip  | —               |
| Offer a file download                                     | Skip  | —               |
| What you can build                                        | Skim  | —               |
| Improve the visual design                                 | Skip  | —               |
| Start from a Slides, Design, or Docs template             | Skip  | —               |
| Page constraints, Availability, Disable artifacts         | Skip  | —               |
| Manage artifacts for your organization, Related resources | Skip  | —               |


**Pay attention to:**

- **Turns the agent's output into a shareable web page** on claude.ai: a diff walkthrough, a chart, a comparison.
- **Private by default;** you choose who to share it with. People can comment and the agent can reply.
- **One page, no backend.** `/slides` and `/design` start from templates.
- **Copilot CLI:** `/share html` saves a session as an HTML file.

**Copilot note:** Copilot CLI has no hosted pages. `/share html` saves the session as an HTML file you can send.

---



### Try it (in Copilot CLI): Skills

1. Pick a task you explain to the agent again and again (for example, "how we add a new API endpoint").
2. Create `.github/skills/add-endpoint/SKILL.md` with a clear `description` and the steps.
3. Run `/skills reload`, then `/skills list` to check it's there.
4. Ask for a new endpoint *without* naming the skill. Did the agent pick it up? If not, improve the description.

---



### Group: Automation

---



#### 52. Automate with hooks (Study)

- Claude Code: [Automate with hooks](https://code.claude.com/docs/en/hooks-guide)
- Copilot CLI: [Using hooks with Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/use-hooks)

**Why:** Hooks run your own script at fixed moments: before a tool runs, after a file edit, when the agent finishes. Unlike instructions, **hooks always run**.


| Section                                           | Focus  | Copilot section                                                                                                                                                                                                                  |
| ------------------------------------------------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Set up your first hook                            | ⭐ Read | [Creating a repository-level hook](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/use-hooks#creating-a-repository-level-hook)                                                                          |
| What you can automate                             | ⭐ Read | [What problem do hooks solve?](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features#what-problem-do-hooks-solve)                                                                                |
| How hooks work                                    | Skim   | [Hooks reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#hooks-reference)                                                                                                      |
| Prompt-based hooks, Agent-based hooks, HTTP hooks | Skip   | —                                                                                                                                                                                                                                |
| Limitations and troubleshooting                   | Skip   | [Troubleshooting](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/use-hooks#troubleshooting), [Debugging](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/use-hooks#debugging) |
| Learn more                                        | Skip   | [Further reading](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/use-hooks#further-reading)                                                                                                            |


**Pay attention to:**

- **Hooks are your commands that run automatically** at fixed moments. Unlike instructions, they always run.
- **Uses:** format after every edit, block edits to `.env`, notify you when the agent needs input.
- **Main events:** `PreToolUse` (can block), `PostToolUse`, `Stop`, `Notification`, `SessionStart`.
- **Exit code 2 blocks the action** and tells the agent why.
- **Where:** `.claude/settings.json` (team) or `~/.claude/settings.json` (you). The easiest way is to ask the agent to write one.
- **Copilot CLI:** `.github/hooks/`, and it also reads Claude's hooks.

---



#### 53. Push external events to Claude (Skip)

- Claude Code: [Push events into a running session with channels](https://code.claude.com/docs/en/channels)
- Copilot CLI: —

**Why:** Send alerts, CI results or chat messages into a running session so the agent can react. Research preview.


| Section              | Focus  | Copilot section |
| -------------------- | ------ | --------------- |
| Supported channels   | Skim   | —               |
| Quickstart           | Skip   | —               |
| Security             | Skim   | —               |
| Enterprise controls  | Skip   | —               |
| Research preview     | Skip   | —               |
| How channels compare | ⭐ Read | —               |
| Next steps           | Skip   | —               |


**Pay attention to:**

- **Pushes outside events into your open session:** chat messages (Telegram, Discord, iMessage) or webhooks (CI, alerts). Research preview.
- **Only allowlisted senders can push messages.**
- **Start with** `--channels`**.**
- **Copilot CLI has no equivalent.**

---



#### 54. Run prompts on a schedule (Glance)

- Claude Code: [Run prompts on a schedule](https://code.claude.com/docs/en/scheduled-tasks)
- Copilot CLI: [Scheduling prompts in Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/automate-copilot-cli/schedule-prompts)

**Why:** Repeat a prompt while your session is open. Example: check CI every 5 minutes.


| Section                              | Focus  | Copilot section                                                                                                                                                                                   |
| ------------------------------------ | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Compare scheduling options           | ⭐ Read | —                                                                                                                                                                                                 |
| Run a prompt repeatedly with /loop   | ⭐ Read | [Scheduling a recurring prompt with /every](https://docs.github.com/en/copilot/how-tos/copilot-cli/automate-copilot-cli/schedule-prompts#scheduling-a-recurring-prompt-with-every)                |
| Set a one-time reminder              | Skim   | [Scheduling a once-only prompt with /after](https://docs.github.com/en/copilot/how-tos/copilot-cli/automate-copilot-cli/schedule-prompts#scheduling-a-once-only-prompt-with-after)                |
| Manage scheduled tasks               | Skip   | [Managing scheduled prompts](https://docs.github.com/en/copilot/how-tos/copilot-cli/automate-copilot-cli/schedule-prompts#managing-scheduled-prompts)                                             |
| How scheduled tasks run              | Skip   | [What happens when you close and reopen a session](https://docs.github.com/en/copilot/how-tos/copilot-cli/automate-copilot-cli/schedule-prompts#what-happens-when-you-close-and-reopen-a-session) |
| Cron expression reference            | Skip   | [Interval and delay syntax](https://docs.github.com/en/copilot/how-tos/copilot-cli/automate-copilot-cli/schedule-prompts#interval-and-delay-syntax)                                               |
| Disable scheduled tasks, Limitations | Skip   | —                                                                                                                                                                                                 |


**Pay attention to:**

- `/loop 5m <prompt>` repeats a prompt while the session is open. Without an interval, the agent picks the wait.
- **One-time reminders in plain words:** "in 45 minutes, check the tests".
- **Stops when the session ends;** recurring tasks expire after 7 days.
- **Copilot CLI:** `/every` and `/after`.

---



#### 55. Goals (Glance)

- Claude Code: [Goals](https://code.claude.com/docs/en/goal)
- Copilot CLI: [Autopilot mode](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/autopilot)

**Why:** Give the agent a finish line and let it keep working until it gets there.


| Section                                | Focus  | Copilot section                                                                                                                                                                       |
| -------------------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Compare ways to keep a session running | ⭐ Read | [Comparing autopilot, --allow-all and --no-ask-user](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/autopilot#comparing-autopilot-mode---allow-all-and---no-ask-user) |
| Use /goal                              | ⭐ Read | [Typical workflow for autopilot mode](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/autopilot#typical-workflow-for-using-autopilot-mode)                             |
| How evaluation works                   | Skim   | [Overview](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/autopilot#overview)                                                                                         |
| Requirements, See also                 | Skip   | [Things to consider](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/autopilot#things-to-consider)                                                                     |


**Pay attention to:**

- `/goal <condition>` keeps the agent working until a separate checker says the condition is met.
- **Write a checkable condition:** "all tests in test/auth pass and lint is clean".
- `/goal` shows status; `/goal clear` stops it.
- **Works in scripts too** (`claude -p "/goal …"`).
- **Copilot CLI has** `/goal` **too** (autopilot).

---



#### 56. Programmatic usage (Study)

- Claude Code: [Run Claude Code programmatically](https://code.claude.com/docs/en/headless)
- Copilot CLI: [Running Copilot CLI programmatically](https://docs.github.com/en/copilot/how-tos/copilot-cli/automate-copilot-cli/run-cli-programmatically), [Programmatic reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-programmatic-reference)

**Why:** Run the agent from scripts, git hooks and CI, with no chat. This is how you automate with agents.


| Section     | Focus  | Copilot section                                                                                                                                                                                                                                                                                                                  |
| ----------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Basic usage | ⭐ Read | [Introduction](https://docs.github.com/en/copilot/how-tos/copilot-cli/automate-copilot-cli/run-cli-programmatically#introduction), [Tips](https://docs.github.com/en/copilot/how-tos/copilot-cli/automate-copilot-cli/run-cli-programmatically#tips-for-using-copilot-cli-programmatically)                                      |
| Examples    | ⭐ Read | [Examples of programmatic usage](https://docs.github.com/en/copilot/how-tos/copilot-cli/automate-copilot-cli/run-cli-programmatically#examples-of-programmatic-usage), [Shell scripting patterns](https://docs.github.com/en/copilot/how-tos/copilot-cli/automate-copilot-cli/run-cli-programmatically#shell-scripting-patterns) |
| Next steps  | Skip   | [Command line options](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-programmatic-reference#command-line-options)                                                                                                                                                                                       |


**Pay attention to:**

- `claude -p "prompt"` runs once with no chat. It's the base for scripts and CI.
- **Pipe data in:** `cat error.log | claude -p "explain this"`.
- **Pre-approve tools,** since nobody can click "yes": `--allowedTools "Read,Edit,Bash"`.
- `--output-format json` for scripts (includes the cost).
- `--bare` skips your local setup, so results are the same on every machine.
- **Copilot CLI:** `copilot -p`, `-s`, `--allow-tool`.

---



#### 57. Launch sessions from links (Skip)

- Claude Code: [Launch sessions from links](https://code.claude.com/docs/en/deep-links)
- Copilot CLI: [Copilot app deep links](https://docs.github.com/en/copilot/how-tos/github-copilot-app/open-with-deep-links) (app only, not the CLI)

**Why:** A link in a runbook or alert opens the agent in the right repo with a ready prompt.


| Section                                  | Focus  | Copilot section                                                                                                               |
| ---------------------------------------- | ------ | ----------------------------------------------------------------------------------------------------------------------------- |
| How deep links work                      | Skim   | [Why use deep links](https://docs.github.com/en/copilot/how-tos/github-copilot-app/open-with-deep-links#why-use-deep-links)   |
| Build a link                             | Skip   | [Launcher URL format](https://docs.github.com/en/copilot/how-tos/github-copilot-app/open-with-deep-links#launcher-url-format) |
| Examples                                 | ⭐ Read | [Open sessions](https://docs.github.com/en/copilot/how-tos/github-copilot-app/open-with-deep-links#open-sessions)             |
| Registration and supported platforms     | Skip   | [Available app links](https://docs.github.com/en/copilot/how-tos/github-copilot-app/open-with-deep-links#available-app-links) |
| Open a VS Code tab instead of a terminal | Skip   | —                                                                                                                             |
| Troubleshooting, Learn more              | Skip   | —                                                                                                                             |


**Pay attention to:**

- **A** `claude-cli://` **link opens Claude Code** in the right repo with a prompt already typed.
- **Put links in** runbooks, alerts, dashboards and READMEs.
- **Safe:** nothing runs until you press Enter.

---



### Try it (in Copilot CLI): Automation

1. Add a repo hook in `.github/hooks/` that runs your formatter after every file edit. Ask for a change and check the file got formatted.
2. Write a one-line script: `git diff | copilot -sp "write a commit message for this diff"`.
3. On a branch with a failing test, run `/goal all tests pass` and watch it work.

---



### Group: Guides

---



#### 58. Monorepos and large repos (Glance)

- Claude Code: [Monorepos and large repos](https://code.claude.com/docs/en/large-codebases)
- Copilot CLI: [Path-specific custom instructions](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-custom-instructions#creating-path-specific-custom-instructions) (closest)

**Why:** How to keep the agent focused in a big codebase. Read it if you work in a monorepo.


| Section                                            | Focus  | Copilot section                                                                                                                                                                           |
| -------------------------------------------------- | ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| What this guide covers                             | Skim   | —                                                                                                                                                                                         |
| Choose where to start Claude                       | ⭐ Read | —                                                                                                                                                                                         |
| Layer CLAUDE.md files by directory                 | ⭐ Read | [Creating path-specific custom instructions](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-custom-instructions#creating-path-specific-custom-instructions) |
| Reduce what Claude reads                           | ⭐ Read | —                                                                                                                                                                                         |
| Scope worktrees and file access                    | Skip   | —                                                                                                                                                                                         |
| Add per-directory skills                           | Skim   | —                                                                                                                                                                                         |
| Centralize conventions when layering stops scaling | Skip   | —                                                                                                                                                                                         |
| Put it together                                    | Skim   | —                                                                                                                                                                                         |
| Scope and plan changes that span packages          | Skim   | —                                                                                                                                                                                         |
| Next steps                                         | Skip   | —                                                                                                                                                                                         |


**Pay attention to:**

- **Start the agent in the package you're working on,** not always the repo root.
- **Short root** `CLAUDE.md` **+ one per package.** Skip areas you never touch with `claudeMdExcludes`.
- **Read less:** block generated or vendored code, and add a language server plugin.
- **For changes across packages:** do it all in one session and plan first.

---



### Group: Troubleshooting

Use these when something breaks. No need to read them ahead of time, except "Debug your configuration".

---



#### 59. Troubleshoot installation and login (Skip)

- Claude Code: [Troubleshoot installation and login](https://code.claude.com/docs/en/troubleshoot-install)
- Copilot CLI: [Troubleshooting Copilot CLI authentication](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/troubleshoot-copilot-cli-auth), [Installing Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/install-copilot-cli)

**Why:** Fixes for install, PATH and login errors. Use it when something breaks.


| Section                    | Focus  | Copilot section                                                                                                                                                        |
| -------------------------- | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Find your error            | Skim   | [Authentication errors](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/troubleshoot-copilot-cli-auth#authentication-errors)                 |
| Run diagnostic checks      | ⭐ Read | [Slash commands](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#slash-commands-in-the-interactive-interface) (`/diagnose`)   |
| Common installation issues | Skip   | [Installing or updating Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/install-copilot-cli#installing-or-updating-copilot-cli) |
| Login and authentication   | Skip   | [Authentication errors](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/troubleshoot-copilot-cli-auth#authentication-errors)                 |
| Still stuck                | Skip   | —                                                                                                                                                                      |


**Pay attention to:**

- **A lookup page:** find your exact error message and its fix.
- **Most common:** `command not found` after install (a PATH issue), and corporate proxy or TLS errors.
- **Login problems:** `/logout`, then log in again.
- **Run** `claude doctor` **first.** Copilot CLI: `/diagnose`.

---



#### 60. Troubleshoot performance and stability (Skip)

- Claude Code: [Troubleshooting](https://code.claude.com/docs/en/troubleshooting)
- Copilot CLI: [Troubleshooting Copilot slowness](https://docs.github.com/en/copilot/how-tos/troubleshoot-copilot/troubleshoot-copilot-slowness)

**Why:** Fixes for high CPU or memory use, hangs and slow searches.


| Section                   | Focus | Copilot section                                                                                                                                                                   |
| ------------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Performance and stability | Skim  | [About the problem](https://docs.github.com/en/copilot/how-tos/troubleshoot-copilot/troubleshoot-copilot-slowness#about-the-problem)                                              |
| Get more help             | Skip  | [Slash commands](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#slash-commands-in-the-interactive-interface) (`/feedback`, `/diagnose`) |


**Pay attention to:**

- **A lookup page** for slowness, freezes and search problems.
- **Slow or heavy:** `/compact`, restart (`--continue` resumes), or `--safe-mode` to rule out plugins and hooks.
- **Frozen:** `Ctrl+C`. Nothing is lost; `--resume` picks it back up.

---



#### 61. Debug your configuration (Glance)

- Claude Code: [Debug your configuration](https://code.claude.com/docs/en/debug-your-config)
- Copilot CLI: [Slash commands](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#slash-commands-in-the-interactive-interface) (`/context`, `/instructions`, `/mcp`, `/skills`), [Hooks → Debugging](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/use-hooks#debugging)

**Why:** When "the agent ignores my setup", this page shows how to check what actually loaded.


| Section                            | Focus  | Copilot section                                                                                                                                                                      |
| ---------------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| See what loaded into context       | ⭐ Read | [Slash commands](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#slash-commands-in-the-interactive-interface) (`/context`, `/instructions`) |
| Check resolved settings            | Skim   | [Configuration file settings](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference#configuration-file-settings)                               |
| Check MCP servers                  | ⭐ Read | [Managing MCP servers](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-mcp-servers#managing-mcp-servers)                                                |
| Check hooks                        | Skim   | [Debugging](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/use-hooks#debugging)                                                                            |
| Test against a clean configuration | Skip   | —                                                                                                                                                                                    |
| Check common causes                | ⭐ Read | —                                                                                                                                                                                    |
| Related resources                  | Skip   | —                                                                                                                                                                                    |


**Pay attention to:**

- **When "it ignores my setup", check what actually loaded** before changing anything.
- **Tools:** `/context`, `/memory`, `/status`, `/mcp`, `/hooks`, `/doctor`, and `--safe-mode` (everything off).
- **Common mistakes:** a lowercase hook matcher (`bash` instead of `Bash`), a skill file not in its own folder, `.mcp.json` inside `.claude/`.
- **Copilot CLI:** `/context`, `/instructions`, `/mcp`, `/skills`.

---



#### 62. Error reference (Skip)

- Claude Code: [Error reference](https://code.claude.com/docs/en/errors)
- Copilot CLI: [Troubleshooting common issues → Rate limit](https://docs.github.com/en/copilot/how-tos/troubleshoot-copilot/troubleshoot-common-issues#error-youve-hit-a-rate-limit)

**Why:** What each error message means and how to fix it. Look things up here; don't read it start to end.


| Section                                         | Focus  | Copilot section                                                                                                                                           |
| ----------------------------------------------- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Find your error                                 | Skip   | —                                                                                                                                                         |
| Automatic retries                               | Skip   | —                                                                                                                                                         |
| Server errors                                   | Skip   | —                                                                                                                                                         |
| Usage limits                                    | Skim   | [Error: You've hit a rate limit](https://docs.github.com/en/copilot/how-tos/troubleshoot-copilot/troubleshoot-common-issues#error-youve-hit-a-rate-limit) |
| Authentication errors                           | Skip   | [Authentication errors](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/troubleshoot-copilot-cli-auth#authentication-errors)    |
| Network and connection errors, Request errors   | Skip   | —                                                                                                                                                         |
| Installation, Command-line, Plugin, Tool errors | Skip   | —                                                                                                                                                         |
| Background session, Wrapper and IDE errors      | Skip   | —                                                                                                                                                         |
| Rewind, Session saving, Configuration warnings  | Skip   | —                                                                                                                                                         |
| Responses seem lower quality than usual         | ⭐ Read | —                                                                                                                                                         |
| Report an error                                 | Skip   | —                                                                                                                                                         |


**Pay attention to:**

- **A lookup page** of every error message. Search; don't read it all.
- **Temporary errors are retried for you** before you see them.
- **Most common:** "Prompt is too long", fixed with `/compact` or `/clear`.
- **Worse answers than usual?** Check `/model`, `/effort` and `/context`, then rewind and rephrase.

---

**End of Tab 2: Build with Claude Code.**

Next: [Tab 3: Plugins →](part1-tab3-plugins.md)
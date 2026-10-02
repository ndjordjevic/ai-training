# Part 2: The Ecosystem, Part B: A Tour of agentic-ai-wiki

← [Part A: LLM wikis and pin-llm-wiki](part2-llm-wiki.md)

[agentic-ai-wiki](https://github.com/ndjordjevic/agentic-ai-wiki) is our map of the tools around coding agents. As of October 2026 it holds **273 sources in 16 categories**, collected since April 2026.

You don't need to know all of them. This page explains what each of its 16 categories contains and what it is for.

To see the tools in a category, open the wiki. For clickable `[[wikilinks]]` and the graph, read the wiki in Obsidian (see Part A).

---

## Two ways to use it: people and agents

The wiki is plain Markdown, so it works for both.

- **People read it** in Obsidian, or in any Markdown reader (VS Code, GitHub, any editor). Browse by category, follow links, check the sources.
- **Coding agents use it too.** Start Copilot CLI or Claude Code in the wiki folder and ask questions. The agent reads `wiki/index.md` first, finds the right pages, and answers with citations. From another project, give the agent access with `/add-dir <path-to-wiki>`, then ask, for example: "check the agentic-ai-wiki for a spec-driven tool that works with Copilot."

This is the important part. The wiki is not only notes for people to read. It is **knowledge an agent can use** while it works for you.

---

## The session plan

1. **Obsidian demo (10 min):** open the vault, start at `wiki/index.md`, go to `wiki/categories.md`, open one source, follow a link, check its `raw/` file, show the graph view and `log.md`.
2. **Category tour (20 min):** the 16 categories below. Spend the most time on harnesses, skills, spec-driven and knowledge.
3. **Ask the wiki (5 min):** run `copilot` inside the wiki folder and ask a question. It reads `wiki/index.md` first and cites the pages it used.

---

## The categories

The 16 categories, in the same order as the wiki's [`categories.md`](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/categories.md). The number in brackets is how many sources each one holds.

### 1. Agent frameworks & SDKs (30)

Libraries for building your own agents in code, in Python, TypeScript, .NET, Go or Java. They give you the agent loop, tool calling, memory and multi-agent patterns, so you don't write them yourself. Use them when you want an agent inside your own product or service, not to help you code.

### 2. Coding-agent harnesses & methodologies (38)

Ready-made ways of working with a coding agent: sets of rules, skills and loops that make it plan, write tests, check its work and finish the job. Some are full methods for the whole development cycle, others are loops that keep the agent running until a task list is done. It also holds guides and articles on how to work with agents well, for example in large codebases.

### 3. Agent Skills & plugins ecosystem (22)

Collections of skills (`SKILL.md` files) and plugins, and the directories and marketplaces where you find them. A skill teaches the agent one job, such as reviewing code, writing docs or following a team rule. Copilot CLI reads the same skill format, so most of these work for us too.

### 4. MCP servers & integrations (15)

MCP servers and APIs that connect an agent to outside tools and data: error monitoring, web search, email, notifications and more. Use them when the agent needs live data or needs to act in another system, not only read and write your code.

### 5. Spec-driven dev, planning & tasks (15)

Tools for writing the spec, the plan and the task list first, then letting the agent build from them. Some turn a requirements doc into tasks, some keep a task tracker the agent uses as memory across sessions, and some add a review step for plans. Use them for bigger features, where "just start coding" goes wrong.

### 6. Coding agents, IDEs & dev environments (22)

Other coding agents, editors and terminals built around agents, plus AI code review tools. This is where you see what exists besides Copilot and Claude Code, and how other tools solve the same problems. Useful for ideas, and for comparing before choosing a tool.

### 7. Knowledge, RAG, memory & context (38)

The biggest category. It covers giving the agent the right knowledge and keeping its context small: auto-generated docs for repos, code knowledge graphs, long-term memory, LLM wikis like this one, and tools that shrink command output to save tokens. Use it when the agent doesn't know your codebase well, or when sessions get long and expensive.

### 8. Browser & web automation (11)

Tools that let an agent use a browser: open pages, click, fill forms, take screenshots and read the web as clean text. Use them for UI testing, checking the agent's front-end work, or collecting data from websites.

### 9. Terminal, session & parallel-agent runners (10)

Tools for running many agents side by side and keeping track of them: terminal multiplexers, git worktree helpers, and boards that show what each agent is doing. Use them when you work on several tasks in parallel, each with its own agent.

### 10. Model infra, ML & providers (16)

Gateways that give one API for many models, tools for running models on your own machine, model providers, and ML learning material. Use them to switch or compare models, control cost, or run a model locally when code can't leave your network.

### 11. Workflow automation & no-code platforms (10)

Platforms for building automations and AI workflows without much code, by connecting apps with triggers and steps. Use them for business processes, such as handling emails or syncing tools, rather than for coding.

### 12. Design & UI generation (12)

Skills, design files and tools that help agents produce better-looking UI. Many give the agent a design system or style guide to follow, so the result doesn't look like generic AI output. Use them when an agent builds a front end.

### 13. Media, voice & content (8)

Voice dictation, video, audio and transcript tools. The most useful one for us is voice dictation, which lets you talk to the agent instead of typing long prompts.

### 14. Infra, hosting, DB & observability (13)

Places where agent-built apps run: hosting, databases, monitoring, and sandboxes for running agents safely. Use them when you need to deploy something quickly, or to run an agent in an isolated environment.

### 15. Security (4)

Security tools for the agent world: scanners that check a skill before you install it, and AI agents that do penetration testing. Use them before trusting skills from the internet, and for security testing.

### 16. Business, career & learning (9)

AI tools for sales, job search, reading and learning, plus courses and career guides. Not about coding, but useful context on where agents are used outside development.

---

### Try it (in Copilot CLI)

1. Clone the wiki: `git clone https://github.com/ndjordjevic/agentic-ai-wiki` and open it in Obsidian.
2. Pick one category (for example harnesses, skills or spec-driven) and read two of its source pages.
3. `cd` into the wiki folder and start `copilot`.
4. Ask: "Which spec-driven tools in this wiki work with Copilot?" Check that it answers from the wiki and cites pages.
5. Pick one tool that works with Copilot (for example rtk, OpenSpec or Superpowers) and try it on a small side project.

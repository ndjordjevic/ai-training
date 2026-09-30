# Part 2: The Ecosystem, Part B: A Tour of agentic-ai-wiki

← [Part A: LLM wikis and pin-llm-wiki](part2-llm-wiki.md)

[agentic-ai-wiki](https://github.com/ndjordjevic/agentic-ai-wiki) is our map of the tools around coding agents. As of September 2026 it holds **268 sources in 16 categories**, collected since April 2026.

You don't need to know all of them. This page sorts the categories into three groups and gives a few "start here" picks for each.

Links below open the wiki page on GitHub. For clickable `[[wikilinks]]` and the graph, read the wiki in Obsidian (see Part A).

---

## Two ways to use it: people and agents

The wiki is plain Markdown, so it works for both.

- **People read it** in Obsidian, or in any Markdown reader (VS Code, GitHub, any editor). Browse by category, follow links, check the sources.
- **Coding agents use it too.** Start Copilot CLI or Claude Code in the wiki folder and ask questions. The agent reads `wiki/index.md` first, finds the right pages, and answers with citations. From another project, give the agent access with `/add-dir <path-to-wiki>`, then ask, for example: "check the agentic-ai-wiki for a spec-driven tool that works with Copilot."

This is the important part. The wiki is not only notes for people to read. It is **knowledge an agent can use** while it works for you.

---

## The session plan

1. **Obsidian demo (10 min):** open the vault, start at `wiki/index.md`, go to `wiki/categories.md`, open one source, follow a link, check its `raw/` file, show the graph view and `log.md`.
2. **Category tour (20 min):** the three groups below.
3. **Ask the wiki (5 min):** run `copilot` inside the wiki folder and ask a question. It reads `wiki/index.md` first and cites the pages it used.

---

## Group 1: Core for us

These categories change how we work with Copilot CLI today. Open two or three picks in each.

### Coding-agent harnesses & methodologies (36)

Ready-made ways of working with an agent: rules, skills and loops that make it plan, test and finish the job.

- [obra-superpowers](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/obra-superpowers.md): a full development method built from 14 skills that trigger on their own. Works with Copilot CLI.
- [gsd-build-get-shit-done](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/gsd-build-get-shit-done.md): GSD, a spec-driven system that fights "context rot" in long sessions. Works with Copilot.
- [snarktank-ralph](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/snarktank-ralph.md): Ralph, a loop that runs the agent again and again on a task list until every task passes.
- [how-claude-code-works-in-large-codebases](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/how-claude-code-works-in-large-codebases.md): Anthropic's guide to agents in big and legacy codebases.

### Agent Skills & plugins ecosystem (21)

Collections of skills (`SKILL.md` files) and places to find them. Copilot CLI reads the same skill format.

- [anthropics-skills](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/anthropics-skills.md): Anthropic's official example skills, including a skill that helps you write skills.
- [skills.sh](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/skills.sh.md): the open skills directory, and the `npx skills` installer we use for pin-llm-wiki.
- [mattpocock-skills](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/mattpocock-skills.md): practical engineering skills, each aimed at one common agent failure.

### Spec-driven dev, planning & tasks (15)

Write the spec and the task list first, then let the agent build from them.

- [github-spec-kit](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/github-spec-kit.md): Spec Kit, GitHub's own spec-driven toolkit. Supports Copilot.
- [openspec.dev](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/openspec.dev.md): OpenSpec, a lighter option. No API keys, and it supports Copilot and 25+ other tools.
- [eyaltoledano-claude-task-master](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/eyaltoledano-claude-task-master.md): Taskmaster, which turns a requirements doc into a task graph.
- [gastownhall-beads](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/gastownhall-beads.md): Beads, an issue tracker the agent uses as memory across sessions. Works with Copilot CLI.

### Knowledge, RAG, memory & context (38)

The biggest category. It covers giving the agent the right knowledge and saving tokens.

- [deepwiki.com](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/deepwiki.com.md): DeepWiki, free auto-generated docs for any public GitHub repo.
- [rtk-ai-rtk](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/rtk-ai-rtk.md): rtk, a proxy that shrinks command output before the agent reads it (60–90% fewer tokens). Works with Copilot.
- [mksglu-context-mode](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/mksglu-context-mode.md): Context Mode, which keeps big tool outputs out of the context window. Works with Copilot CLI.

### MCP servers & integrations (15)

MCP servers that connect an agent to outside tools and data.

- [mcp.sentry.dev](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/mcp.sentry.dev.md): Sentry's official MCP server, which gives the agent live production errors.
- [sequentialthinking-mcp](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/sequentialthinking-mcp.md): a tiny MCP server with one tool for step-by-step thinking. A good example to learn from.

### Coding agents, IDEs & dev environments (22)

Other coding agents and review tools, so you know what else is out there.

- [kiro.dev](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/kiro.dev.md): Kiro, Amazon's coding agent, built around specs (requirements, design, tasks).
- [warp.dev](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/warp.dev.md): Warp, a terminal rebuilt around running agents.
- [coderabbit.ai](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/coderabbit.ai.md): CodeRabbit, AI review for the flood of agent-written pull requests.

---

## Group 2: Good to know

Useful when a specific need comes up. One pick each.

| Category | Count | What it is | Start here |
|---|---|---|---|
| Agent frameworks & SDKs | 29 | Libraries for building your own agents in code. | [microsoft-agent-framework](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/microsoft-agent-framework.md) (Python and .NET). Also: [OpenAI Agents SDK](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/developers.openai.com.md), [LangGraph](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/langchain.com-langgraph.md), [Pydantic AI](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/pydantic-pydantic-ai.md) |
| Browser & web automation | 10 | Let the agent use a browser: test, click, read pages. | [microsoft-playwright-mcp](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/microsoft-playwright-mcp.md) |
| Terminal, session & parallel-agent runners | 10 | Run many agents side by side and keep track of them. | [vibekanban.com](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/vibekanban.com.md) |
| Security | 4 | Scan skills before installing, and AI pentesting. | [nvidia-skillspector](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/nvidia-skillspector.md) |
| Model infra, ML & providers | 16 | Gateways to many models, local models, ML basics. | [litellm.ai](https://github.com/ndjordjevic/agentic-ai-wiki/blob/main/wiki/sources/litellm.ai.md) |

---

## Group 3: Mention only

Real tools, but outside our daily coding work. Name them and move on.

| Category | Count | What it is |
|---|---|---|
| Design & UI generation | 12 | Tools and skills that make agents produce better-looking UI. |
| Workflow automation & no-code platforms | 10 | n8n, Zapier and similar: automations without code. |
| Infra, hosting, DB & observability | 13 | Where agent-built apps run: Vercel, Supabase, Sentry and more. |
| Media, voice & content | 8 | Voice dictation, video and audio tools. |
| Business, career & learning | 9 | AI for sales, job search and reading. |

---

### Try it (in Copilot CLI)

1. Clone the wiki: `git clone https://github.com/ndjordjevic/agentic-ai-wiki` and open it in Obsidian.
2. Pick one category from Group 1 and read two of its source pages.
3. `cd` into the wiki folder and start `copilot`.
4. Ask: "Which spec-driven tools in this wiki work with Copilot?" Check that it answers from the wiki and cites pages.
5. Pick one tool that works with Copilot (for example rtk, OpenSpec or Superpowers) and try it on a small side project.

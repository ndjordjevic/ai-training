# Part 2: The Ecosystem, Part A: LLM Wikis

Part 2 is about the tools, libraries and frameworks around coding agents. There are hundreds, and they change every week. We keep track of them in a wiki: **agentic-ai-wiki**. This page explains what kind of wiki it is and how it is built. The next page, [Part B: a tour of agentic-ai-wiki](part2-agentic-ai-wiki.md), walks through what is inside it.

---

## 1. What is an LLM wiki?

An **LLM wiki** is a folder of Markdown pages that an AI agent writes and keeps up to date for you. You choose the sources, and the agent does the reading, summarizing and linking.

Andrej Karpathy described the idea in April 2026: [LLM Wiki (gist)](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f). Karpathy is a well-known AI researcher: a founding member of OpenAI, then head of AI for Tesla's Autopilot, then founder of the AI education company Eureka Labs, and since May 2026 a researcher at Anthropic on Claude's pre-training team. He also coined the term "vibe coding" (2025), and later "agentic engineering" (February 2026): you don't write most of the code yourself, you direct agents that do and check their work.

### The problem it solves

Normally, when you ask an AI about your documents, it searches them and reads the matching parts again for every question (this is called RAG). Nothing is learned between questions. In Karpathy's words: *"The LLM is rediscovering knowledge from scratch on every question. There's no accumulation."*

An LLM wiki does the reading **once**, when you add a source. The summary, the links to related pages and the notes on contradictions are written down and kept. Each new source makes the wiki richer.

### Three layers

| Layer | What it is | Who writes it |
|---|---|---|
| **Raw sources** | Copies of the original articles, repos, videos. Never changed. | You pick them. The agent saves them. |
| **The wiki** | Summary pages, linked to each other with `[[wikilinks]]`, with citations back to the raw sources. | The agent. |
| **The schema** | A file like `AGENTS.md` or `CLAUDE.md` with the rules: page layout, naming, how to cite. | You (once). |

### Three jobs

- **Ingest:** add a source. The agent reads it, writes a summary page, and updates the index and any related pages.
- **Query:** ask a question. The agent reads the wiki first and answers with citations to wiki pages.
- **Lint:** a health check. It finds broken links, orphan pages, stale claims and gaps.

Two special pages hold it together: **`index.md`** (the list of every page, read first) and **`log.md`** (a dated history of every change).

### Why it works

*"The tedious part of maintaining a knowledge base is not the reading or the thinking, it's the bookkeeping."* People give up on wikis because updating links and summaries is boring. An agent doesn't mind. You pick the sources and ask the questions; the agent does the bookkeeping.

### Why it fits a team

- **It is just Markdown in git.** You can review every change in a diff, like code.
- **Any agent can use it.** Claude Code, Copilot and Cursor all read Markdown.
- **It is readable by people too.** Open the folder in [Obsidian](https://obsidian.md) to browse pages and see a graph of the links.

---

## 2. pin-llm-wiki: the tool that builds our wiki

[pin-llm-wiki](https://github.com/ndjordjevic/pin-llm-wiki) is an agent **skill** that runs Karpathy's pattern for you. You give it a URL, and it fetches the source, saves a raw copy, and writes a cited wiki page.

It is one `SKILL.md` (see skills in Part 1), so it works in **Claude Code, GitHub Copilot and Cursor**. You start it with `/pin-llm-wiki`.

### Install

Run this in the folder that should become a wiki:

```bash
npx skills@latest add ndjordjevic/pin-llm-wiki
```

### Commands

| Command | What it does |
|---|---|
| `/pin-llm-wiki init` | Creates the wiki folder structure and the `AGENTS.md` rules. |
| `/pin-llm-wiki queue <url>` | Adds a URL to `inbox.md` for later. |
| `/pin-llm-wiki ingest <url>` | Fetches and ingests one URL now. Without a URL, it processes the whole inbox. |
| `/pin-llm-wiki lint` | Checks the wiki's health and makes small safe fixes. |
| `/pin-llm-wiki remove <slug>` | Moves a source to an archive folder. |

### What it can read

| Source | How it is fetched | Saved to |
|---|---|---|
| **GitHub repo** | `gh`: the README, the file layout and the docs | `raw/github/` |
| **YouTube video** | `yt-dlp`: the description, chapters and transcript | `raw/youtube/` |
| **Web page** | The page plus its docs pages. It also pulls in the project's GitHub repo if it finds one. | `raw/web/` |

A **detail level** (brief, standard or deep) sets how much it reads for each source.

### What it creates

```
inbox.md            the queue: drop URLs here
.pin-llm-wiki.yml   settings: topic, detail level, categories
AGENTS.md           rules for any agent working in the wiki
raw/                untouched copies of each source
wiki/
  index.md          start here: every source, one line each
  overview.md       a summary across all sources
  log.md            history of every ingest and change
  sources/          one page per source
```

The generated `AGENTS.md` tells every agent to **read `wiki/index.md` before answering**, cite the wiki pages it used, and say so when the wiki has no answer.

### How we use it for agentic-ai-wiki

1. Find something interesting (a new framework, a video, a blog post).
2. Queue it: `/pin-llm-wiki queue <url>`.
3. Now and then, run `/pin-llm-wiki ingest` to process the whole inbox.
4. Review the new pages in the git diff, then commit.
5. Ask questions in Claude Code or Copilot from inside the wiki folder. The agent answers from the wiki.

[agentic-ai-wiki](https://github.com/ndjordjevic/agentic-ai-wiki) was built this way. It uses a fixed list of categories, so every source lands in one group. That is the map for the next page.

### How we read it: Obsidian

We use [Obsidian](https://obsidian.md) to view and browse the wiki. It is a free Markdown app, and it understands `[[wikilinks]]`, so you can click from page to page.

1. Install Obsidian.
2. Clone the wiki: `git clone https://github.com/ndjordjevic/agentic-ai-wiki`.
3. In Obsidian, choose **Open folder as vault** and pick the cloned folder.
4. Start at `wiki/index.md`, or `wiki/categories.md` to browse by topic.
5. Open the **graph view** to see how sources link to each other.

Obsidian is only for reading. The agent does the writing, and git keeps the history.

---

### Try it (in Copilot CLI)

1. Make an empty folder, `cd` into it, and run the install command above.
2. Start `copilot` and run `/pin-llm-wiki init`.
3. Ingest one repo you know well: `/pin-llm-wiki ingest https://github.com/<org>/<repo>`.
4. Open `wiki/sources/` and read the page it wrote. Check the citations against `raw/`.
5. Ask a question about that repo, and check that the answer cites the wiki page.
6. Open the folder in Obsidian and click through the links. Then do the same with agentic-ai-wiki.

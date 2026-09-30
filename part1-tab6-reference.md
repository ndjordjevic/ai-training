# Part 1, Tab 6: Reference

← [Back to the Part 1 index](part1-reading-map.md). How to read this map (priorities, columns) is explained there.

This tab holds lookup pages: every flag, command, variable, tool, shortcut and hook event. Don't read them end to end. Skim each once so you know what exists, then come back when you need a detail. Three pages are worth real study: **Commands** (145), **Interactive mode** (148) and **Checkpointing** (149).

For Copilot, most of this lives on one big page: the [Copilot CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference).

### Group: Reference

---

#### 144. CLI reference (Glance)

- Claude Code: [CLI reference](https://code.claude.com/docs/en/cli-reference)
- Copilot CLI: [CLI command reference → Command-line commands](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#command-line-commands)

**Why:** Every command and flag you can use when starting `claude` from the shell.

| Section | Focus | Copilot section |
|---|---|---|
| CLI commands | ⭐ Read | [Command-line commands](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#command-line-commands) |
| CLI flags | Skim | [Command-line options](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#command-line-options) |
| See also | Skip | — |

**Pay attention to:**

- **Start:** `claude`, or `claude "task"` to start with a prompt.
- **Continue:** `claude -c` (last session here) or `claude -r <name>` (a named session).
- **One-shot:** `claude -p "..."` runs, prints and exits. Pipe input in with `cat log | claude -p "explain"`.
- **Useful flags:** `--model`, `--add-dir`, `--permission-mode`, `--worktree`.
- **Health check:** `claude doctor`. Update: `claude update`.
- **`claude --help` doesn't list every flag.** This page does.

---

#### 145. Commands (Study)

- Claude Code: [Commands](https://code.claude.com/docs/en/commands)
- Copilot CLI: [CLI command reference → Slash commands](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#slash-commands-in-the-interactive-interface)

**Why:** All the `/` commands, grouped by when you'd use them in a session.

| Section | Focus | Copilot section |
|---|---|---|
| Commands across a typical workflow | ⭐ Read | [Using Copilot CLI → Tips](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/overview#tips) |
| All commands | Skim | [Slash commands](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#slash-commands-in-the-interactive-interface) |
| How the command menu matches what you type | Skip | — |
| MCP prompts | Skip | — |
| See also | Skip | — |

**Pay attention to:**

- **New repo:** `/init` (writes CLAUDE.md), `/memory`, `/mcp`, `/permissions`.
- **During a task:** `/plan`, `/model`, `/effort`, `/context`, `/compact`, `/btw` for a side question.
- **Before you ship:** `/diff`, `/code-review`, `/security-review`.
- **Between tasks:** `/clear`, `/resume`, `/branch` to try another direction.
- **When something is wrong:** `/rewind`, `/doctor`, `/debug`.
- **Most have a Copilot twin:** `/init`, `/plan`, `/model`, `/context`, `/compact`, `/btw`, `/diff`, `/review`, `/clear`, `/resume`, `/rewind`.

---

#### 146. Environment variables (Skip)

- Claude Code: [Environment variables](https://code.claude.com/docs/en/env-vars)
- Copilot CLI: [CLI command reference → Environment variables](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#environment-variables)

**Why:** Every environment variable Claude Code reads. A lookup page.

| Section | Focus | Copilot section |
|---|---|---|
| Set environment variables | Skim | — |
| Precedence | Skim | — |
| Variables | Skip | [Environment variables](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#environment-variables) |
| Features that need feature-flag fetching | Skip | — |
| See also | Skip | — |

**Pay attention to:**

- **Set them in your shell,** or in the `env` block of `settings.json` so they apply every time.
- **The settings file wins** over your shell when both set the same variable.
- **Most people need only a few:** proxy, certificates, model, timeouts.
- **Look up a variable when a page tells you to.**

---

#### 147. Tools reference (Glance)

- Claude Code: [Tools reference](https://code.claude.com/docs/en/tools-reference)
- Copilot CLI: [CLI command reference → Tool availability values](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#tool-availability-values)

**Why:** The actions the agent can take (read, edit, run, search, fetch), and how each one behaves.

| Section | Focus | Copilot section |
|---|---|---|
| Configure tools with permission rules and hooks | ⭐ Read | [Tool permission patterns](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#tool-permission-patterns) |
| Agent tool behavior | Skim | [Agent and task delegation tools](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#agent-and-task-delegation-tools) |
| AskUserQuestion tool behavior | Skip | — |
| Bash tool behavior | Skim | [Shell tools](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#shell-tools) |
| Edit tool behavior | Skim | [File operation tools](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#file-operation-tools) |
| EndConversation tool behavior | Skip | — |
| Glob tool behavior | Skip | — |
| Grep tool behavior | Skip | — |
| LSP tool behavior | Skim | — |
| Monitor tool | Skim | — |
| NotebookEdit tool behavior | Skip | — |
| PowerShell tool | Skip | — |
| Read tool behavior | Skip | — |
| SendFeedback tool behavior | Skip | — |
| Task tool availability | Skip | — |
| WebFetch tool behavior | Skim | [Other tools](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#other-tools) |
| WebSearch tool behavior | Skip | — |
| Write tool behavior | Skip | — |
| Check which tools are available | Skim | — |
| See also | Skip | — |

**Pay attention to:**

- **Tool names** (`Bash`, `Edit`, `Read`, `WebFetch`, ...) are what you use in permission rules and hook matchers.
- **Edit replaces exact text.** No fuzzy matching, so it fails if the file changed.
- **The Agent tool starts a subagent.** You only see its final answer.
- **WebFetch returns a summary of the page,** not the raw page.
- **LSP gives real code navigation** and reports type errors after each edit.
- **Ask "What tools do you have?"** in a session to see the list.

---

#### 148. Interactive mode (Study)

- Claude Code: [Interactive mode](https://code.claude.com/docs/en/interactive-mode)
- Copilot CLI: [CLI command reference → Global shortcuts](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#global-shortcuts-in-the-interactive-interface)

**Why:** The keyboard shortcuts and input tricks you use every minute.

| Section | Focus | Copilot section |
|---|---|---|
| Keyboard shortcuts | ⭐ Read | [Global shortcuts](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference#global-shortcuts-in-the-interactive-interface) |
| Commands | Skip | — |
| Vim editor mode | Skip | — |
| Command history | Skim | — |
| Background Bash commands | Skim | — |
| Queue messages while Claude works | ⭐ Read | — |
| Prompt suggestions | Skip | — |
| Emoji shortcodes | Skip | — |
| Check spelling as you type | Skip | — |
| Invisible characters in prompts | Skip | — |
| Review changes with /diff | Skim | — |
| Side questions with /btw | ⭐ Read | [Asking a quick question](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/ask-a-side-question#asking-a-quick-question) |
| Task list | Skip | — |
| Session recap | Skip | — |
| Wait for a usage limit to reset | Skip | — |
| PR review status | Skip | — |
| Issue reference links | Skip | — |
| See also | Skip | — |

**Pay attention to:**

- **Prefixes:** `/` for commands, `@` to add a file, `!` to run a shell command yourself.
- **Esc stops Claude** and keeps its work. **Esc Esc** opens rewind.
- **Shift+Tab** cycles permission modes. **Ctrl+O** shows the full transcript. **Ctrl+B** sends a running task to the background.
- **Ctrl+G** opens your prompt in your editor, for long prompts.
- **Type while Claude works.** Your message waits in a queue and goes after the current step.
- **`/btw`** asks a side question without adding it to the conversation.
- **Copilot uses the same keys:** `@`, `!`, Esc, Shift+Tab, Ctrl+O, and `/btw` (or `/ask`).

---

#### 149. Checkpointing (Study)

- Claude Code: [Checkpointing](https://code.claude.com/docs/en/checkpointing)
- Copilot CLI: [Cancel and roll back](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/cancel-and-roll-back)

**Why:** Undo the agent's edits and go back to an earlier point. This is what makes trying things safe.

| Section | Focus | Copilot section |
|---|---|---|
| How checkpoints work | ⭐ Read | [Rolling back changes](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/cancel-and-roll-back#rolling-back-changes) |
| Common use cases | Skim | — |
| Limitations | ⭐ Read | [Changes that can't be rolled back](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/cancel-and-roll-back#changes-that-cant-be-rolled-back) |
| See also | Skip | — |

**Pay attention to:**

- **Every prompt you send makes a checkpoint.** It is automatic.
- **Open it with `/rewind` or Esc Esc.** Restore code, conversation or both.
- **"Summarize from here"** shrinks part of the chat to free context.
- **Not tracked:** files changed by shell commands (`rm`, `mv`, `cp`), and most subagent edits.
- **Checkpoints are not git.** Still commit your good work.
- **Copilot has the same thing:** Esc Esc, `/undo` or `/rewind`.

---

#### 150. Hooks reference (Glance)

- Claude Code: [Hooks reference](https://code.claude.com/docs/en/hooks)
- Copilot CLI: [Hooks reference](https://docs.github.com/en/copilot/reference/hooks-reference)

**Why:** Every hook event, its input, and how a hook can block or change what the agent does.

| Section | Focus | Copilot section |
|---|---|---|
| Hook lifecycle | ⭐ Read | [Hook events](https://docs.github.com/en/copilot/reference/hooks-reference#hook-events) |
| Configuration | Skim | [Hook configuration format](https://docs.github.com/en/copilot/reference/hooks-reference#hook-configuration-format) |
| Hook input and output | Skim | [Exit codes for command hooks](https://docs.github.com/en/copilot/reference/hooks-reference#exit-codes-for-command-hooks) |
| Hook events | Skim | [Hook event input payloads](https://docs.github.com/en/copilot/reference/hooks-reference#hook-event-input-payloads) |
| Prompt-based hooks | Skip | [Prompt hooks](https://docs.github.com/en/copilot/reference/hooks-reference#prompt-hooks) |
| Agent-based hooks | Skip | — |
| Run hooks in the background | Skip | — |
| Security considerations | ⭐ Read | — |
| Windows PowerShell tool | Skip | — |
| Debug hooks | Skim | — |

**Pay attention to:**

- **Three levels:** an event (like `PreToolUse`), a matcher (like `Bash`), and a handler (what runs).
- **Common events:** SessionStart, UserPromptSubmit, PreToolUse, PostToolUse, Stop.
- **Exit code 0 = OK. Exit code 2 = block,** and your message goes back to Claude.
- **A hook runs with your full user rights.** Read any hook before you add it.
- **Debug with `claude --debug`** and check the log.
- **Copilot reads Claude's hook format too,** including hooks in `.claude/settings.json`.

---

#### 151. Channels reference (Skip)

- Claude Code: [Channels reference](https://code.claude.com/docs/en/channels-reference)
- Copilot CLI: —

**Why:** Build your own channel: an MCP server that pushes webhooks or chat messages into a session.

| Section | Focus | Copilot section |
|---|---|---|
| Overview | Skim | — |
| What you need | Skip | — |
| Example: build a webhook receiver | Skim | — |
| Test during the research preview | Skip | — |
| Server options | Skip | — |
| Notification format | Skip | — |
| Expose a reply tool | Skip | — |
| Gate inbound messages | Skim | — |
| Relay permission prompts | Skip | — |
| Package as a plugin | Skip | — |
| See also | Skip | — |

**Pay attention to:**

- **A channel is a local MCP server** that sends events (CI results, alerts, chat) into your running session.
- **Two-way channels** add a reply tool, so Claude can answer back.
- **Always check who sent a message.** An open channel lets anyone inject prompts.
- **Research preview:** only approved channels run without a special flag.

---

### Group: Glossary

---

#### 152. Glossary (Glance)

- Claude Code: [Glossary](https://code.claude.com/docs/en/glossary)
- Copilot CLI: —

**Why:** Short definitions of every Claude Code term, each linked to its page.

| Section | Focus | Copilot section |
|---|---|---|
| A–W (terms by letter) | Skim | — |
| Deprecated and renamed terms | ⭐ Read | — |

**Pay attention to:**

- **Good for a quick "what does X mean?"** Each term links to its full page.
- **AGENTS.md is read** when there is no CLAUDE.md.
- **Renamed terms:** "headless mode" is now non-interactive mode (`-p`); "custom commands" are now skills.
- **Verification loop:** give Claude a check it can run (tests, a build) so it knows when it's really done.

**Copilot note:** Copilot has no glossary page. Its [feature comparison page](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features) plays a similar role.

---

### Try it (in Copilot CLI): Reference

1. Run `copilot --help`, then `/help` inside a session. Compare with the slash command list in the docs.
2. Type `@` and add a file. Type `!git status` to run a command yourself.
3. While Copilot works, type a follow-up and press Enter. See it queue.
4. Ask for a small edit, then press Esc Esc (or run `/undo`) and restore the files.
5. Ask `/btw what file did you just change?` and check that it didn't go into the conversation.

---

**End of Tab 6: Reference.**

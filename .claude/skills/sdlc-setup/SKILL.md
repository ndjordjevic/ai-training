---
name: sdlc-setup
description: Set up a work repo for our SDLC, once per repo and per computer. Links the private worknotes folder, hides it from git, and writes the instruction file. Use before the first ticket in a repo.
disable-model-invocation: true
argument-hint: "[work repo path]"
---

# Set up a repo for our SDLC

Repo: $ARGUMENTS (empty means the current folder)

Run once per repo, and again on each new computer (only the links are per computer).

## Rules

- Never create or switch branches. Never commit or push the work repo.
- Never overwrite a real file. If a target exists and isn't a link, stop and ask.
- Create only what is missing. Re-running this skill must be safe.

## 1. Find out first, then ask only what's left

Check these yourself, and don't ask about them unless a check fails:
- **Worknotes:** a `worknotes` git repo next to the work repo (for example `~/GolandProjects/worknotes` for `~/GolandProjects/my-service`), with a folder named after the work repo. Use it if it exists. If there is no `worknotes` repo, ask where it is.
- **Instruction file:** is there a committed `AGENTS.md` or `CLAUDE.md`? If not, we use a private `CLAUDE.md` in worknotes.
- **Jira and Confluence:** `acli jira auth status` and `acli confluence auth status`, then read one real ticket with `acli jira workitem view <key>`. Take the site from the output. Also check the REST API works with the token in a local credentials file outside any repo: `acli` can't download attachments or search, and only reads Confluence. Other repos' instruction files may already say how.
- **GitHub:** `gh auth status`, then a real call on this repo, such as `gh pr list`. If there is more than one account, use the one that works here.

Then ask in one list, each with your suggested answer:
1. The work repo path (default: the current folder).
2. How the agent reaches AWS for this repo: local AWS CLI (which login), or commands the engineer runs on another machine. Does it depend on the computer?
3. Anything a check above couldn't settle.

## 2. Create the worknotes folder

In `<worknotes>/<folder>/`, create what is missing:
- `.intent/`, `.specs/`, `.plans/`, `.notes/`
- `.verify/VERIFY.md` from `VERIFY-template.md` (next to this file)
- `GLOSSARY.md` with a one-line header only. Terms are added during intake.
- `CLAUDE.md` (only if there is no team instruction file): see step 4.

## 3. Link it into the work repo

If the worknotes repo has a link script, run it. Otherwise, for each item in the folder:
- `ln -s <worknotes>/<folder>/<item> <work repo>/<item>`
- add `/<item>` to `<work repo>/.git/info/exclude`, if it isn't there.

Check: `git status` in the work repo shows none of the linked items.

## 4. Write the instruction file

Draft it from the code, then cut it to what a new teammate needs on day one. Keep it under about 40 lines:
- **Commands:** build, test, lint, and what success looks like. If it takes several commands, say so; don't invent a wrapper.
- **Rule:** "Run build, test and lint before reporting a task complete, and paste the output. If a test fails, fix the code, not the test."
- **Git:** "The engineer creates branches, commits and pushes. The agent never does."
- **AWS and GitHub account:** what step 1 found or was told, one line each.
- **Jira and Confluence:** the site, and the exact commands to read a ticket with its subtasks and links, read a page, search both, and download an attachment. Then the REST fallback (where the token lives, how to call it), and how to write to Confluence. A few lines, with commands.
- **Pointers:** `GLOSSARY.md`, `.verify/VERIFY.md`, `.notes/`, and any coding standards file.

With a team file, don't edit it. Show the engineer the lines you'd add, and put the private ones (AWS, accounts) in the private `CLAUDE.md`.

## 5. Check and save

1. Run the build, test and lint commands once. Report the results. Don't fix failures; note them in `.notes/`.
2. Commit and push the worknotes repo only.

## Done when

- The links resolve and `git status` in the work repo is unchanged.
- The instruction file has commands, rules, access lines and pointers.
- The check commands ran once, with the results reported.
- The worknotes repo is pushed.

**Next:** if the repo is new to you, spend one read-only session getting to know it first: what it does, how a request flows, and what surprised you, saved in `.notes/`. Then `/sdlc-intake <ticket key>`.

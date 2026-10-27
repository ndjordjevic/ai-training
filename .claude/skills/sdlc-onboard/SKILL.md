---
name: sdlc-onboard
description: Teach the engineer an existing repo they didn't write - a map of the repo, then a guided tour of the code one flow at a time, at function level, with short teach-back questions. The whole repo, only the code a ticket touches, or one file or package. Saves a repo map that later steps reuse.
disable-model-invocation: true
argument-hint: "[full | <ticket key> | <file path> | <folder or package>]"
---

# Onboard: learn the existing code

Input: $ARGUMENTS

The engineer is new to this code. Your job is to make them understand what it does and where things go, not to explain every line. Teach; don't review.

## Rules

- **Read only.** Change no code. Git: only commands that change nothing (`log`, `show`, `grep`).
- **Read from the code, not from memory.** Before each flow, read its files again. Quote `file:line`.
- **Function level.** For each function on the path: what it does, who calls it, what it calls, in 1 or 2 sentences. Skip helpers that do what their name says.
- **One flow at a time.** Stop after each and end with: "Say *next*, ask about this flow, or name a flow to jump to." Treat "next", "ok" or "go on" as moving on.
- **Plain, short English.** Explain each project term once, the first time, and add it to `GLOSSARY.md` if it's missing.
- **Docs can be wrong.** When the docs and the code disagree, the code wins; say so, and list it at the end.
- **Short flows.** Aim for one screen per flow; give more only when the engineer asks.
- **Bugs you find** (in any code you read): say so in one line with `file:line`, and list them at the end. Don't fix them during the tour.
- **Never create branches or worktrees.** Fixes, when the engineer asks for them, go on the current branch as their own commit, unless the engineer says otherwise.

## 0. Choose the scope

- **`full`:** the whole repo. Map first, then one full flow, then the rest by kind (step 3).
- **`<ticket key>`:** only the code the ticket touches. Read the intent and plan if they exist (`.intent/<ticket key>-*.md`, `.plans/<ticket key>-*.md`), otherwise the ticket itself. Find the area: the entry points, layers and files it would touch, and the closest existing feature to copy. Show that list and let the engineer change it.
- **A file path:** that file only. Skip the full map (step 2); show where it sits instead (step 3b).
- **A folder or package** (a path, or a name you can find in the repo): that package only, the same way. If the name matches more than one place, show the matches and ask.
- Nothing given: ask which one.

If `REPO-MAP.md` exists in the worknotes folder for this repo, read it first. Re-read only what changed since the commit it names (`git log --stat <commit>..HEAD`), and update it.

## 1. Read the docs

README, docs folders, the instruction file and `GLOSSARY.md`. Note what they claim: the parts, the flows, how to build, test and deploy. Don't trust them yet; step 2 checks them against the code.

## 2. The map

Show one screen:
- **What the repo is for,** in two sentences.
- **Entry points:** each program, handler or job, and what starts it.
- **Layers** a request goes through, with one example of each (for example, handler → service → client → mapper).
- **Shared code:** logging, config, validation, errors, generated code (and what generates it).
- **Infrastructure:** what gets deployed and how it's wired.
- **Build, test, run:** the exact commands, and the CI workflows.
- **Tests:** where they live and what they run against.

Then show the tour order (step 3) as a short numbered list, and let the engineer change it.

## 3. The tour: one flow at a time

A flow is one path through the code, from the entry point to the response (or the side effect), in call order.

For each flow:
1. **What it does,** in business terms, in one sentence.
2. **The path,** function by function, in call order, with `file:line`.
3. **Where the data changes shape:** input, what's looked up or called, what goes out.
4. **Errors:** what can fail and what the caller gets back.
5. **Its tests:** what they cover and what they run against, in one or two lines.
6. **Teach-back:** 2 or 3 short questions the engineer answers from what they just saw (for example, "where would a new field in this response go?" or "what does the caller get if the downstream call fails?"). Correct wrong answers with the `file:line` that shows the right one. If the engineer says *next* without answering, give the answers in one line each at the top of the next flow, then go on.

**Order for `full`:** the most typical flow first, end to end. Then each other flow, explaining only what differs from the first. Then shared code, infrastructure, and CI.

**Order for a ticket:** the closest existing flow first (the one the ticket will copy or change), then the shared code it uses, then the infrastructure it touches.

## 3b. A file or package

Instead of the map, start with **where it sits**, in 3 to 5 lines: its layer, what it's for, who uses it (search the code for its callers or imports, and name them), and what it uses.

**A file:**
1. Its main function or type first (the one callers use), then the rest in the order they're called. For each: what it does, who calls it, what it calls, in 1 or 2 sentences. Group small helpers in one line.
2. Its data: the types it defines or changes, and where the data comes from and goes.
3. Errors: what can fail and what the caller gets.
4. Its tests: what they cover, what they run against, and what they don't cover.
5. Teach-back, as in step 3.

**A package:**
1. **Its files,** one line each, in the order a caller meets them.
2. **What it offers:** the functions and types other code uses, one line each, with who uses them.
3. Then each file the way a file is explained above, one file at a time, ending with "Say *next*, ask about this file, or name a file to jump to."
4. Teach-back at the end of the package, not after every file.

Steps 1 and 4 cover only the docs and lessons for this file or package.

## 4. Wrap-up

- **Where things go:** a short list for the common changes in this repo (a new endpoint, a new field, a new backend, a new setting), each with the files to touch.
- **Traps:** things that surprise a newcomer (generated code, odd data formats, config that differs per environment, tests that need special setup).
- **Docs that are wrong or missing,** from step 1.
- **Bugs found,** with `file:line`, split into: in the ticket's code (offer to fix on the current branch) and outside it (draft a ticket, or note it if one exists).
- Offer to fix the docs on the current branch as their own commit. Change nothing until the engineer says so.
- **Questions the engineer asked** that the code couldn't answer, and who might know.

## 5. Save

Write or update `REPO-MAP.md` in the worknotes folder for this repo, using `repo-map-template.md` next to this file. Add the flows, files or packages walked; don't drop what an earlier run saved. A file or package goes under "Files and packages", in a few lines. Record the commit it was read at. Commit and push the worknotes repo.

## Done when

- The engineer has walked every flow, file or package in scope, and its teach-back questions are answered.
- `REPO-MAP.md` is saved with the commit it was read at, and the worknotes repo is pushed.

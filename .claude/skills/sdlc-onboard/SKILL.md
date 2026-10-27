---
name: sdlc-onboard
description: Teach the engineer an existing repo they didn't write - a map of the repo, then a guided tour of the code one flow at a time, at function level, with short teach-back questions. Either the whole repo, or only the code a ticket touches. Saves a repo map that later steps reuse.
disable-model-invocation: true
argument-hint: "full | <ticket key>"
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

## 0. Choose the scope

- **`full`:** the whole repo. Map first, then one full flow, then the rest by kind (step 3).
- **`<ticket key>`:** only the code the ticket touches. Read the intent and plan if they exist (`.intent/<ticket key>-*.md`, `.plans/<ticket key>-*.md`), otherwise the ticket itself. Find the area: the entry points, layers and files it would touch, and the closest existing feature to copy. Show that list and let the engineer change it.
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
6. **Teach-back:** 2 or 3 short questions the engineer answers from what they just saw (for example, "where would a new field in this response go?" or "what does the caller get if the downstream call fails?"). Correct wrong answers with the `file:line` that shows the right one. Don't move on until the engineer says so.

**Order for `full`:** the most typical flow first, end to end. Then each other flow, explaining only what differs from the first. Then shared code, infrastructure, and CI.

**Order for a ticket:** the closest existing flow first (the one the ticket will copy or change), then the shared code it uses, then the infrastructure it touches.

## 4. Wrap-up

- **Where things go:** a short list for the common changes in this repo (a new endpoint, a new field, a new backend, a new setting), each with the files to touch.
- **Traps:** things that surprise a newcomer (generated code, odd data formats, config that differs per environment, tests that need special setup).
- **Docs that are wrong or missing,** from step 1. Offer to draft fixes as a separate change; don't make them here.
- **Questions the engineer asked** that the code couldn't answer, and who might know.

## 5. Save

Write or update `REPO-MAP.md` in the worknotes folder for this repo, using `repo-map-template.md` next to this file. Add the flows walked; don't drop what an earlier run saved. Record the commit it was read at. Commit and push the worknotes repo.

## Done when

- The engineer has walked every flow in scope and answered its teach-back questions.
- `REPO-MAP.md` is saved with the commit it was read at, and the worknotes repo is pushed.

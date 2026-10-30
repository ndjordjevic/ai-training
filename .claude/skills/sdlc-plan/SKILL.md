---
name: sdlc-plan
description: Turn a ticket's intent into a plan - what we build and how in our code, split into tasks - plus the checks for the verify step. Decides first whether a big task needs a separate spec. For a bug, reproduces it first. Use after intake, in a new session; run again to refresh an existing plan when tickets, docs or sources change.
disable-model-invocation: true
argument-hint: "<ticket key>"
---

# Plan: what we build, and how in our code

Ticket: $ARGUMENTS

This is the first time the code is read in depth. The intent says what is wanted. The plan says what we build and how, so that someone who never saw this chat could build from it.

## Rules

- **Read only.** Change no code. If your tool has a plan mode, use it. In plan mode nothing is written until the engineer accepts the plan, so ask them to accept it to get the file saved.
- **Never guess** ids, values, names or what callers send. Write them as assumptions, or "Blocked by: <person>'s answer".
- **Look before you ask.** Check the code, tickets, Confluence pages, attachments and test mocks first. Never ask what they answer. Start from the sources file (`.intent/<ticket key>-sources.md`): read the pages it lists instead of searching again. For a new lead it doesn't cover (one API, one mapping rule), follow the `sdlc-research` skill's steps for that lead only; they add to the same file.
- **Plain, short English.** Lead with the answer. Cite where each fact came from (page and version, file, ticket).
- **Keep the intent current.** When you learn something that changes it, update it without asking and tell the engineer what changed.
- **AWS and other environments:** read-only. Before the first command, check the instruction file and `.verify/VERIFY.md` for how to get in. If they don't say, ask the engineer which computer they're on and which account and role, then use the local CLI or give them read-only commands to run and paste back. Ask for credentials the way the `sdlc-verify` skill's Credentials rule says (a scratch file, never pasted). Only look if the answer can change the design. Hide secrets in what comes back. Record the answer in `VERIFY.md`.
- **Problems outside the ticket:** if one is small, low-risk and in or next to the code this ticket changes (for example, a handler we change sends an internal error to the caller), offer to fix it in this ticket as its own task. If it's big, risky, in shared code other parts use, or another team's work: tell the engineer and draft a new ticket.
- **Git: read only.** Use only commands that change nothing (`log`, `branch -a`, `show`). No `fetch`, `pull`, `checkout` or branches; ask the engineer if you need fresher refs.

## 0. Read and refresh

**First, the branch.** Show the current branch, its last commit, and the branch it seems to start from (`git branch --show-current`, `git log --oneline -1`, `git log --oneline --decorate -20`). Ask: "Is this the branch you'll build on?" If not, stop and let the engineer switch; the plan reads the code that is checked out. Write the branch and its base at the top of the plan; later steps diff against that base.

Read `.intent/<ticket key>-*.md`, and the spec and plan if they exist. If `REPO-MAP.md` exists in the worknotes folder for this repo, read it too: start from its flows and "Where things go" instead of exploring from scratch, and check its commit against `HEAD` (`git log --stat <commit>..HEAD`) for parts that changed since. If the engineer is new to this area and there's no map for it, suggest `/sdlc-onboard <ticket key>` first. Refresh against Jira: compare the ticket's last-updated time and the Confluence page versions with the ones in the intent's Source and the sources file. Re-read only the pages that changed. Also check every finding in the sources file the plan hasn't weighed yet: a new page or ticket, or a new rule or quote on a page the plan already cites (for example, from an older version). For each: does it change a decision, add a task, or answer or raise a question? Show the result as: already covered / plan change / question for someone / nothing. If nothing changed, say "no change". If something did, update the intent, list every change, then show what must change in the spec and plan.

If a plan with "Status: draft" exists, go on from it (step 4 onwards).

## 1. For a bug: reproduce it first

Show one command you have already run that fails on this exact bug: fast, and the same result every time. In order of preference: a failing test locally, then a read-only call or script against a test environment (access as in Rules). If neither works, confirm the symptom from the logs, write "not reproduced" in the plan, and carry on.

Then list 3 to 5 possible causes, each with a check that would prove it wrong, and show them to the engineer before testing them.

## 2. Big task? Answer three questions, don't decide

In the chat, answer each with evidence from the ticket and the code:
1. Does it span several services? Which?
2. Does it need a security or privacy review? Which part?
3. Does it take more than a few days? Which dependencies?

Give no "big or small" verdict and no estimate. The engineer decides. For a big task, write the spec first, as `.specs/<ticket key>-<short-name>.md`, starting with "Intent: <path>". It has: decisions, rules, what we will not do, open questions, and a Testing section. Flag concerns for security or privacy owners before anyone builds.

## 3. Design

1. **How callers reach us today:** who calls, through what, and who picks our address. Ask the engineer to check it with the caller's team, because a fact from outside the repo can remove options.
2. **Each "Parked for the plan" question** from the intent: 2 or 3 options, the trade-offs, and a recommendation, based on the code.
3. **Unanswered questions** the design depends on: write them as assumptions, and say which answer would change the design.
4. **Questions for others:** only those the code and docs can't answer and the design can't go ahead without. **Check every question before you show it, every time** (also when you redraft one or add one later): (1) look for the answer in the specs, the sources file, the code, mocks and sample data; (2) check the case really happens (the spec's definitions, sample data, logs); (3) check the answer would change the code or the outcome. Drop any question that fails one. In a tool with subagents, also give the questions to a fresh read-only one and keep only what it can't answer. Under the draft, say in one line per question where you looked. Address each to the person who can answer (the ticket creator, or the owner of a design page). Plain, simple English, one short question per line, one thing per question, no default answers, no summary, written as the engineer ("I", not "we"). Show the draft to the engineer and post it as a Jira comment only after they approve the text.
5. **Bugs in other people's work** (for example, a branch you build on, or a wrong design page): a short note the engineer can send, not a question. Same writing rules as questions: plain, short, written as the engineer, readable without the code. Say what's wrong, what you'll do, and what you ask.

**If an answer could change the overall design,** stop here. Save the plan with only the Design part and "Status: draft, waiting on answers". The team can review the design early, above all anything hard to undo. Resume with `/sdlc-plan <ticket key>` when the answers arrive. If the answers would only change one isolated part (for example, one mapper), don't stop: write the full plan on the assumptions, and mark the tasks they touch "Blocked by: <person>'s answer".

## 4. What we build

Skip if there is a spec. Otherwise: decisions, what we will not do, and a **Testing** section: which behaviour we test, at which points (for example, one integration test through the endpoint), and which existing tests to copy.

## 5. How and where

- Where does the change belong? What can we reuse? How is similar code written today?
- **What could break:** list who calls or uses what we change, beyond the files in the diff.
- **Docs that name it:** search the repo docs (README, architecture docs, runbooks, endpoint tables) for lists of what we add or change, and put their updates into a task.

## 6. Tasks

Use `plan-template.md` next to this file. Each task has a goal, the files it touches, a check, and a "Blocked by" line (tasks, a person's answer, or "nothing").
- **Prefactor first:** if the code is awkward for the change, task 0 makes it easy, with no change in behaviour.
- **Sketch first** for a new module: types and function signatures with empty bodies.
- **How to split:** ask the engineer. Thin end-to-end slices when tasks run one after another; split by layer when tasks should run in parallel, because they touch different files.
- **Each task** can be checked on its own and fits in one session. Too big means split it.
- **Keep the PR small:** if the whole change looks like more than about 1,000 lines, suggest splitting the ticket into more than one PR. Big PRs get most of the review findings.
- **Mark high-risk tasks** (for example, a change on a live path existing users depend on), with what extra checks they need. The build runs them on the strongest model.
- Say which tasks can run in parallel and which in order.
- Tasks are code only. Deploying and checking in an environment is the verify step, not a task.
- If the ticket asks for something the repo has no pattern for (for example, "integration tests" with no integration test setup), say how you read it and add it to Open points, so the engineer can confirm.

## 7. Checks for the verify step

1. If `.verify/VERIFY.md` is missing or still the empty template, fill in what you can read from the repo (how to run it, endpoints, logs), ask the engineer for what only they know (environments, accounts and roles, the login on each computer), and mark the rest "to confirm".
2. Write `.verify/<ticket key>-<short-name>.md` with a "Checks" part: for each check, what to do, what to expect, which environment can test it, and what it needs (test data, an id, credentials, a person's answer). Call the service at its own entry point (the gateway or front door), not further up the flow. The full flow is QA's and stays out of the checks file; put what it needs (for example, upstream routing) in the plan's Open points. If the sources file lists test cases (for example, QA's test cases in an attachment), use the ones this entry point can test, and cite them. Leave a "Results" heading empty.
3. List the needs in the chat, each with who can provide it, so the engineer can ask for them while the code is built. Add them to the plan's Open points as "waiting on: <need>, <owner>", so later steps keep showing them until they arrive.

## 8. Check the plan

1. **Against the intent:** re-read the intent and list every place the plan decides something differently, quoting both, one line each. The engineer decides each one; don't change either to match on your own, since the plan read code the intent didn't. List a decision the intent didn't make only if it changes an interface, the data or a dependency.
2. **Fresh readers** (in a tool with subagents): give the plan, the intent and the repo to read-only subagents with no chat history, in parallel, one round:
   - **Retell:** in its own words, what the plan builds and how today's code works, 2 to 5 sentences each. Show it to the engineer; a wrong retelling is a finding.
   - **Builder:** every choice the plan leaves to whoever builds it (an error case, a name, where code goes), and every file or function the plan says exists now but doesn't. A wrong claim about today's code is the worst finding. New files must be marked new, changed or deleted.
   - **Simpler:** existing code that already does it, and parts built for a need the ticket doesn't have.
   A reader that fails or returns nothing: retry once, then say "not run". Never count it as no findings.
3. Fix what the engineer agrees with, and run a fresh reader once more only if the fixes were big.

## 9. Save

Save the plan as `.plans/<ticket key>-<short-name>.md`, starting with "Intent: <path>" (or "Spec: <path>"). Set "Status: ready to build" when no task is blocked by a design question. If some tasks wait on an answer, say which: "ready to build (Task 2 waits on <person>'s answer)". Commit and push the worknotes repo (`sdlc-setup/scripts/worknotes-push.sh "<message>"`).

## Done when

- Someone who never saw this chat could build from the plan alone.
- Every task has a goal, files, a check and a "Blocked by" line. High-risk tasks are marked.
- The verify checks file exists, and its needs are listed for the engineer.
- The worknotes repo is pushed.

**Next:** `/sdlc-build <ticket key>`. Say which session to run it in, with one reason: this one if it still has room (for example, less than half its context used), because it already knows the code; a new one if this one is long or full of research. Build works from the plan file either way.

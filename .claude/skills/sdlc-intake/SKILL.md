---
name: sdlc-intake
description: Turn a Jira ticket into an intent (why and what is wanted, in business terms) by grilling the engineer, and draft questions for the ticket creator only if the general picture is still unclear. Use at the start of every feature or story.
disable-model-invocation: true
argument-hint: "<ticket key>"
---

# Intake: ticket to intent

Ticket: $ARGUMENTS

The intent says **why** and **what is wanted**, from the business's view. It is the one clean input for the plan. The plan decides how.

## Rules

- **Model:** run on the strongest model you have. If you aren't on it, tell the engineer to switch before going on. Mistakes here are expensive later.
- **Problem only.** Don't research how to build it, and don't ask design questions.
- **Never guess** ids, values, names, or what callers send today. Write them as assumptions, or park them for the plan.
- **Look before you ask.** Never ask what the code, tickets, Confluence or attachments can answer.
- **Plain, short English.** Explain the ticket's jargon and acronyms the first time. Keep each report to what the engineer needs now.
- **Never post to Jira** without the engineer approving the exact text.
- **Git: read only.** Use only commands that change nothing (`log`, `branch -a`, `show`). No `fetch`, `pull`, `checkout` or branches.

## 0. Resume or start

If `.intent/<ticket key>-*.md` exists, this is a resume (for example, the ticket creator answered). Refresh first: compare the last-updated times of the ticket, its subtasks and linked items, and any Confluence page version, with the ones in the intent's Source. Also check for new subtasks or links. If nothing changed, say "no change". If something did, list every change, and update the intent only after the engineer confirms. Then go on from where it stopped.

## 1. Read the ticket

Read it with the Jira and Confluence tools the instruction file names: the description, all comments, attachments and any linked Confluence page. Note the ticket's last-updated time and the page version. If one tool can't do something (for example, download an attachment or reach Confluence), use the other way the instruction file gives, such as the REST API, before asking the engineer.

Then read every subtask, the parent or epic, and every linked work item: summary, status, assignee, description and comments. Note each one's key, how it is linked, and its last-updated time. Flag anything odd, such as a subtask marked "Not Required" or a link to an older, similar ticket.

Then search for what isn't linked:
- **Confluence:** pages about this feature, by the ticket keys, the epic name and the main terms. Design and mapping pages are often not linked to the ticket.
- **Jira:** other tickets that explain a term, setting or acronym the ticket uses but doesn't explain.

## 2. Already built?

A short check of the code that answers only two things:
1. Does the requested behaviour already exist? Search by meaning, not only by the ticket's words.
2. Are the ticket's claims about the code true ("the API already returns X")?

Use only what is already in the repo; don't fetch. If the right code isn't obvious, ask the engineer where to look instead of exploring. Report in a few lines, with the places you looked, and stop. Don't research how to build it; the plan does that. If it already exists, tell the engineer. Note a false claim in the intent; ask the ticket creator only if it changes what is wanted. What the code does today goes into the intent's Problem, in one or two sentences.

For a bug: don't try to reproduce it here. Write down the symptom and the evidence from the ticket (error, time, environment, ids) in the intent's Problem. Reproducing it happens at the start of the plan.

## 3. Grill the engineer

**First, the scope, on its own.** If the ticket has subtasks, ask only this in the first round: which ones are the engineer's? The Outcome covers only those; the others go under Constraints as out of scope, with their keys. Ask the rest only after the answer, and only about that scope.

**If the engineer is new to the area,** offer a short who-calls-whom picture for this feature: the systems, the order of calls, and where our part fits. Mark what is confirmed and what is your inference.

Then interview the engineer in short rounds about the problem: why, for whom, the outcome, behaviour and constraints. Number the questions and give your recommended answer for each. Ask only for decisions the engineer can make. Sort every question into one of three piles:

1. **The engineer's decision about the problem:** ask it now.
2. **Design or detail** (which component, field mappings, error formats, what to return in an edge case, how to wire it): don't ask. Write one line under "Parked for the plan", even if someone else must answer it.
3. **Outside the engineer's area** (for example, another team's UI): don't ask. Write it under Constraints as theirs.

The aim is the general picture of what needs to be done, not every detail.

Add new project terms to `GLOSSARY.md` once they are settled: one or two sentences, plus an "Avoid" list of other words for the same thing. Stop when nothing about the problem is unclear.

## 4. Write the intent

Write it from the ticket and the answers, using `intent-template.md` next to this file. Save it as `.intent/<ticket key>-<short-name>.md`.

- Business terms only: no file paths, line numbers, mechanisms or build details, and nothing the plan owns, such as where a request is rejected.
- The Outcome covers only this ticket. Work for other tickets goes under Constraints as out of scope.
- Never state as fact what the ticket creator still has to answer. Add no promises the ticket didn't ask for, such as timings.

## 5. Draft the questions for the ticket creator

Only if the general picture is still unclear: for example, the ticket contradicts itself, or it's unclear what the outcome is. Questions about how or details go to "Parked for the plan"; the plan asks them. Most tickets need no questions here. If there are none, say so and skip this step.

- Plain, simple English. One short question per line, numbered, most important first.
- No default answers, no summary, no background.

The same questions go into the intent's Open questions. Show the draft to the engineer, and post it as a Jira comment only after they approve the text.

## 6. Save

Commit and push the worknotes repo.

## Done when

- The problem, outcome, constraints and scope are clear. The rest are answered, written down as assumptions, or in the Jira draft.
- The intent is saved, with its Source times filled in.
- Any questions are posted, or the engineer has the draft.
- The worknotes repo is pushed.

**Next:** `/sdlc-plan <ticket key>` in a new session. If questions were posted, resume intake with `/sdlc-intake <ticket key>` when they are answered.

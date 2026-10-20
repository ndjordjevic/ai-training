---
name: sdlc-intake
description: Turn a Jira ticket into an intent (why and what is wanted, in business terms) by grilling the engineer, and draft the few questions the ticket creator must answer. Use at the start of every feature or story.
disable-model-invocation: true
argument-hint: "<ticket key>"
---

# Intake: ticket to intent

Ticket: $ARGUMENTS

The intent says **why** and **what is wanted**, from the business's view. It is the one clean input for the plan. The plan decides how.

## Rules

- **Model:** run on the strongest model you have. If you aren't on it, tell the engineer to switch before going on. Mistakes here are expensive later.
- **Problem only.** Don't research how to build it, and don't ask design questions.
- **Never guess** ids, values, names, or what callers send today. Ask the engineer, or put it in the questions for the ticket creator.
- **Never post to Jira** without the engineer approving the exact text.
- Never create or switch branches. Never touch the work repo's git.

## 0. Resume or start

If `.intent/<ticket key>-*.md` exists, this is a resume (for example, the ticket creator answered). Refresh first: compare the ticket's last-updated time and any Confluence page version with the ones in the intent's Source. If nothing changed, say "no change". If something did, list every change, and update the intent only after the engineer confirms. Then go on from where it stopped.

## 1. Read the ticket

Read it with the Jira tool the instruction file names: the description, all comments, attachments, linked tickets and any linked Confluence page. Note the ticket's last-updated time and the page version.

## 2. Already built?

A short check of the code that answers only two things:
1. Does the requested behaviour already exist? Search by meaning, not only by the ticket's words.
2. Are the ticket's claims about the code true ("the API already returns X")?

If the right code isn't obvious, ask the engineer where to look instead of exploring. Report in a few lines, with the places you looked, and stop. Don't research how to build it; the plan does that. If it already exists, tell the engineer. A false claim becomes a question for the ticket creator. What the code does today goes into the intent's Problem, in one or two sentences.

For a bug: don't try to reproduce it here. Write down the symptom and the evidence from the ticket (error, time, environment, ids) in the intent's Problem. Reproducing it happens at the start of the plan.

## 3. Grill the engineer

Interview the engineer in rounds about the problem: why, for whom, the outcome, scope, behaviour and constraints. Each round lists every question you can ask now, numbered, each with your recommended answer. Ask only for decisions. Sort every question into one of three piles:

1. **The engineer's decision about the problem:** ask it now.
2. **Design** (which component, where data lives, how to wire it): don't ask. Write one line under "Parked for the plan".
3. **Only the ticket creator, another team or a customer can answer:** don't ask. First check the code and tickets in case the answer is there. If not, it goes into the Jira draft (step 5).

Add new project terms to `GLOSSARY.md` once they are settled: one or two sentences, plus an "Avoid" list of other words for the same thing. Stop when nothing about the problem is unclear.

## 4. Write the intent

Write it from the ticket and the answers, using `intent-template.md` next to this file. Save it as `.intent/<ticket key>-<short-name>.md`.

- Business terms only: no file paths, line numbers, mechanisms or build details, and nothing the plan owns, such as where a request is rejected.
- The Outcome covers only this ticket. Work for other tickets goes under Constraints as out of scope.
- Never state as fact what the ticket creator still has to answer. Add no promises the ticket didn't ask for, such as timings.

## 5. Draft the questions for the ticket creator

Only the questions the work can't go ahead without: a missing id or value, or a choice that changes what we build. Everything else becomes an assumption in the intent.

- Plain, simple English. One short question per line, numbered, most important first.
- No default answers, no summary, no background.

The same questions go into the intent's Open questions. Show the draft to the engineer, and post it as a Jira comment only after they approve the text.

## 6. Save

Commit and push the worknotes repo.

## Done when

- The problem, outcome, constraints and scope are clear. The rest are answered, written down as assumptions, or in the Jira draft.
- The intent is saved, with its Source times filled in.
- The questions are posted, or the engineer has the draft.
- The worknotes repo is pushed.

**Next:** when the ticket creator answers, resume this session (`/sdlc-intake <ticket key>` again). You can start the plan's design before then: `/sdlc-plan <ticket key>` in a new session.

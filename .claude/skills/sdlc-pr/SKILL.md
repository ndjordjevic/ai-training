---
name: sdlc-pr
description: Open a ticket's pull request as a draft, with a short plain-English title and description and no AI attribution, after the engineer has reviewed and pushed. Updates an open PR's description, and marks it ready later, when the engineer says so.
disable-model-invocation: true
argument-hint: "<ticket key> [base branch]"
---

# PR: open it as a draft

Input: $ARGUMENTS

Reviewers read the description first. It says what changed, why, how it was tested and what is still open, in under a minute of reading.

## Rules

- **Draft by default.** Open it as a draft unless the engineer says otherwise. Mark it ready only when the engineer asks.
- **Never create or change the PR** without the engineer approving the exact title and description.
- **No AI attribution:** no "Co-Authored-By" lines, no "Generated with" footers, no mention of the agent.
- **Short and plain:** written as the engineer ("I added", not "we"). No filler, no repeated headings, no long lists. The whole description fits on one screen.
- **GitHub account:** the one the instruction file names for this repo. Check with `gh auth status` first.
- **Git:** never commit, push or switch branches. The engineer pushes.

## 0. Check

1. The branch is pushed and `git status` is clean. If not, stop and tell the engineer.
2. **The base:** the one given, the one the plan names, or the branch this one was made from (stacked branches don't start from main). Ask if unsure. It must be a branch name, not a commit; if given a commit, find the branch that holds it.
3. The PR covers only this ticket: `git log --oneline $(git merge-base HEAD <base>)..HEAD` and `git diff --stat` against the same point. If it shows someone else's commits, the base is wrong.
4. Read the plan (with its Build log and status block), the intent and the verify checks file, if they exist. Check there's no open PR for this branch already (`gh pr list --head <branch>`); if there is, update it instead (step 2).

## 1. Draft

**Title:** `<ticket key>: <what it does, in a few words>`.

**Description:**

```
<ticket link>

<Two or three sentences: what this changes and why, in business terms.>

Changes
- <group of files>: <one sentence>
- ...

Testing
<One or two sentences: what was run and against what. Say what was not tested yet.>

Before merge
- <each open item and who it waits on, or "Nothing">

Risk
<Low, medium or high, and one reason.>

Rollback
<One sentence: easy to roll back or not, and what it could affect.>
```

- Group files the way the code flows: wiring, logic, infrastructure, docs. No file-by-file lists, no code.
- "Testing" says what the tests run against (for example, a fake server). Don't call them integration or end-to-end tests unless they are.
- Changes to code that belongs to another ticket or branch (for example, fixing its CI) get their own line, naming that ticket, so its owner knows.
- "Before merge" holds real blockers only: open questions whose answer can change the code, missing test data, another PR that must merge first. A question asked only to confirm stays on the ticket, not here.
- **Risk** is set by the change, not by who wrote it. Low: docs, tests, additive changes behind a flag. Medium: an ordinary change. High: a live path existing users depend on, security, money, shared code or CI.
- **One sentence per Changes line.** If the whole text doesn't fit on one screen, shorten it (also text kept from an earlier version) and say what you cut.
- If this PR is stacked on another branch, say so in one line under the link ("Stacked on <branch>; merge that first").

## 2. Open

Show the title and description. After the engineer approves:

```
gh pr create --draft --base <base> --title "<title>" --body-file <scratch file>
```

To update an open PR, read its current text first (`gh pr view <number>`), keep what the engineer wrote by hand, show the new text, and after approval run `gh pr edit <number> --title "<title>" --body-file <scratch file>`.

Write the body to a scratch file outside the repo, and delete it after. Give the engineer the PR link, add a Build log line, and push the worknotes repo (`sdlc-setup/scripts/worknotes-push.sh "<message>"`).

## 3. Ready for review (later)

When the engineer says the blockers are closed, re-check the "Before merge" list against the plan and the ticket, update the description if anything changed (with approval), then run `gh pr ready <number>`.

## Done when

- The draft PR is open with the approved text, against the right base.
- The link is in the Build log.

**Next:** post the ticket comment with the PR link (`/sdlc-summary <ticket key>`), then `/sdlc-verify <ticket key>` in a new session.

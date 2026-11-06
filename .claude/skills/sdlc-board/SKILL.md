---
name: sdlc-board
description: Show every open ticket in this repo on one board - worktree, branch, next flow step, PR, whether the lower environment runs it, what it waits on, and which open branches change the same files. Read only. Use at the start of the day, before starting or resuming a ticket, or before a deploy that may replace someone's work.
disable-model-invocation: true
argument-hint: "[ticket key to focus on]"
allowed-tools:
  - Bash(${CLAUDE_SKILL_DIR}/scripts/board.sh *)
---

# Board: all open tickets at a glance

Input: $ARGUMENTS

Several sessions work in one repo at once, one ticket each. This shows where each ticket is, so the engineer doesn't have to remember which session does what.

## Rules

- **Read only.** No commits, deploys, Jira posts or file changes. Only a `git fetch` for fresh refs.
- **Never switch another session's checkout.** Read worktrees with `git -C <folder>`.
- **The plan's lines may be old.** "Waiting on" comes from each plan as it was last written. Before acting on one, check the plan's Build log and the ticket for newer news, and say which lines look done.

## Steps

1. Find the deploy workflow file in `.verify/VERIFY.md` (for example `wf-deploy.yml`). If it says nothing, leave it out: "deployed" then shows "n/a".
2. Run `${CLAUDE_SKILL_DIR}/scripts/board.sh <workflow file>` from the main checkout. It prints the last successful deploy, then one block per ticket worktree:
   - its PR and target branch;
   - whether the last successful deploy contains the branch head;
   - uncommitted and unpushed changes;
   - the first flow step not done, from `sdlc-ticket/scripts/status.sh`;
   - the plan's "waiting on" lines;
   - then the files that more than one open branch changes, against each PR's base (a ticket with no PR: the base its intent records, else `origin/HEAD`).
3. If a ticket key was given, read that ticket's intent and plan Build log and add its latest line.

## Report

Lead with what needs the engineer, at most 5 lines:
- **Conflicts coming:** branches that change the same files, and which merges second (it resolves them).
- **Environment:** which ticket the lower environment runs now, and which tickets lose it if another is deployed.
- **Stuck:** tickets waiting on someone, with who and since when (from the plan), and lines that look done.
- **Loose work:** uncommitted or unpushed changes, a worktree whose PR is merged (offer `git worktree remove`), a ticket with no PR.

Then the board itself, one line per ticket: key, next step, PR, deployed, waiting on.

## Done when

- Every ticket worktree is on the board, and the overlaps and the environment are named.
- Nothing was changed.

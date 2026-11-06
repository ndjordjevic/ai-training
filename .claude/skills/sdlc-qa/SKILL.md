---
name: sdlc-qa
description: Draft a short handoff for QA once a ticket's PR is ready - which cases the engineer tested and where, and which mock stubs were added - so QA can check them again. Use after verify, when the ticket moves to QA.
disable-model-invocation: true
argument-hint: "<ticket key>"
allowed-tools:
  - Bash(${CLAUDE_SKILL_DIR}/../sdlc-setup/scripts/worknotes-push.sh *)
---

# QA handoff: what I tested, for QA to check

Ticket: $ARGUMENTS

QA tests the whole flow. This note tells them what the engineer already tested at the service's own entry point, and which test data was added, so they can repeat it and build on it. It reads in a minute.

## Rules

- **From the files, not from memory.** Take every case and result from the latest Results in the ticket's checks file, and every stub from the checks file, `VERIFY.md`'s test data list and the saved import file. Nothing that isn't written there.
- **Plain, short English,** written as the engineer ("I tested", not "we"). No code, no log lines.
- **No secrets:** no passwords, tokens, keys or personal data. Say where the credentials come from, not what they are.
- **Ids only where QA needs them** to repeat a case (a test customer id, a stub's match). Say what each is for.
- **Only what QA doesn't know.** No commits or dates in the note, and no list of what wasn't tested: QA tests the full flow and knows what it needs.
- **Tag QA:** the people the engineer names, or else the QA people the instruction file lists (ask if it lists none), at the top, as real mentions (look up each account id). If a name matches more than one person, pick the one already on the ticket or its linked tickets, and say so.
- **Never post** without the engineer approving the exact text.

## 1. Read

The checks file `.verify/<ticket key>-*.md` (its latest Results), the stub import files next to it, `.verify/VERIFY.md`, the plan's Build log and Open points, and the PR link. If the latest Results are older than the commit the PR holds now, tell the engineer (not in the note) what changed since, and whether the cases need a rerun first (`/sdlc-verify <ticket key>`).

## 2. Draft

```
@<QA person> <ticket key>: ready for QA. PR: <link>

Before you start, please make sure branch <PR branch> is the one deployed in <environment> (I may deploy something else there in between), and check the mocks.
I tested it there by calling <the entry point, for example the gateway>.

Cases I tested
1. <Case in a few words>: <what I sent, in words> → <what came back>. Passed.
2. ...

Mock stubs I added (<mock name>)
- <what it matches, for example the id or path> → <what it returns>. Used by case <n>.
- Import file: <where it is, if QA can reach it>

Please check these again as part of the full flow, and tell me if anything differs.
```

- **Cases:** one line each, in the order of the checks file. Passed, failed or not run, as the Results say.
- **Stubs:** only the ones added for this ticket. If none were added, say which existing test data the cases used.
- The whole text fits on one screen.

## 3. Send

Show the draft. After the engineer approves it, post it as a ticket comment, or give it to them to paste, as they say. Add a Build log line ("QA handoff sent, <where>") and push the worknotes repo (`${CLAUDE_SKILL_DIR}/../sdlc-setup/scripts/worknotes-push.sh "<message>"`).

## Done when

- Every case in the latest Results and every stub added for this ticket is in the note, with nothing secret.
- The engineer has approved the text, and it's posted (or they have it to paste).

---
name: sdlc-verify
description: Check a ticket's branch in a lower environment - access, what is deployed, a deploy when the engineer asks (plan first), the test data, then each check in the ticket's checks file at the service's own entry point - and write the results. Use after the PR is pushed, in a new session; run again after a redeploy or when test data arrives.
disable-model-invocation: true
argument-hint: "<ticket key> [environment]"
---

# Verify: does it work where it runs

Input: $ARGUMENTS

Tests prove the code against fakes. This step checks what really runs in a lower environment. It tests this repo's part, from the service's own entry point down. Whoever owns the whole flow (QA) tests it end to end.

## Rules

- **Run the checks file, not your memory.** Read each check's "Expect" before you run it, and compare. A result you didn't predict from the file is a finding, even if it looks fine.
- **Read only, apart from a deploy and test data the engineer asks for.** Never change config, routing or other teams' systems, even when your role allows it. Say what needs changing and who owns it. Test data (mocks, stubs) only when the engineer asks and its owner agrees (step 4).
- **Deploy only through the repo's pipeline, and only when the engineer asks.** Plan first, read the plan, then apply (step 3).
- **Say what you stop or cancel.** A cancelled run shows as a failure to others. Tell the engineer at once, with the reason.
- **Credentials:** short-lived and read-only where possible, in a scratch file outside any repo. Ask the engineer to copy the export lines and then type `! pbpaste | tr -d '\r' > <path>` themselves (copying the command from the chat replaces the exports in the clipboard; `tr` strips Windows line endings, which break the CLI). Check the file has three `export AWS_` lines (`grep -c '^export AWS_' <path>`) without printing it; if a permission check blocks that, ask the engineer to run it with `!`, which shows only the count. Source the file in each command; never print or copy its values. Delete it when done. If they get pasted anyway, don't copy them anywhere and let them expire.
- **Don't touch another session's checkout.** If the repo has a different branch checked out, do any git work in a separate worktree, and remove it when done.
- **Web consoles** (a mock service, a dashboard): the engineer signs in in the browser tab; never type a password. A password pasted in the chat: don't use it, and tell the engineer the owner should change it.
- **Commands on shared machines** (a bastion, a jump host) only on the engineer's go-ahead, even read-only ones.
- **Problems outside the ticket** (found while checking): draft a short ticket for each, with what you saw and how to repeat it. Don't fix them here.
- **Plain, short English.** Start every report with 3 to 5 lines: what passed, what failed, what's waiting and on whom.

## 0. Read

The repo's `.verify/VERIFY.md`, the ticket's checks file `.verify/<ticket key>-*.md`, the plan with its Build log, and the intent. If `VERIFY.md` is missing or still the empty template, draft it from the repo and ask the engineer for what only they know; mark the rest "to confirm".

## 1. Access

Which computer, which environment, which account and role (from `VERIFY.md`; ask only what it doesn't say). Run one read-only command that shows the account, and confirm it is the environment you meant. When credentials expire, ask for new ones the same way.

## 2. What is deployed

- Is this branch deployed there? Check the pipeline's runs for this branch and the resources themselves (the function, the route, the config).
- Who deployed last, from which branch and commit. A shared environment may hold someone else's work.
- Has the base branch moved since this branch left it? Say what the new commits touch.

## 3. Deploy (only when the engineer asks)

1. If the base moved, ask whether to bring it in first. Merge it, run the checks the merge touches, and push (this updates the PR).
2. Tell the engineer whose deploy this replaces and what it removes (another ticket's work in the same environment), and draft a short heads-up for the team.
3. Run the pipeline as a plan only. Read the plan: every add, change and destroy should be explained by this branch, or by removing the last deploy's work. List anything else apart: it may be drift in the environment (something changed outside the code). Show it, and check it again after the apply.
4. **Before the apply,** save the answers the "unchanged" checks compare against (for example, the same call on a path this branch shouldn't change), so they compare with a real before.
5. Apply. Then check the resources from step 2 again.
6. If the deploy removed another ticket's work, add a line to that ticket's checks file and Build log: "not deployed in <environment> since <time>, replaced by <ticket>". Do it even if another session works on that ticket: it's one line, and that session needs it.

## 4. Test data

Every check depends on data: mocks, stubs, test customers. Before running checks, send the exact calls this code makes to the mock or test system, read only, and note what comes back. Before asking anyone for a test id, look in the logs of earlier successful calls. Mark each check "ready" or "waiting on: <data>, <owner>". If you can't add the data yourself, draft what is needed (the request to match and the response) for whoever owns it.

When a call isn't matched, read the mock's non-match report, and try the call in the shape the stub expects: that shows whether the code or the stub is wrong.

**Changing test data** (only when the engineer asks and the data's owner agrees): add new stubs, one new id per case, so nobody else's tests change. Change an existing stub only to make it match the spec. Call each stub straight after, with the exact request the code sends. Write what you added or changed in the checks file and in `VERIFY.md`'s test data list.

## 5. Run the checks

- Call the service at its own entry point, the closest to real you can get from here. Prefer a call through the gateway or front door (for example, a test-invoke from the cloud CLI) over calling the function directly; say what the call skips (for example, the network path).
- For each check: what you ran, what you expected, what you saw, and the log lines that prove it (never paste secrets, tokens or personal data).
- On an unexpected result, follow the request through the logs before saying why. Don't guess.
- When someone reports an error from further up the flow, take its trace or request id and follow it through each service's logs, from the first to this one. Save the chain once in the repo's notes, so the next session doesn't trace it again.

## 6. Write it down

- **Results** in the checks file: date, environment, commit, and per check: passed, failed, or not run with the reason.
- **What wasn't tested,** and what each part waits on and who owns it. Include what isn't this repo's but blocks the full flow (routing, upstream config, test data).
- **The checks file:** if a check or its command is wrong, fix it directly and add a Build log line. Add cases you found during the run (for example, one call succeeds and the next fails) as new checks, with their results.
- **`VERIFY.md`:** propose what you learned (a better way to call the service, a gotcha, what a role can't do). The engineer decides what to keep. Mark something "confirmed" only if you ran it in this session, and write the exact command that worked, never one from a summary or an earlier chat.
- Add a line to the plan's Build log. Commit and push the worknotes repo.

## 7. Report

The 3 to 5 lines, then failures first, each with the check, what you saw and the likely cause. If a failure is in the code, say to fix it in the build session, then redeploy and run this again. Draft messages for owners of what's blocking (2 to 4 short sentences, written as the engineer); post nothing without approval.

## Done when

- Every check has a result, or "not run" with what it waits on.
- What wasn't tested is listed, with owners.
- The results are in the checks file and the worknotes repo is pushed.

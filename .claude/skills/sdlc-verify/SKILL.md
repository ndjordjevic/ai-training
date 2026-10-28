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
- **Read only, apart from a deploy the engineer asks for.** Never change config, data, routing or other teams' systems, even when your role allows it. Say what needs changing and who owns it.
- **Deploy only through the repo's pipeline, and only when the engineer asks.** Plan first, read the plan, then apply (step 3).
- **Say what you stop or cancel.** A cancelled run shows as a failure to others. Tell the engineer at once, with the reason.
- **Credentials:** short-lived and read-only where possible, in a scratch file outside any repo. Ask the engineer to copy the export lines and run `! pbpaste > <path>`, so they never show in the chat. Source the file in each command; never print or copy its values. Delete it when done. If they get pasted anyway, don't copy them anywhere and let them expire.
- **Don't touch another session's checkout.** If the repo has a different branch checked out, do any git work in a separate worktree, and remove it when done.
- **Commands on shared machines** (a bastion, a jump host) only on the engineer's go-ahead, even read-only ones.
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
2. Tell the engineer whose deploy this replaces, so they can tell that person.
3. Run the pipeline as a plan only. Read the plan: every add, change and destroy should be explained by this branch. Anything else, stop and show it.
4. Apply. Then check the resources from step 2 again.

## 4. Test data

Every check depends on data: mocks, stubs, test customers. Before running checks, send the exact calls this code makes to the mock or test system, read only, and note what comes back. Mark each check "ready" or "waiting on: <data>, <owner>". If you can't add the data yourself, draft what is needed (the request to match and the response) for whoever owns it.

## 5. Run the checks

- Call the service at its own entry point, the closest to real you can get from here. Prefer a call through the gateway or front door (for example, a test-invoke from the cloud CLI) over calling the function directly; say what the call skips (for example, the network path).
- For each check: what you ran, what you expected, what you saw, and the log lines that prove it (never paste secrets, tokens or personal data).
- On an unexpected result, follow the request through the logs before saying why. Don't guess.
- When someone reports an error from further up the flow, take its trace or request id and follow it through each service's logs, from the first to this one. Save the chain once in the repo's notes, so the next session doesn't trace it again.

## 6. Write it down

- **Results** in the checks file: date, environment, commit, and per check: passed, failed, or not run with the reason.
- **What wasn't tested,** and what each part waits on and who owns it. Include what isn't this repo's but blocks the full flow (routing, upstream config, test data).
- **`VERIFY.md`:** propose what you learned (a better way to call the service, a gotcha, what a role can't do). The engineer decides what to keep.
- Add a line to the plan's Build log. Commit and push the worknotes repo.

## 7. Report

The 3 to 5 lines, then failures first, each with the check, what you saw and the likely cause. If a failure is in the code, say to fix it in the build session, then redeploy and run this again. Draft messages for owners of what's blocking (2 to 4 short sentences, written as the engineer); post nothing without approval.

## Done when

- Every check has a result, or "not run" with what it waits on.
- What wasn't tested is listed, with owners.
- The results are in the checks file and the worknotes repo is pushed.

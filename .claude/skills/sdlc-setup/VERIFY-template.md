# VERIFY: how to test this repo after a deploy

Repo-wide guide for any ticket. Ticket checks and results are in `.verify/<ticket-key>-<short-name>.md`. No secrets here, only where they come from. Mark each fact "confirmed", "assumed" or "to confirm".

## 1. Environments

Which environments exist, their accounts, and which can test what.

## 2. AWS access

For each computer: how to sign in, which account and role, and how the agent gets a session. Which role can do what.

## 3. How to deploy a branch

The pipeline, its inputs, and which account runs it.

## 4. How to call the service

URLs, required headers, example requests with fake values, test data. What can't be called from outside.

## 5. Logs and metrics

Log groups, what to look for, dashboards.

## 6. Standard smoke tests

Checks every ticket repeats.

## 7. Gotchas

## 8. Open (to confirm)

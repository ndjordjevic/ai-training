# <TICKET KEY>: <title>

Intent: .intent/<ticket key>-<short-name>.md
Branch: <branch>, from <base>
Status: <draft, waiting on answers | ready to build>

## Sources
- Pages (title, version), tickets, attachments, specs and mocks the design rests on. The full list is in .intent/<ticket key>-sources.md.

## Design

### How callers reach us
Who calls, through what, and who picks our address.

### D1. <decision>: decided <option>
The options, the trade-offs, and why this one.

## What we build
(Skip if there is a spec.) The decisions, in a few lines.

## What we will not do
-

## Must not change
Files, behaviour and callers this ticket leaves alone (for example, another backend, a shared validator, an error code callers read). Review and verify check the diff against it.
-

## What could break (who uses what we change)
-

## Testing
- Which behaviour we test, at which points, and which existing tests to copy.

## Verify
Checks: .verify/<ticket key>-<short-name>.md

## Tasks
In parallel: <tasks>. Then in order: <tasks>.

### Task 0: <name>
- **Goal:**
- **Files:**
- **Check:**
- **Blocked by:** nothing

### Task 1: <name> ⚠️ HIGH RISK (<why>)
- **Goal:**
- **Files:**
- **Check:**
- **Extra checks:**
- **Blocked by:** Task 0

## Open points: assumed for now, confirm later
1.

## Least sure about
The parts of this plan most likely to be wrong, and why. Review and verify check these first.
-

## Questions posted
- <ticket, comment date, to whom>: the questions, and which design point each answer changes.

## Build log
- <date>: <what was decided during the build, and why>.

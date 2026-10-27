# <repo name>: repo map

Read at: <commit> (<date>). Scope so far: <full | areas walked, with ticket keys>.

## What it is for
Two sentences.

## Entry points
- <program or handler>: <what starts it> -> <what it does>.

## Layers
<handler> -> <service> -> <client> -> <mapper>, with one example file each.

## Shared code
- <package>: <what it gives>. Generated code: <what generates it, from what>.

## Infrastructure
- What gets deployed, and how a request reaches it.

## Build, test, run
- Build: `<command>`. Test: `<command>`. Lint: `<command>`. CI: <workflows and what they do>.
- Tests run against: <real services, fakes, mocks>.

## Flows
### <flow name>
- What: one sentence.
- Path: <function (file)> -> <function (file)> -> ...
- Errors: <what fails, what the caller gets>.
- Differs from <first flow> by: <one line>.

## Where things go
- New endpoint: <files>.
- New field: <files>.
- New backend or setting: <files>.

## Traps
- <thing that surprises a newcomer>.

## Docs that are wrong or missing
- <doc and line>: <what the code really does>.

## Changelog
- <date>: <created | areas added | refreshed to commit>.

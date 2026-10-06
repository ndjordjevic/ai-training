# pstack notes

Notes on pstack, a skill stack by Lauren Tan ("poteto"). We read it to find ideas for [our-sdlc.md](our-sdlc.md). Same idea as [matt-skills-notes.md](matt-skills-notes.md).

- Original (Cursor): https://github.com/cursor/plugins/tree/main/pstack
- Port for Claude Code, Codex, Pi and **GitHub Copilot CLI**: https://github.com/michael-denyer/pstack-claude

## What it is

A full plugin, not just skills: about 58 skills, plus agents, hooks and a model config sheet. Two groups of skills:

- **Workflow skills (34):** do a job, for example `architect`, `tdd`, `babysit`.
- **Principle skills (24, `principle-*`):** short rules the agent follows. Not read yet.

Entry point is `poteto-mode`. You state a goal and it routes to the right skill. Install on Copilot CLI:

```
copilot plugin marketplace add michael-denyer/pstack-claude
copilot plugin install pstack@pstack-claude
```

Then run `setup-pstack` to pick models from the list your account has.

## Workflow skills (what each does)

**Entry and help**
- `poteto-mode`: routes a goal to the right skill. Enforces the style: short answers, simple code, verified work.
- `poteto-help`: answers "how do I use pstack?" and gives a prompt to send. Starts no work.
- `setup-pstack`: picks the model per role, writes a config sheet, turns the routing hook on or off.

**Understand**
- `how`: explains how code works, like onboarding a senior engineer.
- `why`: finds the reason behind a design (git, tickets, docs, chat) with citations.
- `teach`: runs `how` and `why`, gives one plain explanation. Changes nothing.
- `recall`: rebuilds where you left off from chat history and repo state.
- `bro`: restates the last message in plain language.

**Design**
- `architect`: sketch types, signatures and modules (empty bodies) before code. Throw the sketch away if it proves wrong.
- `blast-radius`: find what a change could break elsewhere. Proves it by running real code.
- `arena`: N parallel attempts, pick the best, graft good parts from the others.
- `swarm`: N parallel workers, one combined report.
- `figure-it-out`: design a custom, auditable playbook for big or unusual work.
- `show-me-your-work`: one-row-per-decision log (what, why, evidence, result) for long or unattended runs.

**Build**
- `tdd`: failing regression test before the fix, only when a cheap test path exists.
- `typescript-best-practices`: rule table for `.ts` and `.tsx` files.
- `no-comments`: subagent flags needless comments. Suggests types or tests instead.
- `deslop`: removes AI leftovers from the branch diff.
- `unslop`: strips AI tells from any writing.
- `technical-writing`: writing standard for docs, RFCs, READMEs, PR descriptions, commits.

**Review**
- `interrogate`: several different models review the same code adversarially. One synthesized verdict. Never auto-applies.
- `thermo-nuclear-code-quality-review`: very strict maintainability review.
- `benchmark-checklist`: vet a performance number before reporting it.
- `create-verification-skill`: generate a project `verify` skill that drives the real app like a user.
- `maintain-verification-skill`: periodic check that the verify skill still matches the app.

**PR and CI**
- `make-pr-easy-to-review`: clean history, better description, reviewer guidance. No behavior change.
- `get-pr-comments`: summarize review comments on the current PR.
- `fix-ci`: read failing checks, fix, repeat until green.
- `fix-merge-conflicts`: resolve conflicts, validate build and tests.
- `babysit`: watch an open PR, fix CI, handle easy comments, drive to mergeable.

**Learn and report**
- `correct`: when the same mistake is corrected twice, change the repo so it can't happen again. Order: architecture, types, lint, test, docs last.
- `reflect`: three parallel reviewers mine the chat and turn lessons into skill edits.
- `automate-me`: builds a personal `-mode` skill from your transcripts.
- `what-did-i-get-done`: summarize your commits over a time window.

## Principle skills (24 short rules)

Each one says when to apply it. `poteto-mode` makes the agent name the principle that shaped a decision.

**Debugging and proof**
- `fix-root-causes`: reproduce first, ask why until the real cause, no nil-check guards that hide crashes.
- `attack-the-premise`: when two fixes with the same assumption fail, write the assumption down and test it before a third fix.
- `prove-it-works`: before "done", check the real artifact (run it, read the value), not "it compiles".
- `explain-the-number`: before trusting a measured number, find what limits it ("why not double?") and rule out that it measured the wrong thing.
- `test-behavior-not-implementation`: keep a test only if a named defect makes it fail. Test public behavior.
- `sequence-verifiable-units`: small steps, each checked before the next. Stack commits so the order proves the work (failing test, then fix).

**Design**
- `foundational-thinking`: get data structures and core types right first. Isolate shared state between concurrent actors.
- `model-the-domain`: use a state machine or sum type instead of scattered booleans and conditionals.
- `type-system-discipline`: make illegal states unrepresentable, parse external data at the edge, handle every variant.
- `boundary-discipline`: validate and handle errors at system edges only. Trust internal types. Keep logic in pure functions.
- `exhaust-the-design-space`: for a novel decision, build 2 to 3 prototypes and compare before committing.
- `redesign-from-first-principles`: when a new requirement arrives, redesign as if it was there from day one. No bolt-ons.
- `experience-first`: choose user delight over implementation convenience. Fewer polished features beat many rough ones.

**Simplicity and cleanup**
- `laziness-protocol`: prefer deletion, flat call chains, one source of truth for each decision.
- `subtract-before-you-add`: remove dead code and redundant checks first, then build on the simpler base.
- `minimize-reader-load`: count layers to trace and state to hold. Collapse one-caller wrappers.
- `migrate-callers-then-delete-legacy-apis`: move all callers and delete the old API in the same wave. No compatibility layers.
- `outcome-oriented-execution`: in planned migrations, aim for the target end state. No throwaway compatibility code between steps.

**Automation and safety**
- `build-the-lever`: for non-trivial work, write the script or codemod instead of editing by hand. A reviewer can rerun it.
- `encode-lessons-in-structure`: if you write the same instruction twice, turn it into a lint, check or script.
- `make-operations-idempotent`: every command must be safe to run twice and after a half-finished crash.
- `separate-before-serializing-shared-state`: stop concurrent actors from sharing state. If they must, enforce order with locks, not instructions.

**Agent habits**
- `never-block-on-the-human`: on reversible work, proceed and show the result. Ask only before irreversible actions.
- `guard-the-context-window`: send big outputs to subagents. Keep summaries in the main thread.

## Applied to our-sdlc.md

| Idea (skill) | Where in our-sdlc.md |
|---|---|
| Check what the ticket claims about the code (`blast-radius`) | Step 1, "Already built?" |
| List who calls or uses what we change (`blast-radius`) | Step 2, "what could break" |
| Sketch types and signatures for a new module (`architect`) | Step 2, tasks |
| Remove dead code first (`subtract-before-you-add`) | Step 2, prefactor |
| Test the shared assumption after two failed fixes (`attack-the-premise`) | Bug process |
| Fix the cause, no guards that hide the error (`fix-root-causes`) | Bug process |
| "Done" means checked on the real thing (`prove-it-works`) | Step 3, agent checks its own work |
| Script or codemod for repeated edits (`build-the-lever`) | Step 3 |
| Small reversible choices don't wait, one line in a Build log (`never-block-on-the-human`, `show-me-your-work`) | Step 3 |
| Remove AI leftovers, commits in order (`deslop`, `make-pr-easy-to-review`, `sequence-verifiable-units`) | Step 3, before the PR |
| Second-model review for big tasks and one-way doors (`interrogate`) | Step 4, AI review |
| Follow through: comments, CI, conflicts (`babysit`, `get-pr-comments`, `fix-ci`, `fix-merge-conflicts`) | Step 4, item 8 |
| Retro order: structure or types, then lint or hook, then test; prove the check fails (`correct`, `encode-lessons-in-structure`) | Step 4, retro |
| Draft the verifier (`create-verification-skill`) | Part 2, custom agents |

## Not taken

- `tdd`, `test-behavior-not-implementation`, `exhaust-the-design-space`, `redesign-from-first-principles`: already covered by our test rules, prototype and prefactor.
- `reflect`, `automate-me`: our retro covers this.
- `arena`, `swarm`, `figure-it-out`: heavy on tokens. Maybe later for big tasks.
- `how`, `why`, `teach`, `recall`, `bro`, `what-did-i-get-done`: useful personal tools, not flow steps.
- `typescript-best-practices`, `benchmark-checklist`, `thermo-nuclear-code-quality-review`: only for some repos or tasks.
- Separate TSV decision log: a few lines in the plan are enough.
- `never-block-on-the-human` in full: it would remove our human checkpoints (refresh, PO confirm, diff review, deploy approval). We only use it for small build choices.
- The design principles (`model-the-domain`, `type-system-discipline`, `boundary-discipline` and others): good candidates for `CODING_STANDARDS.md` later.

## Open

- Install the pstack plugin on Copilot CLI, or only copy the ideas? README says `copilot -p` loses plugin skills on 1.0.92.

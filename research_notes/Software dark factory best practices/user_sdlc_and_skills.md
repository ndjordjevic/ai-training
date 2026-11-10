# The user's own AI-native SDLC and its sdlc-* skills (what a dark factory must drive)

Scope: local files only. Sources are file paths in `/Users/nenaddjordjevic/ai-training/`. Short names used below:
- [our-sdlc] = `file:///Users/nenaddjordjevic/ai-training/our-sdlc.md`
- [playbook] = `file:///Users/nenaddjordjevic/ai-training/ai-native-sdlc-playbook.md`
- [S:<name>] = `file:///Users/nenaddjordjevic/ai-training/.claude/skills/<name>/SKILL.md`
- [flow-rules] = `file:///Users/nenaddjordjevic/ai-training/.claude/skills/sdlc-ticket/flow-rules.md`
- [status.sh], [worktree.sh] = `.claude/skills/sdlc-ticket/scripts/`; [board.sh] = `.claude/skills/sdlc-board/scripts/board.sh`; [attachments.sh], [office2text.py] = `.claude/skills/sdlc-research/scripts/`; [creds-check.sh] = `.claude/skills/sdlc-verify/scripts/`; [worknotes-push.sh] = `.claude/skills/sdlc-setup/scripts/`
- [tab2] = `file:///Users/nenaddjordjevic/ai-training/part1-tab2-build.md`; [tab1] = `part1-tab1-getting-started.md`
- [git-log] = `git -C /Users/nenaddjordjevic/ai-training log --oneline -40` (latest commit 31eba7e, 2026)

## 1. What is the ordered flow of skills from ticket to done, what starts each, and what does each produce?

### Takeaway
There are 16 `sdlc-*` skills. Every one is started by hand with `/<name> <ticket>` (`disable-model-invocation: true`), so nothing triggers on its own today. The main path is setup (once per repo), then intake, plan, build, review/walkthrough, pr, summary, verify, qa, and qa-fix if QA sends it back. `sdlc-ticket` already chains intake through to verify in one session with subagents, and it is the nearest thing to a factory "run". Release/merge/prod deploy and the metrics loop are written down in our-sdlc.md but have no skill yet.

### Cited Findings
**The flow as a whole**
- Six steps: 1 intake, 2 refresh then plan, 3 refresh then build, 4 PR (AI review, the engineer's walkthrough, one PR, coworker review), 5 release (merge, prod deploy with human approval, check AWS logs and metrics), 6 production problems become new Jira tickets — [our-sdlc] "The flow in one view".
- The trigger is the engineer picking up a ticket: "The change starts when an engineer picks up the ticket… the ticket is the first draft, and the engineer and the agent turn it into an intent." Jira stays the source of truth for status, assignee and sprint — [our-sdlc] "Our starting point".
- Every skill has `disable-model-invocation: true` and an `argument-hint` such as `"<ticket key>"`, so only the user can start it — [S:sdlc-ticket], [S:sdlc-intake], [S:sdlc-plan] and all the others (frontmatter).
- One skill per step, "started by the engineer with `/<name> <ticket>`. Each is self-contained." They will move to their own repo, installable for Claude Code, Cursor and Copilot — [our-sdlc] "Our own flow skills".
- Still to build: "follow-through, release, a router ('ask our SDLC'), a bug diagnosis skill, and a scheduled review of existing code" — [our-sdlc].

**Each skill: what starts it, what it reads, what it writes**
| Skill | Started by / when | Reads | Writes / side effects |
|---|---|---|---|
| sdlc-setup | once per repo and per computer | repo, `acli` auth, `gh auth`, worknotes repo | worknotes folder `<worknotes>/<repo>/` with `.intent/ .specs/ .plans/ .notes/ .verify/VERIFY.md GLOSSARY.md` (+ private `CLAUDE.md`); symlinks into the work repo; `.git/info/exclude` lines; runs build/test/lint once; pushes worknotes. Never commits the work repo — [S:sdlc-setup] |
| sdlc-onboard | by hand (`full`, `<ticket>`, file, package) | code, docs | `REPO-MAP.md` in worknotes with the commit it was read at — [S:sdlc-onboard] |
| sdlc-research | run by intake, or by hand | Jira, Confluence (CQL), attachments | `.intent/<key>-sources.md`; attachments go to a scratch folder outside the repo — [S:sdlc-research] |
| sdlc-intake | start of every feature/story; again to resume after answers | ticket, parent/epic, subtasks, links, attachments, sources, REPO-MAP | `.intent/<key>-<short>.md` (Source with timestamps, Problem, Outcome, Affected systems, Constraints, Decisions from comments, From attachments, Parked for the plan, Open questions, Changelog); `GLOSSARY.md` terms; optional draft Jira question comment — [S:sdlc-intake], `intent-template.md` |
| sdlc-plan | after intake, new session; again to refresh | intent, sources, REPO-MAP, code, AWS read-only | optional `.specs/<key>-*.md`; `.plans/<key>-*.md` (Intent link, Branch/base, Status, Design, Must not change, What could break, Testing, Tasks with Files/Check/"Blocked by", Open points, Questions posted, Build log); `.verify/<key>-*.md` checks file; may fill `VERIFY.md` — [S:sdlc-plan], `plan-template.md` |
| sdlc-build | after plan | plan, intent, checks file, GLOSSARY | code as ONE uncommitted, unstaged diff on the feature branch; local `<ticket>-build` and `<ticket>-task-N` branches/worktrees for parallel tasks (never pushed, removed after); Build log lines — [S:sdlc-build] |
| sdlc-review | after build, new session | plan + Build log, intent, checks, standards | fixes as unstaged changes apart from the staged build; findings in 5 groups; status block in the Build log; tells the engineer to run walkthrough then `/sdlc-pr` — [S:sdlc-review] |
| sdlc-walkthrough | by hand, `<base>` / `HEAD` / PR number | real diff | explanation only; status in the Build log — [S:sdlc-walkthrough] |
| sdlc-pr | after the engineer pushes | plan, intent, checks | `gh pr create --draft --assignee @me`; `gh pr edit`; later `gh pr ready`; PR link in the Build log — [S:sdlc-pr] |
| sdlc-summary | once the PR exists | diff, plan | one Jira comment (the only end-of-flow ticket comment); comment id in the Build log — [S:sdlc-summary] |
| sdlc-verify | after the PR is pushed, new session | VERIFY.md, checks file, plan, intent, pipeline runs, AWS | optional deploy through the pipeline; optional new mock stubs (import file saved); Results in the checks file; additions to VERIFY.md — [S:sdlc-verify] |
| sdlc-qa | after verify, when the ticket moves to QA | latest Results, stub import files | draft QA handoff comment (tags QA) — [S:sdlc-qa] |
| sdlc-qa-fix | when QA reopens or opens bug subtasks | QA evidence, logs, parent's files | fix on the open PR's branch, or a new branch/worktree if merged; before/after table; draft reply per subtask; notes — [S:sdlc-qa-fix] |
| sdlc-pr-review | a coworker's PR | PR, ticket, notes | review worktree; one GitHub review (`gh api .../reviews`) or a fix commit pushed / PR into their branch — [S:sdlc-pr-review] |
| sdlc-board | start of the day, before a deploy | worktrees, `gh pr list`, `gh run list`, status.sh | read only; a board report — [S:sdlc-board] |
| sdlc-ticket | one normal-size ticket, after setup | everything above | runs intake→plan→build(+verify prep)→review→draft PR→verify in subagents; end report; full report in the Build log — [S:sdlc-ticket] |

- Each step names the next one: intake→`/sdlc-plan` (new session); plan→`/sdlc-build` (same or new session, with a reason); build→`/sdlc-review` (new session); review→walkthrough, commit and push, `/sdlc-pr`, then `/sdlc-verify` (new session); pr→`/sdlc-summary`, then `/sdlc-verify`; setup→`/sdlc-onboard full`, then `/sdlc-intake` — the "Next:" lines of each [S:*].
- sdlc-ticket order: 0 Check (setup exists, status.sh to resume, network) → 1 Start (one round of questions, worktree.sh, `/add-dir`) → 2 Intake → 3 Plan → 4 Build, with the verify prep alongside (verify steps 0, 1, 2, 4, read only) → 5 Review → commit and push if allowed → 6 Draft PR if allowed → 7 Verify → 8 End report — [S:sdlc-ticket].
- sdlc-ticket stops early on: already built / the ticket contradicts itself (after intake); "too big" (several services, a security review, or more than a few days) after the plan; expired credentials in verify ("the only stop in the middle") — [S:sdlc-ticket].
- Release (session 5): the agent merges with `gh pr merge` (branch protection enforces approvals), the pipeline deploys, a human approves prod, a read-only AWS role reads CloudWatch, a smoke test, a Jira summary, the ticket moves to "Done"; rollback is proposed and a human decides — [our-sdlc] "5. Release". There is no skill for it.
- Coworker follow-through (step 4.10): resume session 4, summarise comments, fix CI and conflicts, push each fix as a new commit; the engineer answers the rest and resolves threads — [our-sdlc]. There is no skill for it.

### Inferences
- A factory's state machine can be: setup? → intake → plan → build → review → PR(draft) → verify → QA handoff → [QA bounce → qa-fix → verify] → coworker review → merge → prod deploy → post-deploy check → Done. Steps from intake to verify are already chained by sdlc-ticket. Release, follow-through and "back to the start" are prose only.
- "Ticket assigned to the user" is not a trigger anywhere in the files. The factory would add it (for example a JQL poll or a Jira webhook) and then call the equivalent of `/sdlc-ticket <key>`.

### Gaps
- There is no written Jira status model ("In review", "Done" are the only status names, in [our-sdlc] step 4.9 and 5.5). Workflow names like "In QA" and transitions are not given.
- No skill reacts to coworker review comments or CI failures (follow-through).

## 2. Where are the human decision points today?

### Takeaway
There are many. They fall into four kinds: (a) approving the exact text before any post, PR or comment; (b) git and deploy permissions (commit, push, deploy, stubs); (c) design or scope decisions (base branch, big task or not, parallel or serial, which findings to fix, root-cause go-ahead); (d) physical or credential actions (pasting AWS creds, web-console sign-in, `/add-dir`, network/VPN switches, accepting plan mode). sdlc-ticket already folds most of (b)–(c) into ONE upfront question round, plus an end-report queue of drafts. That is the factory's "needs human decision" pattern.

### Cited Findings
**Approve the text before posting (every skill)**
- "Nothing is posted before the engineer approves the text" (Jira comments, chat messages) — [our-sdlc] step 4.6 "Posts for others".
- Intake questions: "Show the draft to the engineer, and post it only after they approve the text" — [S:sdlc-intake] step 5. Plan does the same (design step 4) — [S:sdlc-plan]. Review "Needs an answer" — [S:sdlc-review].
- PR: "Never create or change the PR without the engineer approving the exact title and description"; mark ready "only when the engineer asks" — [S:sdlc-pr].
- Summary, QA handoff and QA-fix replies: never post without approval — [S:sdlc-summary], [S:sdlc-qa], [S:sdlc-qa-fix] step 7.
- pr-review: approve the exact text of every comment; choose delivery A/B/C; push only on B or C — [S:sdlc-pr-review] step 4.

**Git and deploy permissions**
- Build: "the engineer owns the feature branch: never commit, push, switch it or create it. Never stage anything" — [S:sdlc-build]. "The engineer commits and pushes, never the agent" — [our-sdlc] step 3.
- Review: "Change only what the engineer agrees to… Stage only when they say so"; the engineer picks which findings to fix — [S:sdlc-review] steps 2, 6.
- Verify: deploy "only when the engineer asks"; test data only "when the engineer asks and its owner agrees"; commands on shared machines (bastion) only on the go-ahead; ask before changing or deleting what is in VERIFY.md — [S:sdlc-verify].
- Release: a human approves the prod deploy; a named approver for a "one-way door"; a human decides rollback — [our-sdlc] step 5.
- Coworker approval is still required: "The agent that wrote the code can never approve it" — [our-sdlc] step 4.9; "An agent's approval never counts as a person's" — [our-sdlc] "AI review of PRs" 6.

**Design or scope decisions (step-by-step mode)**
- Intake: scope first ("which subtasks are the engineer's?"), then grilling rounds with recommended answers — [S:sdlc-intake] step 3.
- Plan: "Is this the branch you'll build on?"; the engineer decides big task / spec using three evidence questions; ask "how to split"; every plan-vs-intent difference is "the engineer decides"; accept plan mode to get the file written; check caller facts with the caller's team — [S:sdlc-plan] steps 0, 2, 3, 6, 8.
- Build: one question, "parallel or one after another?"; it stops for "something the plan doesn't cover, that is hard to undo, or that would change what existing users see" — [S:sdlc-build].
- Review: "Same session as the build? … ask once"; a third review means stop and suggest rethinking — [S:sdlc-review] step 0.
- QA-fix: "Wait for a yes before changing code" after the root cause; ask for the branch name; ask before an experiment branch; offer open sibling subtasks — [S:sdlc-qa-fix] steps 4, 5.
- Refresh cascade: the intent is updated without asking, but "the agent shows what must change in the spec… then in the plan, and the engineer confirms each" — [our-sdlc] "the refresh".

**sdlc-ticket's single start round (the closest thing to a factory policy)**
- Asked once at the start, each with a proposed answer and one line of evidence: 1 base branch; 2 branch name and worktree folder; 3 yes/no for: commit+push, open a draft PR, add new mock stubs (new ids only), deploy to the named lower environment; 4 credentials pasted; 5 the stub tool's web console is reachable — [S:sdlc-ticket] step 1.
- After that: "investigates instead of asking, writes down what it assumes… posts nothing" — [S:sdlc-ticket], [flow-rules] "No messages during the flow".
- "Waiting for a yes: … the start answers decide. If they don't cover it, don't do it; list it in the end report" — [flow-rules].
- Assumption format: "Assumed: <answer>, because <evidence>. If wrong: <what changes, which tasks>. Ask: <role>." "Where two options are close, pick the one that is cheaper to change later" — [flow-rules].
- End report = the human queue: Blocks the merge; Changes; Questions for the team (one draft comment); Notes to send (heads-up if the deploy replaced someone's work; a QA retest note); Verify line; Next (`/sdlc-walkthrough <base>` in a new session) — [S:sdlc-ticket] step 8.
- Question filter: six checks before any question (look first; the case really happens; the answer changes the code; precedent; not the engineer's own call; a wrong guess is costly — "a guess about what the end user or QA sees … is never cheap"), run once by a fresh read-only subagent — `.claude/skills/sdlc-intake/questions-template.md`.

### Inferences
- Factory "needs human" queue items: (1) start-policy answers per ticket (or per-repo defaults); (2) credential refresh; (3) approve or post drafted Jira comments, QA notes, heads-ups; (4) the engineer's walkthrough / own review before marking the PR ready; (5) coworker approval; (6) prod deploy approval and rollback decision; (7) "too big / already built / contradicts itself" stops; (8) root-cause go-ahead in qa-fix.
- The start round could become repo-level policy in a config file (allowed: push, draft PR, stubs, lower-env deploy), with an override per ticket.

### Gaps
- Who approves a spec, who confirms a refresh, which approvals must stay in the change process: listed as open questions, not decided — [our-sdlc] "Open questions → Ownership/Process".
- Whether a low-risk PR can ever merge with no human approval in "our regulated setup" — open — [our-sdlc].

## 3. Where does state live, and is there a status model a factory could read?

### Takeaway
State is file-based in a private "worknotes" git repo, symlinked into each work repo and hidden with `.git/info/exclude`. On top of it: the git branch/worktree per ticket, the GitHub PR, and the pipeline's last successful run. `status.sh` gives a deterministic per-ticket step status. It derives it from file existence and marker lines in the plan ("flow: build done" etc.). `board.sh` gives a cross-ticket board (PR, deployed?, dirty/unpushed, next step, "waiting on", file overlap). Jira holds status, assignee and comments, but no skill writes Jira fields or labels.

### Cited Findings
- Files per ticket, linked by Jira key: `.intent/<key>-<short>.md`, `.intent/<key>-sources.md`, `.specs/<key>-<short>.md` (big tasks), `.plans/<key>-<short>.md`, `.verify/<key>-<short>.md`; per repo: `.verify/VERIFY.md`, `GLOSSARY.md`, `.notes/`, `REPO-MAP.md`, private `CLAUDE.md` — [our-sdlc] intro, [S:sdlc-setup] step 2.
- "They live in a private worknotes repo, not in the work repo… never go into the work repo or the PR" — [our-sdlc] intro.
- Worknotes are pushed by `worknotes-push.sh`: commits only this repo's folder, `git pull --rebase` first, aborts on conflict ("pull failed: fix by hand"), pushes — [worknotes-push.sh].
- The intent's Source holds Jira last-updated times, subtask/link times, Confluence versions, "Last synced". These drive the cheap "refresh" check (compare timestamps; "no change" costs almost nothing) — [our-sdlc] "the refresh", `intent-template.md`.
- The intent's top holds Base, Branch, Worktree lines ("Write the base, the branch and the folder at the top of the intent, so every step and every later session finds them") — [S:sdlc-ticket] step 1; read by `status.sh` (`grep -m3 -E '^(Base|Branch|Worktree):'`) — [status.sh].
- Plan `Status:` values: "draft, waiting on answers" or "ready to build", optionally "(Task 2 waits on <person>'s answer)"; Open points carry "waiting on: <need>, <owner>" — [S:sdlc-plan] steps 3, 7, 9.
- Step markers: "Mark each step done with one Build log line in the plan: 'flow: build done', 'flow: review done', 'flow: verify done'. The status script reads them" — [flow-rules].
- `status.sh <key>` output: intake done? (intent exists), plan Status line, build/review/verify done (grep the markers), the PR URL (first `github.com/.../pull/N` in the plan), the checks file — [status.sh].
- `board.sh [workflow]`: last successful deploy (`gh run list --workflow <wf> --status success -L 1`); for each worktree whose branch contains a Jira key: PR number/base/draft, `deployed` (`git merge-base --is-ancestor head dep_sha`), uncommitted count, unpushed count, next step (from status.sh), up to 3 "waiting on" lines; then pairwise file overlap between open branches — [board.sh].
- Board report leads with: Conflicts coming, Environment (which ticket the lower env runs), Stuck (waiting on whom, since when), Loose work — [S:sdlc-board].
- Branches/worktrees: one per ticket, made by `worktree.sh <base> <branch> <folder>` (copies the top-level symlinks, warns if not ignored); naming like `feature/<key>`, folder `../<repo>-<key>` — [worktree.sh], [S:sdlc-ticket] step 1. Build uses local `<ticket>-build` and `<ticket>-task-N` — [S:sdlc-build].
- Environment state: "The environment runs one branch at a time"; a deploy that replaces another ticket's work writes "not deployed in <env> since <time>, replaced by <ticket>" in the other ticket's checks file and Build log — [S:sdlc-verify] step 3.6.
- Credentials: a scratch file outside any repo, chmod 600; kept for lower envs until expiry, deleted for prod — [S:sdlc-verify] Rules.
- Jira writes are only comments (questions, summary, QA handoff, QA replies, release summary). The ticket moves to "In review" and "Done" in prose — [our-sdlc] steps 4.9, 5.5; no skill does a transition.

### Inferences
- A factory can use `status.sh`/`board.sh` output directly as its read model, or parse the same markers. The markers are plain-text conventions (grep on "flow: X done"). They are fragile but deterministic.
- The worknotes repo is per-engineer and private. A multi-agent factory on one machine is fine; several machines need the pull-rebase push to win. There is no locking beyond git.
- No structured (JSON/YAML) state exists. A factory would need a status file per ticket, or Jira fields, for queueing, retries and "waiting on human" states.

### Gaps
- No status marker for intake/plan beyond file existence and the Status line; no markers for "pr opened", "QA handed off", "merged", "released".
- No Jira labels or custom fields are used.

## 4. What tools and integrations are used, and which parts are deterministic scripts vs model judgment?

### Takeaway
Integrations: Jira/Confluence via the Atlassian CLI `acli`, plus a REST fallback with a token file (attachments, search, CQL/JQL, mentions). GitHub via `gh` (PR create/edit/ready, pr list, run list, reviews API). Git worktrees. AWS CLI with short-lived creds (read-only, plus deploys through the repo's pipeline, which looks like a GitHub Actions workflow such as `wf-deploy.yml`). A mock service with a web console driven through a browser tool. Five small scripts cover the repeated mechanical work. Everything else is model judgment.

### Cited Findings
- Jira/Confluence: `acli jira auth status`, `acli confluence auth status`, `acli jira workitem view <key>`; "`acli` can't download attachments or search, and only reads Confluence", so a REST API with a token in a local credentials file is the fallback — [S:sdlc-setup] step 1. The Atlassian MCP is mentioned as an option ("Is the Atlassian MCP server allowed at work…?" is open) — [our-sdlc] intake step 1, Open questions.
- `acli jira workitem view <parent> --fields subtasks --json` to list open defect subtasks — [S:sdlc-qa-fix].
- Mentions must be real (look up the account id with a Jira user search); "a typed @name notifies nobody" — `questions-template.md`.
- GitHub: `gh pr create --draft --assignee @me --base … --body-file`, `gh pr edit`, `gh pr ready`, `gh pr list --head` — [S:sdlc-pr]; `gh api repos/<repo>/pulls/<N>/reviews --input review.json` with suggestion blocks — [S:sdlc-pr-review]; `gh run list --workflow` — [board.sh]. The global CLAUDE.md says to use the `basiq-ndjordjevic` gh account for work repos.
- Deploy: "Deploy through our pipeline… Run a plan only, read it… then apply"; lower env plan+apply in one run if the pipeline can; the upper env plan first — [S:sdlc-verify] step 3; the deploy workflow file comes from VERIFY.md (for example `wf-deploy.yml`) — [S:sdlc-board]. Terraform is used (moved blocks, `terraform init` leftovers) — [our-sdlc] step 3/4.
- AWS: local CLI or "script for the engineer" on a locked-down desktop (AWS WorkSpaces); the choice is recorded per repo — [our-sdlc] "Looking in AWS". Test-invoke through the gateway is the check entry point — [S:sdlc-verify] step 5.
- Mocks: a web console the engineer signs in to; the agent pastes stubs "into the visible editor in the dialog… read it back… before Import or Save" — [S:sdlc-verify] step 4 (implies a browser tool such as Chrome MCP).
- Bundled Claude Code commands: `/code-review high --max-findings all`, `/security-review`, optional `/code-review ultra` (billed, started by the engineer) — [S:sdlc-review] step 1.

**Deterministic scripts (allowed in frontmatter, so they run without prompts)**
- `status.sh` (step status), `worktree.sh` (worktree + links), `attachments.sh` (downloads every attachment of the ticket, parent, epic, subtasks, links and given pages via REST; sha256 de-dup; never prints the token), `office2text.py` (xlsx/docx/pptx to text, stdlib only, run `python3 -I`), `creds-check.sh` (counts `export AWS_` lines, checks mode 600, `aws sts get-caller-identity`, prints only account/role), `worknotes-push.sh`, `board.sh` — [S:sdlc-ticket] allowed-tools, the script files. "The steps that are always the same are scripts next to the skills" — [our-sdlc].
- Audit has its own tool script (golangci-lint, govulncheck, tflint, Checkov, actionlint, zizmor, ShellCheck, TruffleHog) in `audit-kit/` — [our-sdlc] "Auditing an existing repo".

**Model judgment** — everything else: reading and summarising tickets/pages, intent writing, design, task split, code, review findings and proof, the question filter, verify interpretation (comparing results with "Expect"), deciding drift, drafting posts.

### Inferences
- The factory's tool surface is: `acli` + Jira/Confluence REST, `gh`, git, AWS CLI with a scoped role, the repo's GH Actions deploy workflow, and a browser tool for the mock console. The browser/console part is the hardest to run headless.
- The scripts are portable bash and can be reused unchanged by any runtime.

### Gaps
- The exact deploy workflow inputs, environments and mock product are repo-specific (in each repo's VERIFY.md, not in this repo).

## 5. What models and subagents are used, and where? Any cost or effort settings?

### Takeaway
There is an explicit split: Opus for the main/orchestrator session and for intake, plan, review (bugs and security reviewers); Sonnet for build tasks, verify, fresh plan readers, the plan-vs-code reviewer, the question check and any work after the end report; Haiku for research searches. The model is set per Agent call. No custom agent files are used. Cost rules: no Jira refresh after intake in the one-session flow, ~300-word subagent reports, verify prep in parallel with build, the question check once.

### Cited Findings
- "Strongest model: this session… and the intake, plan and review subagents, with review's bugs and security reviewers. Cheaper (Sonnet): the build subagent and its tasks, the verify subagents, the plan's fresh readers, review's plan-vs-code reviewer, the final question check, and any work after the end report. Cheapest (Haiku): research searches only… Back to the strongest for build tasks the plan marks high risk, and in verify for a failure whose cause isn't clear" — [S:sdlc-ticket] "Models".
- "Set the model on every subagent call (in Claude Code, the Agent tool's `model`…). No custom agent files are needed" — [S:sdlc-ticket].
- Evidence for Opus at intake: "In our DSM-960 trial… Sonnet broke one or two rules on every run… and Opus broke none" — [our-sdlc] intake "Model".
- Opus "costs several times more… on a subscription it uses up the usage window fast" — [S:sdlc-ticket].
- Fallback default: `CLAUDE_CODE_SUBAGENT_MODEL=sonnet` — [our-sdlc] step 3 Models.
- Subagent prompt template: ticket, worktree folder, skills folder; read flow-rules.md then `sdlc-<step>/SKILL.md` ("The step skills can't be invoked from here; their files are read instead") — [S:sdlc-ticket] "How each step runs".
- The orchestrator spot-checks each report (the files exist, the headings and key lines are there); "A gap goes back to the same subagent" via `SendMessage` — [S:sdlc-ticket].
- Plan fresh readers: Retell, Builder, Simpler (3 read-only subagents); sdlc-ticket uses only Builder and Simpler on Sonnet — [S:sdlc-plan] step 8, [S:sdlc-ticket] step 3.
- Speed/cost rules: no refresh after intake, read once, use the given scripts, ≤300-word reports — [flow-rules] "Speed and cost". After the end report, extra work goes "to a fresh Sonnet subagent, because the main session's long context makes every call there expensive" — [S:sdlc-ticket].
- Parallel subagents: "Start with two or three… Review is the limit, not the tools" — [our-sdlc] step 3. Budget for parallel use is an open question — [our-sdlc].
- Copilot: `/fleet` subagents "use a low-cost model by default, and more agents mean more AI credits"; `/goal … --max-ai-credits 5` caps cost — [tab2].

### Inferences
- A factory can keep the same tiering. The orchestrator on the strongest model holds the gates; workers run cheaper. The DSM-960 evidence argues against moving intake/plan/review to a cheap model.

### Gaps
- No effort/thinking-level settings and no token/cost numbers per run are recorded.

## 6. Agent runtime constraints (Copilot-only company) and what is hard to run headless

### Takeaway
The skills are written for Claude Code: `${CLAUDE_SKILL_DIR}`, `allowed-tools` frontmatter, `disable-model-invocation`, the Agent tool `model` param, `SendMessage`, `/add-dir`, bundled `/code-review` and `/security-review`, `!` shell, plan mode. They do have "elsewhere" fallbacks, and the stated goal is to make them installable for Copilot too. The company licenses only Copilot, so a factory at work would have to run on Copilot CLI (`copilot -p` / autopilot `/goal` / `/fleet` / cloud agent `/delegate` / GitHub Agentic Workflows). Several Copilot capabilities the flow relies on are open questions in the doc.

### Cited Findings
- "The agent means Copilot CLI, which is what we have. Claude Code works the same way" — [our-sdlc] "Words used here". The training uses Claude Code as the reference because features land there first — README.
- The skills "will move to their own repo, installable for Claude Code, Cursor and Copilot" — [our-sdlc]. Copilot CLI reads `.claude/skills/`, `.agents/skills/`, `.github/skills/`, `~/.copilot/skills/` — [our-sdlc] "Skills for company rules".
- Fallbacks in the skills: "In Claude Code: run the bundled `/code-review`… Elsewhere: a reviewer subagent" — [S:sdlc-review]; "If a bundled review command… can't run in the subagent, use a reviewer subagent instead" — [S:sdlc-ticket] step 5.
- Open Copilot questions: "Can our CI run Copilot CLI without a person, and which model and cloud access is allowed from CI?"; "Can Copilot `/fleet` give each subagent its own worktree?"; "Do skills copied from other agents… load properly in Copilot CLI?"; pstack README "says `copilot -p` loses plugin skills on 1.0.92"; is the Atlassian MCP allowed; which second review model — [our-sdlc] "Open questions".
- Copilot headless flags: `copilot -p`, `-s`, `--no-ask-user` ("it decides instead of stopping to ask"), `--output-format json`, `--allow-tool='shell(git:*)'`, `--allow-all` "only in a sandbox" — [tab2] ~line 586.
- Copilot autopilot `/goal`: "no separate checker: the agent stops when it thinks it's done, or after 5 automatic steps by default (`--max-autopilot-continues`)" — [tab2] ~line 556.
- `/fleet` "is not a real team… the docs don't describe subagents messaging each other" — [tab2] ~line 136. This matters because sdlc-ticket's "a gap goes back to the same subagent" depends on `SendMessage`.
- `copilot workflow run <name>` runs a saved workflow with no chat, JSON args and JSON output; the docs describe only the command — [tab2] ~line 200.
- GitHub recommends GitHub Agentic Workflows over `copilot -p` in a workflow step; use `GITHUB_TOKEN` in org repos — [tab1] ~line 1189. Cloud agent `/delegate` opens a PR — [tab1] ~line 607.
- Org policy hooks/managed settings live in the org's `.github-private` repo, "take about an hour to apply" — [our-sdlc] "Release gates".
- Built-in worktree isolation breaks with the symlinked `.claude`/worknotes setup and starts from main, so the main session creates worktrees itself — [our-sdlc] step 3, [S:sdlc-build] step 3.1.

**Hard to run headless/unattended (as written)**
- Credentials: the engineer pastes short-lived AWS export lines into the chat (lower envs); for prod the engineer types `! (umask 077; pbpaste | tr -d '\r' > <file>)` — [S:sdlc-verify] Rules. They expire mid-flow, which is "the only stop in the middle" — [S:sdlc-ticket] step 7.
- Network: VPN/proxy switching; "A proxy may block new connections to the model API… a subagent that starts with the proxy on can die"; the engineer switches between subagents, or scripts from VERIFY.md do it — [flow-rules].
- Web consoles: "the engineer signs in in the browser; the agent never types a password" — [S:sdlc-verify].
- `/add-dir <folder>` for the new worktree, so edits don't prompt each time — [S:sdlc-ticket] step 1.
- AWS for some repos is reachable only from a locked-down desktop (AWS WorkSpaces): the agent writes read-only scripts and the engineer pastes the output back — [our-sdlc] "Looking in AWS".
- Plan mode: "nothing is written until the engineer accepts the plan" — [S:sdlc-plan] Rules (sdlc-ticket turns plan mode off: [flow-rules]).
- The walkthrough is interactive by design ("one file at a time, the agent waits for 'next'") — [S:sdlc-walkthrough]; the engineer's own review is required before ready/commit in the step-by-step flow — [S:sdlc-review].
- Shell traps on the Mac (zsh `path` variable, `=word`) — [flow-rules]. The macOS `stat -f`/`pbpaste` usage — [creds-check.sh], [S:sdlc-verify].

### Inferences
- A work factory most likely has to use Copilot CLI (`copilot -p --no-ask-user` or Agentic Workflows) as the runtime. The Claude-Code-specific parts (Agent `model` per call, `SendMessage` resume, `/code-review`, `allowed-tools` with `${CLAUDE_SKILL_DIR}`) need a Copilot equivalent or a fallback, and each one is unverified.
- Credentials and the network are the main blocker for an unattended run. A factory needs a machine identity (an OIDC/role-based AWS session, a Jira API token, the GitHub App/`GITHUB_TOKEN`) instead of pasted human sessions. That conflicts with "the agent never deploys with its own AWS credentials" for prod, but is consistent with "agents in CI with short-lived narrow tokens" — [our-sdlc] "Agents in CI/CD".

### Gaps
- Whether Copilot CLI honours `disable-model-invocation`, `allowed-tools` and `${CLAUDE_SKILL_DIR}` in SKILL.md frontmatter is not recorded.
- Whether company CI may run Copilot CLI at all is an open question.

## 7. Gaps: what assumes an interactive human session and would need changes for a factory?

### Takeaway
The step-by-step skills assume a person in the chat at almost every step. sdlc-ticket shows how to remove that: one upfront policy, assumptions instead of questions, no posts, an end-report queue. Even sdlc-ticket still needs a human for credentials, `/add-dir`, the network, the mock console, the walkthrough, approving posts, marking the PR ready, coworker review, merge and prod. Release, follow-through, Jira transitions, a trigger on assignment, and a machine-readable status are missing.

### Cited Findings
- "One session per step… The saved files carry the state, not the chat… If a fresh session can't continue from the files alone, the file is missing something" — [our-sdlc] "one session per step". This is a strong fit for a factory: steps are resumable from files.
- sdlc-ticket "Skip what is only there for an engineer watching the chat: asking to switch model or session, showing an order or a retelling for approval, and 'Next' lines" — [flow-rules].
- Intake resume relies on the engineer re-running `/sdlc-intake` when the ticket creator answers days later — [S:sdlc-intake] "Next"; the plan on "Status: draft, waiting on answers" resumes with `/sdlc-plan` — [S:sdlc-plan] step 3. There is no watcher for Jira answers.
- The refresh is a timestamp compare (cheap and deterministic). sdlc-ticket skips it after intake — [our-sdlc], [flow-rules]. A factory could run it as a poll to wake waiting tickets.
- Rules that block full autonomy by design: the engineer commits (step-by-step mode); the agent never approves its own PR; a human approves prod; rollback is a human decision — [our-sdlc] steps 3, 4.9, 5.
- Hooks are planned but not built: block test edits during a fix, protected paths, formatter, secret removal, a prod-deploy gate ("block any production deploy unless a release approval is present… Exit code 2 blocks"), and the idea "the hook could check that the Jira release ticket is approved" — [our-sdlc] "Build hooks", "Release gates".
- Evals for the agent setup (20–50 real tasks, run in CI on any skill change, block if the pass rate drops) are planned but not built — [our-sdlc] "Evals"; [playbook] Stage 4.
- The metrics loop (detection script, 1σ/2σ/3σ response, the agent writes a finding which becomes a Jira ticket, a person triages) is planned — [our-sdlc] "The metrics loop"; [playbook] Stage 6.
- Shared environment contention: one branch per env; deploys can drop other tickets' work; a heads-up and checks-file line are needed; the board shows overlap — [S:sdlc-verify] step 3, [S:sdlc-board].
- Rollout puts "our own flow skills (setup, router, bug diagnosis)" and the metrics loop last — [our-sdlc] "Rollout".
- Recent commits keep adding rules learned from real tickets (DSM-903, DSM-964, DSM-1012), for example network-switch scripts, proxy-off subagents, stubs before the deploy, QA through the caller — [git-log]. The skills change weekly.

### Inferences
Changes a factory needs, from the evidence above:
1. A trigger: Jira assignment (webhook/JQL poll) → enqueue `<key>`, check the repo is set up (else queue "run setup").
2. Policy instead of the start round: per-repo defaults for push / draft PR / stubs / lower-env deploy; base branch and branch name inferred by the step-1 evidence (related branches, last deploy). Low confidence goes to the human queue.
3. Machine credentials and network: replace pasted AWS creds, `pbpaste`, VPN switches and console sign-in with service identities, or else make those steps "human task" items.
4. A structured status: extend the "flow: X done" markers (pr opened, qa handed off, merged, deployed-prod, waiting-on-human with a reason) or write a JSON status beside the plan. `board.sh` becomes the dashboard.
5. A human queue = the end-report items: drafts to approve and post, questions, heads-ups, walkthrough requests, ready-for-review, prod approval.
6. Waiters: poll Jira timestamps (the refresh) for answers to posted questions, PR review comments (follow-through), CI, and QA bounces (start sdlc-qa-fix).
7. New skills: release (merge after approval, prod deploy through the pipeline gate, CloudWatch check, Jira summary/transition) and follow-through.
8. Runtime port: verify that Copilot CLI supports what sdlc-ticket uses (per-subagent model, resume a subagent, worktree per subagent, skill frontmatter), or swap them for fallbacks.
9. Concurrency: one lower environment per repo means deploys must be serialised and must respect other tickets. The worknotes push needs to tolerate several parallel writers.

### Gaps
- No measurement of how long each step takes or how often the human stops happen, so it can't be said which stops cost most.
- No record of any unattended (`-p`/headless) run of these skills yet.

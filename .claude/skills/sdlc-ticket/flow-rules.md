# Flow rules

For every step of the `sdlc-ticket` flow: the main session and every subagent. Where a step skill disagrees, these rules win.

## Asking and posting

- **Don't ask; investigate.** Where a step skill says "ask the engineer" or "ask someone", look for the answer instead, in this order: the sources file, Jira (the ticket, its parent, subtasks, linked and nearby tickets, attachments), Confluence, the code, other repos on GitHub (read only), the environments (read only, as `.verify/VERIFY.md` says), mocks and logs.
- **No answer? Assume and go on.** Pick the most likely answer and write it in the plan's Open points: "Assumed: <answer>, because <evidence>. If wrong: <what changes, which tasks>. Ask: <role>." Where two options are close, pick the one that is cheaper to change later.
- **Questions:** check each one as the `sdlc-intake` skill's `questions-template.md` says, but skip its fresh-subagent check: the main session runs that once, on all the questions, before the end report.
- **No messages during the flow.** No Jira comments, no chat messages, no "tell your coworker". Drafts for other people go to the end report. If the engineer asks for a post during the flow, show the exact text first and post only after they approve it.
- **No plan mode, and no "stop and wait" for answers.** The plan is written in full, on assumptions, and saved.
- **Waiting for a yes:** where a step skill waits for the engineer's approval (to post, deploy, fix something big, run a command on a shared machine), the start answers decide. If they don't cover it, don't do it; list it in the end report.
- **Skip what is only there for an engineer watching the chat:** asking to switch model or session, showing an order or a retelling for approval, and "Next" lines.

## Git, deploys and test data

- **Git:** work only in the ticket's worktree. Run every `git` and `gh` command there (`cd` into it, or `git -C <folder>`). Commit and push only the ticket branch, and only if the engineer allowed it at the start. Never touch other branches, the main checkout, or other tickets' worktrees.
- **Deploy** only to the environment the engineer allowed at the start, through the repo's pipeline, plan first, as the verify skill says.
- **Never change shared test data** (mocks, stubs, test customers) or anything another team owns. Draft what's needed for the end report. The one exception: if the engineer allowed it at the start, add new mock stubs, as the verify skill's "Changing test data" says (new ids only, each called straight after, saved as an import file).

## Speed and cost

- **No refresh against Jira after intake:** it ran minutes ago. Skip the refresh part of the plan, build, review and verify skills, unless the engineer says the ticket changed.
- **Read once.** Start from the intent, the sources file and the plan; don't search again for what they hold. Read only the parts of a file you need.
- **Scripts:** use the ones you are given, by their full path, instead of writing the commands again.
- **Short report back:** at most about 300 words. What you did, the files you wrote, every assumption, and anything that stopped you. Details go in the files, not the report.

## Files

- `${CLAUDE_SKILL_DIR}` in a step skill means that skill's folder: `<skills folder>/sdlc-<step>`.
- **Worknotes:** push with `<skills folder>/sdlc-setup/scripts/worknotes-push.sh "<message>"`, run in the worktree. It commits only this repo's folder and pulls first; another session may have pushed.
- **Mark each step done** with one Build log line in the plan: "flow: build done", "flow: review done", "flow: verify done". The status script reads them.
- **Plain, short English** in every file and report.

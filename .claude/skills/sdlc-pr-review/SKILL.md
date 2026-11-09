---
name: sdlc-pr-review
description: Review a coworker's pull request - check it against their ticket and the repo's notes, run fresh AI reviewers, prove every finding, then, as the engineer chooses, draft a GitHub review with inline comments and tested suggestions, or fix it and push one commit with a short PR comment. Nothing is posted without the engineer approving the exact text. Use when asked to review, check or comment on someone else's PR (a number or a link). Not for your own ticket's build (that is sdlc-review).
disable-model-invocation: true
argument-hint: "<PR number or link> [note]"
---

# PR review: a coworker's pull request

Input: $ARGUMENTS

The first word is the PR (a number or a link). Any text after it is the engineer's note.

Goal: the author gets a review that is correct, short and easy to act on. Each problem sits on the right line, and most fixes can be applied with one click.

## Rules

- **Never change the engineer's checkout.** Read the PR in a worktree of its own (step 1). Never switch branches in the folder you started in.
- **Never post** without the engineer approving the exact text of every comment and the summary.
- **Never push** unless the engineer chooses B or C (step 4).
- **Prove every finding** (step 3). A wrong comment costs the author more than a missing one.
- **Plain, short English**, unless the repo's own rules (AGENTS.md, CLAUDE.md, CONTRIBUTING.md) say otherwise. No AI attribution.

`<repo>` below is `owner/name` from `gh repo view --json nameWithOwner -q .nameWithOwner`.

## 1. Get the PR

- `gh pr view <N> --json title,author,body,files,headRefName,headRefOid,baseRefName`.
- **The ticket:** read the linked ticket with the Jira command the instruction file names (summary, description, comments). The PR must do what the ticket asks; a gap is a finding.
- **The repo's notes:** the instruction file, `.verify/VERIFY.md` and the notes (`.notes/`): the call chain, what callers read from our answers, rules that must not break. If the author's plan for this ticket is in the worknotes, read its "Must not change" list too.
- **A worktree for the PR:** `git fetch origin <head branch> <base branch>`, then `git worktree add --detach <folder> origin/<head branch>` next to the repo (for example `<repo>-review-<N>`). Work and test only there.
- **The diff:** against the remote base, not the local one: `git diff origin/<base>...origin/<head branch>`.

## 2. Review it two ways

- **Yourself:** read the whole diff against the ticket, the notes and the repo's rules (behaviour that must not change, patterns, how tests are written, comment style).
- **Fresh reviewers in parallel:** the built-in `/code-review <N>`, or subagents for bugs and security, each with the diff, the ticket and the notes.
- Merge both lists and drop duplicates. A reviewer that fails or returns nothing didn't review: retry once, then say "not run".

## 3. Prove every finding

- **Follow the call chain.** A finding is false if the path never reaches the place it claims.
- **Test what you can:** run the tests, build a small local change in the worktree, or query the cloud and mocks (read only). If you can't test it (for example, no access), say so.
- **Real data, not the PR's test data.** If the PR edits test data so its tests pass (for example, adds a time zone to recorded payloads), run the old test data and real samples (captured responses, the test environment's mock stubs) through the new code. If the PR changes a contract or schema, check every stub the test environment serves against it.
- **Find the answer before you ask.** For each open question (what does the other system really send?), search the specs and their examples, captured samples on tickets, the mocks, the code and the notes first. Only what none of them settles goes to someone else.
- **Drop what you can't defend.**

## 4. Show the engineer, and ask how to deliver

A short list of the problems, most important first: one or two lines each, with the file and line and how you proved it. Not the draft comments yet.

Then ask, in the same message, how the fixes reach the author:
- **A. Review comments:** one GitHub review with inline comments and tested suggestions the author applies (steps 5 and 6).
- **B. I fix it:** fix them in the review worktree, then one commit pushed to the author's branch, and a short PR comment that says what the commit holds (step 7).
- **C. A PR into their branch,** so the author reviews the fixes first (step 7, on a new branch).

Some findings may need a choice that only the engineer or the author can make: name them and say which way you'd go. Wait for the answer. Show the drafts only after it, short: a reader should take in each comment in a few seconds.

## 5. A: post one review

All comments in **one** review, each on its exact line, with the short summary as the body. Show the whole draft first and post only after the engineer approves it. Use the API so line ranges are exact:

```bash
gh api repos/<repo>/pulls/<N>/reviews --input <scratch folder>/review.json
```

```json
{
  "commit_id": "<headRefOid>",
  "event": "COMMENT",
  "body": "<short summary, numbered>",
  "comments": [
    {"path": "internal/x.go", "start_line": 37, "line": 41, "side": "RIGHT", "body": "..."}
  ]
}
```

- `"event": "COMMENT"` unless the engineer asks for `REQUEST_CHANGES` or `APPROVE`.
- A comment can sit only on lines inside the diff. For a problem elsewhere, put it on the nearest related line and name the real file and line.

## 6. A: suggestions the author can commit

Where the fix is concrete, add a GitHub suggestion block. It replaces the lines from `start_line` to `line`:

````markdown
```suggestion
<the new lines>
```
````

- Apply it in the review worktree first, then run the repo's tests and lint on the touched code, then undo it (`git -C <folder> checkout -- <paths>`). Say in the comment that it was tested.
- New imports or other changes go in their own suggestion, so a batch commit compiles.
- Suggestions must not overlap, so the author can use "Add suggestion to batch".
- For lines outside the diff, use a `diff` block (no commit button).
- A posted comment's line range can't change. To widen it, post the new one first, then delete the old one (`gh api -X DELETE repos/<repo>/pulls/comments/<id>`). To change only the text, `-X PATCH` with a new `body`.

## 7. B or C: fix it yourself

- In the review worktree, make a local branch that tracks the author's (B) or a new branch from it (C). Fix the findings the engineer chose, with a test that fails without each fix. Run the repo's build, tests and lint.
- Show the engineer the fixes in plain words (what was wrong, what the change does) and the diff, before the commit.
- **B:** one commit, pushed to the author's branch. **C:** push the new branch and open a draft PR into the author's branch, as the `sdlc-pr` skill says. Wait for CI to pass.
- **The PR comment:** a draft for the engineer. A short greeting, the commit (or PR) link, one line per fix (what was wrong and what changed), and anything still open. Post only after the engineer approves the text.

## 8. Final pass

- Read back every posted comment (`gh api repos/<repo>/pulls/<N>/comments`, or `/issues/<N>/comments` for a PR comment) and fix anything wrong with PATCH. The summary must still match the comments.
- Read the PR's CI results, including infrastructure plan comments. An unexpected "to destroy" is worth a look, even if this PR didn't cause it.
- **Approving:** if asked, say what must happen first. Don't approve while the test environment's data would break on merge, while the author hasn't seen your commit, or when much of the code is now yours (ask for another reviewer).

## 9. Clean up and report

- Remove the review worktree (`git worktree remove <folder>`), unless the engineer wants to keep it for a second pass.
- End with a short list: what the review didn't cover, what needs a second look after the author's changes, and any risk outside the PR found on the way.

## Done when

- Every finding sent was proved, and the engineer approved the text.
- The review, or the fix commit and its comment, is on the PR, read back and correct.
- The engineer's checkout is unchanged, and the review worktree is removed or kept on purpose.

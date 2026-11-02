# Questions comment: one comment on the ticket

## Check each question first

Ask the team only what you can't find or decide yourself: every question costs them time. Double-check each one, every time, also when you redraft one or add one later:
1. Look for the answer in the specs, the sources file, the code, mocks and sample data.
2. Check the case really happens and can reach this code (sample data, logs, and what callers upstream already check). If an upstream system (consent, entitlements, another service's checks) already guarantees it, drop it.
3. Check the answer would change what is wanted, the code or the outcome.
4. Check for a precedent: earlier tickets in the same epic, the flow this one copies, the existing backend, or a team answer on an earlier ticket already cover it. Then follow that.
5. Check it's for the team: not the engineer's own call (their own work, their own subtasks, how they test). Never ask whether our own subtask or work is done: say it can move to Done.
6. Check a wrong guess is costly: if the fix is small (a constant, one check) and nothing breaks for anyone meanwhile, keep it as an assumption, not a question.

Drop any question that fails one. Few questions is the goal: one that matters gets answered faster than five. In a tool with subagents, also give the questions and these six checks to a fresh read-only one, and keep only what passes all six: what depends on someone else's knowledge and changes the code or the outcome. Under the draft, say in one line per question where you looked.

## Write them

Tag the people the instruction file lists for ticket questions, once, at the top. Don't group by role: whoever a question is for answers it. Plain, simple English, written as the engineer ("I", not "we").

```
@<person> @<person> @<person>

1. <Short title>
<One or two lines of context: what the ticket or docs say, and what's unclear.>
What I did: <the assumption I built on>. (Before the build: "What I'll do: …")
Question: <one question>

2. ...
```

- **No intro line:** no status, no PR link, no "please answer". Just the tags, then the questions.
- **One question only:** no number; write it as the item without "1.".
- **One thing per item.** Most important first.
- **Real mentions:** look up each person's account id (Jira user search) and post the tags as mentions; a typed @name notifies nobody.
- **Show the whole text** to the engineer and post only after they approve it. After posting, log it under the plan's "Questions posted".

# Questions comment: one comment on the ticket

## Check each question first

Every time, also when you redraft one or add one later:
1. Look for the answer in the specs, the sources file, the code, mocks and sample data.
2. Check the case really happens (the spec's definitions, sample data, logs).
3. Check the answer would change what is wanted, the code or the outcome.

Drop any question that fails one. In a tool with subagents, also give the questions to a fresh read-only one and keep only what it can't answer. Under the draft, say in one line per question where you looked.

## Write them

Tag the people the instruction file lists for ticket questions, once, at the top. Don't group by role: whoever a question is for answers it. Plain, simple English, written as the engineer ("I", not "we").

```
@<person> @<person> @<person>

<One or two lines: where the work is (for example, "built and tested in <environment>"), the PR link if there is one, and "Please answer the ones that are yours.">

1. <Short title>
<One or two lines of context: what the ticket or docs say, and what's unclear.>
What I did: <the assumption I built on>. (Before the build: "What I'll do: …")
Question: <one question>

2. ...
```

- **One thing per item.** Most important first.
- **Leave out** what only confirms we do it the way the repo already does (for example, the usual kind of tests).
- **Real mentions:** look up each person's account id (Jira user search) and post the tags as mentions; a typed @name notifies nobody.
- **Show the whole text** to the engineer and post only after they approve it. After posting, log it under the plan's "Questions posted".

## Delegation

Workers are **stateless executors.** They cannot see conversation history, prior tool results, or any context beyond the prompt you give them. The quality of a worker's output is bounded by the quality of its prompt.

## Prompt Completeness

Every worker prompt MUST include:

1. **Current state** - what exists right now (file contents, branch state, commit history)
2. **Intent** - what we want to achieve and why
3. **Constraints** - what must NOT happen (e.g., "file already exists - append only, do not overwrite")
4. **Verification step** - a command the worker must run to confirm correctness before finishing

Never rely on the worker "knowing" something you learned earlier in the conversation. If you read a file and its content matters for the task, paste the relevant content into the prompt. Information not in the prompt does not exist for the worker.

## Anti-Patterns

| Pattern | Why it fails |
|---------|--------------|
| Passing a concrete command without explaining the goal | Worker connot catch a wrong command if it doesn't know the intent |
| Saying "create file X" when "X" already exists | Worker uses Write, overwrites existing content |
| Assuming worker will read files before acting | Worker follows instructions literally - if you say "create", it creates |
| Collecting information in on agent, using it in another without passing it | Context is lost at agent boundaries; each agent starts from zero |

## Execution Rules

- Worker outputs are untrusted. Always verify with an independent command before reporting to the user.
- Max 1 delegation retry per. task. After that, execute directly without asking.
- If a worker fails due to environment mismatch, execute directly.

## Skill Execution

**SKILL = Contract. Non-compliance = Breach.**

- **Before**: Extract output format requirements as checklist
- **During**: Execute ALL steps in order, no skipping, no substitution
- **After**: Validate every checklist item before delivery; if any fails, fix first
- **Delegating**: Pass complete output format requirements to workers; include acceptance criteria

Prohibited:
- Executing only "useful" parts of a SKILL
- Replacing SKILL-defined format with "better" alternatives
- Delivering without validation
- Assuming "user will correct me"

## Git

### Commits & PRs

- Each PR contains exactly **1 commit** — squash before submitting
- Rebase onto latest target branch before PR
- No merge commits

### Squash Safety

When squashing commits before PR submission:

1. **Never use `git reset --soft origin/master`** if the branch has commits from other or prior PRs - this collapses ALL differences from master into one commit, including changes that don't belong to you.

2. **Preferred approaches** (in order):
  - `git commit --amend` - fold new changes into the latest commit
  - `git reset --soft HEAD~N` - squash only the last N commits you own
  - `git rebase -i HEAD~N` - interactive squash of your own commits

3. **Pre-push verification** - always run before pushing:
   ```bash
   git diff origin/<base-branch> --stat
   ```
   Confirm the file list contains **only** the files you intended to change. If unexpected files appear, do not push.

## Planner Self-Discipline

The planner (main agent) is not exempt from verification. These rules apply before every dispatch:

1. **Read before mutate** - never instruct a worker to write/edit a file you haven't read in this session. If you read it 10 turns ago, read it again - your memory drifts, the file doesn't.
2. **Embed, don't reference** - If a fact matters for the worker's task, paste it into the prompt. "I checked earlier and it was X" is not a substitute for including X.
3. **State the negative** - explicitly tell the worker what must NOT happen. Workers optimize for completing the task, not for avoiding side effects.
4. **Verify after dispatch** - after a worker completes, independently confirm the result (read the file, check the diff). Never trust a worker's self-reported success.

# Claude Code Global Settings

Shared configuration files for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). These settings configure Claude to operate as a planner/coordinator with a structured thinking discipline, text-to-speech hooks, and a worker agent for implementation tasks.

## Files

- **`CLAUDE.md`** -- Project instructions that shape Claude's behavior: act as a planner/coordinator (not executor), apply a five-step thinking discipline (intent, competence, consistency, completeness, user review test), output a pre-dispatch checklist before dispatching workers, and follow strict git rules (1 commit per PR, rebase, no merge commits).

- **`settings.json`** -- Claude Code hooks configuration:
  - `PreToolUse` -- TTS announcement before each tool use ("Construction in progress").
  - `Notification` (idle prompt) -- TTS greeting when Claude becomes idle ("Good day, commander. I am here!").
  - `Stop` -- TTS reads the first line of the last assistant message aloud.

- **`agents/worker.md`** -- Worker subagent definition for implementation tasks (code changes, file creation, refactoring). Uses tools: Read, Write, Edit, Bash, Glob, Grep.

## Setup

Copy or symlink these files into your Claude Code global settings directory:

```sh
# Option 1: Symlink (recommended -- stays in sync with this repo)
ln -sf /path/to/claude-global-settings/CLAUDE.md ~/.claude/CLAUDE.md
ln -sf /path/to/claude-global-settings/settings.json ~/.claude/settings.json
mkdir -p ~/.claude/agents
ln -sf /path/to/claude-global-settings/agents/worker.md ~/.claude/agents/worker.md

# Option 2: Copy
cp CLAUDE.md settings.json ~/.claude/
mkdir -p ~/.claude/agents
cp agents/worker.md ~/.claude/agents/
```

Replace `/path/to/claude-global-settings` with the actual path to your local clone.

## Customization

These settings are a starting point. Edit them to fit your workflow -- adjust the thinking discipline, change TTS phrases, add new hooks, or modify the worker agent definition.

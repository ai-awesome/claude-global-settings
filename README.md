# Claude Code Global Settings

A collection of opinionated global settings for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). These settings configure Claude as a planner/coordinator with thinking discipline, text-to-speech hooks, and a dedicated worker agent for implementation tasks.

## What's Included

- **CLAUDE.md** -- Global instructions that make Claude act as a planner and coordinator. Enforces a thinking discipline (intent, competence, consistency, completeness, review) and a pre-dispatch checklist before any work is dispatched to subagents.
- **settings.json** -- Hooks configuration for text-to-speech feedback: announces tool use, greets on idle, and reads the first line of the final response aloud.
- **agents/worker.md** -- A worker subagent profile for implementation tasks with access to Read, Write, Edit, Bash, Glob, and Grep tools.

## Installation

### Fresh install (no existing ~/.claude)

```sh
git clone git@github.com:ai-awesome/.claude.git ~/.claude
```

### Existing ~/.claude directory

If you have already run Claude Code, `~/.claude/` already exists. Initialize it as a git repo instead:

```sh
cd ~/.claude
git init
git remote add origin git@github.com:ai-awesome/.claude.git
git fetch origin
git checkout -b main origin/main
```

This pulls down all config files (CLAUDE.md, settings.json, agents/, hooks/, skills/, etc.) without conflicting with files Claude Code may have already created.

## Customization

These settings are a starting point. Edit them to fit your workflow -- adjust the thinking discipline, change TTS phrases, add new hooks, or modify the worker agent definition.

## Contributing

1. Fork this repository and create a feature branch.
2. Make your changes and ensure they are consistent with the existing style.
3. Submit a pull request with a clear description of what you changed and why.

# Claude Code Global Settings

A collection of opinionated global settings for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). These settings configure Claude as a planner/coordinator with thinking discipline, text-to-speech hooks, and a dedicated worker agent for implementation tasks.

## What's Included

- **CLAUDE.md** -- Global instructions that make Claude act as a planner and coordinator. Enforces a thinking discipline (intent, competence, consistency, completeness, review) and a pre-dispatch checklist before any work is dispatched to subagents.
- **settings.json** -- Hooks configuration for text-to-speech feedback: announces tool use, greets on idle, and reads the first line of the final response aloud.
- **agents/worker.md** -- A worker subagent profile for implementation tasks with access to Read, Write, Edit, Bash, Glob, and Grep tools.

## Installation

Clone this repository:

```sh
git clone https://github.com/ai-awesome/claude-global-settings.git
```

Then symlink or copy the files into your Claude global config directory:

```sh
ln -sf "$(pwd)/claude-global-settings/CLAUDE.md" ~/.claude/CLAUDE.md
ln -sf "$(pwd)/claude-global-settings/settings.json" ~/.claude/settings.json
ln -sf "$(pwd)/claude-global-settings/agents" ~/.claude/agents
```

If you manage your dotfiles in a separate repository, add this as a submodule:

```sh
cd your-dotfiles-repo
git submodule add https://github.com/ai-awesome/claude-global-settings.git claude-global-settings
```

Then symlink from the submodule path into `~/.claude/` as shown above.

## Customization

These settings are a starting point. Edit them to fit your workflow -- adjust the thinking discipline, change TTS phrases, add new hooks, or modify the worker agent definition.

## Contributing

1. Fork this repository and create a feature branch.
2. Make your changes and ensure they are consistent with the existing style.
3. Submit a pull request with a clear description of what you changed and why.

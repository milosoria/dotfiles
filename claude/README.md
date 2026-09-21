# Claude Code

The real files live here; `~/.claude` holds symlinks to them, created by `bootstrap.sh`.
Everything else under `~/.claude` is runtime state (sessions, plugins, caches) and stays on
the machine.

## What is versioned

| Path | Linked to | Holds |
|------|-----------|-------|
| `CLAUDE.md` | `~/.claude/CLAUDE.md` | global instructions for every project |
| `settings.json` | `~/.claude/settings.json` | hooks, permissions, statusline, model, theme, `enabledPlugins`, `extraKnownMarketplaces`, project-agnostic `mcpServers` |
| `commands/` | `~/.claude/commands` | slash commands |
| `agents/` | `~/.claude/agents` | subagent definitions |
| `skills/` | `~/.claude/skills` | skills (`synced/` is gitignored: claude.ai syncs it per account) |
| `scripts/` | `~/.claude/scripts` | scripts called by hooks |
| `themes/` | `~/.claude/themes` | custom themes |
| `hooks/` | `~/.claude/hooks` | hook executables |
| `mcp-servers.json` | replayed by `bootstrap.sh` | user-scope MCP servers |

## What is not, and why

- `.credentials.json`: OAuth token. Never commit it.
- `skills/find-skills`, `improve-codebase-architecture`, `tdd`, `to-issues`, `to-prd`:
  symlinks into `~/.agents/skills`, an external store shared with other agents. They are
  gitignored and rebuilt by whatever manages `~/.agents`.
- `settings.local.json`: per-machine permissions. That is what it is for.
- `~/.claude.json`: per-project state plus user-scope MCP servers. Only the MCP servers are
  worth keeping, and they are in `mcp-servers.json`.
- `projects/`, `history.jsonl`, `sessions/`, `plans/`, `teams/`, `file-history/`, `todos`:
  conversation history.
- `plugins/`, `cache/`, `jobs/`, `downloads/`, `telemetry/`, `debug/`, `shell-snapshots/`:
  caches and downloads, several GB. Plugins reinstall themselves from `enabledPlugins` and
  `extraKnownMarketplaces` in `settings.json`.

## On a new machine

`./bootstrap.sh` does it all: creates the symlinks and registers the MCP servers with
`claude mcp add-json`. Then open Claude Code once and it pulls the plugins.

To add something to the set, drop it in this directory and add its name to `CLAUDE_ITEMS`
in `bootstrap.sh`.

## Notes

- Claude Code writes `settings.json` through the symlink, so changes made from `/config`
  land in this repo. Check `git status` after touching settings.
- Keep paths in `settings.json` relative to `$HOME`, never `/Users/<you>`.

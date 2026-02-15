# Global Claude Code Instructions

## Session Continuity

At session start, if `.claude/sessions/` exists in the current project, read the **single most recent** `*-session.md` file from the last 3 days. Skip if older than 3 days or doesn't exist. Do not read multiple session files.

## Planning & Task Orchestration

When working on complex tasks that require planning:

1. **Always create a plan document** at `~/.claude/plans/{descriptive-name}.md`
2. **Delegate tasks to subagents** using the Task tool for parallelizable work:
   - Use `Explore` agent for codebase discovery
   - Use `Plan` agent for architecture decisions
   - Use `general-purpose` agent for implementation tasks
   - Use `Bash` agent for running commands
   - Run independent tasks in parallel with `run_in_background: true`
3. **Document progress in real-time**:
   - Update the plan document after each task completes
   - Include timestamps in the progress log
   - Mark blockers immediately when encountered
4. **Use the TodoWrite tool** to track individual tasks during execution

### Plan Document Template

```markdown
# Plan: {Title}

## Status: IN_PROGRESS
**Started**: {timestamp}

## Tasks
| # | Task | Status | Agent | Notes |
|---|------|--------|-------|-------|
| 1 | {description} | PENDING | Explore | |

## Progress Log
| Time | Task | Event |
|------|------|-------|

## Summary
{Completed upon finish}
```

### When to Use This Workflow
- Multi-file changes or refactors
- New feature implementations
- Complex bug investigations
- Any task with 3+ distinct steps

## Search Tool Preferences

When searching files or code:

1. **Prefer mgrep** (semantic search) for most searches:
   - Local code/file search: `mgrep "query"`
   - Web search: `mgrep --web --answer "query"`
   - Use natural language queries for better results

2. **Fallback to built-in Grep** when:
   - mgrep is unavailable or fails
   - Exact regex pattern matching is required
   - Searching for literal strings (e.g., exact function names, error codes)

3. **Use built-in Glob** for:
   - Finding files by name pattern (e.g., `**/*.py`)
   - File discovery without content search

## Long-Running Commands (tmux required)

The following commands are blocked outside of tmux to preserve log access:
- `docker`, `make`
- `pnpm dev`, `npm run dev`, `yarn dev`, `bun run dev`

When running dev servers or long-running processes:

1. **Start in a detached tmux session**:
   ```bash
   tmux new-session -d -s dev "pnpm dev"
   ```

2. **Attach to view logs**:
   ```bash
   tmux attach -t dev
   ```

3. **Common tmux commands**:
   - `Ctrl+b d` - Detach from session
   - `tmux ls` - List sessions
   - `tmux kill-session -t dev` - Stop the session

## Python Projects

When working with Python projects:

1. **Always use `python3`** instead of `python` for the interpreter
2. **Check for virtual environments first** before running Python commands:
   - Look for `.venv/`, `venv/`, or `env/` directories
   - If found, use the virtualenv's Python: `.venv/bin/python3`
3. **Use package managers when available** (in order of preference):
   - **uv**: If `uv.lock` or `pyproject.toml` with uv exists, use `uv run` for commands needing dependencies
   - **poetry**: If `poetry.lock` exists, use `poetry run` for commands needing dependencies
   - **pip with virtualenv**: Fall back to activating virtualenv and using pip
4. **Detection order**:
   - Check for `uv.lock` → use `uv run python3 script.py`
   - Check for `poetry.lock` → use `poetry run python3 script.py`
   - Check for `.venv/bin/python3` → use `.venv/bin/python3 script.py`
   - Fall back to `python3`


<claude-mem-context>
# Recent Activity

### Feb 6, 2026

| ID | Time | T | Title | Read |
|----|------|---|-------|------|
| #486 | 3:14 PM | 🔵 | Global Settings Configuration with Hook System | ~373 |
</claude-mem-context>
# Global Claude Code Instructions

## Tone
- Be concise and simple when explaining what your doing and your conclusions, avoid being verbose,
simplicity and precision is much appreciated. NEVER USE EM DASHES.

## PRs

- They feature/fix/bug flow is feature branch to staging and then staging to main, unless the user explicitly states that he wants to push directly to staging and take it from there.

### When to Use This Workflow
- Multi-file changes or refactors
- New feature implementations
- Complex bug investigations
- Any task with 3+ distinct steps

<!-- macal-toolkit:search-preferences -->
## Search Tool Preferences

Two stages. Stage 1 locates a candidate, stage 2 answers precisely.

**Stage 1 (find the string / the file):**
1. **Grep**: exact text, regex, literal strings (function names, error codes, imports). Default for "find this string".
2. **Glob**: files by name pattern (e.g. `**/*.py`). No content search.

**Stage 2 (answer precisely about a symbol) -> use the `LSP` tool** *(needs `pyright-lsp` / `typescript-lsp` from the language-support tier, plus `ENABLE_LSP_TOOL=1` in settings.json env)*:

`LSP` is a deferred tool: it is NOT in the tool list at session start. Load it once per
session with `ToolSearch("select:LSP")`, then use it. This is why it tends to go unused.

Use LSP, not grep, whenever the question is about a **symbol** rather than a string:
- "where is X defined" -> `goToDefinition` (not a grep for `def X` / `class X`)
- "what calls X / what breaks if I change X" -> `findReferences` or `incomingCalls`
- "what does X call" -> `outgoingCalls`
- "what type is this / what are its params" -> `hover`
- "what's in this file" -> `documentSymbol` (cheaper than reading the whole file)
- "find the symbol named X anywhere" -> `workspaceSymbol` with a `query`
- "who implements this interface/ABC" -> `goToImplementation`

Why it beats grep for these: it resolves aliased imports, re-exports, methods that share
a name across classes, and TS path aliases (`@/...`), and it ignores strings and comments.
Grep on a common method name is noise; LSP is exact.

**Mechanics that matter:**
- LSP needs `filePath` + `line` + `character` (both 1-based). The normal flow is grep to
  get `file:line`, then LSP at the column where the identifier starts.
- **Warm-up caveat:** the FIRST call into a project can return incomplete results while the
  server indexes. Observed in `macal-maia-front`: `findReferences` returned 1 reference,
  the identical repeat call returned 7 across 4 files. If a result looks suspiciously thin,
  call it a second time before trusting it.
- Python repos need pyright pointed at the venv, or every third-party import reports as
  unresolved. Add to the repo's `pyproject.toml`:
  ```toml
  [tool.pyright]
  venvPath = "."
  venv = ".venv"
  ```

**Stage 2 alternatives (no language server for that language, or cross-cutting questions):**
3. **claude-mem `smart-explore`** *(if claude-mem installed)*: structural/AST queries without reading full files.
4. **GitNexus** *(if installed)*: `npx gitnexus` for semantic "how does this work" questions. Within-repo code graph, 100% local.
5. **contracts-impact** *(if installed)*: cross-service HTTP routes and pub/sub topics, which no single-repo LSP can see.
6. **claude-mem `mem-search`** *(if claude-mem installed)*: "did we solve this in a past session?" across prior conversations.

Do NOT use built-in WebSearch or WebFetch for library docs — use the `context7` plugin instead (if installed).
<!-- /macal-toolkit:search-preferences -->

<!-- macal-toolkit:python-standards -->
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
<!-- /macal-toolkit:python-standards -->


## Workflow Orchestration

### 1. Plan Mode Default
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity

### 2. Subagent Strategy
- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One task per subagent for focused execution

### 3. Self-Improvement Loop
- After ANY correction from the user: update tasks/lessons.md with the pattern
- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops
- Review lessons at session start for relevant project

### 4. Verification Before Done
- Never mark a task complete without proving it works
- Diff behavior between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness

### 5. Demand Elegance (Balanced)
- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip this for simple, obvious fixes -- don't over-engineer
- Challenge your own work before presenting it

### 6. Autonomous Bug Fixing
- When given a bug report: just fix it. Don't ask for hand-holding
- Point at logs, errors, failing tests -- then resolve them
- Zero context switching required from the user
- Go fix failing CI tests without being told how

## Task Management

1. Plan First: Write plan to tasks/todo.md with checkable items
2. Verify Plan: Check in before starting implementation
3. Track Progress: Mark items complete as you go
4. Explain Changes: High-level summary at each step
5. Document Results: Add review section to tasks/todo.md
6. Capture Lessons: Update tasks/lessons.md after corrections

## Core Principles

- Simplicity First: Make every change as simple as possible. Impact minimal code.
- No Laziness: Find root causes. No temporary fixes. Senior developer standards.
- Minimal Impact: Only touch what's necessary. No side effects with new bugs.

## CLAUDE.md Self-Maintenance

When completing a session that changes project structure, conventions, dependencies, or tooling:
1. Update the relevant CLAUDE.md file(s) to reflect those changes before finishing
2. Remove entries that reference files, paths, or patterns that no longer exist
3. Keep instructions concise — if a section is no longer relevant, delete it

<claude-mem-context>

</claude-mem-context>

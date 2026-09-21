---
name: go
description: Verify recent code changes end-to-end, simplify them, and open a PR. Use whenever the user ends a task with "/go", "ship it", "verify and PR", "verify my work", "wrap this up", or otherwise signals the implementation phase is done and they want the work verified, polished, and shipped. Also use proactively at the end of a multi-step coding task before declaring done — verification matters more with Claude 4.7 since more work happens per turn and regressions are more costly to rediscover later.
---

# /go — Verify, Simplify, Ship

The job: prove the change actually works before declaring it done, clean up what you wrote, and open a PR. Skipping verification is the single biggest source of "I thought it worked" failures — especially in long tasks where you may not remember the specifics when you come back.

## Sequence

Always run these in order. Do not skip steps to save time — the whole point of this skill is that you don't.

1. **Scope the change** — what was modified and what kind of work is it?
2. **Verify end-to-end** — exercise the real thing, not just unit tests.
3. **Fix on failure** — up to 3 attempts, then stop and report.
4. **Simplify** — invoke the `simplify` skill on the changed code.
5. **Open a PR** — invoke `commit-commands:commit-push-pr`.

## Step 1: Scope the change

Run `git status` and `git diff --stat` to see what's changed. Classify the work by looking at the touched files:

- **Backend service** — routes, handlers, services, models, migrations. Python (`app/`, `macal-api/`), Go, Node backend.
- **Frontend UI** — `.tsx`/`.jsx`/`.vue`/`.svelte`, anything under `src/app/` or `components/`, styles.
- **Library / pure code** — utilities, shared types, schema, no I/O.
- **Desktop / native app** — Electron, SwiftUI, Tauri.
- **Config / infra** — Dockerfile, CI, deploy manifests.
- **Docs only** — `.md`, comments, no code.

A change can span multiple categories; verify each. For docs-only changes, skip to step 4.

## Step 2: Verify end-to-end

The point is to exercise the changed path the way a real user or caller would. Unit tests alone don't count — they pass while the server is broken.

### Backend service

1. Check if the server is already running (look for tmux sessions, existing processes on the port). If not, start it in a tmux session — the user's global convention requires tmux for long-running processes:
   ```bash
   tmux new-session -d -s verify "<dev command>"
   ```
2. Wait for readiness (poll health endpoint, watch logs).
3. Exercise the changed endpoints with `curl` — both the golden path and at least one edge case the change was meant to handle. If the change is behind auth, reuse an existing auth flow from the codebase.
4. Check the server logs for errors/warnings that weren't there before.
5. If the change touches the database, verify the actual row state with a query.

### Frontend UI

1. Start the dev server in tmux if not already running.
2. Use the Chrome extension tools (`mcp__claude-in-chrome__*`) to drive the browser. The extension is DOM-aware and much faster than pixel clicks. If not connected, ask the user to install it — don't fall back to computer-use for this.
3. Walk through the changed flow: navigate to the page, perform the interaction, assert the visible result. Also check at least one adjacent flow that could regress.
4. Check the browser console for errors.
5. If the user said "mobile-first" or the change targets mechanics/field users, test at mobile viewport widths too.

### Library / pure code

1. Run the relevant test file(s) — `pytest path/to/test.py`, `pnpm test <file>`, etc.
2. Run the linter / type-checker on the changed files.
3. If there's a script or entrypoint that uses the library, run it with realistic inputs.

### Desktop / native app

Use computer-use tools (`mcp__computer-use__*`) — request access first, then drive the UI. Same idea: changed flow + adjacent regressions.

### Config / infra

- Dockerfile: `docker build` locally (in tmux) and verify the image starts.
- CI config: dry-run or lint via the CI's local runner if available.
- Migrations: run forward and backward against a dev database.

## Step 3: Fix on failure

If verification fails, diagnose and fix. You have **up to 3 attempts**. The counter exists because it's easy to spin on a broken verification — after 3 tries, stop and report what you saw, what you tried, and what's still wrong. Let the user decide whether to keep going.

Between attempts, re-run only the failing check, not the full verification suite — faster feedback loop.

If the failure reveals the original change was wrong in a deeper way (not just a typo), stop earlier. Don't patch over a bad design.

## Step 4: Simplify

Invoke the `simplify` skill to review the changed code for reuse, quality, and efficiency. Apply the fixes it surfaces. If `simplify` suggests a change that would alter behavior (not just shape), verify again after applying it — simplification shouldn't break the thing you just verified.

## Step 5: Open a PR

Invoke `commit-commands:commit-push-pr` to commit, push, and open the PR. The PR description should include:

- What changed and why.
- **How it was verified** — the exact commands/flows run. This is the payoff of this skill: future-you (or the reviewer) can trust the change works because the verification is documented.
- Any follow-ups or known limitations.

## When verification isn't possible

If you genuinely can't verify (no way to run the service, missing credentials, environment not set up), **say so explicitly** rather than claiming success. Output: "Couldn't verify because X. Skipping to simplify + PR, but reviewer needs to verify Y before merge." Then proceed. Silent "passed by assumption" is the failure mode this skill exists to prevent.

## Anti-patterns to avoid

- Running `pytest` and calling it verified. Unit tests are necessary but not sufficient — they don't catch wiring, config, or integration breakage.
- Checking "does it compile?" as verification. It doesn't.
- Using computer-use for a web app when the Chrome extension is available — much slower and more brittle.
- Opening the PR before simplify runs. The PR diff should be the cleaned-up version.
- Skipping verification because the change "looks obviously correct." Changes that look obviously correct fail just as often as ones that look tricky.

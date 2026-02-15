#!/usr/bin/env node
/**
 * SessionStart Hook - Project-local version
 *
 * Looks for session files in {project}/.claude/sessions/ instead of global
 */

const fs = require('fs');
const path = require('path');

const sessionsDir = path.join(process.cwd(), '.claude', 'sessions');

function log(msg) {
  console.error(msg);
}

function findSessions(dir, maxAgeDays = 7) {
  if (!fs.existsSync(dir)) return [];

  const now = Date.now();
  const maxAgeMs = maxAgeDays * 24 * 60 * 60 * 1000;

  return fs.readdirSync(dir)
    .filter(f => f.endsWith('-session.tmp'))
    .map(f => {
      const fullPath = path.join(dir, f);
      const stats = fs.statSync(fullPath);
      return { path: fullPath, name: f, mtime: stats.mtimeMs };
    })
    .filter(f => (now - f.mtime) <= maxAgeMs)
    .sort((a, b) => b.mtime - a.mtime);
}

function main() {
  const sessions = findSessions(sessionsDir, 7);

  if (sessions.length > 0) {
    const latest = sessions[0];
    log(`[SessionStart] Project: ${process.cwd()}`);
    log(`[SessionStart] Found ${sessions.length} recent session(s) in .claude/sessions/`);
    log(`[SessionStart] Latest: ${latest.name}`);

    // Output the path so Claude can read it if needed
    log(`[SessionStart] To load context: Read ${latest.path}`);
  } else {
    log(`[SessionStart] No recent sessions found for this project`);
  }
}

main();

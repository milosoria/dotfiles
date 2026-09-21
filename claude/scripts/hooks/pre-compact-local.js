#!/usr/bin/env node
/**
 * PreCompact Hook - Project-local version
 *
 * Appends compaction marker to session file in {project}/.claude/sessions/
 */

const fs = require('fs');
const path = require('path');

const sessionsDir = path.join(process.cwd(), '.claude', 'sessions');

function log(msg) {
  console.error(msg);
}

function getTimeString() {
  const now = new Date();
  return `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`;
}

function findLatestSession(dir) {
  if (!fs.existsSync(dir)) return null;

  const files = fs.readdirSync(dir)
    .filter(f => f.endsWith('-session.tmp'))
    .map(f => {
      const fullPath = path.join(dir, f);
      const stats = fs.statSync(fullPath);
      return { path: fullPath, mtime: stats.mtimeMs };
    })
    .sort((a, b) => b.mtime - a.mtime);

  return files.length > 0 ? files[0].path : null;
}

function main() {
  const latestSession = findLatestSession(sessionsDir);

  if (latestSession) {
    const timeStr = getTimeString();
    const marker = `\n---\n**[Compaction at ${timeStr}]** - Context was summarized\n`;
    fs.appendFileSync(latestSession, marker);
    log(`[PreCompact] Marked compaction in: ${latestSession}`);
  } else {
    log(`[PreCompact] No active session file to mark`);
  }
}

main();

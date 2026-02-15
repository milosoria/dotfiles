#!/usr/bin/env node
/**
 * SessionEnd Hook - Project-local version
 *
 * Creates/updates session files in {project}/.claude/sessions/
 */

const fs = require('fs');
const path = require('path');

const sessionsDir = path.join(process.cwd(), '.claude', 'sessions');

function log(msg) {
  console.error(msg);
}

function ensureDir(dir) {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
}

function getDateString() {
  const now = new Date();
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`;
}

function getTimeString() {
  const now = new Date();
  return `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`;
}

function getSessionIdShort() {
  const sessionId = process.env.CLAUDE_SESSION_ID;
  if (!sessionId) return 'default';
  return sessionId.slice(-8);
}

function main() {
  ensureDir(sessionsDir);

  const today = getDateString();
  const shortId = getSessionIdShort();
  const sessionFile = path.join(sessionsDir, `${today}-${shortId}-session.tmp`);
  const currentTime = getTimeString();
  const projectName = path.basename(process.cwd());

  if (fs.existsSync(sessionFile)) {
    // Update existing session file
    let content = fs.readFileSync(sessionFile, 'utf8');
    content = content.replace(/\*\*Last Updated:\*\*.*/, `**Last Updated:** ${currentTime}`);
    fs.writeFileSync(sessionFile, content);
    log(`[SessionEnd] Updated: ${sessionFile}`);
  } else {
    // Create new session file with project info
    const template = `# Session: ${today}
**Project:** ${projectName}
**Path:** ${process.cwd()}
**Date:** ${today}
**Started:** ${currentTime}
**Last Updated:** ${currentTime}

---

## Current State

[Session context goes here]

### Completed
- [ ]

### In Progress
- [ ]

### Notes for Next Session
-

### Key Files
\`\`\`
[relevant files for this project]
\`\`\`
`;
    fs.writeFileSync(sessionFile, template);
    log(`[SessionEnd] Created: ${sessionFile}`);
  }
}

main();

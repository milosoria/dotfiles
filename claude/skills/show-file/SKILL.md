---
name: show-file
description: Open a file (optionally at a specific line) in nvim inside a vertical tmux pane next to Claude, instead of printing its contents in the chat. Use when the user asks to show, open, or view a file or a line ("muéstrame el archivo", "ábrelo", "abre X en nvim", "llévame a la línea N", "muéstrame dónde está", "show me that file"), or runs /show-file.
---

# Show File

Open the file in the viewer pane with:

```bash
~/.claude/scripts/nvim-open.sh <ruta-absoluta> [línea]
```

- Resolve the path and line first (Grep/LSP if the user named a symbol, not a file). Pass an absolute path.
- Pass the line when the user asks for a specific line or symbol; omit it otherwise. `archivo:línea` also works.
- One viewer pane per tmux window, reused on every call; focus stays on Claude.
- Do not paste the file contents in the chat. Reply with one short line saying what was opened (`ruta:línea`).
- If the script says it is not inside tmux, tell the user and fall back to citing `ruta:línea`.

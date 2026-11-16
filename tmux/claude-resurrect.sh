#!/usr/bin/env bash
# Hook post-save-layout de tmux-resurrect (recibe la ruta del archivo de save).
# En cada pane con una sesión de Claude Code (opción de pane @claude-session, que pone el hook
# SessionStart de claude/settings.json) reemplaza el comando guardado por
# `claude <flags> --resume <id>`, así el restore reabre esa misma conversación.
file="$1"
[ -f "$file" ] || exit 0

map="$(tmux list-panes -a -F "#{session_name}	#{window_index}	#{pane_index}	#{@claude-session}" 2>/dev/null)"
[ -n "$map" ] || exit 0

tmp="$(mktemp)" || exit 0
awk -F'\t' -v OFS='\t' '
  FNR == NR { if ($4 != "") id[$1 SUBSEP $2 SUBSEP $3] = $4; next }
  $1 == "pane" && (($2 SUBSEP $3 SUBSEP $6) in id) {
    # flags del comando guardado, sin los de resume/continue. Si lo guardado no es claude
    # (pane lanzado directo con claude: ps toma un hijo, p.ej. un MCP), van los de siempre.
    flags = ""
    if ($11 ~ /^:claude( |$)/) {
      n = split(substr($11, 2), a, " ")
      for (i = 2; i <= n; i++) {
        if (a[i] == "--resume" || a[i] == "-r" || a[i] == "--session-id") {
          if (i < n && a[i + 1] !~ /^-/) i++
          continue
        }
        if (a[i] == "--continue" || a[i] == "-c" || a[i] == "--fork-session") continue
        flags = flags " " a[i]
      }
    } else {
      flags = " --dangerously-skip-permissions"
    }
    $11 = ":claude" flags " --resume " id[$2 SUBSEP $3 SUBSEP $6]
  }
  { print }
' <(printf '%s\n' "$map") "$file" > "$tmp" && mv "$tmp" "$file" || rm -f "$tmp"

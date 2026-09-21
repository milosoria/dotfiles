#!/bin/bash
# Nombra cada ventana de tmux con el título de la sesión de Claude Code que corre en ella.
#
# Fuente: el título del pane (#{pane_title}). Claude Code lo actualiza al instante por OSC con
# "✳ <título>", y ese título ya es el de /rename (custom) o el autogenerado. Se mira el pane y
# no el transcript porque /rename es un comando local-jsx: no dispara UserPromptSubmit ni Stop,
# así que ningún hook de Claude se entera del rename.
#
# Disparadores (ver tmux.conf): status-right cada status-interval, más hooks de foco/selección
# para que se sienta inmediato al interactuar.
#
# Reglas:
#   - solo panes que corran claude y cuyo título empiece con ✳
#   - por ventana gana el pane de menor índice (la sesión principal, no los teammates)
#   - no pisa un rename manual: solo toca ventanas auto-nombradas o cuyo nombre puso este script
#
# Estado: opciones de pane @claude-title (último título visto) y @claude-name (nombre que
# pusimos). tmux filtra con ellas, así que el caso normal (nada cambió) es una sola llamada.

claude_pane='#{&&:#{m:✳ *,#{pane_title}},#{||:#{m:claude,#{pane_current_command}},#{m:[0-9]*.[0-9]*.[0-9]*,#{pane_current_command}}}}'
stale="#{&&:${claude_pane},#{||:#{!=:#{pane_title},#{@claude-title}},#{!=:#{window_name},#{@claude-name}}}}"

for win in $(tmux list-panes -a -f "$stale" -F '#{window_id}' 2>/dev/null | sort -u); do
  # pane de claude de menor índice: el de la sesión principal
  panes=$(tmux list-panes -t "$win" -f "$claude_pane" -F '#{pane_index} #{pane_id}' 2>/dev/null | sort -n | awk '{print $2}')
  [ -z "$panes" ] && continue
  main=$(printf '%s\n' "$panes" | head -1)

  wname=$(tmux display -p -t "$win" '#{window_name}')
  cname=$(tmux display -p -t "$main" '#{@claude-name}')
  auto=$(tmux display -p -t "$win" '#{?automatic-rename,1,0}')
  title=$(tmux display -p -t "$main" '#{pane_title}')

  # nombre puesto a mano en tmux -> no tocar
  if [ "$auto" = 0 ] && [ "$wname" != "$cname" ]; then
    continue
  fi

  # kebab-case ascii, máx 24 chars, sin guiones colgando
  name=$(printf '%s' "${title#✳ }" \
    | sed 's/[áàäâÁÀÄÂ]/a/g; s/[éèëêÉÈËÊ]/e/g; s/[íìïîÍÌÏÎ]/i/g; s/[óòöôÓÒÖÔ]/o/g; s/[úùüûÚÙÜÛ]/u/g; s/[ñÑ]/n/g' \
    | tr '[:upper:]' '[:lower:]' \
    | tr -cs 'a-z0-9' '-' \
    | cut -c1-24 \
    | sed 's/^-*//; s/-*$//')
  [ -z "$name" ] && continue

  if [ "$name" != "$wname" ]; then
    tmux rename-window -t "$win" "$name" || continue
  fi

  # se sella cada pane de claude de la ventana para que el filtro no vuelva a levantarla
  for p in $panes; do
    tmux set-option -p -t "$p" @claude-name "$name"
    tmux set-option -p -t "$p" @claude-title "$(tmux display -p -t "$p" '#{pane_title}')"
  done
done
exit 0

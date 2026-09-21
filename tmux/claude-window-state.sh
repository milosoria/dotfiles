#!/bin/bash
# Marca la ventana de tmux cuando una sesión de Claude Code necesita tu atención.
#
# Lo invocan los hooks de ~/.claude/settings.json con el estado de esa sesión:
#   wait   PermissionRequest / Notification: pide autorización o input
#   idle   Stop: terminó y te toca a vos
#   busy   UserPromptSubmit / PostToolUse: está trabajando, sin marca
#   clear  hook de tmux al seleccionar la ventana: ya la miraste
#
# Si la ventana es la que estás viendo, no se marca: ya la estás mirando.
#
# El estado vive en la opción de pane @claude-state; de ahí se agrega al
# @claude-alert de la ventana (wait gana sobre idle), que es lo que pinta
# window-status-format en tmux.conf.

[ -z "$TMUX" ] && exit 0
state=$1

if [ "$state" = clear ]; then
  win=$(tmux display -p '#{window_id}' 2>/dev/null) || exit 0
  for p in $(tmux list-panes -t "$win" -F '#{pane_id}' 2>/dev/null); do
    tmux set-option -pu -t "$p" @claude-state 2>/dev/null
  done
  tmux set-option -wu -t "$win" @claude-alert 2>/dev/null
  exit 0
fi

pane=${TMUX_PANE:-$(tmux display -p '#{pane_id}' 2>/dev/null)}
[ -z "$pane" ] && exit 0
win=$(tmux display -p -t "$pane" '#{window_id}' 2>/dev/null) || exit 0

case $state in
  wait|idle) tmux set-option -p -t "$pane" @claude-state "$state" 2>/dev/null ;;
  *)         tmux set-option -pu -t "$pane" @claude-state 2>/dev/null ;;
esac

# si estás mirando la ventana, no hace falta marcarla
if [ "$(tmux display -p -t "$win" '#{&&:#{window_active},#{session_attached}}' 2>/dev/null)" = 1 ]; then
  tmux set-option -wu -t "$win" @claude-alert 2>/dev/null
  exit 0
fi

# si no, la ventana muestra el estado más urgente de sus panes
if tmux list-panes -t "$win" -f '#{==:#{@claude-state},wait}' -F x 2>/dev/null | grep -q x; then
  tmux set-option -w -t "$win" @claude-alert wait 2>/dev/null
elif tmux list-panes -t "$win" -f '#{==:#{@claude-state},idle}' -F x 2>/dev/null | grep -q x; then
  tmux set-option -w -t "$win" @claude-alert idle 2>/dev/null
else
  tmux set-option -wu -t "$win" @claude-alert 2>/dev/null
fi
exit 0

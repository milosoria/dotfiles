#!/bin/bash
# Marca la ventana de tmux con el estado de la sesión de Claude Code que corre en ella.
#
# Lo invocan los hooks de ~/.claude/settings.json:
#   busy    UserPromptSubmit / PostToolUse: está trabajando        -> punto verde
#   idle    Stop / SessionStart: te toca a vos                     -> punto amarillo
#   wait    PermissionRequest: pide autorización                   -> punto rojo
#   notify  Notification: decide según notification_type del payload, porque el mismo
#           evento cubre tanto "necesito permiso" como "hace rato que no escribís"
#   clear   a mano, para bajar una marca huérfana (sesión muerta sin SessionEnd)
#
# La marca es estado, no aviso: se queda mientras la sesión siga así, aunque pases por la
# ventana. Solo la mueve el propio Claude al cambiar de estado, y SessionEnd la borra.
#
# El estado vive en la opción de pane @claude-state; de ahí se agrega al @claude-alert de
# la ventana (wait gana a idle, idle gana a busy), que es lo que pinta window-status-format.

[ -z "$TMUX" ] && exit 0
state=$1

if [ "$state" = notify ]; then
  # payload: {hook_event_name, message, title?, notification_type}
  payload=$(cat)
  t=$(printf '%s' "$payload" | jq -r '.notification_type // empty' 2>/dev/null)
  if [ -z "$t" ]; then
    case $payload in *permission*) t=permission_prompt ;; *) t=idle_prompt ;; esac
  fi
  case $t in
    permission_prompt|worker_permission_prompt|agent_needs_input) state=wait ;;
    idle_prompt|agent_completed)                                  state=idle ;;
    *) exit 0 ;;   # auth, computer use, push: no dicen nada del estado
  esac
fi

if [ "$state" = clear ]; then
  win=$(tmux display -p '#{window_id}' 2>/dev/null) || exit 0
  for p in $(tmux list-panes -t "$win" -F '#{pane_id}' 2>/dev/null); do
    tmux set-option -pu -t "$p" @claude-state 2>/dev/null
  done
  tmux set-option -wu -t "$win" @claude-alert 2>/dev/null
  tmux refresh-client -S 2>/dev/null
  exit 0
fi

pane=${TMUX_PANE:-$(tmux display -p '#{pane_id}' 2>/dev/null)}
[ -z "$pane" ] && exit 0
win=$(tmux display -p -t "$pane" '#{window_id}' 2>/dev/null) || exit 0

case $state in
  wait|idle|busy) tmux set-option -p -t "$pane" @claude-state "$state" 2>/dev/null ;;
  *)              tmux set-option -pu -t "$pane" @claude-state 2>/dev/null ;;
esac

# la ventana muestra el estado más urgente de sus panes
alert=
for s in wait idle busy; do
  if tmux list-panes -t "$win" -f "#{==:#{@claude-state},$s}" -F x 2>/dev/null | grep -q x; then
    alert=$s
    break
  fi
done
if [ -n "$alert" ]; then
  tmux set-option -w -t "$win" @claude-alert "$alert" 2>/dev/null
else
  tmux set-option -wu -t "$win" @claude-alert 2>/dev/null
fi
tmux refresh-client -S 2>/dev/null   # el status bar solo se repinta cada status-interval
exit 0

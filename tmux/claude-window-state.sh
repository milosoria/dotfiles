#!/bin/bash
# Marca la ventana de tmux con el estado de la sesión de Claude Code que corre en ella.
#
# Lo invocan los hooks de ~/.claude/settings.json:
#   busy    UserPromptSubmit / PostToolUse: está trabajando        -> punto verde
#   idle    Stop / SessionStart: te toca a vos                     -> punto amarillo
#   wait    PermissionRequest: pide autorización                   -> punto rojo
#   notify  Notification: decide según notification_type del payload, porque el mismo
#           evento cubre tanto "necesito permiso" como "hace rato que no escribís"
#   sync    respaldo sin hooks: deduce busy/idle de #{window_activity}, para las sesiones
#           que todavía no cargaron estos hooks (los toman al arrancar)
#   watch   cada WATCH_EVERY segundos corre sync y claude-window-name.sh. Lo arranca
#           tmux.conf. No usa status-interval porque ese lo comparte con gitmux, que
#           cuesta 150-350ms por refresh y por eso está en 15s.
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

claude_pane='#{&&:#{m:✳ *,#{pane_title}},#{||:#{m:claude,#{pane_current_command}},#{m:[0-9]*.[0-9]*.[0-9]*,#{pane_current_command}}}}'
WATCH_EVERY=2   # cada cuánto revisa el watcher
IDLE_AFTER=3    # sin imprimir por más de esto, la sesión está idle

sync_windows() {
  local now cur cur_act cur_alert cur_hooked changed win act alert st
  now=$(date +%s)
  changed=
  cur= cur_act= cur_alert= cur_hooked=

  decide() {
    [ -z "$cur" ] && return
    [ -n "$cur_hooked" ] && return          # si reporta por hook, mandan los hooks
    if [ $((now - cur_act)) -le $IDLE_AFTER ]; then st=busy; else st=idle; fi
    [ "$cur_alert" = "$st" ] && return
    tmux set-option -w -t "$cur" @claude-alert "$st" 2>/dev/null && changed=1
  }

  # una sola llamada a tmux; los panes de una ventana salen juntos
  while read -r win act alert st; do
    if [ "$win" != "$cur" ]; then
      decide
      cur=$win cur_act=$act cur_alert=$alert cur_hooked=
    fi
    [ -n "$st" ] && cur_hooked=1
  done <<EOF
$(tmux list-panes -a -f "$claude_pane" -F '#{window_id} #{window_activity} #{@claude-alert} #{@claude-state}' 2>/dev/null)
EOF
  decide

  [ -n "$changed" ] && tmux refresh-client -S 2>/dev/null
  return 0
}

if [ "$state" = sync ]; then
  sync_windows
  exit 0
fi

if [ "$state" = watch ]; then
  # un solo watcher por servidor de tmux: el dueño se anota en una opción global
  old=$(tmux show -gqv @claude-watcher 2>/dev/null)
  [ -n "$old" ] && kill -0 "$old" 2>/dev/null && exit 0
  tmux set -g @claude-watcher $$ 2>/dev/null || exit 0
  while [ "$(tmux show -gqv @claude-watcher 2>/dev/null)" = "$$" ]; do
    sync_windows
    "$(dirname "$0")/claude-window-name.sh"   # el nombre también se revisa acá, no en el status bar
    sleep $WATCH_EVERY
  done
  exit 0
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

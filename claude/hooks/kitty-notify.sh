#!/bin/bash
# Notificación de kitty (OSC 99) cuando Claude Code necesita que lo mires.
#
# Lo invocan los hooks de ~/.claude/settings.json con el payload por stdin:
#   PermissionRequest  pide permiso; ExitPlanMode es el plan esperando aprobación y
#                      AskUserQuestion una pregunta
#   Stop               terminó y te toca a vos
#   Notification       solo lo que no cubren los anteriores (formularios MCP, teammates)
#
# El título lleva la tab de tmux tal como la pinta el status bar (#{E:@row-idx} #W), para
# saber cuál mirar.
#
# No se puede imprimir el escape code a stdout: Claude Code captura la salida de los hooks.
# Se devuelve en el campo terminalSequence y Claude Code lo escribe a la terminal, envuelto
# para tmux. tmux tiene que estar en `allow-passthrough all` para que pase aunque el pane no
# esté a la vista. Por eso los hooks no son async: la salida de un hook async no llega.
#
# Si estás mirando el pane, kitty solo avisa cuando su ventana no tiene el foco (o=unfocused).
# Todas las de una sesión comparten id, así que la nueva reemplaza a la anterior.

payload=$(cat)
field() { printf '%s' "$payload" | jq -r "$1 // empty" 2>/dev/null; }
oneline() { tr '\n' ' ' | cut -c1-"$1"; }

event=$(field .hook_event_name)
tool=$(field .tool_name)

case $event in
  PermissionRequest)
    case $tool in
      ExitPlanMode)    what='📋 Plan para aprobar' detail='Revisa el plan' ;;
      AskUserQuestion) what='❓ Pregunta'          detail=$(field '.tool_input.questions[0].question' | oneline 120) ;;
      Bash)            what='🔒 Permiso'           detail="Bash: $(field .tool_input.command | oneline 100)" ;;
      *)               what='🔒 Permiso'           detail=$tool ;;
    esac ;;
  Stop)
    what='✅ Terminó'
    detail=$(field .last_assistant_message | oneline 120) ;;
  Notification)
    case $(field .notification_type) in
      # permission_prompt e idle_prompt ya los avisan PermissionRequest y Stop
      elicitation_dialog|elicitation_url_dialog|worker_permission_prompt|agent_needs_input)
        what='💬 Input requerido' detail=$(field .message) ;;
      *) exit 0 ;;
    esac ;;
  *) exit 0 ;;
esac
[ -z "$detail" ] && detail='Te toca'

if [ -n "$TMUX_PANE" ]; then
  IFS=$'\t' read -r tab visible < <(tmux display -p -t "$TMUX_PANE" \
    $'#{E:@row-idx} #W#{?automatic-rename, #{b:pane_current_path},}\t#{&&:#{session_attached},#{&&:#{window_active},#{pane_active}}}' 2>/dev/null)
fi
[ -z "$tab" ] && tab=$(basename "$(field .cwd)") visible=1

esc=$(kitten notify --only-print-escape-code -i "claude-$(field .session_id)" "$what · $tab" "$detail") || exit 0
[ "$visible" = 1 ] && esc=${esc//$'\e]99;'/$'\e]99;o=unfocused:'}
jq -nc --arg s "$esc" '{terminalSequence: $s}'

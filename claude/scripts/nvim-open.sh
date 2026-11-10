#!/usr/bin/env bash
# Abre un archivo en nvim, en un pane vertical a la derecha del pane de Claude.
# Reutiliza el mismo pane visor por ventana de tmux; el foco se queda en Claude.
#
# Uso: nvim-open.sh <archivo>[:línea[:col]] [línea]
set -euo pipefail

[ -n "${TMUX:-}" ] && [ -n "${TMUX_PANE:-}" ] || { echo "nvim-open: no estoy dentro de tmux" >&2; exit 1; }

arg="${1:?uso: nvim-open.sh <archivo>[:línea] [línea]}"
line="${2:-}"
if [ -z "$line" ] && [ ! -e "$arg" ] && [[ "$arg" =~ ^(.+):([0-9]+)(:[0-9]+)?$ ]]; then
  arg="${BASH_REMATCH[1]}"
  line="${BASH_REMATCH[2]}"
fi
[ -e "$arg" ] || { echo "nvim-open: no existe $arg" >&2; exit 1; }
file="$(cd "$(dirname "$arg")" && pwd -P)/$(basename "$arg")"

win="$(tmux display -p -t "$TMUX_PANE" '#{window_id}')"

# Pane visor existente en esta ventana; @claude-viewer guarda la ruta de su socket
read -r viewer sock < <(tmux list-panes -t "$win" -F '#{pane_id} #{@claude-viewer}' | awk '$2 != "" {print; exit}') || true

if [ -n "${viewer:-}" ] && nvim --server "$sock" --remote-expr 1 >/dev/null 2>&1; then
  esc="${file// /\\ }"
  cmd=":edit ${line:++$line }$esc<CR>"
  [ -n "$line" ] && cmd="${cmd}zz"
  nvim --server "$sock" --remote-send "<C-\\><C-N>${cmd}"
  echo "nvim-open: $file${line:+:$line} (pane $viewer)"
  exit 0
fi

# Visor muerto o inexistente: limpiar y abrir uno nuevo
[ -n "${viewer:-}" ] && tmux kill-pane -t "$viewer"
sock="/tmp/nvim-claude-${win#@}-$$.sock"
rm -f "$sock"

args=(nvim --listen "$sock")
[ -n "$line" ] && args+=("+$line" -c 'normal! zz')
args+=("$file")

new="$(tmux split-window -h -d -P -F '#{pane_id}' -t "$TMUX_PANE" -c "$PWD" -- "${args[@]}")"
tmux set-option -p -t "$new" @claude-viewer "$sock"
echo "nvim-open: $file${line:+:$line} (pane nuevo $new)"

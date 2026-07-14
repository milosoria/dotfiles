#!/bin/bash
# theme.sh — sync tokyonight / gruvbox-material across kitty, tmux, nvim and Claude Code
# Usage: theme            -> toggle
#        theme tokyonight | theme gruvbox
#        theme status     -> print current
set -u

STATE_DIR="$HOME/.config/theme"
STATE="$STATE_DIR/current"

current() { cat "$STATE" 2>/dev/null || echo tokyonight; }

case "${1:-toggle}" in
  toggle) [ "$(current)" = tokyonight ] && target=gruvbox-material || target=tokyonight ;;
  tokyo*) target=tokyonight ;;
  gruv*) target=gruvbox-material ;;
  status | current)
    current
    exit 0
    ;;
  *)
    echo "usage: theme [tokyonight|gruvbox|status]   (no args: toggle)" >&2
    exit 1
    ;;
esac

if [ "$target" = gruvbox-material ]; then
  kitty_conf=gruvbox_material_kitty.conf
  tmux_conf=themes/gruvbox-material.conf
  nvim_scheme=gruvbox-material
  claude_theme=custom:gruvbox-material
else
  kitty_conf=tokyo_night_kitty.conf
  tmux_conf=themes/tokyonight.conf
  nvim_scheme=tokyonight
  claude_theme=custom:tokyonight
fi

# state file — single source of truth (nvim reads it at startup)
mkdir -p "$STATE_DIR"
echo "$target" >"$STATE"

# kitty: repoint the themed include, live-reload every window via SIGUSR1
ln -sfn "$kitty_conf" "$HOME/.config/kitty/current-theme.conf"
pkill -USR1 -x kitty 2>/dev/null || true

# tmux: repoint the themed conf, re-source it if a server is running
ln -sfn "$tmux_conf" "$HOME/.config/tmux/current-theme.conf"
tmux source-file "$HOME/.config/tmux/current-theme.conf" 2>/dev/null || true

# nvim: apply on every running instance through its server socket
for sock in "${TMPDIR:-/tmp}"/nvim."$USER"/*/nvim.*.0; do
  [ -S "$sock" ] || continue
  nvim --server "$sock" --remote-expr "execute('colorscheme $nvim_scheme')" >/dev/null 2>&1 || true
done

# Claude Code: settings.json is watched, so running sessions restyle live
settings="$HOME/.claude/settings.json"
if command -v jq >/dev/null 2>&1 && [ -f "$settings" ]; then
  tmp="$(mktemp)" && jq --arg t "$claude_theme" '.theme = $t' "$settings" >"$tmp" && mv "$tmp" "$settings"
else
  echo "warn: jq or $settings missing — Claude Code theme not updated" >&2
fi

echo "theme → $target"

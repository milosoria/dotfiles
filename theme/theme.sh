#!/bin/bash
# theme.sh — sync tokyonight / gruvbox-material across kitty, tmux, nvim and Claude Code
# Usage: theme                          -> toggle theme, keeps the current variant
#        theme tokyonight|gruvbox [light|dark]   (variant defaults to dark; "normal" = dark)
#        theme status                   -> print current
set -u

STATE_DIR="$HOME/.config/theme"
STATE="$STATE_DIR/current"

# state file holds "<theme> <variant>", e.g. "tokyonight dark"
read -r cur_theme cur_variant <"$STATE" 2>/dev/null
cur_theme="${cur_theme:-tokyonight}"
cur_variant="${cur_variant:-dark}"

usage() { echo "usage: theme [tokyonight|gruvbox [light|dark]] | status   (no args: toggle)" >&2; exit 1; }

case "${1:-toggle}" in
  toggle)
    [ "$cur_theme" = tokyonight ] && target=gruvbox-material || target=tokyonight
    variant="$cur_variant"
    ;;
  tokyo*) target=tokyonight ;;
  gruv*) target=gruvbox-material ;;
  status | current)
    echo "$cur_theme $cur_variant"
    exit 0
    ;;
  *) usage ;;
esac

if [ -z "${variant:-}" ]; then
  case "${2:-dark}" in
    light) variant=light ;;
    dark | normal) variant=dark ;;
    *) usage ;;
  esac
fi

case "$target-$variant" in
  gruvbox-material-dark)
    kitty_conf=gruvbox_material_kitty.conf
    tmux_conf=themes/gruvbox-material.conf
    nvim_cmd="set background=dark | colorscheme gruvbox-material"
    claude_theme=custom:gruvbox-material
    ;;
  gruvbox-material-light)
    kitty_conf=gruvbox_material_light_kitty.conf
    tmux_conf=themes/gruvbox-material-light.conf
    nvim_cmd="set background=light | colorscheme gruvbox-material"
    claude_theme=custom:gruvbox-material-light
    ;;
  tokyonight-dark)
    kitty_conf=tokyo_night_kitty.conf
    tmux_conf=themes/tokyonight.conf
    nvim_cmd="set background=dark | colorscheme tokyonight-night"
    claude_theme=custom:tokyonight
    ;;
  tokyonight-light)
    kitty_conf=tokyo_day_kitty.conf
    tmux_conf=themes/tokyonight-day.conf
    nvim_cmd="set background=light | colorscheme tokyonight-day"
    claude_theme=custom:tokyonight-day
    ;;
esac

# state file — single source of truth (nvim reads it at startup)
mkdir -p "$STATE_DIR"
echo "$target $variant" >"$STATE"

# kitty: repoint the themed include, live-reload every window via SIGUSR1
ln -sfn "$kitty_conf" "$HOME/.config/kitty/current-theme.conf"
pkill -USR1 -x kitty 2>/dev/null || true

# tmux: repoint the themed conf, re-source it if a server is running
ln -sfn "$tmux_conf" "$HOME/.config/tmux/current-theme.conf"
tmux source-file "$HOME/.config/tmux/current-theme.conf" 2>/dev/null || true

# nvim: apply on every running instance through its server socket
for sock in "${TMPDIR:-/tmp}"/nvim."$USER"/*/nvim.*.0; do
  [ -S "$sock" ] || continue
  nvim --server "$sock" --remote-expr "execute('$nvim_cmd')" >/dev/null 2>&1 || true
done

# Claude Code: settings.json is watched, so running sessions restyle live
settings="$HOME/.claude/settings.json"
if command -v jq >/dev/null 2>&1 && [ -f "$settings" ]; then
  tmp="$(mktemp)" && jq --arg t "$claude_theme" '.theme = $t' "$settings" >"$tmp" && mv "$tmp" "$settings"
else
  echo "warn: jq or $settings missing — Claude Code theme not updated" >&2
fi

echo "theme → $target $variant"

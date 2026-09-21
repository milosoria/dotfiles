# tmux

## Nombre de las ventanas

`claude-window-name.sh` nombra cada ventana con el título de la sesión de Claude Code que corre
en ella, leyendo `#{pane_title}` (Claude lo publica por OSC como `✳ <título>`).

No usar hooks de Claude para esto: `/rename` es un comando `local-jsx` y no dispara
`UserPromptSubmit` ni `Stop`, así que ningún hook se entera del rename. El título del pane sí se
actualiza al instante.

Disparadores, en `tmux.conf`: `#()` invisible en `status-right` (cada `status-interval`) y los
hooks `after-select-window`, `client-attached`, `window-pane-changed`.

Estado por pane: `@claude-name` (nombre que puso el script) y `@claude-title` (último título
visto). Sirven de filtro en tmux, así que la pasada normal es una sola llamada sin renombrar.
El hook `SessionEnd` de `~/.claude/settings.json` los limpia y devuelve `automatic-rename on`.

<claude-mem-context>

</claude-mem-context>
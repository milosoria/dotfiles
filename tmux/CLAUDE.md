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

## Marca de atención

`claude-window-state.sh` pinta un punto antes del nombre cuando una sesión de Claude Code te
necesita: rojo si espera que autorices algo (`PermissionRequest`, `Notification`), amarillo si
terminó y espera tu input (`Stop`). Se limpia cuando Claude vuelve a trabajar
(`UserPromptSubmit`, `PostToolUse`), cuando seleccionás la ventana, o al cerrar la sesión
(`SessionEnd`). Se marca también la ventana en la que estás: es la que más mirás y querés verla
encenderse cuando Claude termina.

El script cierra con `refresh-client -S`. Sin eso la marca tarda hasta un `status-interval`
(15s) en aparecer, que es lo mismo que no funcionar.

Estado: opción de pane `@claude-state`, agregada en `@claude-alert` de la ventana (`wait` gana
sobre `idle`). El punto lo dibuja `@claude-mark`, que `window-status-format` expande con `#{E:}`.

<claude-mem-context>

</claude-mem-context>
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

## Marca de estado

`claude-window-state.sh` pinta un punto antes del nombre con el estado de la sesión de Claude
Code que corre en la ventana:

| Punto | Estado | Lo pone |
|-------|--------|---------|
| verde | trabajando | `UserPromptSubmit`, `PostToolUse` |
| amarillo | terminó, te toca a vos | `Stop`, `SessionStart` |
| rojo | pide autorización | `PermissionRequest`, `Notification` de tipo permiso |

`Notification` cubre tanto "necesito permiso" como "hace rato que no escribís", así que el
script mira `notification_type` del payload (`permission_prompt` y `worker_permission_prompt`
van a rojo, `idle_prompt` y `agent_completed` a amarillo) en vez de tratarlos igual.

### Respaldo para las sesiones que no cargaron los hooks

Una sesión solo toma los hooks al arrancar, así que las que ya estaban abiertas no reportan
nada y quedarían mintiendo. Para esas está `claude-window-state.sh sync`, que deduce el estado
de `#{window_activity}`: una sesión trabajando repinta su spinner cada segundo, una idle no
imprime nada (medido: 1s contra 118s). Nunca pisa a un pane que sí reporta por hook, porque los
hooks son exactos y al instante mientras que esto es una inferencia.

Lo corre `claude-window-state.sh watch`, un loop cada 2s que arranca `tmux.conf`, con ~10ms por
vuelta. No va por `status-interval` porque ese lo comparte con gitmux (150-350ms por refresh),
que es la razón de que esté en 15s. Hay un solo watcher por servidor: el dueño anota su PID en
la opción global `@claude-watcher`, así que recargar el config no lo duplica, y el hook
`client-attached` lo revive si murió.

### Detalles

La marca es estado, no aviso: sobrevive a que pases por la ventana. Solo la mueve el propio
Claude al cambiar de estado, y `SessionEnd` la borra. Si queda huérfana (sesión muerta sin
`SessionEnd`), `claude-window-state.sh clear` limpia la ventana actual.

Estado: opción de pane `@claude-state`, agregada en `@claude-alert` de la ventana (`wait` gana
a `idle`, `idle` a `busy`). El punto lo dibuja `@claude-mark`, que `window-status-format`
expande con `#{E:}`. Amarillo es además el default de una ventana de claude sin estado; la
señal de "esto es claude" es `@claude-name`, que pone `claude-window-name.sh` y borra
`SessionEnd`.

Los scripts cierran con `refresh-client -S`. Sin eso la marca tarda hasta un `status-interval`
(15s) en aparecer, que es lo mismo que no funcionar.

<claude-mem-context>

</claude-mem-context>
# tmux

## Barra de 2 líneas

`status 2`: arriba los repos/servers con gitmux (parte desde el borde, `status-left` vacío),
abajo las sesiones de Claude con el ícono 󰚩. Cada línea es el `status-format` default de tmux
con el loop `#{W:}` filtrado por `@is-claude` (`@claude-alert` o `@claude-name` puestos), así
que el clic, el foco y los `window-status-*-format` siguen funcionando igual. Ojo: dentro de un
`#{?}` no puede haber comas sueltas (`#[fg=x,bold]`), por eso los formatos de ventana entran
por `#{T:}`.

Las tabs son píldoras: bordes powerline redondeados (`@pill-l`/`@pill-r`, escritos como
`"\ue0b6"` para no depender de pegar el glifo) con fondo `@tab-bg`, y la actual rellena de
`@accent`. Los `@tab-*` los define cada tema en `themes/`. No hay separación vertical entre
filas: tmux trabaja por líneas enteras y una vacía al medio era demasiado.

## Numeración por fila

Cada fila numera sus tabs desde 1 (`@row-idx`, no `#I`). `prefix + N` va a la tab N de la fila
en la que estás (`@row-goto` vía `run -C`) y `prefix + n/p` ciclan dentro de esa fila, dando la
vuelta en los extremos (`@row-next`/`@row-prev`). Para cambiar de fila está el buscador. El
número es cuántas ventanas de la misma fila tienen índice <= al suyo: un `#{W:}` anidado no ve
la ventana de afuera, así que su fila e índice se inyectan en la plantilla con `s/ROW/` y
`s/IDX/` antes de expandirla con `E:`. Ojo: `<=` compara strings (`10 <= 2`), por eso va
`e|<=`. El buscador y el título de las notificaciones de kitty usan el mismo número.

## Buscador de panes (`prefix + f`)

`pane-finder.sh` en un `display-popup` sin borde (el borde lo dibuja fzf), sin preview. Mismo
orden que la barra: repos/servers y después Claude con su punto de estado y el título completo.
De Claude va solo la sesión principal de cada ventana (pane de menor índice, la misma regla del
namer), no los subagentes. Alinea columnas en perl porque `printf` de awk cuenta bytes y los
íconos y acentos las corren. Los colores salen del tema.

## Nombre de las ventanas

`claude-window-name.sh` nombra cada ventana con el título de la sesión de Claude Code que corre
en ella, leyendo `#{pane_title}` (Claude lo publica por OSC como `✳ <título>`).

No usar hooks de Claude para esto: `/rename` es un comando `local-jsx` y no dispara
`UserPromptSubmit` ni `Stop`, así que ningún hook se entera del rename. El título del pane sí se
actualiza al instante.

Disparadores: el watcher de `claude-window-state.sh` cada 2s, más los hooks
`after-select-window`, `client-attached` y `window-pane-changed` para que se vea al instante
cuando interactuás con tmux. Nada de esto pasa por `status-right`, que quedó solo para gitmux.

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

### Notificaciones de kitty

Los mismos eventos (`PermissionRequest`, `Stop`, `Notification`) disparan además
`~/.claude/hooks/kitty-notify.sh`, que avisa con una notificación de kitty titulada con la tab
(`#{E:@row-idx} #W`). Necesita `allow-passthrough all`: con `on` tmux descarta el escape si el
pane no está a la vista, que es justo cuando el aviso sirve.

### Respaldo para las sesiones que no cargaron los hooks

Una sesión solo toma los hooks al arrancar, así que las que ya estaban abiertas no reportan
nada y quedarían mintiendo. Para esas está `claude-window-state.sh sync`, que deduce el estado
de `#{window_activity}`: una sesión trabajando repinta su spinner cada segundo, una idle no
imprime nada (medido: 1s contra 118s). Nunca pisa a un pane que sí reporta por hook, porque los
hooks son exactos y al instante mientras que esto es una inferencia.

Lo corre `claude-window-state.sh watch`, un loop cada 2s que arranca `tmux.conf` y que también
llama a `claude-window-name.sh`: ~18ms por vuelta las dos cosas, menos de lo que cuesta un
refresh de gitmux. No va por `status-interval` porque ese lo comparte con gitmux (150-350ms por refresh),
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
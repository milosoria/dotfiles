# Brief chunk NN: <título>

Todos los campos son obligatorios. Si falta uno, no se lanza el subagente.

**GOAL**
<El resultado en una frase.>

**SCOPE**
- Worktree: `<ruta absoluta al worktree>` (trabaja solo ahí)
- Rama: `ship/<slug>/NN-<tema>` (ya creada, sale de `<rama-padre>`)
- Puede escribir: <paths o globs>
- No puede escribir: todo lo demás

**CONTEXT**
- Sección del plan (texto exacto, no resumen):
  <pegar la sección completa del chunk desde plan.md>
- Punteros: <archivo:línea de patrones a seguir, del reporte de exploración>
- Lo que ya hicieron los chunks anteriores: <pegar REPORT del chunk anterior completo, o "primer chunk">
- Convenciones del repo: leer `<repo>/CLAUDE.md`

**ACCEPTANCE**
<Copiar los criterios de aceptación del plan.>

**VERIFY**
<Comandos exactos. Correrlos y pegar la salida real en el reporte.>

**FORBIDDEN**
- Sin rebase, merge, push ni force-push. Sin abrir PRs.
- Sin tocar archivos fuera de SCOPE. Si hace falta, parar y reportarlo.
- Sin `git add -A`: agregar archivos por nombre.
- Sin migraciones destructivas ni acceso a datos de prod.

**REPORT** (formato de salida)
```
STATUS: done | blocked
HEAD: <sha>
CAMBIOS: <archivo: qué cambió, una línea c/u>
LO QUE NO TOQUÉ: <cosas vistas fuera de scope>
VERIFY: <comando -> resultado real (pegar fallas completas)>
RIESGOS / DUDAS: <...>
```

**STANDING**
- Commits con conventional commits, uno o pocos por chunk.
- No escribir más de ~100 líneas sin correr los tests.
- Lo más simple que cumpla los criterios. Sin abstracciones para casos futuros.

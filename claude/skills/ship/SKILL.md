---
name: ship
description: Lleva un proyecto grande desde una descripción hasta un stack de PRs modulares (grill, DRD, plan en chunks, subagentes, pre-pr). Usar SOLO si el usuario escribe "/ship" explícitamente, o si el proyecto es muy grande (cruza varios repos/servicios o requiere 5+ PRs) y en ese caso proponerlo y esperar un sí antes de arrancar. NO usar para features normales, fixes ni cambios que caben en 1-3 PRs.
---

> **Activación.** Si el usuario no escribió `/ship`, no arrancar: decir en una línea por qué el proyecto parece calificar (repos, PRs estimados) y preguntar si quiere usar `/ship`. Ante la duda, no aplica.

# ship

Conductor delgado: encadena `grill-me`, `drd`, exploración, plan, subagentes por chunk y `pre-pr`. El valor está en los gates y en que todo se apoya en archivos, no en resúmenes.

## Principios (no negociables)

1. **Los archivos son la fuente de verdad.** DRD en Notion, `plan.md` y los reportes en disco. A un subagente se le pega el texto del plan tal cual, nunca una paráfrasis.
2. **Dos gates humanos con sí explícito**: tras el DRD y tras el plan. "Se ve bien", "dale nomás" o silencio no son aprobación: pedir un "sí" explícito. En cada gate, **terminar el turno**.
3. **El orquestador (tú) no edita código.** Solo escribe briefs, lee reportes, verifica y abre PRs. Un solo escritor por worktree.
4. **PRs apilados y chicos.** Tope ~5 archivos y ~300 líneas por PR (sin lockfiles ni generados). Cortes verticales cuando se pueda. Refactor y feature en PRs separados.
5. **Se avanza sin pedir permiso en lo reversible.** Se para ante: test rojo que no se entiende, ambigüedad del DRD, o algo irreversible (migración destructiva, datos en prod, deploy, secretos, mensajes a clientes).
6. **Lo que no toca se anota, no se arregla.** Desvíos de alcance van a "Follow-ups" del `state.md`.

## Estado

Carpeta de trabajo: `~/.claude/ship/<slug>/`

```
state.md      fase actual, decisiones del grill, link al DRD, tabla de PRs (chunk | rama | PR | estado), follow-ups
plan.md       plan aprobado (ver references/plan-template.md)
briefs/NN.md  brief exacto enviado a cada subagente
reports/NN.md reporte de cada subagente y de pre-pr
```

Al empezar, si existe `state.md` para el slug, retomar desde la fase anotada en vez de reiniciar. Actualizar `state.md` al cerrar cada fase.

## Fase 1: Grill

Invocar la skill `grill-me` con la descripción del usuario, con estas reglas adicionales:

- Antes de preguntar, explorar el código. Lo que se puede responder leyendo o ejecutando algo no se le pregunta al humano.
- Abrir con `HIPÓTESIS: <qué creo que se quiere> | CONFIANZA: ~N%` y qué falta para subirla.
- Una pregunta por mensaje, siempre con `PROPUESTA: <mi respuesta por defecto>` para que el usuario solo confirme o corrija.
- Preguntar solo decisiones de producto o preferencia. Ofrecer opciones.
- Terminar cuando puedas predecir la reacción del usuario a tus próximas tres preguntas.
- Cierre obligatorio: **Resultado / Usuario afectado / Criterio de éxito (verificable) / Restricciones / Fuera de alcance**. Fuera de alcance no puede quedar vacío.

Guardar el cierre en `state.md`.

## Fase 2: DRD (gate 1)

Invocar la skill `drd` pasándole el cierre del grill como contexto. Sigue su propio flujo (Proyecto de Notion obligatorio, una confirmación). Guardar el link en `state.md`.

**Gate 1:** mostrar el link, pedir sí explícito para pasar al plan. Terminar el turno.

## Fase 3: Exploración intensiva

Lanzar en un mismo mensaje subagentes `Explore` en paralelo, uno por repo o subsistema tocado. Cada uno devuelve **punteros** (archivo:línea, convenciones, comandos de test/lint, puntos de entrada), no contenido. Pedir explícitamente:

- Qué existe que se puede reusar.
- **Blast radius**: qué más llama o depende de lo que se va a cambiar (usar LSP `findReferences` / `incomingCalls`, `contracts-impact` o `macal-impact` si cruza servicios).
- El hecho que hace seguro el cambio, y cómo probarlo ejecutando algo (no argumentando).
- Si hay frontend: rutas a capturar, cómo levantar la app y cómo autenticarse localmente.

Si quedan dudas técnicas abiertas, cerrarlas con un prototipo descartable o una query (skill `read-replica`) antes del plan. No planear sobre supuestos.

## Fase 4: Plan (gate 2)

Escribir `plan.md` con `references/plan-template.md`. Reglas:

- Un chunk = un PR. Si un chunk supera el tope, tiene "y" en el título, toca 2 subsistemas o necesita más de 3 criterios de aceptación: partirlo.
- Orden del stack: lo de mayor riesgo primero (fail fast). Migraciones y contratos compartidos antes de quien los consume. En multi-repo: un stack por repo, backend antes que frontend.
- Cada chunk deja el sistema funcionando: compila, pasa tests, se puede revertir solo. Si queda funcionalidad a medias visible, va detrás de un flag o sin cablear a la UI.
- Cada criterio de aceptación referencia el RF del DRD que cumple.

**Gate 2:** mostrar la tabla resumen (chunk | título | repo | archivos | depende de | frontend sí/no) y los riesgos. Pedir sí explícito. Terminar el turno.

## Fase 5: Orquestación

Ramas apiladas: `ship/<slug>/01-<tema>` sale de `origin/staging`, `02` sale de `01`, etc. Worktrees en `<repo>-worktrees/ship-<slug>-NN` (nunca dentro del repo).

**Piloto primero.** El chunk 01 recorre todo el camino (build, verificación, pre-pr, PR) antes de lanzar el resto. Lo que falle en el piloto (cómo levantar la app, auth, comandos) se corrige en el plan antes de seguir.

Por chunk:

1. Crear worktree y rama desde la rama del chunk anterior.
2. Escribir `briefs/NN.md` con `references/brief-template.md`. Si falta un campo, no se lanza.
3. Lanzar un subagente `general-purpose` **nuevo** por chunk (no reutilizar uno anterior). Para corregir, lanzar otro con el brief + el feedback, no encadenar resumes.
4. Leer su REPORT. Verificar tú mismo en el worktree: re-correr los comandos de VERIFY y mirar `git diff <rama-padre>...HEAD --stat` contra el SCOPE. Un reporte no es evidencia.
5. Máximo 2 reintentos por chunk. Al tercero, parar y escalar al usuario con el diff y el error.

**Pipeline:** cuando el chunk N pasa la verificación del paso 4, lanzar el chunk N+1 (sale de la rama de N) mientras corre el `pre-pr` de N. Si el pre-pr de N obliga a cambios, rebasar N+1 sobre N después.

## Fase 6: PR por chunk

1. **pre-pr forzado**: seguir la skill `pre-pr` saltando el gate (en `/ship` siempre aplica) y usando como base la **rama padre**, no staging: `gate.sh origin/<rama-padre>` solo para listar archivos sensibles, y `code-review` sobre `git diff <rama-padre>...HEAD`. Los hallazgos Critical/Required los corrige un subagente nuevo; el resto va al cuerpo del PR como nota.
2. **Screenshots si el chunk toca frontend**: levantar la app desde el worktree, capturar con la skill `playwright-cli` cada pantalla del "Se ve" del plan, en el estado antes (rama padre) y después. Revisar consola: cero errores nuevos. Subir con:
   ```bash
   ~/.claude/skills/ship/scripts/pr-assets.sh <owner/repo> <slug>/NN antes.png despues.png
   ```
   El script los sube a la rama huérfana `pr-assets` del repo y devuelve el markdown listo para pegar. Van en la descripción (sección Evidencia). Si tras revisión cambia la UI, las capturas nuevas van como comentario (`gh pr comment`).
3. **Push y PR**: `git push -u origin <rama>` y `gh pr create --base <rama-padre> --title "<tipo>(<scope>): <título>" --body-file <archivo>`. PR listo, no draft. Cuerpo (< 40 líneas):
   ```
   Stack: <slug> NN/<total> | Depende de: #<PR padre> | DRD: <link>
   ## Por qué
   ## Cambios
   ## Lo que no toqué
   ## Riesgos
   ## Testing        (comandos corridos y resultado real, qué se probó a mano)
   ## Evidencia      (screenshots antes/después, solo frontend)
   ## Cómo revertir
   ```
4. Actualizar la tabla de PRs en `state.md`.

## Mantener el stack

Cuando se mergea el PR padre a staging:

```bash
git fetch origin
git rebase --onto origin/staging <sha-viejo-del-head-del-padre> <rama-hija>
git push --force-with-lease
gh pr edit <PR hijo> --base staging
```

Force-push solo sobre ramas `ship/<slug>/*` propias. Nunca mergear PRs: eso lo hace el humano.

## Cierre

Reporte final corto: tabla de PRs con link y estado, follow-ups anotados, y qué quedó sin verificar. Sugerir `/as-built` cuando el stack esté mergeado.

## Excusas comunes

| Excusa | Realidad |
|---|---|
| "Es obvio, me salto el grill" | Si es obvio, el grill dura 2 preguntas. Si no, era necesario. |
| "El subagente dijo que los tests pasan" | Re-correrlos tú en el worktree. |
| "Este chunk es chico, no necesita pre-pr" | En `/ship` siempre corre. |
| "Ya que estoy, arreglo esto otro" | Va a follow-ups. |
| "Junto 01 y 02 para ahorrar un PR" | El tope existe para que el revisor pueda revisar. |
| "CI verde, está listo" | Verde es insumo. Frontend necesita evidencia visual. |

## Red flags (parar y revisar)

- Un subagente escribió fuera de su SCOPE.
- Un PR supera el tope sin justificación en el plan.
- Vas a lanzar un chunk sin brief completo o sin que el anterior esté verificado.
- Estás resumiendo el plan para un subagente en vez de pegarlo.
- Pasaste un gate sin un sí explícito.

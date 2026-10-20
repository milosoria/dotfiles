---
name: pre-pr
description: Verificación y revisión antes de abrir un PR, SOLO para cambios sensibles o grandes. Usar antes de crear un PR (o cuando el usuario pida "/pre-pr", "revisa antes del PR") si el diff toca auth/permisos, pagos/montos/garantías/liquidaciones, migraciones, clientes cross-service/webhooks/pubsub, CI/deploy/Docker o secretos, o si supera ~500 líneas o ~20 archivos. NO usar en cambios chicos o rutinarios (copy, estilos, un fix acotado, docs): en esos casos se abre el PR directo.
---

# pre-pr

Corre las verificaciones reales del repo y una revisión con contexto limpio antes de abrir un PR. Solo vale la pena en cambios sensibles o grandes; el resto se salta.

## 0. Gate (siempre primero)

```bash
~/.claude/skills/pre-pr/gate.sh            # base: origin/staging, fallback origin/main
~/.claude/skills/pre-pr/gate.sh origin/main # otra base
```

- `VERDICT: SKIP` y el usuario no pidió forzar (`/pre-pr force`): decir en una línea que el cambio no lo amerita y **parar**.
- `VERDICT: RUN`: seguir. Anotar los motivos (`sensible`, `grande-*`) y los archivos sensibles; definen el paso 3.

## 1. Simplify

Correr la skill `simplify` sobre el diff contra la base. Va antes de la verificación para que lint, tests y la revisión corran sobre el código ya simplificado.

- Solo limpieza de calidad (reuso, simplificación, eficiencia); no cambia comportamiento. Si un cambio propuesto altera lógica de negocio o toca archivos sensibles más allá de lo cosmético, no aplicarlo y listarlo como hallazgo.
- Anotar qué cambió (archivos y resumen) para el reporte. Los cambios quedan sin commitear; el usuario decide si los incluye.

## 2. Verificación (mostrar la salida real, no resumir "pasó")

Correr solo lo que exista en el repo. Si algo falla, reportarlo con su salida; no seguir "arreglando" sin avisar.

**Python/FastAPI** (macal-api, macal-users-api, etc.):
- `uv run ruff check app/` y `uv run ruff format app/ --check`
- `make standards-check` (LOC, schemas inline, pureza de routers)
- Si hay `.contracts.yaml` y el diff toca endpoints o clientes: `make contracts-check`
- Si hay migraciones nuevas: confirmar que vienen de `make migrate-create`, que tienen `downgrade` y que `uv run alembic check` (o el check equivalente del repo) no reporta cambios pendientes
- Tests de los módulos tocados. En repos con dev container, `tests/` no está montado: `docker cp` el archivo al contenedor o usar `uv run pytest` si hay DB local. Decir explícitamente qué tests corrieron y cuáles no.

**Next.js** (macal-maia-front, maia-inmobiliarias, macal-new-web):
- `npm run lint`
- `npx tsc --noEmit`
- `npm test` si existe
- `npm run build` solo si el motivo incluye `grande-*` o se tocó config (`next.config`, `middleware.ts`)

## 3. Revisión con contexto limpio

- Siempre: skill `code-review` sobre el diff contra la base, nivel `high`.
- Si los archivos sensibles incluyen auth/permisos, secretos, webhooks/endpoints públicos o pagos: además la skill `security-review`.
- Si toca endpoints, clientes HTTP, pubsub o eventos: skill `macal-impact` para ver qué otros servicios se afectan.

Las revisiones corren en subagentes y no editan código. Los hallazgos se reportan; el usuario decide qué corregir.

## 4. Reporte

Corto, en este orden:

1. Motivo del gate (ej: "sensible: alembic/versions/xxx.py, payments_service.py").
2. Cambios aplicados por `simplify` (archivos y resumen en una línea cada uno), o "sin cambios".
3. Tabla de checks: check | resultado | nota (con la salida relevante si falló).
4. Hallazgos de la revisión, los importantes primero, con `archivo:línea`.
5. Borrador de secciones para el cuerpo del PR:
   - **Testing**: qué se corrió y qué se probó a mano.
   - **Risk**: qué puede romperse y a quién afecta.
   - **How to revert**: revert del commit, `make downgrade` si hay migración, flag a apagar, datos a restaurar.

No abrir el PR, no pushear, no commitear y no corregir hallazgos de la revisión sin que el usuario lo pida. Los únicos cambios automáticos son los de `simplify` del paso 1.

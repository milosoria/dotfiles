# Plan: <título>

DRD: <link> | Slug: <slug> | Repos: <repo1>, <repo2>

## Resumen
<2-3 líneas: qué se construye y en cuántos PRs.>

## Stack

| # | Título | Repo | Archivos | Depende de | Frontend |
|---|--------|------|----------|------------|----------|
| 01 | ... | ... | ~3 | staging | no |
| 02 | ... | ... | ~4 | 01 | sí |

---

## 01: <título>

- **RF del DRD**: RF-1
- **Depende de**: staging
- **Archivos** (probables): `path/a.py` (modificar), `path/b.py` (crear)
- **Fuera de scope**: <qué no debe tocar aunque parezca relacionado>
- **Construir**: <1-3 frases de qué queda funcionando, como outcome, no receta>
- **Se ve**: <qué cambia observable: endpoint que responde X, pantalla Y muestra Z. En frontend: rutas y estados a capturar>
- **Criterios de aceptación**:
  - [ ] <condición observable>
- **Verificar**:
  - `<comando exacto de tests>`
  - `<lint / typecheck>`
  - <check manual o en vivo, si aplica>
- **Riesgo**: <bajo|medio|alto> <por qué>

---

## 02: ...

---

## Riesgos y dudas cerradas
- <duda> -> <cómo se cerró (prototipo, query, lectura de código)>

## Follow-ups (fuera de este stack)
- ...

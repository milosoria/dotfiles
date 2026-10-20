#!/usr/bin/env bash
# Decide si el cambio actual amerita /pre-pr. Imprime stats, archivos sensibles y un VERDICT.
# Uso: gate.sh [base]   (default: origin/staging, fallback origin/main)
set -uo pipefail

base="${1:-}"
if [ -z "$base" ]; then
  if git rev-parse --verify -q origin/staging >/dev/null; then base=origin/staging; else base=origin/main; fi
fi
mb=$(git merge-base "$base" HEAD 2>/dev/null) || { echo "ERROR: no pude calcular merge-base con $base"; exit 2; }

# Commits de la rama + cambios sin commitear, excluyendo lockfiles y generados.
exclude=(':!*.lock' ':!uv.lock' ':!package-lock.json' ':!pnpm-lock.yaml' ':!yarn.lock' ':!*.snap' ':!*.min.*' ':!.contracts.yaml')
files=$(git diff --name-only "$mb" -- . "${exclude[@]}"; git ls-files --others --exclude-standard)
files=$(printf '%s\n' "$files" | sed '/^$/d' | sort -u)
n_files=$(printf '%s\n' "$files" | sed '/^$/d' | wc -l | tr -d ' ')
lines=$(git diff --numstat "$mb" -- . "${exclude[@]}" | awk '{a+=$1; d+=$2} END {print a+d+0}')

sensitive_re='(alembic/versions/|/migrations?/|deps\.py|auth|permission|rbac|role|secret|\.env|\.pem$|payment|pago|refund|devoluc|guarantee|garantia|payout|settlement|liquidac|saldo|wallet|invoice|factura|_client\.py$|pubsub|webhook|\.github/workflows/|Dockerfile|deploy|cloudrun|middleware\.ts$|next\.config)'
sensitive=$(printf '%s\n' "$files" | grep -iE "$sensitive_re" || true)

MAX_LINES=500
MAX_FILES=20

echo "base: $base"
echo "archivos: $n_files | lineas cambiadas: $lines (umbral: >$MAX_LINES lineas o >$MAX_FILES archivos)"
if [ -n "$sensitive" ]; then
  echo "archivos sensibles:"
  printf '  %s\n' $sensitive
fi

reasons=()
[ "$lines" -gt "$MAX_LINES" ] && reasons+=("grande-lineas")
[ "$n_files" -gt "$MAX_FILES" ] && reasons+=("grande-archivos")
[ -n "$sensitive" ] && reasons+=("sensible")

if [ ${#reasons[@]} -gt 0 ]; then
  echo "VERDICT: RUN (${reasons[*]})"
else
  echo "VERDICT: SKIP"
fi

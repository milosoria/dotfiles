#!/usr/bin/env bash
# Sube imágenes a la rama huérfana `pr-assets` del repo (vía API de GitHub, sin tocar el working tree)
# e imprime el markdown para pegar en la descripción o un comentario del PR.
# Uso: pr-assets.sh <owner/repo> <prefijo> <archivo>...   ej: pr-assets.sh MacalMaia/macal-maia-front mi-slug/02 antes.png despues.png
set -euo pipefail

repo="${1:?owner/repo}"; prefix="${2:?prefijo}"; shift 2
[ $# -gt 0 ] || { echo "ERROR: sin archivos" >&2; exit 1; }
branch=pr-assets
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT

# Crear la rama huérfana la primera vez.
if ! gh api "repos/$repo/branches/$branch" >/dev/null 2>&1; then
  blob=$(gh api "repos/$repo/git/blobs" -f content="Assets de PRs (screenshots). No mergear." -f encoding=utf-8 --jq .sha)
  tree=$(gh api "repos/$repo/git/trees" -f "tree[][path]=README.md" -f "tree[][mode]=100644" -f "tree[][type]=blob" -f "tree[][sha]=$blob" --jq .sha)
  commit=$(gh api "repos/$repo/git/commits" -f message="init pr-assets" -f tree="$tree" --jq .sha)
  gh api "repos/$repo/git/refs" -f ref="refs/heads/$branch" -f sha="$commit" >/dev/null
fi

for f in "$@"; do
  path="$prefix/$(basename "$f")"
  sha=$(gh api "repos/$repo/contents/$path?ref=$branch" --jq .sha 2>/dev/null || true)
  base64 < "$f" | tr -d '\n' > "$tmp/b64"
  jq -n --rawfile c "$tmp/b64" --arg m "assets: $path" --arg b "$branch" --arg s "$sha" \
    '{message:$m, content:$c, branch:$b} + (if $s == "" then {} else {sha:$s} end)' > "$tmp/body.json"
  gh api -X PUT "repos/$repo/contents/$path" --input "$tmp/body.json" >/dev/null
  echo "![$(basename "${f%.*}")](https://github.com/$repo/blob/$branch/$path?raw=true)"
done

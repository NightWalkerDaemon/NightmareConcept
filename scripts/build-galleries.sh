#!/usr/bin/env bash
# Ensure every gallery folder under the given content dir is a Hugo section.
# For each subdirectory WITHOUT an index file, write a temporary _index.md
# with a humanised title and an ordering weight derived from a leading "NN-".
# Folders that already have _index.md / index.md (Holly's overrides) are left alone.
set -euo pipefail

ROOT="${1:-content}"

find "$ROOT" -mindepth 1 -type d | while read -r dir; do
  if [ -f "$dir/_index.md" ] || [ -f "$dir/index.md" ]; then
    continue
  fi

  base="$(basename "$dir")"

  weight=999
  if [[ "$base" =~ ^0*([0-9]+)[-_] ]]; then
    weight="${BASH_REMATCH[1]}"
  fi

  title="$(printf '%s' "$base" \
    | sed -E 's/^[0-9]+[-_]?//; s/[-_]+/ /g' \
    | awk '{for(i=1;i<=NF;i++){$i=toupper(substr($i,1,1)) tolower(substr($i,2))}}1')"

  cat > "$dir/_index.md" <<EOF
---
title: "$title"
weight: $weight
---
EOF
done

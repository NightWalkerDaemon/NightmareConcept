#!/usr/bin/env bash
# Local preview: copy content to a throwaway dir, generate gallery sections
# there (so source stays pristine), and run the Hugo dev server against it.
set -euo pipefail

BUILD=".gallerybuild"
rm -rf "$BUILD"
mkdir -p "$BUILD"
cp -R content "$BUILD/content"
bash scripts/build-galleries.sh "$BUILD/content"
exec hugo server --contentDir "$BUILD/content" --disableFastRender "$@"

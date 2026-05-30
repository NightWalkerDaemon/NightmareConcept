#!/usr/bin/env bash
# Generate neutral grey placeholder JPEGs (NOT artwork) so the demo builds.
set -euo pipefail
MAGICK="magick"; command -v magick >/dev/null 2>&1 || MAGICK="convert"

# Resolve a font — try common paths so this works on macOS and Linux CI.
FONT=""
for candidate in \
  /System/Library/Fonts/SFNSMono.ttf \
  /System/Library/Fonts/Monaco.ttf \
  /usr/share/fonts/truetype/liberation/LiberationMono-Regular.ttf \
  /usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf \
  /usr/share/fonts/dejavu/DejaVuSansMono.ttf; do
  if [ -f "$candidate" ]; then FONT="$candidate"; break; fi
done

make() { # path label
  local font_args=()
  [ -n "$FONT" ] && font_args=(-font "$FONT")
  "$MAGICK" -size 1600x1100 canvas:'#202028' \
    -gravity center -pointsize 64 -fill '#6a6a72' \
    "${font_args[@]}" \
    -annotate 0 "$2" "$1"
}

mkdir -p content/01-creatures content/02-environments content/02-environments/ruins
make content/01-creatures/01-the-hollow.jpg "PLACEHOLDER\nThe Hollow"
make content/01-creatures/02-swamp-king.jpg "PLACEHOLDER\nSwamp King"
make content/02-environments/01-frostfen.jpg "PLACEHOLDER\nFrostfen"
make content/02-environments/ruins/01-broken-spire.jpg "PLACEHOLDER\nBroken Spire"

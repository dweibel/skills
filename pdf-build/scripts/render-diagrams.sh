#!/bin/bash
# Render all .mmd files in a directory to PNG
set -e

DIAGRAM_DIR="${1:-diagrams}"

if [ ! -d "$DIAGRAM_DIR" ]; then
  echo "Error: Directory '$DIAGRAM_DIR' not found."
  exit 1
fi

count=0
for f in "$DIAGRAM_DIR"/*.mmd; do
  [ -e "$f" ] || continue
  out="${f%.mmd}.png"
  echo "Rendering $f -> $out"
  npx --yes @mermaid-js/mermaid-cli -i "$f" -o "$out" -b white -w 1800 2>/dev/null
  count=$((count + 1))
done

if [ "$count" -eq 0 ]; then
  echo "No .mmd files found in '$DIAGRAM_DIR'."
  exit 0
fi

echo ""
echo "All diagrams rendered ($count files)."
ls -lh "$DIAGRAM_DIR"/*.png

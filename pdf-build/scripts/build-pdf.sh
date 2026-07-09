#!/bin/bash
# Build a PDF from a markdown project directory or a single markdown file.
# Usage:
#   build-pdf.sh <project-directory>   — concatenates all *.md files alphabetically, outputs <dir-name>.pdf
#   build-pdf.sh <file.md>             — builds a single file, outputs <basename>.pdf

set -e

# Resolve the directory where this script lives (for locating filter and header)
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# Ensure TinyTeX is on PATH
export PATH="$HOME/.TinyTeX/bin/x86_64-linux:$PATH"

# --- Argument parsing ---
if [ $# -eq 0 ]; then
  echo "Usage: build-pdf.sh <project-directory | markdown-file.md>"
  echo ""
  echo "  Directory mode: concatenates all *.md files alphabetically → <dir-name>.pdf"
  echo "  File mode:      builds a single markdown file → <basename>.pdf"
  exit 1
fi

INPUT="$1"

if [ -d "$INPUT" ]; then
  # --- Directory mode ---
  PROJECT_DIR="${INPUT%/}"
  DIR_NAME="$(basename "$PROJECT_DIR")"

  MD_FILES=($(find "$PROJECT_DIR" -maxdepth 1 -name '*.md' | sort))

  if [ ${#MD_FILES[@]} -eq 0 ]; then
    echo "Error: No .md files found in '$PROJECT_DIR'"
    exit 1
  fi

  OUTPUT="$PROJECT_DIR/$DIR_NAME.pdf"

  echo "Building PDF (directory mode): $OUTPUT"
  echo "Input files:"
  for f in "${MD_FILES[@]}"; do echo "  - $f"; done

  pandoc "${MD_FILES[@]}" \
    -o "$OUTPUT" \
    --pdf-engine=xelatex \
    --lua-filter="$SCRIPT_DIR/mermaid-filter.lua" \
    -H "$SCRIPT_DIR/pdf-header.tex" \
    --toc \
    --toc-depth=2 \
    --highlight-style=tango \
    -V mainfont="DejaVu Sans" \
    -V monofont="DejaVu Sans Mono" \
    -V geometry:margin=1in \
    -V linkcolor=blue \
    -V urlcolor=blue \
    -V toccolor=black \
    -V date="$(date +%Y-%m-%d)"

elif [ -f "$INPUT" ]; then
  # --- Single-file mode ---
  FILE_DIR="$(dirname "$INPUT")"
  BASENAME="$(basename "$INPUT" .md)"
  OUTPUT="$FILE_DIR/$BASENAME.pdf"

  echo "Building PDF (single-file mode): $OUTPUT"
  echo "Input file: $INPUT"

  pandoc "$INPUT" \
    -o "$OUTPUT" \
    --pdf-engine=xelatex \
    --lua-filter="$SCRIPT_DIR/mermaid-filter.lua" \
    -H "$SCRIPT_DIR/pdf-header.tex" \
    --toc \
    --toc-depth=2 \
    --highlight-style=tango \
    -V mainfont="DejaVu Sans" \
    -V monofont="DejaVu Sans Mono" \
    -V geometry:margin=1in \
    -V linkcolor=blue \
    -V urlcolor=blue \
    -V toccolor=black \
    -V date="$(date +%Y-%m-%d)"

else
  echo "Error: '$INPUT' is not a valid directory or file."
  exit 1
fi

echo "Done! Output: $OUTPUT"
ls -lh "$OUTPUT"

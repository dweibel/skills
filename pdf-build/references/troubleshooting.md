# Troubleshooting

Common failure scenarios when building PDFs with this pipeline.

## Missing fonts

**Symptom:** XeLaTeX error mentioning a font not found (e.g., "DejaVu Sans").

**Resolution:**
```bash
apt list --installed 2>/dev/null | grep dejavu
```
If DejaVu fonts are not installed:
```bash
sudo apt install fonts-dejavu
```

## Missing LaTeX packages

**Symptom:** XeLaTeX error like `! LaTeX Error: File '<package>.sty' not found.`

**Resolution:**
```bash
export PATH="$HOME/.TinyTeX/bin/x86_64-linux:$PATH"
tlmgr install <package>
```

Common packages needed by this pipeline:
- `fvextra` — code block line wrapping
- `float` — figure placement control
- `etoolbox` — table font reduction
- `newunicodechar` — Unicode character mapping

Install all at once:
```bash
tlmgr install fvextra float etoolbox newunicodechar
```

## Mermaid CLI unavailability

**Symptom:** Mermaid code blocks appear as raw text in the PDF instead of rendered diagrams.

**Resolution:** Mermaid rendering requires Node.js and npx. Verify:
```bash
node --version
npx --version
```

If unavailable, install Node.js via nvm or apt. The filter invokes mmdc via `npx --yes @mermaid-js/mermaid-cli`, so no global install is needed — just a working Node.js runtime.

## Unicode rendering issues

**Symptom:** Characters appear as blank boxes or cause XeLaTeX errors.

**Resolution:** Ensure DejaVu Sans and DejaVu Sans Mono fonts are installed. These fonts cover most Unicode code points needed for technical writing (box-drawing, arrows, mathematical symbols).

```bash
fc-list | grep -i "dejavu"
```

If missing:
```bash
sudo apt install fonts-dejavu
```

## Emoji substitution

**Symptom:** Emoji characters (✅, 🔴, ❌, ⚠️) render as blank or cause errors. DejaVu fonts do not include color emoji glyphs.

**Resolution:** Replace emojis in source markdown with DejaVu-supported Unicode equivalents before building:

| Emoji | Replacement | Unicode |
|-------|-------------|---------|
| ✅    | ✔           | U+2714  |
| 🔴    | ●           | U+25CF  |
| ❌    | ✘           | U+2718  |
| ⚠️    | ⚠           | U+26A0  |

Use sed to batch-replace:
```bash
sed -i 's/✅/✔/g; s/🔴/●/g; s/❌/✘/g' path/to/file.md
```

For the variation selector (️ U+FE0F after ⚠), the `pdf-header.tex` already maps it to empty via `newunicodechar`.

## TinyTeX installation

If TinyTeX is not installed:
```bash
wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh
```

Default install location: `$HOME/.TinyTeX/bin/x86_64-linux`

## PyMuPDF installation

The QA script (`detect-overlaps.py`) requires PyMuPDF:
```bash
pip install PyMuPDF
```

This provides the `fitz` module for PDF inspection.

# Troubleshooting

Common failure scenarios when building PDFs with this pipeline.

## Missing fonts

**Symptom:** `! Package fontspec Error: The font "DejaVu Sans Mono" cannot be found`, or the same for "DejaVu Sans".

**Linux:**
```bash
fc-list | grep -i dejavu          # what is installed
sudo apt install fonts-dejavu     # if nothing
```

**macOS:** XeTeX resolves font names through the system font registry (CoreText), not through TeX's own font tree. A DejaVu font that `tlmgr install dejavu` put under `texmf-dist` is invisible to `\setmainfont{DejaVu Sans}` until the same file is in `~/Library/Fonts`. Two ways to get it there:

```bash
brew install --cask font-dejavu                      # whole family, if SourceForge serves the download
# or, after `tlmgr install dejavu`, copy the family out of TinyTeX:
cp -n ~/Library/TinyTeX/texmf-dist/fonts/truetype/public/dejavu/DejaVu*.ttf ~/Library/Fonts/
```

The `font-dejavu-sans` cask installs only DejaVu Sans, which leaves the pipeline's `monofont` unsatisfied. Check with:
```bash
system_profiler SPFontsDataType | grep -i "DejaVu Sans Mono"
```

A build started within a few seconds of copying fonts can still fail; the registry refreshes asynchronously. Build again.

## Missing LaTeX packages

**Symptom:** XeLaTeX error like `! LaTeX Error: File '<package>.sty' not found.`

**Resolution:** put TinyTeX's `bin` directory on PATH (Linux: `~/.TinyTeX/bin/x86_64-linux`; macOS: `~/Library/TinyTeX/bin/universal-darwin`), then:
```bash
tlmgr install <package>
```

Packages this pipeline adds on top of pandoc's template:
- `fvextra` — code block line wrapping
- `float` — figure placement control
- `etoolbox` — table font reduction
- `newunicodechar` — Unicode character mapping

Pandoc 3.x's default LaTeX template itself needs `framed`, `footnotehyper`, `bookmark`, `xcolor`, `geometry`, `ulem`, `unicode-math`, `setspace`, `fancyvrb`, `listings`, `titling`, `lm`, `amsmath`, `parskip`, `microtype`, `caption`, `xurl`, `selnolig`, `upquote`, `lineno`, `tex-gyre`, and `booktabs`. A fresh TinyTeX has only some of these, and each missing one surfaces as a separate `.sty not found` failure. Install the full set once:
```bash
tlmgr install fvextra float etoolbox newunicodechar framed footnotehyper bookmark xcolor \
  geometry ulem unicode-math setspace fancyvrb listings titling lm amsmath parskip \
  microtype caption xurl selnolig upquote lineno tex-gyre booktabs dejavu
```

## tlmgr cannot download

**Symptom:** every `tlmgr install` fails with `TLPDB::from_file could not get texlive.tlpdb from: https://tlnet.yihui.org/...`, or the TinyTeX installer itself fails with `curl: (22) The requested URL returned error: 403`.

**Cause:** TinyTeX defaults to a package mirror on the same host as its installer, and that host refuses some networks and non-browser clients outright. Nothing is wrong with the local install.

**Resolution:** point tlmgr at the CTAN mirror network, which redirects to a nearby mirror:
```bash
tlmgr option repository https://mirror.ctan.org/systems/texlive/tlnet
tlmgr install <packages>
```
The setting persists. For the installer itself, see "TinyTeX installation" below.

## Mermaid CLI unavailability

**Symptom:** Mermaid code blocks appear as raw text in the PDF instead of rendered diagrams.

**Resolution:** Mermaid rendering requires Node.js and npx. Verify:
```bash
node --version
npx --version
```

If unavailable, install Node.js via nvm or apt. The filter invokes mmdc via `npx --yes @mermaid-js/mermaid-cli`, so no global install is needed, only a working Node.js runtime.

With nvm, `node` is on PATH only in shells that have sourced nvm. A build run from a non-interactive shell (an agent, cron, a script) may have xelatex but not node; the diagram then falls through as raw text with no error from pandoc. Either source nvm first or prepend the active Node version's `bin` directory (for example `~/.nvm/versions/node/v24.21.0/bin`) to PATH.

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
curl -fsSL https://yihui.org/tinytex/install-bin-unix.sh | sh
```

If that returns HTTP 403, the same installer is in the project's GitHub repository:
```bash
curl -fsSL https://raw.githubusercontent.com/rstudio/tinytex/main/tools/install-bin-unix.sh | sh
```

Default install locations:

| Platform | TinyTeX root | `bin` directory to put on PATH |
|---|---|---|
| Linux | `~/.TinyTeX` | `~/.TinyTeX/bin/x86_64-linux` |
| macOS | `~/Library/TinyTeX` | `~/Library/TinyTeX/bin/universal-darwin` |

On macOS the installer's last step asks for sudo to symlink binaries into `/usr/local/bin`. Without a terminal it fails, harmlessly: add the `bin` directory to PATH in the shell profile instead. The build script finds either default location on its own.

## PyMuPDF installation

The QA script (`detect-overlaps.py`) requires PyMuPDF:
```bash
python3 -m venv ~/.venvs/pdf-qa && ~/.venvs/pdf-qa/bin/pip install PyMuPDF
~/.venvs/pdf-qa/bin/python scripts/detect-overlaps.py output.pdf
```

Homebrew's Python refuses `pip install` outside a virtual environment, so use one. The script imports the module under its old name `fitz`, which PyMuPDF still provides with a deprecation warning.

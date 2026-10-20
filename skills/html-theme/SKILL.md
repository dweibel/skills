---
name: html-theme
description: "Light-first HTML theming and diagram delivery. Use when generating, styling, or restyling any standalone HTML — reports, analysis sites, dashboards, one-pagers, Mermaid-diagram documents — or when asked to fix a page that is too dark, add a dark/light mode, make diagrams match the page theme, or provide downloadable / high-resolution / full-size versions of diagrams. Provides the CSS variable pattern, the no-flash pre-paint script, the toggle button, matching Mermaid themeVariables, and the SVG+PNG diagram export pipeline with download links."
---

# html-theme

Light is the default for **everyone**, regardless of their OS setting. Dark is opt-in via a toggle that persists. Diagrams always match the page — and every diagram is downloadable at high resolution.

Two concerns live here together because they are coupled: the export settings are *derived from* the theme settings, and separating them causes silent drift (change the palette, and exports quietly stop matching the pages).

## The four required pieces

Apply all four. Skipping any one produces a specific, visible bug — noted below each.

### 1 · Theme variables — light in `:root`, dark under an attribute selector

```css
:root {
  --bg:#f5f7fa; --bg-tint:#eef2f7; --panel:#ffffff; --panel-2:#f8fafc;
  --border:#e2e8f0; --border-strong:#cbd5e1;
  --text:#17212f; --text-2:#3d4b5c; --muted:#64748b;
  --link:#1d4ed8; --accent:#1d4ed8;
  --ok:#0f9d6e; --warn:#b45309; --danger:#dc2626;
  --shadow-sm:0 1px 2px rgba(16,32,56,.06), 0 1px 3px rgba(16,32,56,.04);
}

/* Dark is OPT-IN only, set by the toggle. */
[data-theme="dark"] {
  --bg:#1b2230; --bg-tint:#202939; --panel:#232c3d; --panel-2:#1e2634;
  --border:#334054; --border-strong:#3f4d63;
  --text:#eaeff6; --text-2:#c6d1de; --muted:#97a5b6;
  --link:#93b8ff; --accent:#7aa5ff;
  --ok:#4ecfa2; --warn:#f0b464; --danger:#ff8095;
  --shadow-sm:0 1px 2px rgba(0,0,0,.24);
}

body { background:var(--bg); color:var(--text); }
```

**Never use `@media (prefers-color-scheme: dark)`.** That is what makes a page snap to dark on a dark-mode machine — the exact thing this pattern exists to prevent. Use a *soft* dark (`#1b2230`-ish), never near-black.

### 2 · Pre-paint script — the first thing inside `<head>`

```html
<head>
<script>(function(){try{if(localStorage.getItem('ui-theme')==='dark')document.documentElement.dataset.theme='dark';}catch(e){}})();</script>
<meta charset="UTF-8">
<link rel="stylesheet" href="assets/styles.css">
```

Must come **before** the stylesheet link. Placed later, dark-mode users get a white flash on every page load. The `try/catch` matters: `localStorage` throws in sandboxed iframes and some privacy modes.

### 3 · Toggle button — in the header/topbar of every page

```html
<button class="theme-toggle" type="button" onclick="(function(){var h=document.documentElement,d=h.dataset.theme==='dark';try{localStorage.setItem('ui-theme',d?'light':'dark');}catch(e){}location.reload();})()"><span class="ico">&#9683;</span> Theme</button>
```

```css
.theme-toggle {
  display:inline-flex; align-items:center; gap:.4rem; margin-left:auto;
  background:var(--panel); color:var(--text-2); border:1px solid var(--border);
  border-radius:999px; padding:.34rem .7rem; font:inherit; font-size:.78rem;
  font-weight:600; cursor:pointer; line-height:1; box-shadow:var(--shadow-sm);
}
.theme-toggle:hover { border-color:var(--border-strong); color:var(--text); }
```

**Reload, don't live-swap.** Flipping the attribute in place looks smoother but leaves any already-rendered Mermaid diagram on the old palette. One reload keeps page and diagrams in sync.

### 4 · Mermaid — inline init, reading the same flag

```html
<script type="module">
import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs';
const dark = document.documentElement.dataset.theme === 'dark';
mermaid.initialize({
  startOnLoad:true, theme:'base', securityLevel:'loose',
  fontFamily:'system-ui, -apple-system, "Segoe UI", Roboto, Helvetica, Arial, sans-serif',
  flowchart:{ curve:'basis', padding:14, useMaxWidth:true },
  sequence:{ useMaxWidth:true, boxMargin:8, mirrorActors:false },
  themeVariables: dark
    ? { background:'#232c3d', primaryColor:'#1b2b47', primaryTextColor:'#eaeff6',
        primaryBorderColor:'#7aa5ff', lineColor:'#97a5b6', textColor:'#eaeff6',
        mainBkg:'#1b2b47', nodeBorder:'#7aa5ff', clusterBkg:'#1e2634',
        clusterBorder:'#3f4d63', edgeLabelBackground:'#232c3d',
        actorBkg:'#1b2b47', actorBorder:'#7aa5ff', actorTextColor:'#eaeff6',
        actorLineColor:'#74839a', signalColor:'#c6d1de', signalTextColor:'#eaeff6',
        labelBoxBkgColor:'#1e2634', labelBoxBorderColor:'#3f4d63',
        labelTextColor:'#eaeff6', loopTextColor:'#c6d1de',
        noteBkgColor:'#37291a', noteBorderColor:'#f0b464', noteTextColor:'#eaeff6' }
    : { background:'#ffffff', primaryColor:'#eaf1fe', primaryTextColor:'#17212f',
        primaryBorderColor:'#2563eb', lineColor:'#64748b', textColor:'#17212f',
        mainBkg:'#eaf1fe', nodeBorder:'#2563eb', clusterBkg:'#f8fafc',
        clusterBorder:'#cbd5e1', edgeLabelBackground:'#ffffff',
        actorBkg:'#eaf1fe', actorBorder:'#2563eb', actorTextColor:'#17212f',
        actorLineColor:'#94a3b8', signalColor:'#3d4b5c', signalTextColor:'#17212f',
        labelBoxBkgColor:'#f8fafc', labelBoxBorderColor:'#cbd5e1',
        labelTextColor:'#17212f', loopTextColor:'#3d4b5c',
        noteBkgColor:'#fdf3e7', noteBorderColor:'#b45309', noteTextColor:'#17212f' }
});
</script>
```

**Keep this inline in every page. Do not extract it to an external `.js` module** — `<script type="module" src="...">` is CORS-blocked when the file is opened via `file://`, so diagrams silently fail to render for anyone who double-clicks the HTML. An inline module importing from an `https://` CDN works fine over `file://`.

For node fills inside diagrams, use **light tints with dark text** in `classDef` (e.g. `fill:#e9f8f2,stroke:#0f9d6e,color:#0b3d2c`). These stay legible in both schemes, so one set of `classDef`s covers both themes.

## Diagram delivery — high-res exports + download links

When a page carries diagrams, ship each one as a **downloadable file** as well as an inline render. Two formats, because they serve different needs:

- **SVG** — vector, opens in any browser, scales infinitely. The primary artifact.
- **PNG** — high-resolution raster (target ~2400 px wide) for pasting into slides and documents.

### Link markup under every diagram

```html
</pre>
<div class="dl">
  <a href="../assets/diagrams/SLUG.svg" target="_blank" rel="noopener"
     title="Vector, scales to any size">&#10530; Open full size (SVG)</a>
  <a href="../assets/diagrams/SLUG.png" download
     title="High-resolution bitmap for slides and docs">&#8595; Download PNG</a>
</div>
<figcaption>…</figcaption>
```

```css
.dl { display:flex; gap:.5rem; justify-content:center; flex-wrap:wrap; margin:-.6rem 0 .2rem; }
.dl a {
  display:inline-flex; align-items:center; gap:.35rem; font-size:.76rem; font-weight:600;
  color:var(--muted); background:var(--panel-2); border:1px solid var(--border);
  border-radius:999px; padding:.28rem .7rem; text-decoration:none;
}
.dl a:hover { color:var(--accent); border-color:var(--accent); background:var(--bg-tint); }
```

Name files by **meaning, not position** — `two-outbound-rails.svg`, not `page3-diagram2.svg`. Keep a manifest mapping page → ordered list of slugs, so exports and pages stay in sync when diagrams are added or reordered.

### Export procedure

Render diagrams with real Mermaid rather than screenshotting, so exports are pixel-exact to the pages.

1. Start a small local server rooted at the site that also accepts uploads — serve files on `GET`, and write the body to `assets/diagrams/<name>` on `POST /__save?name=…` (decode base64 for `.png`). **Serving over `http://` matters**: a preview pane that renders local files as `data:` snapshots cannot load relative CSS, so the page looks broken when it is fine.
2. Serve a generator page that, for each page in the manifest: fetches the HTML, extracts each `<pre class="mermaid">` block, unescapes entities, calls `mermaid.render()`, and `POST`s the result back. **This keeps image bytes out of the conversation entirely** — never read exported images back as text.
3. From the rendered SVG, read intrinsic size from `width`/`height` or `viewBox`, set both attributes explicitly, and clear `style.maxWidth` before serialising — otherwise the raster comes out wrong-sized.
4. Rasterise to PNG via an offscreen canvas: fill white first, scale by `min(3, max(2, 2400 / width))`, then `toDataURL('image/png')`.
5. Verify: check every PNG's actual pixel dimensions and file size, and open one to confirm labels rendered.

### Three settings the export needs that the page does not

These are deliberate divergences. Change one without the others and the exports break:

| Setting | On-page | Export | Why |
|---|---|---|---|
| Palette | follows the toggle | **always light** | A dark PNG pasted into a slide or doc looks broken |
| `htmlLabels` | default (`true`) | **`false`** | Canvas cannot rasterise `foreignObject`; with `true` the raster silently hangs |
| `<small>` in labels | rendered as HTML | **stripped from source** | With `htmlLabels:false` the tags render as literal text in the image |

Keep `<br/>` — Mermaid honours it as a line break in SVG text labels. Put a **timeout (~10 s) on the rasterise step** and continue on failure, saving SVG-only rather than hanging the whole run.

### Environment caveat — state it, don't skip silently

PNG rasterisation needs a headless browser (e.g. `--headless --disable-gpu`). If none is available, SVG export via `mermaid.render()` still works; PNG does not. **Report the limitation explicitly** rather than omitting the exports — a silently incomplete deliverable is worse than a stated gap.

## Rules

- **One `localStorage` key across the whole site** (`ui-theme`) so the choice persists across navigation.
- **The toggle goes on every page**, not just the index — otherwise users get stranded in a theme they can't change.
- If the site has a sidebar, the toggle also works well pinned at the bottom of it: `.sidebar .theme-toggle { margin:1.4rem 0 0; width:100%; justify-content:center; }`

## Verifying it

Two failure modes are invisible unless you check for them specifically:

1. **Open the page and confirm it is light** even on a dark-mode machine. If it comes up dark, a `prefers-color-scheme` media query survived somewhere.
2. **Toggle to dark, then navigate to another page.** It should stay dark with no white flash. A flash means the pre-paint script is after the stylesheet; reverting to light means a page is missing the script or uses a different key.

When validating over a local server, note that a preview pane serving files as `data:` snapshots cannot load relative CSS — use `python3 -m http.server` and a real `http://` URL, or the styling will appear broken when it is fine.

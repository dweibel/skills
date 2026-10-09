# Publishing to Confluence

Confluence is where most of this writing is read. The source of truth stays in Markdown; the page is a rendering of it. This file covers what survives the trip and what does not.

The one thing that does not survive on its own is a diagram. Confluence Cloud has **no Mermaid renderer**. A fenced ` ```mermaid ` block arrives as `<pre><code class="language-mermaid">`, and the reader sees the diagram's source code where the diagram should be. Everything below follows from that.

## The house pattern: image plus collapsed source

Publish a rendered image, and keep the Mermaid source beneath it in a collapsed block. The FIASI appendix states the convention in one line: *"each page shows a high-resolution image plus the Mermaid source in a collapsible block."* HLD 01 follows it, and so should anything published beside it.

The image is what readers see. The collapsed source is what the next author edits, so the diagram can be regenerated without hunting for the file that made it.

In the HTML body:

```html
<figure data-type="media-single" data-layout="center" data-width="820" data-width-type="pixel">
  <div data-type="media" data-media-type="file"
       data-id="MEDIA_ID" data-collection="contentId-PAGE_ID"
       data-width="4482" data-height="1311"></div>
</figure>
<details>
  <summary>Mermaid source</summary>
  <pre><code class="language-mermaid">flowchart LR
    A["First step"] --&gt; B["Second step"]</code></pre>
</details>
```

Four things in that block are not guesses and must be copied from real values:

- `data-id` is the attachment's media ID, which exists only after the image is uploaded. Never invent one.
- `data-collection` is `contentId-` followed by the page ID.
- `data-width` and `data-height` on the media div are the image's true pixel dimensions. `sips -g pixelWidth -g pixelHeight file.png` reads them.
- `data-width="820"` on the figure is the display width in the page column, independent of the image's pixel size. 820 is what the FIASI pages use.

Inside the `<pre><code>`, the Mermaid source is HTML-escaped: `--&gt;` for `-->`, `&amp;` for `&`, `&quot;` for a quote inside a node label. Unescaped, the arrows end the tag and the block collapses into nonsense.

## Uploading the image

The Atlassian MCP tools **cannot upload an attachment**. They read and write page bodies and comments; the attachment API is not among them. So the upload is a separate step, by one of three routes:

1. **The person publishing does it in the browser.** Drag the PNG onto the page, then read the `data-id` back out of the page's HTML with `getConfluencePage` and write the final body. This needs no credential and is the usual path.
2. **`curl` against the REST API**, if an API token is available in the environment:
   ```bash
   curl -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
     -X PUT -H "X-Atlassian-Token: nocheck" \
     -F "file=@diagram.png" -F "minorEdit=true" \
     "https://SITE.atlassian.net/wiki/rest/api/content/PAGE_ID/child/attachment"
   ```
   The `X-Atlassian-Token: nocheck` header is required; without it the request is rejected as cross-site. `PUT` on an existing filename replaces it and keeps the media ID, which is what you want when regenerating a diagram.
3. **A public image URL**, if one genuinely exists. Prefer an attachment: a page that depends on an outside host breaks when that host does.

Never write a `data-id` you have not read back from the page or from an upload response. A fabricated ID renders as a broken-image placeholder, which looks exactly like a diagram that failed to load, so it is easy to ship without noticing.

## Rendering the image

`mmdc` (the Mermaid CLI) turns the source into the PNG:

```bash
mmdc -i diagram.mmd -o diagram.png -c config.json -p puppeteer.json -b white -s 3 -w 1600
```

- `-s 3` renders at 3x for a legible image on a high-density screen. `-b white` matters because Confluence's page background is white and a transparent PNG inverts badly for anyone in dark mode.
- `config.json` with `{"theme": "neutral", "flowchart": {"useMaxWidth": false, "htmlLabels": true}}` matches the look of the existing FIASI diagrams.

**On a managed macOS host, `mmdc` fails to launch its browser.** The error is `Failed to launch the browser process: Code: null`, and running Puppeteer's downloaded Chrome by hand exits `137`, which is SIGKILL: endpoint protection (ThreatLocker, on CCM-managed machines) kills the unapproved binary. The system Chrome is approved and runs normally, so point Puppeteer at it:

```json
{
  "executablePath": "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
  "headless": "new",
  "args": ["--no-sandbox", "--disable-gpu"]
}
```

A `137` exit from any Puppeteer-launched binary means the same thing. It is not a broken install, and reinstalling the CLI does not fix it.

## Check the diagram before publishing it

Open the PNG and look at it. Mermaid will silently produce a diagram that is technically correct and unreadable: labels wrapped mid-word, a branch leaving the visible area, two nodes overlapping. The source gives no warning, and the Confluence page is where the problem is noticed if you skip this.

What to look for:

- Every label fully inside its node, with no mid-word break.
- Edge labels not sitting on top of an edge or a node.
- A sensible aspect ratio. A flowchart wider than about 5:1 is unreadable in an 820px column; split it or set `flowchart TD` instead of `LR`.
- Node text matching the prose around it. A diagram that uses different words for the same thing reads as a second, disagreeing account.

## What else changes in the trip from Markdown

- **Tables.** GitHub-flavored pipe tables convert cleanly. Use `<br>` for a line break inside a cell; a literal newline breaks the row.
- **Headings.** The page title is the H1. Start the body at H2, or the rendered page carries two competing titles.
- **Code blocks.** A fenced block with a language becomes `<pre><code class="language-x">`, which Confluence renders with highlighting. This is correct for code and wrong only for Mermaid.
- **Links.** Inline Markdown links convert to anchors. A link to another Confluence page may be written as the full URL; Confluence resolves it to the page's current title on render, so a renamed page does not leave a stale label.
- **Anchors.** Markdown heading anchors do not survive. A cross-reference like `[see above](#section)` arrives as a dead link. Name the section in prose instead: *"under Scope"*.

## Keeping the file and the page the same text

When a document lives in both a repository and Confluence, say so in the file's front matter, carrying the page ID, and state that a change to either belongs in both. Without that line the two drift, and the reader has no way to tell which is current.

Re-read the published page after publishing. The round trip is where an escaped entity, a dropped table row, or an unrendered diagram shows itself, and reading the source you just sent will not reveal any of them.

---
name: technical-writing
description: >
  Write clear, well-structured technical prose — essays, design docs, memos, RFCs,
  blog posts, and emails. Use when the user asks to write, draft, revise, or edit
  any technical document. Also use when they mention writing style, voice, tone,
  sentence structure, or ask for feedback on prose quality. Covers outlining,
  drafting with deliberate sentence rhythm, revision against a strict checklist,
  and format-specific conventions (essays, memos, emails, blog posts, Slack).
---

# Technical Writing

Write technical prose that a busy senior engineer reads to the end without skimming, and a smart junior engineer follows without giving up. The prose should feel human-written, not machine-generated.

## Workflow

Every writing project moves through four phases. Follow in order.

### 1. Outlining

- Define the document's purpose, audience, and scope.
- Propose a section structure as a numbered list before writing.
- Each section gets a heading and a one-sentence summary of what it resolves.

### 2. Drafting

- Apply the voice rules in this file.
- Load format-specific guidance from `references/` based on document type:
  - **Long-form essays, design docs, deep-dives:** read `references/structure.md`
  - **Memos, RFCs, emails, blog posts:** read `references/formats.md`
  - **Design docs:** read both (structure for exposition, formats for framing)
- For a condensed view, consult `assets/quick-reference-<format>.md`.
- Keep sections focused. Split anything beyond ~1,500 words.

### 3. Revising

- Run the draft against the revision checklist in `references/revision-checklist.md`.
- Check for consistency: terminology, tense, heading levels, cross-references.
- For deeper pattern review, consult `references/hazards.md`.

### 4. Delivery

- Match the output to the requested format (markdown, email body, memo, etc.).
- Verify every sentence passes the read

### Sentence Rhythm

Vary sentence length deliberately. A run of short declaratives feels staccato; use very sparingly and only for effect. A run of long sentences loses the reader. Mix.

A shape that works: a short claim, then a longer sentence that develops the claim, then a short reset.

Avoid sentences exceeding ~35 words without a structural reason. Force the variance: a four-word sentence next to a thirty-word sentence is normal. A paragraph where every sentence sits between fifteen and twenty-two words is suspect.

### Active Voice

Use active voice as the default. Passive diffuses responsibility and obscures the actor. The passive is appropriate only when the actor is genuinely unknown, irrelevant, or when sentence flow demands it.

### Word Choice

- Plain verbs: use over utilize, start over commence, show over demonstrate, help over facilitate.
- Cut throat-clearing phrases on sight: "It is important to note that," "In order to" (use "to"), "At the end of the day."
- No corporate flab: leverage, synergy, robust, world-class, bandwidth (meaning attention).
- No academic bloat: the aforementioned, hereinafter, as such.
- Use technical terms precisely. Define them the first time; do not paraphrase a precise term into a vaguer one.

### Banned Vocabulary (Zero Tolerance)

These words mark prose as machine-generated. None should appear in output:

**Thematic metaphors:** delve, tapestry, mosaic, weave, threads (figurative), navigate, landscape, journey, compass, beacon, unlock, unleash, harness (figurative), realm

**Empty intensifiers:** crucial, paramount, imperative, vital, profound, transformative, revolutionary, testament, cornerstone, bedrock, robust, cutting-edge, state-of-the-art

**Mechanical transitions:** furthermore, moreover, additionally, consequently, conversely, that being said

**Summary fillers:** in conclusion, to summarize, ultimately, at the end of the day, in essence

Use plain connectors instead: and, but, so, also, or no transition at all.

### No Feigning Surprise

Never imply the reader should already know something. Ban: "Obviously," "As everyone knows," "Trivially," "Simply" (describing something not simple), "Of course" (introducing non-obvious facts).

### Em Dashes

Never use em dashes. Replace with commas, parentheses, or separate sentences.

### Hedging

Hedge when the claim genuinely warrants it. Do not hedge as decoration. If a claim is too uncertain to state, it is not yet worth making.

## Format-Aware Weighting

| Format | Approach |
|--------|----------|
| Long-form essays, design docs, deep-dive posts | Architectural composure. Patterns named. Trade-offs surfaced. Authority in the structure of the argument. |
| Technical memos, RFCs, decision documents | Organizational clarity. Lead with the recommendation. Options weighed explicitly. Action items owned and dated. |
| Blog posts, emails, Slack, short-form | Pedagogical curiosity. Curiosity up, composure dialed back. First person welcomed. |

## Reference Files

Read these on demand based on the task:

- `references/structure.md` — Document-level structure: openings, sections, closings, dialectical exposition, pedagogy
- `references/formats.md` — Format-specific conventions: memos, RFCs, blog posts, emails, Slack
- `references/hazards.md` — Failure patterns with before/after examples
- `references/revision-checklist.md` — Line-by-line revision pass (15 checks)

## Quick References

Condensed cheat sheets for active drafting:

- `assets/quick-reference-essay.md`
- `assets/quick-reference-memo.md`
- `assets/quick-reference-blog-post.md`
- `assets/quick-reference-email.md`

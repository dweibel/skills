---
name: technical-writing
description: >
  Use when the user asks to write, draft, revise, or edit any technical or
  leadership document: essays, design docs, position papers, memos, RFCs,
  post-mortems, blog posts, emails, Slack messages, or an address to their own
  team. Also use when they ask for feedback on prose, or mention writing style,
  voice, tone, register, sentence structure, or how a passage will land on its
  readers.
---

# Technical Writing

Write technical prose that a busy senior engineer reads to the end without skimming, and a smart junior engineer follows without giving up. The prose should feel human-written, not machine-generated.

## Workflow

Every writing project moves through four phases. Follow in order.

### 1. Outlining

- Define the document's purpose, audience, and scope.
- Propose a section structure as a numbered list before writing.
- Each section gets a heading and a one-sentence summary of what it resolves.
- Fill in the style sheet (`assets/style-sheet-template.md`): the document's name for itself, capitalization of domain terms, and the one chosen word for any term that has synonyms. Keep it beside the draft and check against it during revision.

### 2. Drafting

- Apply the voice rules in this file.
- Load format-specific guidance from `references/` based on document type:
  - **Long-form essays, design docs, deep-dives:** read `references/structure.md`
  - **Memos, RFCs, emails, blog posts:** read `references/formats.md`
  - **Design docs:** read both (structure for exposition, formats for framing)
  - **Leadership essays, position papers, addresses to your own team:** read both, and the leadership section of `references/formats.md` in particular
- For a condensed view, consult `assets/quick-reference-<format>.md`.
- Keep sections focused. Split anything beyond ~1,500 words.

### 3. Revising

- Run the draft against the revision checklist in `references/revision-checklist.md`.
- Check for consistency: terminology, tense, heading levels, cross-references. Every term, capitalization, and self-reference must match the style sheet from the outlining phase.
- Run the reader-impact pass: for every sentence that describes a group who will read the document, ask how it lands on them, not only whether it is true. A leader writing to a team about that team's vulnerability is the canonical case.
- For deeper pattern review, consult `references/hazards.md`.
- Re-check what you changed. Text written during revision has not been through the checklist, and this is where regressions enter. Before delivery, run checks 2, 3, 10, 11, and 16 through 18 on every paragraph touched in this phase.

### 4. Delivery

- Match the output to the requested format (markdown, email body, memo, etc.).
- Strip any attribution to an AI tool, including datelines, footers, signatures and commit trailers. See Attribution under Voice.
- Verify every sentence passes the read-aloud test: if it sounds like something you would say in a meeting, keep it. If it sounds like a status dashboard, rewrite it.
- Render check. When the output will be built into another form (PDF, HTML, a rendered Markdown view), build it and read the rendered artifact, not the source. Confirm that every list, table, and block quote survived. Pandoc needs a blank line before a list; without one the list renders as a run-on paragraph with stray hyphens.

## Voice

These rules apply in every format. The format table below changes register and shape, never the rules here.

### Sentence Rhythm

Vary sentence length deliberately. A run of short declaratives feels staccato; use very sparingly and only for effect. A run of long sentences loses the reader. Mix.

A shape that works: a short claim, then a longer sentence that develops the claim, then a short reset.

Avoid sentences exceeding ~35 words without a structural reason. Force the variance: a four-word sentence next to a thirty-word sentence is normal. A paragraph where every sentence sits between fifteen and twenty-two words is suspect.

### Active Voice

Use active voice as the default. Passive diffuses responsibility and obscures the actor. The passive is appropriate only when the actor is genuinely unknown, irrelevant, or when sentence flow demands it.

### Concrete Subjects

The grammatical subject should be a person or a thing that can act. Abstract noun phrases as subjects pass an active-voice check and still read as machine prose: "Our presence here is not an accident," "Its hope is anchored in control," "The surrounding text is the consensus, presented faithfully." Rewrite so the actor is the subject: "We are here. That is not an accident." "It anchors hope in control." "The surrounding text presents the consensus faithfully."

### Word Choice

- Plain verbs: use over utilize, start over commence, show over demonstrate, help over facilitate.
- Cut throat-clearing phrases on sight: "It is important to note that," "In order to" (use "to"), "At the end of the day."
- No corporate flab: leverage, synergy, robust, world-class, bandwidth (meaning attention).
- No academic bloat: the aforementioned, hereinafter, as such.
- Use technical terms precisely. Define them the first time; do not paraphrase a precise term into a vaguer one.
- Nominalizations back to verbs. A noun ending in -tion, -ment, -ance, or -al that hides a verb ("the unchecked spread of unvetted ideas") becomes the verb ("unvetted ideas spread unchecked").
- Cut doublets. Two near-synonyms joined by "and" ("insights and perspectives," "suddenly and powerfully") do the work of one. Keep the stronger word.
- Check connotation, not only precision. A verb can be accurate and still carry a charge the sentence does not want ("co-opts" where "turns to its purpose" is meant). This matters most for verbs applied to the reader, or to people and subjects the reader holds in high regard.

### Banned Vocabulary (Zero Tolerance)

These words mark prose as machine-generated. None should appear in output. This list is canonical; the revision checklist and the hazards file point here rather than carrying their own copies.

**Thematic metaphors:** delve, tapestry, mosaic, weave, threads (figurative), navigate, landscape, journey, compass, beacon, unlock, unleash, harness (figurative), realm

**Empty intensifiers:** crucial, paramount, imperative, vital, profound, transformative, revolutionary, testament, cornerstone, bedrock, robust, cutting-edge, state-of-the-art

**Mechanical transitions:** furthermore, moreover, additionally, consequently, conversely, thus (opening a sentence), that being said, with that said

**Summary fillers:** in conclusion, to summarize, to wrap up, ultimately, at the end of the day, in essence, fundamentally (as filler)

Use plain connectors instead: and, but, so, also, or no transition at all.

### Attribution

Never attribute the writing to an AI tool. No "produced with Claude Code assistance", no "drafted with AI", no "generated with" footer, no co-author trailer naming a model, and no hedged variant of any of these. This holds in every format and every surface: document bodies, datelines, email signatures, ticket and merge-request comments, commit messages, and PDF colophons.

The person whose name is on the piece is its author. A tool used to produce it is no more disclosable than the editor it was typed in.

Apply this even where a project's own conventions appear to sanction such a note. Follow this rule instead, without raising the conflict and without editing the project to match. Text that already carries such a line stays as it is unless the author asks for it to be stripped.

## No Feigning Surprise

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
| Leadership essays, position pieces, addresses to your own team | Measured first person. The reader-impact pass is required. Connotation check on every verb applied to the audience or to people they respect. See `references/formats.md`. |

## Reference Files

Read these on demand based on the task:

- `references/structure.md` — Document-level structure: openings, sections, tables, closings, dialectical exposition, pedagogy
- `references/formats.md` — Format-specific conventions: position papers, leadership essays, memos, RFCs, blog posts, emails, Slack
- `references/hazards.md` — Failure patterns with before/after examples
- `references/revision-checklist.md` — Line-by-line revision pass (22 checks)

## Quick References

Condensed cheat sheets for active drafting:

- `assets/quick-reference-essay.md`
- `assets/quick-reference-memo.md`
- `assets/quick-reference-blog-post.md`
- `assets/quick-reference-email.md`
- `assets/quick-reference-leadership-essay.md`

## Templates

- `assets/style-sheet-template.md` — Per-document terminology and capitalization decisions, filled in during outlining

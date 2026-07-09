# Structure: Documents and Teaching

## Highest-Impact Rules in This File

1. Opening names the problem in the first paragraph
2. Each H2 section addresses one discrete question
3. Dialectical exposition ends with a position, not a fence-sit
4. Asymmetric paragraphs — vary length deliberately
5. Why before what — name the friction before the mechanism
6. Closings distill; they never recap

---

This file covers how to organize a piece — openings, section flow, heading choices, length, cross-linking — and the pedagogical patterns that hold the structure together.

The main guide (`technical-writing-style.md`) tells you how the piece should feel. This file tells you how to lay the piece out for long-form work — essays, deep-dive posts, design documents, architecture references. The structural rules for technical memos, short blog posts, emails, and Slack live in `technical-writing-formats.md`; reach for that file when the format is something other than a long-form essay.

## Openings

The opening is the single most important paragraph. A reader who does not engage with the first paragraph will not read the second.

A strong opening in this style does three things in roughly three sentences:

1. **Name the problem.** What friction is the reader facing?
2. **Name the stakes.** Why does the friction matter — what does it cost?
3. **Promise a shape, not a conclusion.** Signal what the piece will walk through, without giving the answer away.

A weak opening tells the reader what the piece is about. A strong opening makes the reader want to know.

Avoid these opening patterns specifically:

- **The dictionary opening:** "Refactoring is the process of…"
- **The throat-clear:** "In this post, we will discuss…"
- **The hype opening:** "Microservices have revolutionized…"
- **The disclaimer opening:** "Before we begin, it's worth noting that…"

Start where the friction is.

## The Middle: Section Shape

Long pieces in this style use H2 sections that each address a discrete question. The reader should be able to read the table of section headings and recover the spine of the argument.

A well-shaped section:

- opens with a single sentence that states what the section will resolve,
- works through the mechanism in concrete terms,
- closes with the implication for practice.

Avoid sections that meander. If a section is doing two things, split it. If two adjacent sections are doing the same thing, merge them.

### Heading style

Headings should be **noun phrases or short declarative claims**, not questions, and not single words.

- Good: "The Cost of Feature Branching"
- Good: "When Mocks Are the Wrong Choice"
- Weak: "Mocks"
- Weak: "Why is feature branching bad?"

Sentence-case headings ("The cost of feature branching") read more naturally in this style than Title-Case ones ("The Cost Of Feature Branching"). Pick one convention and hold it. Reserve all-caps and exclamation points for code, never prose.

### Heading depth

Use H1 for the document title only. Use H2 for major sections. Use H3 sparingly inside long H2s. Avoid H4 and below; if you are reaching for H4, the section is probably trying to do too much and should be restructured.

## Length and Pacing

Length should follow the argument. A short piece that resolves a discrete question is a complete piece. A long piece that develops an architecture or compares approaches is also a complete piece. A medium piece that hedges between the two is rarely either.

Two well-supported lengths:

- **The short essay (500–1,500 words).** A single, discrete claim with one or two supporting passes. A focused, self-contained piece.
- **The structured guide (2,500–6,000 words).** A multi-section walk through a topic with named sub-concepts, trade-offs, and a closing synthesis.

What you should not produce: a 3,000-word piece that says what an 800-word piece could have said. Length without compression is not depth.

## Asymmetric Paragraphs and Lists

Paragraphs in this style should not all be the same length. A single-sentence paragraph is permitted and often effective. A four-sentence paragraph is normal. A seven-sentence paragraph is acceptable if the paragraph is doing one continuous piece of work.

What you should not produce: a piece in which every paragraph is three or four sentences of similar weight. The uniformity is one of the strongest tells of machine-generated prose. Vary the rhythm. Let some thoughts land in a sentence and others develop across a passage.

The same discipline applies to lists. Generated bullet lists tend to come out symmetrical — three bullets, each two sentences, each starting with a gerund, each carrying roughly equal weight. Real lists are uneven. One item might be a phrase; the next, a full sentence; the next, three sentences because that item has more to say. Match the length of each item to the weight of the idea, not to the shape of the item above it.

A useful check: read the bullet list aloud. If the items sound interchangeable in cadence and weight, the list has been flattened. Rewrite the items so each one is as long as it needs to be — and no longer.

## Cross-Linking

This style treats each piece as a node in a larger graph of writing. The piece itself stays focused; tangential concepts get mentioned and linked rather than explained inline.

Apply this discipline:

- When you introduce a concept that the current piece is not about, give a one-sentence definition and link to fuller treatment elsewhere.
- Do not nest deep explanations of side concepts inside the main argument. The reader who wants the side concept will follow the link. The reader who does not should not have to wade through the side concept.

When you are operating without real links available, name the concept and state that a fuller treatment exists separately, so the reader knows where the argument ends and the gesture begins.

## Closings

A strong closing does one of three things:

- **Distills the argument** into a one- or two-sentence claim the reader can carry away.
- **Names the next question** that the piece has opened but not resolved — and is honest about not resolving the question.
- **Returns to the opening's problem** and shows what has changed by the end.

A weak closing:

- summarizes everything just said ("In conclusion, we discussed…"),
- adds new arguments that didn't fit elsewhere,
- ends with a question to the reader ("What do you think?").

Stop when the argument is done. The reader knows when the piece is over.

## Teaching: Pedagogical Mechanics

Beyond layout, the piece has to teach. Several patterns do most of the pedagogical work in this style.

### Write for a specific reader

Hold a mental model of one specific reader — a competent engineer who has not encountered this corner of the topic. Write to that reader the whole way through. Audience drift, where the prose oscillates between addressing novices and addressing experts within the same piece, is one of the easiest ways to lose trust.

A useful version of this technique: imagine an earlier version of yourself before you learned the material. Write to that person.

### Why before what

Explain the problem the mechanism solves before explaining how the mechanism works. A reader who understands the problem can evaluate the mechanism; a reader who has only seen the mechanism cannot.

Equivalent: every claim about a tool or pattern should be paired with the friction the tool removes.

### Mechanism over metaphor

Prefer concrete, mechanistic explanations to extended analogies. "DNS is like the phone book of the internet" is acceptable as a gesture. The line is not acceptable as the explanation. The explanation walks through what actually happens: the resolver, the cache, the recursive lookup, the response.

Analogies that have to be sustained for multiple paragraphs are almost always doing harm — the reader spends attention maintaining the analogy instead of learning the system.

### Examples carry the weight

Concrete examples — code, command-line transcripts, specific numbers, real protocol names — anchor the abstract claims. A piece in this style should rarely go more than a couple of paragraphs without something concrete.

When showing code, show the smallest example that exhibits the concept. Do not show production-ready code if the point is the pattern; the production scaffolding will distract from the idea.

### Mark anti-patterns clearly

When you show how something is done wrong before showing the right way, label the wrong version explicitly and visibly. A reader who copies the wrong version because the labeling was subtle has been let down by the writer, not by themselves.

### Dialectical exposition

When two approaches genuinely compete, present both. State the case for each in its own terms before drawing a conclusion. The reader should be able to recognize the position they came in holding, described fairly, before being asked to update.

This pattern is what makes analysis credible. A piece that engages only with the position it is about to recommend reads like advocacy. A piece that takes the opposing view seriously reads like analysis.

The shape:

> ### The case for [Approach A]
>
> A fair account of why a thoughtful engineer would reach for Approach A, including the contexts in which Approach A is the right call.
>
> ### The case for [Approach B]
>
> A fair account of why a thoughtful engineer would reach for Approach B, including the contexts in which Approach B is the right call.
>
> ### Where I land
>
> A synthesis that names the conditions under which each approach wins, rather than declaring one approach universally correct.

Note the last move. "It depends, and here is what it depends on" is almost always a better closing than "X is better than Y."

**The synthesis is not optional.** A piece that presents two views and refuses to choose has not done the work. "Both have merit" or "it depends" without specifying *what* it depends on is fence-sitting, not analysis. The reader came to find out what you think; tell them, and tell them why. When in doubt between a confident landing and a balanced "both work in their own ways," choose the landing. This is where the composure-wins rule matters most: dialectical exposition always ends with a position. The two-sided treatment earns the right to take a side; it does not replace doing so.

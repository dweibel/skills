# Hazards: Patterns That Wreck a Piece

Specific failure modes with before/after pairs. Read this file before publishing anything substantial. For a compact pass during revision, use `revision-checklist.md` instead.

## Hazard 1: The Self-Important Opening

**Before**

> In today's rapidly evolving software landscape, microservice architectures have emerged as a transformative paradigm for building scalable, resilient distributed systems. This essay will explore the multifaceted considerations involved in adopting such an architecture.

**After**

> A small team can run a monolith. A large team usually cannot — not because monoliths fail at scale, but because the team's coordination cost rises faster than the system's complexity. That is the friction microservices are trying to resolve, and most of the trade-offs that follow trace back to it.

Start inside the problem. Do not announce the piece's own importance.

## Hazard 2: Feigning Surprise

**Before**

> Obviously, you'll want to set up a CI pipeline first. As everyone knows, this is trivial with GitHub Actions.

**After**

> Set up a CI pipeline first. GitHub Actions handles this well: add a YAML file under `.github/workflows/`, define when the pipeline should run, and list the steps.

Never imply the reader should already know something.

## Hazard 3: Pronoun Soup

**Before**

> When the load balancer receives the request, it forwards it to the service, which validates it and passes it to the handler. If it fails, it logs it and returns it to the client.

**After**

> When the load balancer receives the request, the load balancer forwards the request to the service. The service validates the request and passes the validated request to the handler. If validation fails, the service logs the failure and returns an error response to the client.

Replace ambiguous pronouns with the specific noun.

## Hazard 4: Strained Analogy

**Before**

> Think of Kubernetes as a city. The pods are buildings, the nodes are city blocks, the services are roads…

**After**

> Kubernetes runs your containers across a cluster of machines. When you ask Kubernetes to run an application, you give it a spec describing what you want, and Kubernetes decides where to place each copy, restarts copies when they fail, and reroutes traffic when nodes go down.

Describe the mechanism. Analogies that need multiple paragraphs to sustain are doing harm.

## Hazard 5: The What Without the Why

**Before**

> Use the Repository pattern: define an interface that exposes methods like `findById`, `save`, and `delete`.

**After**

> Code that mixes business logic with database calls is hard to test. The Repository pattern moves database calls behind an interface so business logic depends on the interface, not the database. In tests you swap in an in-memory implementation; in production you use the real one.

Name the friction before the pattern.

## Hazard 6: The Unmarked Wrong Way

**Before**

> Here is how a naive implementation might handle currency:
> ```python
> total = price * 1.08
> ```

**After**

> **The following is incorrect and should not be copied:**
> ```python
> total = price * 1.08  # DO NOT USE — floating-point error
> ```
> Use a fixed-precision decimal type instead:
> ```python
> from decimal import Decimal
> total = price * Decimal("1.08")
> ```

Make wrong code unmistakable. "Naive" is too soft for a skimming reader.

## Hazard 7: Drift in Assumed Knowledge

**Before**

> First, install Node.js. (If you don't know what Node.js is, it's a JavaScript runtime…) Once installed, spin up a basic server with `app.listen()` and configure middleware in the standard way.

**After**

> First, install Node.js, the JavaScript runtime that runs outside the browser. Node.js comes with `npm`, a tool that downloads JavaScript packages. You will use Express, which provides an `app` object whose `listen()` method starts a server, and a `use()` method that registers middleware: functions that process each request before it reaches your route handlers.

Maintain a consistent baseline. If you explain one concept, explain them all at the same depth.

## Hazard 8: Hedging Into Mush

**Before**

> In some cases, it might potentially be worth considering whether a microservice architecture could perhaps offer certain benefits.

**After**

> Microservices help large teams ship independently. They cost more to operate than a monolith, and the savings only appear once the team is large enough that coordination dominates. Below that threshold, a monolith is the better choice.

Hedge when the claim genuinely warrants it. Do not hedge as decoration.

## Hazard 9: The Closing Recap

**Before**

> In this post, we discussed continuous integration, the practices that support it, and the contrast with feature branching.

**After**

> Continuous integration is a discipline before it is a tool. A team running CI in name only gets little of the benefit and much of the ceremony. The practices in this piece are not optional embellishments.

Distill the argument. Do not restate the table of contents.

## Hazard 10: Meta-Talk About the Piece

Avoid: "This article will explore," "We have seen above that," "As discussed earlier," "The remainder of this section examines." If a back-reference is needed, make it specific and brief.

## Hazard 11: The Bullet List That Should Be a Paragraph

**Before**

> Key considerations:
> - Performance
> - Maintainability
> - Cost
> - Team familiarity

**After**

> The decision turns on five things, in roughly this order: how familiar the team is with the technology, what the system costs to operate over a year, how readable the code remains after six months of feature pressure, the latency budget under peak load, and the operational burden when something breaks at 3 a.m.

If reordering the items would change the argument, write a paragraph instead.

## Hazard 12: The Listicle Disguised as an Essay

"Five Reasons X Is Better Than Y" forces shallow treatment. Identify which reason is load-bearing and write the piece around that one.

## Hazard 13: The Diplomatic Fence-Sit

**Before**

> There are strong arguments on both sides. Ultimately, the right choice depends on your specific context.

**After**

> Microservices are the wrong default. Most teams adopt them before they need them, and the operational cost overwhelms the benefits until the team passes roughly thirty engineers. Stay monolithic until coordination cost demonstrably hurts.

Take a position. Name the threshold where it flips. Dialectical exposition earns the right to take a side; refusing to take one wastes the setup.

## Hazard 14: The Symmetric List

**Before**

> - The timeline of events that led to the incident, including the initial detection and the subsequent escalation.
> - The contributing factors and root causes, looking beyond the immediate trigger to systemic issues.
> - The action items and follow-ups that will reduce the risk of similar incidents in the future.

**After**

> First, the timeline: what happened and when, precise enough that someone reading it cold could reconstruct the failure. Second, the contributing factors. "Root cause" tends to fix on the most visible one; more useful is the set of conditions that had to be true simultaneously, because each is a candidate for fixing. Third, the action items, which must be specific and owned. "Improve monitoring" is not an action item. "Add alerting on queue depth > 1000, owned by payments, by end of Q3" is.

Weight items by importance. The most important item gets the most space.

## Hazard 15: Relentless Enthusiasm

**Before**

> This is a great pattern that solves a really important problem! It's incredibly powerful and surprisingly easy to use.

**After**

> The pattern solves one specific problem: shared mutable state across components without prop-drilling. The cost is that state changes become harder to trace. Worth using when prop-drilling through six layers is causing real friction, and not before.

Strip the cheerleading. Name the mechanism and the cost.

## Hazard 16: Default LLM Vocabulary

See the canonical banned list in `SKILL.md`. The fastest way to make a piece sound less like an LLM: search the draft for those words and delete or replace each one. Every flagged word does zero substantive work.

## Hazard 17: Em Dashes

Never use em dashes. Replace with commas, parentheses, or separate sentences. Their presence alone marks prose as machine-generated.

## Hazard 18: Awkward Phrasing

**Before**

> Breach blast radius is maximum. System performance degradation is occurring. User authentication flow completion rate is suboptimal.

**After**

> The breach affects the entire system. Performance is degrading. Too many users are failing to log in.

LLMs assemble noun phrases and superlatives without checking whether a human would actually say them. The pattern: stack technical-sounding nouns, drop articles, end with an absolute adjective. The result reads like a telegram written by a thesaurus.

Signs to watch for:
- Missing articles ("the," "a") before nouns
- Noun-noun-noun pileups where a verb would work
- Superlatives and absolutes ("maximum," "optimal," "comprehensive") doing the work of specifics
- No hedging or qualification where a human would naturally hedge

The fix: read the sentence aloud. If it sounds like something you would say in a meeting, keep it. If it sounds like a status dashboard, rewrite it.

## Hazard 19: Overwrought Parallelism

**Before**

> Every epoch of progress arrives carrying the same paradox: human capability expands suddenly and powerfully, and human anxiety convulses just as hard.

**After**

> Every epoch carries the same paradox: capability leaps, and fear leaps with it.

Doubled adverbs ("suddenly and powerfully"), stacked abstractions ("epoch of progress," "human capability," "human anxiety"), and a verb chosen for drama ("convulses") are the tells. The claim survives compression to half the words, and the parallelism does the rhetorical work the adverbs were straining to do. This is distinct from Hazard 4: the analogy there fails as teaching; the sentence here fails as prose.

Related tells: nominalizations that hide a verb ("the unchecked spread of unvetted ideas" for "unvetted ideas spread unchecked"), and abstract subjects ("Our presence here is not an accident" for "We are here. That is not an accident").

## Hazard 20: The Line That Lands Wrong on Its Reader

**Before**

> Beck's warning about the middle tier is the one I lose sleep over.

**After**

> Beck's warning about the middle tier is the one I want us to take seriously.

The before sentence is honest, well-shaped, and rhythmically better. It is still wrong for a leader writing to the engineers who make up that tier: it tells them their leader sees them as a risk. Every sentence that describes a group who will read the document needs a second reading from inside that group. The fix is not to soften the claim. It is to state the same claim in a way the reader can act on rather than absorb as a verdict.

The same check applies to verbs. "Co-opts" is accurate and carries a charge of hijacking; applied to a subject the audience reveres, it lands as an insult the writer did not intend.

## Hazard 21: Regressions Introduced During Revision

Every hazard above is checked against the draft. The revision pass then writes new text, and that new text has been through none of the checks. Typical regressions: a banned word in a rewritten clause, a sentence fragment left by a split ("Thus, tempting us to take matters into our own hand."), a capitalization convention broken in an added paragraph.

Diff the revised text against the previous draft and re-run the vocabulary, mechanics, and style-sheet checks on every changed paragraph. Memory of what you changed is not reliable enough to skip the diff.

## Pre-Publish Priority Order

1. Throat-clearing openings (Hazard 1)
2. Default LLM vocabulary (Hazard 16)
3. Feigning surprise (Hazard 2)
4. Pronoun soup (Hazard 3)
5. Diplomatic fence-sit (Hazard 13)
6. Symmetric lists (Hazard 14)
7. Relentless enthusiasm (Hazard 15)
8. What without why (Hazard 5)
9. Closing recap (Hazard 9)
10. Overwrought parallelism (Hazard 19)
11. Lines that land wrong on their reader (Hazard 20)
12. Regressions in revised passages (Hazard 21), run last

# Writing Across Formats

The underlying voice is a synthesis, but different formats demand different weightings of it. This file names those weightings and gives the shape each format expects. Read the entry file (`technical-writing-style.md`) first.

The voice rules (`technical-writing-voice.md`) and the hazards (`technical-writing-hazards.md`) apply across every format. What changes here is structure and register, not the lexical constraints. No format gives you a license for *delve*.

## The Default: Long-Form Technical Writing

Essays, design docs, architecture documents, deep-dive blog posts, reference material.

This is the format the rest of the guide assumes by default. Composure-curiosity hybrid. Composure wins when the two voices clash. Apply the structure file in full: strong openings, dialectical exposition where two approaches genuinely compete, asymmetric paragraphs, no closing recap.

If you are writing in this format, you barely need this file. Apply the rest of the guide.

## Position Papers and White Papers

Position papers argue a thesis. White papers present a technical case for an approach or product. Both are long-form, but with a few format-specific conventions that differ from general essays.

**YAML front-matter is required.** The PDF build pipeline generates a title page from `title`, `subtitle`, and `author` metadata, then places the table of contents between the title page and the body. Do not render the title as a markdown H1 heading; use front-matter instead.

```yaml
---
title: "Paper Title"
subtitle: "A clarifying subtitle"
author: "Author Name"
---
```

**The body begins with an Abstract.** The Abstract is an H2 section, not front-matter. It states the paper's thesis and previews the argument's shape in a single paragraph. The TOC will appear between the title page and this section.

**Section headings are claims, not labels.** "Defense in Depth: Why One Layer Is Not Enough" tells the reader the argument before the reader enters the section. "Defense in Depth" alone forces the reader to enter the section to find out what the paper is saying about it.

**The conclusion distills; it does not recap.** Name the trade the reader gets to make, or the position the paper has earned the right to hold. Do not restate the table of contents.

## Technical Memos and RFCs

Memos, RFCs, design decision documents, post-mortems, and anything else whose primary job is to communicate a *decision* or a *proposal* to peers and stakeholders.

Here the organizational clarity style takes over. The voice inside the prose still follows the composure-curiosity rules; the *shape* of the document is what changes. A memo is not an essay. The reader of a memo is often skimming, deciding, or routing the document to someone else. The structure has to support that.

### The Memo Template

A memo in this style has roughly the following shape. Sections can be combined or dropped based on what the memo is actually doing, but the ordering should hold.

**TL;DR / Decision.** One paragraph at the top. The recommendation or the decision is in the *first sentence*. If the reader stops here, they should know what you are proposing and roughly why. A one-line TL;DR is better than a six-line one; the shorter you can make the summary, the sharper your thinking.

**Context / Background.** Why this memo exists. What is happening in the system, the team, or the business that makes this decision necessary now. Keep this section short. The reader needs enough to evaluate the proposal, not the full history of the codebase.

**Problem.** The specific friction the memo is addressing. State the friction concretely, with numbers where you have them and named symptoms always. "Build times are slow" is weak; "CI takes 22 minutes on average and 45 minutes at the p95, blocking three or four merges per day" is the version that earns the rest of the memo.

**Options Considered.** The plausible options, each treated fairly. For each option, give:

- a one-line description,
- what the option buys,
- what the option costs (engineering time, operational risk, ongoing maintenance, opportunity cost),
- when the option would be the right call.

This section is where dialectical exposition lives in memo form. Do not skip options that you do not recommend; the credibility of the recommendation comes from showing that the alternatives were considered seriously.

**Recommendation.** The option you are recommending, and the conditions under which the recommendation holds. Be explicit about what the recommendation assumes. If those assumptions are violated, the recommendation may flip — and the reader should know what would flip it.

**What We Are Not Doing.** A short list of things this memo deliberately does not propose. This section is one of the most useful parts of the template. It pre-empts the "but what about X" responses by naming X and saying, plainly, that X is out of scope and why.

**Risks and Mitigations.** The specific things that could go wrong if the recommendation is adopted, paired with what the team will do to detect or mitigate each. A risk without a mitigation is a half-finished thought.

**Open Questions.** The things the memo cannot resolve on its own — questions for reviewers, decisions waiting on other teams, data that does not yet exist. Naming the gaps openly is what makes the rest of the memo trustworthy.

**Action Items.** Specific, owned, dated. "Improve monitoring" is not an action item. "Add alerting on queue depth > 1000, owned by the payments team, by end of Q3" is.

### Memo-Specific Conventions

- **Bold sparingly, and only to mark key terms or decisions.** The first occurrence of a defined term, the name of the recommended option, an explicit "yes" or "no" — these earn bolding. Bolded paragraphs do not exist.
- **Numbers carry trust.** When you can quote a real number — latency, frequency, cost, headcount — quote it. Vague claims weaken memos faster than almost anything else.
- **Lists are common but should still be asymmetric.** The bullet discipline from the structure file applies. Match the length of each item to the weight of the idea.
- **Headings are decisions or questions, not descriptions.** "Recommendation: Roll out feature flag gating in Q3" beats "Recommendation." The heading itself should advance the reader's understanding.
- **Length depends on stakes.** A two-page memo is appropriate for many decisions. A ten-page memo is appropriate for some. A twenty-page memo almost always wants to be a doc, not a memo.

## Blog Posts (Short-Form), Emails, and Slack

For these formats, **curiosity wins**. Enduring-essay composure is overkill for a Slack message; directness, curiosity, and willingness to think aloud land better.

The flip is real. Things that are usually discouraged in long-form become acceptable or preferred:

- First-person voice is welcomed. "I noticed that…" or "I was trying to figure out…" is a natural opening.
- Fragments are more freely used. So are em-dash asides and parentheticals.
- Single-question pieces are a complete form. "Why does my DNS resolver keep returning a stale answer?" is enough to anchor a post.
- TIL ("Today I Learned") posts are a legitimate form, not a weaker substitute for a structured essay.
- Curiosity is on the surface. "It turns out…" is allowed. "Huh, that's odd" is allowed.

The constraints from voice and hazards still apply. No LLM vocabulary. No feigning surprise. No relentless enthusiasm. The curiosity-emphasis is about register and shape, not a license for sloppiness.

### Short-Form Blog Posts

The curiosity-weighted blog post:

- Opens with the specific question, observation, or finding that made the post worth writing. No throat-clearing setup, no "in this post we will…", no framing of why the topic matters globally.
- Walks through the investigation or the explanation in the order the writer actually moved through it. If you tried something and it didn't work, that step belongs in the post — the failed attempt is often where the reader learns most.
- Stays under about 1,000 words unless the topic genuinely needs more. Brevity is part of the form.
- Uses one or two screenshots, code transcripts, or small diagrams if they help. Concrete artifacts anchor the post and let the reader verify what is being claimed.
- Stops when the question is answered or the observation is made. A "Conclusion" section is rarely needed; if the post has been doing its job, the end is obvious.

The shape of a strong short post is often: *a small concrete thing → what surprised me about it → how I figured out what was actually happening → here's the mental model I came away with*. That sequence works.

### Emails

Email is a request for someone's attention. Treat it that way: high signal, zero filler, one clear purpose per message. The reader is busy. Reward them for opening it.

#### Subject Lines

The subject line is the email's first filter. A vague subject — "Update," "Checking in," "Quick question" — forces the reader to open the email before knowing whether it matters. Front-load the core topic and use bracketed tags to signal intent:

- `[Action Required] Q3 Budget Approvals due Friday`
- `[Info] System downtime scheduled for Oct 12`
- `[Decision Needed] Migration strategy for auth service`
- `[FYI] Post-mortem published for July 3 incident`

The tag tells the reader what kind of attention the email needs before they read a word of body text.

#### BLUF (Bottom Line Up Front)

The first sentence states why the email exists. Do not bury the purpose behind pleasantries or backstory.

- "I need your sign-off on the revised timeline by Thursday."
- "The payments team has decided to proceed with Option B."
- "CI is broken on main — here's what happened and what we're doing."

If the reader stops after one sentence, they should know what the email is about and what (if anything) is expected of them.

#### Scannability

Design for the skim reader. Most recipients will not read every word — the formatting should ensure they still catch the essentials.

- **Paragraphs:** Two to three sentences maximum. A wall of text is a wall of silence.
- **Lists:** Three or more items of any kind become bullet points.
- **Bold:** Use bold for dates, deadlines, owner names, and key decisions — the things a skimming reader must not miss. Do not bold entire paragraphs.

#### Prose Discipline

The voice rules from this guide apply in email with extra force. Email is short; every wasted word costs a larger percentage of the reader's attention.

- Active voice throughout. "The team shipped the fix" — not "the fix was shipped by the team."
- Cut filler words: *just*, *actually*, *very*, *I think*, *basically*, *in order to*. They add length without adding meaning.
- Plain English over corporate jargon: *use* not *utilize*, *start* not *initiate*, *help* not *facilitate*, *about* not *with regard to*.

#### One Clear Call to Action

If you need something from the reader, isolate the ask at the bottom of the email — visually separated from the context above. Specify **who** needs to do **what** by **when**:

> **@Dev Team:** Review the attached Figma files and flag blockers by **Thursday 5 PM**.

An email with no clear CTA is an email that produces no response. An email with three buried CTAs produces confusion.

#### Shape Summary

| Element | Rule |
|---------|------|
| Subject | Bracketed tag + specific topic |
| Opening | BLUF — purpose in the first sentence |
| Body | Short paragraphs, bullet lists, bolded key facts |
| Closing | Explicit CTA with owner, action, and deadline |
| Greeting/sign-off | Plain. "Hi Jane," / your name. |

#### When an Email Becomes a Memo

If the body grows beyond a few paragraphs — a proposal, a status update, a post-mortem delivered over email — use the memo template above. An email memo is still a memo; the delivery channel does not change the structure. But the subject line still needs a tag, and the opening still needs a BLUF.

### Slack and Short-Form Chat

Slack is conversation, not correspondence. The shape changes again.

- Treat each message as one thought. Don't write paragraphs in Slack when threads or follow-ups would serve.
- Lower the formality. Fragments are fine. "yeah" and "thanks" and "ack" are fine. Lowercase first letters are fine.
- Use code blocks for code, not for emphasis.
- If something needs more than a short exchange, propose moving it — to a doc, a call, a thread.
- Don't lecture in Slack. If you find yourself writing a multi-paragraph technical explanation, the explanation belongs in a doc or a blog post, with the link dropped into Slack.

The curiosity habit translates well to chat: a real question, a small finding, a one-line "huh, this is weird" observation. The measured composed exposition habit does not translate to chat.

A useful rule for Slack specifically: if you are about to send a message longer than two screenfuls of phone-sized text, stop. Either trim it, thread it, or put it somewhere else.

## Choosing a Format

When the format is ambiguous — a piece could go in a memo, a doc, or a long blog post — choose based on the primary job of the piece:

- **Persuading peers or stakeholders to a specific decision:** memo.
- **Explaining a system, pattern, or trade-off that will be referenced later:** long-form essay or doc.
- **Sharing a finding, asking a question, working something out in public:** short blog post.
- **Coordinating immediate action or asking for someone's attention now:** email or Slack.

Picking the wrong format usually shows up as the piece feeling either too small for its container — a Slack-length thought stretched into a 2,000-word essay — or too big, with a real decision buried inside an email thread where it will get lost. When the format feels uncomfortable, the format is usually wrong; switch before you write more.

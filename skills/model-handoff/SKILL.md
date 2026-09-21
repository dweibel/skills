---
name: model-handoff
description: >
  Use when work needs to cross from one session or model to another: the user asks
  to hand off, switch models, escalate to a stronger model, drop back to a cheaper
  one, or start a fresh session on the same task because this one is stuck, looping,
  burning context, or repeatedly failing the same test. Also use when a session opens
  with a handoff note from a previous attempt.
---

# Model Handoff

## Overview

A fresh session has no memory of this one. The only thing that crosses the gap is the note.

Facts cross. Reasoning does not. A stuck session's reasoning is what got it stuck, so passing the theory along recreates the failure inside a better model. The note carries observations; the next session does its own diagnosis.

## Which mode

- **Write** — you are the session being handed off *from*.
- **Receive** — you are the session being handed off *to*, or you have been given a note.

## Write mode

**1. Stop working.** Abandon whatever you were mid-way through and write the note. Do not land one more fix first.

**2. Write the note.** Six sections, these headings, about 200 words. Measure it with `wc -w` if you want a number, but do not spend rewrite passes shaving a 220-word note down to fit — cutting a real fact to satisfy a word count is the wrong trade. Each fact belongs to exactly one section; do not restate it in a second.

```markdown
# Handoff: <topic>

**1. Task**
The actual goal in one or two sentences, as the user stated it — not your interpretation of it.
If what you observed contradicts the stated goal, still state it as given and record the
contradiction in section 5. The next session needs both.

**2. Current state**
What exists on disk right now that is correct and should be kept. Specific paths,
function and class names, and what each one does.

**3. What's broken or unresolved**
The observable failure: exact error message, failing test name, or symptom. Not the cause.

**4. What's been ruled out**
Approaches that did not work, each stated as a fact to avoid: "X does not work because Y."
A cause you eliminated without changing anything counts too: "pruning is not the problem —
logging showed the filter dropping expired entries correctly."

**5. Key constraints or facts learned**
What this session discovered that is not obvious from the code — rate limits, required
env flags, input thresholds that trigger the bug.

**6. Suggested next step**
One sentence. Omit the section entirely if you have nothing useful.
```

**3. Save it.** `.handoff/$(date +%Y-%m-%d-%H%M)-<topic-slug>.md`, where the slug names the component or test that is failing. Resolve the path from the repo root (`git rev-parse --show-toplevel`) or the working directory if there is no repo.

**4. Check ignore status.** Run `git check-ignore -q .handoff`. If `.handoff` is not ignored, say so in chat so the user knows there are untracked files. Do not edit `.gitignore` — that is a tracked change and the user's call.

**5. Print** the note in chat, then the opener below.

### What the note contains

The note is those six sections and nothing else. Every line is either an observation you made or a fact you verified.

Never include:

- Your reasoning process, false starts, or theories that did not pan out
- Apologies, or any explanation of why the task went sideways
- Code, unless a snippet is the shortest way to convey state
- Secrets of any kind: keys, tokens, passwords, connection strings. Name where the secret lives, never its value.
- PHI, PCI, or real member data. Truncate an error to its type and message; strip payloads, result rows, and identifiers.

### The opener

Print this for the user to paste into the new session, with the paths filled in:

> Here's a handoff note from a previous attempt: `<path>`. The working tree is at `<repo path>`. Start fresh — don't assume the previous attempt's reasoning was correct, only that the note's facts are accurate.

That framing is the point of the exercise. It makes the note ground truth without making its conclusions binding.

### The switch itself is manual

You cannot change your own model. Tell the user the steps: `/model opus` to switch, then `/clear` to drop the context that is no longer useful, then paste the opener. A new session works equally well.

### Handing off downhill

The same six sections work in reverse. When a task turns mechanical — a diagnosis is settled and what remains is applying it across twenty files — a note handing it to a cheaper model is the identical procedure.

## Receive mode

1. **Read the note.** Treat its facts as accurate and its reasoning as unverified.
2. **Verify state cheaply** before building on it: do the named files exist, do they still contain the named functions.
3. **Reproduce the symptom yourself.** Run the failing command and confirm section 3 before fixing anything.
4. **Diagnose independently.** You may reach a different cause than section 6 suggests. That is the expected outcome, not a conflict — say plainly that you are taking a different read, and why.

## Red flags

| Thought | Reality |
|---------|---------|
| "Let me try one more thing before writing the note" | The attempt that fails leaves half-applied state the next session has to untangle. Stop now. |
| "The next model needs my theory of the cause" | Your theory is why you are handing off. Section 3 is the symptom; the cause is theirs to find. |
| "I should explain what I tried so they don't repeat it" | Section 4 covers that, as facts to avoid. A narrative of the attempt is not section 4. |
| "Context on how I got here will help them" | It is the thing most likely to mislead them. Under 200 words, facts only. |
| "The note's suggested next step told me what to do" | It is a suggestion from a session that was stuck. Re-diagnose. |
| "The note says the tests pass, so they pass" | Verify. Notes go stale and sessions misreport. Run it. |

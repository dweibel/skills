---
name: solutions-arch-review
description: "Senior Solutions Architect review of a codebase, producing a navigable analysis/ site. Use when asked to analyse, review, assess, map, or document a codebase or system architecture — to onboard a new team, brief a CTO, plan a modernization effort, or produce an as-is architecture record. Covers static discovery (stack, entry points, routes, integrations, data model), C4 diagrams, API and external-dependency catalogs, sequence flows, deployment, security posture, and a prioritized risk register. Static analysis only: reads code, never runs it."
---

# solutions-arch-review

You are a **Senior Solutions Architect** performing a thorough, evidence-based architectural review of the codebase at the current path. Reason like someone who has to do three things from this single review: **onboard a new engineering team**, **brief a CTO**, and **plan a modernization effort**.

**Never invent facts.** Every claim is grounded in files, config, or code actually inspected, and cites its source path. Where evidence is missing, say so — an explicit gap is worth more than a confident guess.

## Prime directive

Produce a detailed, navigable analysis and write **all** outputs into a new `analysis/` folder at the repository root. **Do not modify any source file outside `analysis/`.**

## Styling and diagram delivery — delegated

**Use the `html-theme` skill** for all HTML styling and diagram output: the light-first palette with opt-in dark toggle, the no-flash pre-paint script, Mermaid configuration and `themeVariables`, and the SVG+PNG export pipeline with per-diagram download links.

Do not invent a palette or a theming approach here. If `html-theme` is unavailable, say so and apply its headline rules anyway: light by default (never `@media (prefers-color-scheme: dark)`), a persisted toggle on every page, and Mermaid initialised **inline** (an external `.js` module is CORS-blocked over `file://`).

## Phase 0 — Discovery (complete before writing anything)

Work systematically. **Do not infer the stack from folder names — verify it.**

1. **Map the repo.** Enumerate the directory tree, skipping `node_modules`, `.git`, `dist`, `build`, `vendor`, and lockfile-only dirs. Note monorepo vs single app and identify each deployable unit / service / package.
2. **Identify the stack from manifests:** `package.json`, `pom.xml`, `build.gradle`, `requirements.txt`, `pyproject.toml`, `go.mod`, `Gemfile`, `*.csproj`, `Cargo.toml`, plus lockfiles, framework config, Dockerfiles, CI files, IaC.
3. **Find entry points:** `main`/`index`/`app`, server bootstrap, CLI entry points, serverless handlers, cron and worker entry points.
4. **Locate the configuration surface:** `.env*`, config maps, `application.yml`, `appsettings.json`, feature flags. Report *what* is configured; **never print secret values**.
5. **Trace routing:** HTTP routes, GraphQL schema, gRPC services, message consumers.
6. **Trace integrations:** DB and cache clients, queue/broker SDKs, third-party SDKs, outbound HTTP, auth providers.
7. **Skim the tests** — they reveal intended behaviour and which flows are considered critical.

Build an internal inventory first. **Share a brief inventory of findings before generating artifacts**, so the shape can be corrected early.

## Required artifacts

Produce all thirteen. If the codebase genuinely lacks one (e.g. no external APIs), **still produce the page** and state *"None found — evidence:"* rather than omitting it silently.

1. **`index.html`** — landing page and navigation hub (see Navigation).
2. **Executive Summary** — purpose, primary business capability, who uses it, high-level shape, and the 5–10 most important findings. One page, readable by a non-engineer.
3. **Tech Stack & Dependencies** — languages, frameworks, runtimes, build tooling, package managers, notable libraries with versions and their role. Flag outdated, EOL, or security-sensitive dependencies where evident.
4. **Architecture Overview** — narrative plus a C4-style **Context** diagram, a C4-style **Container** diagram, and a **Component** diagram for the most important container(s).
5. **API / Endpoint Catalog** — every exposed interface. HTTP: method, path, purpose, auth requirement, summarized request/response, source file. Also GraphQL, gRPC, WebSocket channels, message topics produced or consumed, CLI commands, scheduled jobs. Tables, grouped by service or module.
6. **Consumed / External APIs** — every outbound dependency (third-party APIs, auth, payments, email, storage, LLMs), its purpose, and where it is invoked.
7. **Integrations Map** — internal (service-to-service, shared DB, events) and external integrations in one diagram plus a table. **Distinguish sync from async.**
8. **Data Model** — entities, key relationships, an ER diagram, the datastore(s) and ORM/driver, and the migrations location.
9. **Sequence Diagrams** — the 3–6 most important end-to-end flows (auth/login, the primary happy path, a webhook or async flow, a background job). Each with a step narrative and the files involved.
10. **Deployment & Infrastructure** — containerization, orchestration, cloud services, CI/CD, environments, runtime topology, and a deployment diagram where evidence exists.
11. **Security & Cross-Cutting Concerns** — authN/authZ, secrets handling, input validation, logging and observability, error handling, rate limiting, and any gaps. **Frame gaps as observations, not accusations.**
12. **Risks, Tech Debt & Recommendations** — prioritized High/Med/Low table with rationale and a suggested remediation direction. Pragmatic, not exhaustive.
13. **Glossary / Module Reference** — a brief per-module or per-service description so a newcomer can navigate the source.

## Output structure

```
analysis/
  index.html                      # navigation hub / mind map
  assets/
    styles.css                    # shared styling (per html-theme)
    diagrams/                     # exported SVG + PNG per diagram
  html/
    executive-summary.html
    tech-stack.html
    architecture.html
    api-catalog.html
    external-apis.html
    integrations.html
    data-model.html
    sequence-diagrams.html
    deployment.html
    security.html
    risks-recommendations.html
    module-reference.html
  markdown/
    executive-summary.md
    tech-stack.md
    architecture.md
    api-catalog.md
    external-apis.md
    integrations.md
    data-model.md
    sequence-diagrams.md
    deployment.md
    security.md
    risks-recommendations.md
    module-reference.md
```

### The markdown mirror rule — no judgement calls

**Every page in `html/` gets a matching file in `markdown/`. One-to-one, same basename, no exceptions.** Do not decide which pages are "text-heavy enough" to deserve a mirror — mirror all of them.

This matters because these reviews get cross-referenced against each other later, and partial markdown breaks that. In practice, ambiguity here is the single most common source of inconsistency between runs.

In the markdown mirrors: include the same diagrams as fenced ` ```mermaid ` blocks so they render on GitHub, **and** link the exported SVG/PNG beneath each one. Convert tables to Markdown tables; keep the source citations.

Filenames may be adjusted, but always keep: the `analysis/index.html` entry point, the `html/` + `markdown/` split, the shared stylesheet, and the 1:1 mirror rule.

## Navigation (`index.html`)

The hub. Requirements:

- A **Mermaid `mindmap`** (or `flowchart`) with the system name at the centre and branches to each analysis page.
- A short **"What is this system?"** blurb and a **generated-on timestamp** at the top.
- A **plain always-working link list** in addition to the diagram, so the page stays usable if a diagram fails to render. Mermaid click-binding is unreliable across versions — treat the link list as the real navigation, not a fallback afterthought.
- Every sub-page carries a **"← Back to index"** link.

## Mermaid rules

- Diagrams go in `<pre class="mermaid">` — raw syntax, not escaped, not fenced.
- **Validate before writing:** balanced brackets, no spaces in node IDs (use quoted labels), correct diagram keyword (`flowchart`, `sequenceDiagram`, `erDiagram`, `classDiagram`, `mindmap`). If `C4Context` is unstable in the pinned version, fall back to a styled `flowchart` conveying the same layers.
- **Sequence diagrams break on `;` and on colons inside `participant … as` aliases.** Keep both out of message and note text.
- Type mapping: Context/Container/Component and Integrations → `flowchart`; data model → `erDiagram`; flows → `sequenceDiagram`; index → `mindmap`.
- **Split oversized diagrams** into several focused ones rather than one unreadable mega-diagram.
- **Verify rendering** — parse every diagram (e.g. `mermaid.parse()`) before declaring done. A diagram that fails to render is invisible in a screenshot-free review.

## Quality bar

- **Evidence over assumption.** Cite source paths (`src/routes/user.ts:42`) for non-obvious claims. Mark deductions explicitly as `Inferred:`.
- **Concise but complete.** Tables for structured data (endpoints, dependencies, risks); prose for narrative.
- **No secrets.** Never output credential values, tokens, or keys — reference their existence and location only.
- **Deterministic navigation.** Every page reachable from `index.html`; every page links back.
- **Self-contained** apart from the Mermaid CDN import.

## Delivery

When finished:

1. Confirm `analysis/` exists at the repo root with all files, and that `html/` and `markdown/` counts match.
2. Verify every internal link resolves and every diagram parses.
3. Print a short summary of what was produced and the top findings.
4. **List explicitly** where evidence was insufficient, what had to be inferred, and anything skipped — including any environment limitation that prevented part of the deliverable (e.g. no headless browser for PNG export).

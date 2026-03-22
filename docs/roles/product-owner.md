# Product Owner Guide

DTF gives POs tools for ticket refinement, sprint planning, impact analysis, and requirements — without needing to touch code.

## What You Get

- **4 agents:** `po-analyst` (Opus), `requirements-analyst` (Opus), `sprint-prioritizer`, `architect`
- **1 skill:** `po-workflows`

### Default Workflow Steps

```
on-start:   📋 Impact analysis done
before-pr:  📋 Acceptance criteria written
after-pr:   📋 Stakeholders notified
```

---

## Key Commands

### `/ticket-scout` — Batch Sprint Triage
```
/ticket-scout PROJ-1234 PROJ-1235 PROJ-1236
```
- Rates complexity (1-4 story points)
- Assesses requirement quality
- Verdict: READY / REFINE / PUSH BACK / SKIP

### `/ticket-refine` — Deep Quality Gate
```
/ticket-refine PROJ-1234
```
- Pushes back on missing acceptance criteria
- Identifies domain model impact
- Maps dependencies
- Posts concrete Jira comments

### Code Insights for PRs
Even without coding, you can use `/code-insights` to understand what changed — DTO analysis with mermaid diagrams makes PR reviews easier.

---

## Agents

**po-analyst** — Bridges business needs with technical reality. Ticket refinement, sprint planning, impact analysis across services.

**requirements-analyst** — Transforms vague requests into testable user stories with Given/When/Then acceptance criteria. Finds edge cases.

**sprint-prioritizer** — Prioritizes backlog by business value, technical risk, and dependencies. Recommends sprint scope.

**architect** — Analyzes which services/components a change affects. Identifies cross-service dependencies.

---

## No Code Knowledge Needed

`/ticket-scout` and `/ticket-refine` work from Jira data only — no codebase access required. POs can run these independently.

---

## Recommended Plugins

| Plugin | What it does |
|--------|-------------|
| **anthropic-pdf** (official) | Read, extract tables from specs and contracts |
| **anthropic-xlsx** (official) | Excel analysis and charts via plain English |
| **anthropic-pptx** (official) | Create slide decks from natural language |

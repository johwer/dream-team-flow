# Marketing & Sales Guide

DTF gives marketing and sales teams AI-powered content creation, SEO optimization, presentation building, and competitive analysis — all from the same CLI developers use.

## What You Get

| | Marketing | Sales |
|--|-----------|-------|
| **Agents** | marketing-ops, content-creator, social-strategist | sales-enablement, data-analyst, insights-reporter |
| **Skills** | content-workflows + 12 marketing skills (SEO, copywriting, email, social) | presentation-workflows |

### Default Workflow Steps

**Marketing:**
```
before-push: 📋 SEO keywords checked
before-pr:   📋 Multi-language considered, 📋 Brand voice reviewed
```

**Sales:**
```
on-start:  📋 Data sources verified
before-pr: 📋 ROI calculated, 📋 Customer-specific data checked
```

---

## Marketing Agents

**marketing-ops** — Content strategy, campaigns, SEO, email marketing, content calendars.
**content-creator** — Blog posts (800-1500 words), case studies, whitepapers, email sequences.
**social-strategist** — LinkedIn thought leadership, Twitter/X, content calendars, engagement strategies.

### Marketing Skills Installed
- `marketing-content-strategy` — topic clusters, editorial calendar
- `marketing-copywriting` — headlines, CTAs, landing pages
- `marketing-email-sequence` — drip campaigns, nurture sequences
- `marketing-seo-audit` — technical SEO, Core Web Vitals
- `marketing-ai-seo` — optimize for ChatGPT/Perplexity/Claude
- `marketing-social-content` — LinkedIn, Twitter, scheduling
- `marketing-competitor-alternatives` — vs pages, battle cards
- `marketing-sales-enablement` — pitch decks, one-pagers
- `claude-seo` — 12 sub-skills: schema, E-E-A-T, Core Web Vitals

---

## Sales Agents

**sales-enablement** — Customer proposals, ROI models, competitive analysis, pitch materials.
**data-analyst** — Pull customer statistics for data-driven pitches.
**insights-reporter** — Transform data into presentation-ready narratives.

### PowerPoint Generation
```
"Create a pitch deck for a logistics company with 500 employees"
```
Uses the official `anthropic-pptx` skill for native slide generation.

---

## Recommended Plugins

| Plugin | What it does |
|--------|-------------|
| **anthropic-pptx** (official) | Slide decks from natural language |
| **anthropic-pdf** (official) | Read and extract from PDFs |
| **anthropic-brand-guidelines** (official) | Encode brand → auto-apply everywhere |
| **anthropic-docx** (official) | Word documents with formatting |

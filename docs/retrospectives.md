# Self-Learning System

Dream Team Flow has five learning channels that continuously feed knowledge into agent prompts, coding style docs, and project conventions. Some are automated, some are human-triggered — all route improvements to the right place so every future ticket benefits.

## The five learning channels

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         LEARNING SOURCES                                │
│                                                                         │
│  1. Session retros          — agents reflect after every ticket          │
│  2. PR review insights      — patterns from merged PR feedback           │
│  3. Jira pushback scraping  — learnings from AI reviewer comments        │
│  4. Research & reading      — internet articles, docs, guides             │
│  5. Retro proposals         — cross-session pattern analysis             │
│                                                                         │
└──────────────────────────┬──────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         DESTINATIONS                                    │
│                                                                         │
│  Agent prompts        ← rules baked into agent definitions              │
│  Coding style docs    ← repo docs (CODING_STYLE_BACKEND.md, etc.)      │
│  CLAUDE.md / AGENTS.md← project-level conventions                       │
│  Pre-hydrated context ← ticket-specific context files                   │
│  Skills & commands    ← improved orchestration logic                    │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 1. Session Retrospectives

**When:** End of every Dream Team session (Phase 6.75)
**Command:** Automatic — runs as part of the Dream Team workflow
**Who:** AI agents reflect, human reviews

After every ticket, agents propose improvements tagged with destinations. These accumulate in `dream-team-learnings.md`.

**What gets captured:**
- Workflow friction ("agent X should share API contracts earlier")
- Missing conventions ("no guidance on soft deletes in HCM")
- Tool gaps ("quality gate should check for unused imports")
- Pattern discoveries ("this upsert pattern should be standard")

**Example flow:**
```
Session retro → "Handlers should always use atomic upserts"
  → Tagged: repo docs (CODING_STYLE_BACKEND.md)
  → /retro-proposals creates Jira ticket + draft PR
  → Team reviews and merges
  → All future agents follow the pattern
```

---

## 2. PR Review Insights

**When:** After PRs are merged and reviewed
**Command:** [`/pr-insights`](commands.md#pr-insights)
**Who:** Human triggers, AI analyzes

Scrapes merged PR review comments to surface recurring patterns — what reviewers keep asking for, what conventions are unclear, what mistakes repeat.

**What gets captured:**
- Recurring review comments ("always add `include` for navigation properties")
- Convention gaps ("no doc on how to handle nullable DTOs")
- Quality patterns ("tests should verify both happy path and error cases")

**Example flow:**
```
/pr-insights scans last 20 merged PRs
  → Pattern: 6 PRs had "missing i18n key" comments
  → Proposes: add i18n check to quality-gate.sh
  → Proposes: add reminder to frontend agent prompt
```

---

## 3. Jira Pushback Scraping

**When:** After AI reviewers (like Solomon) comment on tickets
**Command:** [`/scrape-jira-pushback`](commands.md#scrape-jira-pushback)
**Who:** Human triggers, AI analyzes

Extracts learnings from AI ticket reviewer comments — what questions they ask, what acceptance criteria they suggest, what patterns they catch.

**What gets captured:**
- Ticket quality patterns ("tickets without ACs get 3x more review cycles")
- Domain knowledge gaps ("reviewers keep asking about permission model")
- Requirements patterns ("frontend tickets need wireframes or screenshots")

**Example flow:**
```
/scrape-jira-pushback analyzes Solomon's comments
  → Finding: Solomon catches missing eslint plugins
  → Finding: Solomon is effective on well-written tickets, empty on vague ones
  → Learning routed to /ticket-scout: flag tickets without ACs before sprint
```

---

## 4. Research & Reading

**When:** Team finds relevant articles, documentation, or guides online
**Command:** Human-driven — Claude reads the URL, extracts patterns, human approves
**Who:** Human points to the source, AI reads and extracts, human curates what to keep

This is the most powerful channel. Point Claude at an internet article, a documentation page, or a best-practice guide — it reads the content, extracts the patterns that apply to your codebase, and distributes them across the system.

**What gets captured:**
- Architecture patterns ("at-least-once delivery means handlers must be idempotent")
- Security best practices ("never sync-call services from message handlers")
- Performance patterns ("use transactional outbox for critical state changes")
- Framework-specific knowledge ("Rebus retries 5 times before error queue")

**Example flow:**
```
Human shares a microservices article URL
  → Claude reads and extracts key patterns: idempotency, no sync calls, transactional outbox
  → Creates Jira ticket for docs update (CODING_STYLE_BACKEND.md)
  → Adds critical rule to backend agent prompt
  → Pre-hydrated context includes the patterns for relevant tickets
  → Every future handler implementation follows the patterns automatically
```

**What makes this work:**
- Human identifies what to read — Claude extracts, formats, and distributes
- Learnings go to multiple destinations simultaneously (docs + prompts + context)
- Both humans and AI agents can read the same coding style docs
- The source URL is preserved in the docs for reference
- New team members inherit all accumulated knowledge on day one

---

## 5. Retro Proposals (Cross-Session Analysis)

**When:** Periodically, or when learnings accumulate
**Command:** [`/retro-proposals`](commands.md#retro-proposals)
**Who:** Human triggers, AI analyzes patterns across sessions

Analyzes accumulated retro learnings from multiple sessions to find patterns — individual session retros catch one-off issues, retro proposals catch systemic ones.

**What gets captured:**
- Cross-session patterns ("3 out of 5 sessions had Docker rebuild issues")
- Improvement priorities ("agent prompt changes have 2x impact vs doc changes")
- Workflow optimizations ("pre-hydration should include seed data status")

**Example flow:**
```
/retro-proposals analyzes last 10 session retros
  → Pattern: 4 sessions mentioned "agent didn't know about soft deletes"
  → Routes to: AGENTS.md for HCM service + backend agent prompt
  → Pattern: 2 sessions had "forgot to run quality gate"
  → Routes to: TeammateIdle hook (add quality gate reminder)
```

---

## Where learnings go

Every learning is tagged with a destination. The routing rules:

| Destination | Example | How it's applied |
|-------------|---------|-----------------|
| Agent prompts | "Every handler MUST be idempotent" | Edit agent definition in `agents/` — direct apply, then `/sync-config` |
| Coding style docs | "Message Reliability Patterns" section | Jira ticket + PR (shared repo file, team reviews) |
| CLAUDE.md / AGENTS.md | "HCM uses soft deletes" | Jira ticket + PR (shared repo file, team reviews) |
| Pre-hydrated context | "This ticket touches message handlers — see patterns" | Written by `/create-stories` during pre-hydration |
| Skills & commands | "Quality gate should check X" | Edit skill/command — direct apply, then `/sync-config` |
| Dream Team prompts | "Kenji should share API contracts earlier" | Edit command — direct apply, then `/sync-config` |

**Direct apply** — personal config files (`~/.claude/`) are edited immediately and synced with [`/sync-config`](commands.md#sync-config).

**Ticket + PR** — shared repo files that affect the whole team are never written directly. A Jira ticket and draft PR ensure the team reviews the change.

---

## The compounding effect

```
Week 1:  Agent knows your tech stack
Week 4:  Agent knows your conventions (from retros + docs)
Week 8:  Agent knows your pitfalls (from PR insights + pushback scraping)
Week 12: Agent knows your domain patterns (from research + retros)
Week 20: Agent catches mistakes before reviewers do
```

Every learning channel feeds the same destinations. A pattern discovered in a PR review, an article, and a session retro all end up in the same agent prompt — reinforcing the knowledge from multiple angles.

New team members inherit **everything** on day one. The accumulated knowledge isn't in someone's head — it's in agent prompts, coding style docs, and pre-hydrated context files that every session reads automatically.

---

## Commands reference

| Command | Learning channel | What it does |
|---------|-----------------|-------------|
| (automatic) | Session retros | Runs at end of every Dream Team session |
| [`/retro-proposals`](commands.md#retro-proposals) | Cross-session analysis | Analyzes accumulated retros, routes improvements |
| [`/pr-insights`](commands.md#pr-insights) | PR review patterns | Surfaces recurring review feedback from merged PRs |
| [`/scrape-jira-pushback`](commands.md#scrape-jira-pushback) | Jira AI reviewer | Extracts learnings from AI ticket reviewer comments |
| [`/scrape-pr-history`](commands.md#scrape-pr-history) | PR history | Extracts structured findings from merged PRs |
| [`/sync-config`](commands.md#sync-config) | All (distribution) | Pushes updated config to GitHub after direct-apply changes |

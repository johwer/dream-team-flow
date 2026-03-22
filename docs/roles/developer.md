# Developer Guide — Frontend, Backend, Fullstack

Dream Team Flow's developer workflow takes a Jira ticket from triage to merged PR with multi-agent teams, quality gates, and self-learning.

## What You Get

| | Frontend | Backend | Fullstack |
|--|----------|---------|-----------|
| **Agents** | frontend-dev, architect, pr-reviewer, api-designer, ui-designer | backend-dev, architect, pr-reviewer, api-designer, migration-planner | All 7 engineering agents |
| **Skills** | frontend-conventions, frontend-performance, tdd, playwright-cli, code-insights | backend-conventions, backend-performance, tdd, code-insights | All dev skills combined |

### Your Default Workflow Steps

**Frontend:**
```
before-commit: ⚡ ESLint check
before-push:   📋 Code insights (refactoring nudges + DTO analysis)
before-pr:     📋 Visual verification, 📋 Screenshot capture, 📋 Accessibility check
```

**Backend:**
```
before-commit: ⚡ CSharpier format
before-push:   ⚡ Run unit tests, 📋 Code insights
before-pr:     📋 Swagger validation
```

Customize anytime: `dtf steps add` / `dtf steps remove`

---

## How It Works

```
Ticket → Architect → Parallel Dev → Code Review → Test → PR → Human Review → Ship
```

1. **You say:** `/create-stories PROJ-1234 PROJ-1235`
2. **Dream Team does:**
   - Fetches all tickets from Jira and pre-analyzes them in parallel
   - Presents a recommendations table — you choose Dream Team, Lite, or Just Worktree
   - Creates git worktrees, installs deps, writes pre-hydrated context
   - Opens terminals with Claude Code sessions that start with full context
   - Spawns only the agents each ticket needs
   - Backend and frontend implement in parallel using a shared API contract
   - Creates a draft PR early so the team can follow progress
   - Runs deterministic quality gate script before every push
   - Reviews for security (OWASP) and conventions
   - Polls AI bots and CI — fixes issues with a 2-round cap
   - PR stays draft until you explicitly confirm
   - Moves ticket to Done and cleans up

### Three Modes

| Mode | When | What happens |
|------|------|-------------|
| **Full** | Complex multi-service tickets (3-4 story points) | Multi-agent team, parallel backend+frontend, full quality gates |
| **Lite** | Simple tickets (1-2 story points) | Claude decides agent usage, same quality gates |
| **Local** | Experiments, no PR/push | No worktree, no PR, zero git side effects |

```bash
/create-stories PROJ-1234                        # Full lifecycle
/my-dream-team --lite PROJ-1234                  # Lite mode
/my-dream-team --local "add loading spinner"     # Local mode
```

See **[Workflow Phases](../workflow-phases.md)** for detailed flowcharts.

---

## The Dream Team

11 personas that map to agents:

| Persona | Role | When |
|---------|------|------|
| **Amara** | Architect | Always — ticket analysis, team sizing, API contracts |
| **Kenji** | Backend Dev | When backend changes needed |
| **Ingrid** | Frontend Dev | When frontend changes needed |
| **Ravi** | Backend Dev (pool) | When 2+ backend workstreams |
| **Elsa** | Frontend Dev (pool) | When 2+ frontend workstreams |
| **Mei** | Data Engineer | Complex queries, reports, data mapping |
| **Diego** | Infra Engineer | Migrations, Docker changes |
| **Maya** | PR Reviewer | Always — security, conventions |
| **Suki** | Functional Tester | When architect flags testing |
| **Lena** | Visual Verifier | UI changes need before/after verification |
| **Tane** | Summary Writer | PR description for reviewers |

The architect dynamically sizes the team per ticket — 2-3 for simple changes, full team for complex work.

---

## Code Insights

After your first draft, say "check my changes" or `/code-insights`:

**Quick nudges** — scans only your changed files:

```
📌 UserList.tsx:42 — Async waterfall
   Now:     const user = await getUser(id); const posts = await getPosts(id);
   Better:  const [user, posts] = await Promise.all([getUser(id), getPosts(id)])
   ✅ Why:    Halves the wait time
   ⏭️ Skip if: Second call depends on first
```

React 19 aware — no useMemo/useCallback nudges (compiler handles those).

**DTO & architecture insights** — generates PR-ready content:
- DTO changes with pros/cons
- Mermaid diagrams (data flow, entity relationships, cross-service impact)
- Questions for reviewers

---

## Parallel Everything

Run as many tickets simultaneously as you want:

- Each ticket gets its own git worktree
- Docker containers with isolated ports (auto-allocated)
- Agent teams are independent, zero conflicts
- Backend + frontend work in parallel via shared API contract
- Pause overnight, resume next day — zero token cost

See **[Parallel Everything](../parallel.md)** for details.

---

## Lean by Design

| What | How | Tokens saved |
|------|-----|-------------|
| Formatting, linting, builds | `quality-gate.sh` | 100% — zero LLM tokens |
| Early triage | User decides GO/SKIP first | 100% on skipped tickets |
| Pre-hydration | Budget-capped at 30 tool uses | ~50% vs uncapped |
| Hidden reasoning | `MAX_THINKING_TOKENS: 16000` | ~70% reduction |
| Context management | Strategic compaction at boundaries | Prevents quality degradation |
| Cost visibility | `cost-tracker.sh` | Know where tokens go |
| Mode routing | Full / lite / local per ticket | Trivial tickets cost near zero |

---

## Code Review

`/review-pr` reviews any PR with line-level GitHub comments. Three depths:

| Depth | What | When |
|-------|------|------|
| **Fast** | API-only, seconds | Quick check |
| **Full** (`--full`) | Local builds + tests | Thorough check |
| **Deep** (`--deep`) | 4 parallel agents + validation pass | Critical PRs |

Combine: `--deep --full` for maximum thoroughness. False positives are filtered by a validation agent.

---

## Self-Learning

Your codebase conventions live in the system, not someone's head:

- Backend: `docs/CODING_STYLE_BACKEND.md`, `docs/API_CONVENTIONS.md`
- Frontend: `docs/CODING_STYLE_FRONTEND.md`, `docs/FRONTEND_COMPONENTS.md`
- Agents read these via skills — each dev gets only the rules relevant to their work

Every session's retro feeds improvements back. New team members inherit everything on day one.

---

## Recommended Plugins

| Plugin | What it does |
|--------|-------------|
| **typescript-lsp** | TypeScript code intelligence (official) |
| **csharp-lsp** | C# code intelligence (official) |
| **Vercel React Best Practices** (21k stars) | 45 rules: async waterfalls, bundle size, re-renders |
| **dotnet-skills** (658 stars) | 30 skills + 5 agents: EF Core, DI, concurrency |
| **code-review-skill** (159 stars) | React 19, TypeScript, perf, security guides |
| **Trail of Bits security** (3.8k stars) | Diff-scoped security analysis |
| **frontend-design** | Bold aesthetic direction before writing UI (official) |

See **[dtf-roles.md](../../docs/dtf-roles.md)** for full plugin catalog.

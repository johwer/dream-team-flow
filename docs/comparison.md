# Best-in-Class Comparison

How Dream Team Flow stacks up against the three leading approaches to AI-assisted software development.

| | **Stripe Minions** | **Claude Code Best Practices** | **Everything Claude Code (ECC)** | **Dream Team Flow** |
|---|---|---|---|---|
| | 1,300+ PRs/week at Stripe | Anthropic's official patterns | 50K+ stars, community toolkit | This project |

---

## Architecture & Orchestration

| Capability | Stripe | Claude Docs | ECC | DTF |
|---|---|---|---|---|
| **Orchestration model** | Blueprints (state machines mixing deterministic + agentic nodes) | Writer/Reviewer pattern, fan-out, subagent investigation | 6 autonomous loop patterns (sequential, NanoClaw, infinite, PR loop, de-sloppify, RFC-DAG) | Named multi-agent team with phase-based workflow (11 agents, 7+ phases) |
| **Agent isolation** | Full devbox per agent (EC2, 10s spin-up) | Separate context windows via subagents | Worktree isolation via `devfleet` MCP | Git worktrees with isolated ports, Docker containers per worktree |
| **Parallel execution** | ~6 concurrent minions per engineer | Fan-out with `claude -p` in loops | Parallel agents via Task tool | Parallel backend + frontend within ticket, unlimited parallel tickets via `/create-stories` (each in its own worktree + Docker stack) |
| **Deterministic nodes** | Core concept — git, lint, CI as code nodes, zero LLM tokens | Mentioned (hooks, CLI tools) | `quality-gate` hooks, formatters as PostToolUse | `quality-gate.sh`, `poll-ci-checks.sh`, `poll-ai-reviews.sh` — all shell scripts, zero tokens |
| **Human-in-the-loop** | Mandatory PR review, no interactive loop | Interview pattern, verification | No interactive loop (fire-and-forget) | Draft PR → AI review → user confirms → mark ready. User stays in control throughout |
| **Crash recovery** | Stateless (devboxes are disposable, retry from scratch) | Checkpoints via Esc+Esc, `/rewind` | Session state persistence at Stop hook | Agent notes on disk, `--resume` flag, workspace pause/resume |

## Context Management

| Capability | Stripe | Claude Docs | ECC | DTF |
|---|---|---|---|---|
| **Context hydration** | Pre-flight MCP tools fetch ticket, docs, code search before agent starts | `@` file references, pipe data, URL fetching | `iterative-retrieval` skill (4-phase DISPATCH-EVALUATE-REFINE-LOOP) | Pre-hydration agents analyze all GO tickets in parallel → `.dream-team/context.md` |
| **Rule file scoping** | Directory-scoped rules (Cursor format), conditionally applied | CLAUDE.md hierarchy (global → project → subdirectory) | 34 always-on rules + language-specific | CLAUDE.md hierarchy + on-demand skills (loaded only when needed) |
| **Context window strategy** | Disposable (fresh devbox per run, no compaction needed) | `/clear`, `/compact`, auto-compaction, subagents for investigation | `strategic-compact` skill, `suggest-compact` hook at 50 tool calls | `strategic-compact` skill with phase-specific compact points, `PreCompact` hook saves checkpoint |
| **Context modes** | N/A (unattended, no mode switching) | Explore-Plan-Implement-Commit (4 phases) | 3 modes: dev, review, research (injectable prompts) | 3 modes: dev, review, research (auto-activate per command) |
| **CLAUDE.md philosophy** | "Walls matter more than the model" — rules prevent failures | Keep short, prune ruthlessly, move heavy docs to skills | Always-on rules (34 files) — different philosophy | Small CLAUDE.md as table of contents, heavy docs in skills (on-demand loading) |

## Code Review

| Capability | Stripe | Claude Docs | ECC | DTF |
|---|---|---|---|---|
| **Review approach** | Mandatory human review on every PR (no AI review step) | Writer/Reviewer pattern (two sessions) | `code-reviewer` agent with tiered severity, confidence >80% threshold | `/review-pr` with 3 depth levels: fast, full, deep |
| **Multi-agent review** | No (single human reviewer) | Subagent review as verification step | Single `code-reviewer` agent | `--deep`: 4 parallel agents (2x convention, 2x bug/security) + validation pass |
| **False positive filtering** | N/A (human review) | N/A | Confidence scoring (0-100, threshold 80) | Independent validation agents per finding — CONFIRMED or REJECTED |
| **Security scanning** | Not described (likely internal tooling) | Mentioned as custom subagent pattern | `AgentShield` (1282 tests, 102 rules), `security-review` skill | 7-category OWASP scan built into every review (injection, auth, data exposure, XSS, path traversal, secrets, insecure defaults) |
| **Local build verification** | Yes (devbox has full build env) | Not as part of review | No | `--full` mode: `dotnet build`, `tsc --noEmit`, `eslint`, `vitest` in temp worktree |
| **Posts to GitHub** | PR created by minion, reviewed by human | Not built-in | With `--comment` flag | Always — inline comments with APPROVE/REQUEST_CHANGES, user confirms before posting |

## Quality Gates & Testing

| Capability | Stripe | Claude Docs | ECC | DTF |
|---|---|---|---|---|
| **Local linting** | Sub-second cached lint daemon, pre-push hooks | Hooks for auto-formatting | `plankton-code-quality` PostToolUse hooks (20+ linters) | `quality-gate.sh` (CSharpier, Prettier, ESLint, tsc, dotnet build) — deterministic, zero tokens |
| **CI iteration cap** | 2 rounds max, then hand to human | After 2 failed corrections, `/clear` and restart | Not mentioned | 2 rounds max, then escalate to user |
| **Visual verification** | Not described | Chrome extension for UI testing | Playwright MCP server | Playwright e2e tests with reproducible screenshots, co-located with components |
| **De-sloppify pass** | Not described | Not described | De-sloppify pattern (cleanup pass removing over-engineering) | Phase 4.9: cleanup pass before commit (8 categories of agent-introduced bloat) |
| **Test strategy** | 3+ million tests, selective runs, autofixes | "Provide verification criteria" — tests as verification | TDD-first with `tdd-guide` agent, 80%+ coverage mandatory | Functional testing (Suki) when architect flags it, Playwright e2e for UI, existing test suites |

## Cost & Token Optimization

| Capability | Stripe | Claude Docs | ECC | DTF |
|---|---|---|---|---|
| **Cost philosophy** | Devboxes are cheap; token savings via deterministic nodes | Context is the bottleneck — manage it aggressively | Haiku for subagents, Sonnet default, Opus for deep reasoning. Budget tracking. | Sonnet for devs, Opus for architect/reviewer. Deterministic scripts for mechanical work. |
| **Token optimization** | Conditional rule scoping, deterministic nodes | Short CLAUDE.md, skills on-demand, `/clear` between tasks | `MAX_THINKING_TOKENS: 10000`, `AUTOCOMPACT: 50%`, `SUBAGENT_MODEL: haiku` | `MAX_THINKING_TOKENS: 16000`, `AUTOCOMPACT: 50%`. No haiku for devs (4% write failure rate). |
| **Cost tracking** | Not described (likely internal dashboards) | `/cost` command | `cost-aware-llm-pipeline` skill with budget tracking | `cost-tracker.sh` (per-session reports), `phase-cost-tracker.sh` (per-phase trends) |
| **Budget caps** | 2-round CI cap bounds compute | "After 2 failed corrections, clear and restart" | Immutable budget tracking in cost-aware pipeline | Pre-hydration: 30 tool use cap. CI: 2-round cap. Early triage: user kills tickets before tokens spent. |
| **Tool scoping** | ~15 tools per agent from 500+ toolshed | `--allowedTools` flag for headless mode | Recommends <10 MCPs, <80 tools active | Prompt-level tool scoping per agent role |

## Learning & Adaptation

| Capability | Stripe | Claude Docs | ECC | DTF |
|---|---|---|---|---|
| **Self-learning** | Rule files updated manually by teams | CLAUDE.md iteration — "observe behavior, refine" | `continuous-learning-v2`: hooks capture patterns → instincts → `/evolve` to promote | 6 learning paths: retros, PR mining, Jira pushback, tool usage patterns, research, cross-session analysis |
| **Knowledge persistence** | Rule files in repo (shared via git) | CLAUDE.md + memory (200 lines, auto-loaded) | Instincts with confidence scores, project-scoped | Memory (auto-loaded) + skills (on-demand) + disk-based agent notes + dream-team-history.json |
| **Convention delivery** | Directory-scoped rule files, shared with Cursor/Claude Code | CLAUDE.md hierarchy | 34 always-on rules + language-specific directories | CLAUDE.md (small) → skills (on-demand, 8 skill packs) → agent prompts (role-specific conventions summary) |

## Team & Deployment

| Capability | Stripe | Claude Docs | ECC | DTF |
|---|---|---|---|---|
| **Team setup** | Custom internal infrastructure, forked from Goose | N/A (individual tool) | Plugin install: `/plugin marketplace add` | `dtf install` with company-config for team-wide deployment |
| **Config distribution** | Internal repo + rule files in monorepo | Git-committed CLAUDE.md | Plugin marketplace (community installable) | 3 repos: DTF (docs), marketplace (public, sanitized), marketplace-private (team, real names) |
| **Cross-platform** | Internal only | Claude Code CLI (macOS, Linux, WSL) | Claude Code + Cursor + OpenAI Codex + OpenCode | Claude Code only (10 terminals supported) |
| **Entry points** | Slack (primary), CLI, web, integrations | CLI, IDE extensions | CLI only | CLI (`/create-stories`, `/my-dream-team`), Jira integration, GitHub Actions |

---

## What Each Does Best

### Stripe Minions
- **Devbox isolation** — Fresh, pre-warmed EC2 in 10 seconds beats git worktrees
- **500-tool MCP toolshed** — Deep internal system integration (feature flags, docs, build systems)
- **Sub-second lint feedback** — Cached daemon instead of running linters per-edit
- **Scale** — 1,300+ PRs/week, 3M+ test suite, ~6 concurrent agents per engineer
- **"Walls > model"** — Philosophy that guardrails compound into system-wide reliability

### Claude Code Best Practices
- **Interview pattern** — Have Claude interview you before implementing (surfaces unknowns)
- **Verification as #1 principle** — "If you can't verify it, don't ship it"
- **Context anti-patterns** — Named failure modes (kitchen sink, infinite exploration, trust-then-verify gap)
- **CLAUDE.md pruning test** — "Would removing this cause mistakes? If not, cut it."

### Everything Claude Code (ECC)
- **108 skills** across every language and framework — massive breadth
- **Continuous learning with instincts** — Automatic pattern detection from tool usage
- **Cross-platform** — Same patterns work in Cursor, Codex, OpenCode
- **AgentShield** — 1282-test security scanner for the config itself

### Dream Team Flow
- **Named multi-agent team** — 11 personas with structured communication, task ownership, deadlock detection
- **6 learning paths** — Most comprehensive learning loop (retros + PR mining + Jira + tool usage + research + cross-session)
- **Interactive user control** — Draft PR → user confirms at every gate → never auto-ships
- **Deep PR review** — Only system with multi-agent review + independent validation + local builds + OWASP + file filtering
- **Company-specific deployment** — One-command team install with company config de-sanitization
- **Visual verification** — Playwright e2e tests as reproducible proof, co-located screenshots

---

## Ideas to Steal Next

| From | Idea | Effort | Impact |
|---|---|---|---|
| Stripe | **Sub-second lint daemon** — cached background process instead of running linters per-edit | High (needs custom daemon) | Medium (saves seconds per edit, adds up) |
| Stripe | **Selective test runs** — run only tests affected by changed files, not full suite | Medium (need test dependency graph) | High (faster CI, cheaper) |
| Stripe | **Pre-warmed environments** — Docker images with pre-built dependencies, cached builds | Medium (Docker layer caching) | High (faster worktree startup) |
| Claude Docs | **Interview pattern** — Claude interviews user before complex features, writes spec first | Low (prompt change) | High (surfaces unknowns early) |
| Claude Docs | **Explore-Plan-Implement-Commit** as explicit mode switching (not just context modes) | Low (prompt change) | Medium (cleaner phase transitions) |
| ECC | **AgentShield for config** — scan CLAUDE.md, settings, MCP, hooks for security issues | Done ✅ (`config-scan.sh`) | — |
| ECC | **Continuous learning instincts** | Done ✅ (`analyze-patterns.sh` + `/evolve`) | — |
| ECC | **TDD-first enforcement** — dedicated TDD agent that enforces RED-GREEN-REFACTOR | Medium (new agent definition) | Medium (better test quality) |

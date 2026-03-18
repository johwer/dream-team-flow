# Best-in-Class Comparison

How Dream Team Flow stacks up against the three leading approaches to AI-assisted software development.

| | **Stripe Minions** | **Claude Code Best Practices** | **Everything Claude Code (ECC)** | **Dream Team Flow** |
|---|---|---|---|---|
| | 1,300+ PRs/week at Stripe | Anthropic's official patterns | 50K+ stars, community toolkit | This project |

---

## Architecture & Orchestration

| Capability | Stripe | Claude Docs | ECC | DTF |
|---|---|---|---|---|
| **Orchestration model** | Blueprints (state machines mixing deterministic + agentic nodes) | Writer/Reviewer pattern, fan-out, subagent investigation | 6 autonomous loop patterns (sequential, NanoClaw, infinite, PR loop, de-sloppify, RFC-DAG) | Phase-based workflow (like Stripe blueprints) with named multi-agent team (11 agents). Deterministic nodes (`quality-gate.sh`, CI polling) interleaved with agentic phases (architecture, implementation, review). |
| **Agent isolation** | Full devbox per agent (EC2, 10s spin-up) | Separate context windows via subagents | Worktree isolation via `devfleet` MCP | Git worktrees with isolated ports + Docker containers per worktree (like Stripe devboxes, but local). Each agent has its own context window. |
| **Parallel execution** | ~6 concurrent minions per engineer | Fan-out with `claude -p` in loops | Parallel agents via Task tool | Unlimited parallel tickets via `/create-stories` (each in its own worktree + Docker stack) + parallel backend + frontend within each ticket. No artificial cap. |
| **Deterministic nodes** | Core concept — git, lint, CI as code nodes, zero LLM tokens | Mentioned (hooks, CLI tools) | `quality-gate` hooks, formatters as PostToolUse | Same philosophy as Stripe: `quality-gate.sh`, `poll-ci-checks.sh`, `poll-ai-reviews.sh`, `allocate-ports.sh` as shell scripts (zero tokens). Plus hooks that serve double duty: enforcement (migration guard, lock file guard, idle gate, task completed gate) AND learning capture (`tool-usage-log.sh` logs every tool call, idle/completed gates force journal entries that feed retros). |
| **Human-in-the-loop** | Mandatory PR review, no interactive loop during work | Interview pattern (pre-implementation), verification (post) | No interactive loop (fire-and-forget) | Both Stripe's mandatory review AND Claude Docs' interview approach: early triage checkpoint (Step 1.5) + draft PR → AI review → user confirms → mark ready. User stays in control at every gate. |
| **Crash recovery** | Stateless (devboxes are disposable, retry from scratch) | Checkpoints via Esc+Esc, `/rewind` | Session state persistence at Stop hook | All three: agent notes on disk (like ECC's persistence) + `--resume` rebuilds from notes/git/PR/Jira + `PreCompact` hook saves checkpoints (like Claude Docs). Plus workspace pause/resume for overnight stops. |

## Context Management

| Capability | Stripe | Claude Docs | ECC | DTF |
|---|---|---|---|---|
| **Context hydration** | Pre-flight MCP tools fetch ticket, docs, code search before agent starts | `@` file references, pipe data, URL fetching | `iterative-retrieval` skill (4-phase DISPATCH-EVALUATE-REFINE-LOOP) | Stripe-style pre-flight: Jira fetch → early triage (user decides GO/SKIP before tokens spent) → parallel pre-hydration agents → `.dream-team/context.md`. Budget-capped at 30 tool uses per ticket. |
| **Rule file scoping** | Directory-scoped rules (Cursor format), conditionally applied | CLAUDE.md hierarchy (global → project → subdirectory) | 34 always-on rules + language-specific | Claude Docs hierarchy (global → project → subdirectory) + ECC-style on-demand loading via skills. Best of both: rules that matter always load, heavy conventions load only when needed. |
| **Context window strategy** | Disposable (fresh devbox per run, no compaction needed) | `/clear`, `/compact`, auto-compaction, subagents for investigation | `strategic-compact` skill, `suggest-compact` hook at 50 tool calls | ECC-style strategic compaction (phase-specific compact points) + Claude Docs' `/compact` + `PreCompact` hook auto-saves checkpoint. Phase boundaries defined per Dream Team workflow. |
| **Context modes** | N/A (unattended, no mode switching) | Explore-Plan-Implement-Commit (4 phases) | 3 modes: dev, review, research (injectable prompts) | ECC's 3 modes (dev/review/research) that auto-activate per command (`/my-dream-team` → dev, `/review-pr` → review, `/ticket-refine` → research). Plus Claude Docs' phase transitions within Dream Team workflow. |
| **CLAUDE.md philosophy** | "Walls matter more than the model" — rules prevent failures | Keep short, prune ruthlessly, move heavy docs to skills | Always-on rules (34 files) — different philosophy | Claude Docs' "small CLAUDE.md as table of contents" + Stripe's "walls > model" via hooks that enforce non-negotiably. Skills carry the heavy docs (ECC-style on-demand loading) while hooks guarantee compliance (Stripe-style deterministic enforcement). |

## Code Review

| Capability | Stripe | Claude Docs | ECC | DTF |
|---|---|---|---|---|
| **Review approach** | Mandatory human review on every PR (no AI review step) | Writer/Reviewer pattern (two sessions) | `code-reviewer` agent with tiered severity, confidence >80% threshold | All three combined: AI review (Maya or `--deep` multi-agent) + mandatory human review (like Stripe) + Writer/Reviewer separation (like Claude Docs — devs write, Maya reviews with fresh context) |
| **Multi-agent review** | No (single human reviewer) | Subagent review as verification step | Single `code-reviewer` agent | `--deep`: 4 parallel agents (2x Sonnet convention, 2x Opus bug/security) + N validation agents. More thorough than any single system. |
| **False positive filtering** | N/A (human review) | N/A | Confidence scoring (0-100, threshold 80) | Goes beyond ECC's scoring: independent validation agents per finding return CONFIRMED or REJECTED with reasoning. Binary gate is more reliable than a threshold score. |
| **Security scanning** | Not described (likely internal tooling) | Mentioned as custom subagent pattern | `AgentShield` (1282 tests, 102 rules), `security-review` skill | 7-category OWASP scan built into every review (injection, auth, data exposure, XSS, path traversal, secrets, insecure defaults). Plus `config-scan.sh` for the config itself (like ECC's AgentShield). |
| **Local build verification** | Yes (devbox has full build env) | Not as part of review | No | Like Stripe: `--full` mode checks out branch in temp worktree, runs `dotnet build`, `tsc --noEmit`, `eslint`, `vitest`. Auto-cleanup on exit. |
| **Posts to GitHub** | PR created by minion, reviewed by human | Not built-in | With `--comment` flag | Inline comments with APPROVE/REQUEST_CHANGES/COMMENT, always with user confirmation before posting. Human-in-the-loop that Stripe and ECC lack on the AI review step. |

## Quality Gates & Testing

| Capability | Stripe | Claude Docs | ECC | DTF |
|---|---|---|---|---|
| **Local linting** | Sub-second cached lint daemon, pre-push hooks | Hooks for auto-formatting | `plankton-code-quality` PostToolUse hooks (20+ linters) | Stripe-style deterministic script (`quality-gate.sh`: CSharpier, Prettier, ESLint, tsc, dotnet build — zero tokens) + ECC-style hooks (auto-lint reminder on every Edit/Write). |
| **CI iteration cap** | 2 rounds max, then hand to human | After 2 failed corrections, `/clear` and restart | Not mentioned | Same as Stripe: 2 rounds max, then escalate to user. Explicit in both `/my-dream-team` and `dev-workflow-checklist.md`. |
| **Visual verification** | Not described | Chrome extension for UI testing (screenshots, iteration) | Playwright MCP server | Beyond Claude Docs' Chrome extension: Playwright e2e tests that generate reproducible screenshots, co-located with components in `__screenshots__/`. Tests ARE the verification — anyone can re-run them. Visual regression baselines via `toHaveScreenshot()`. |
| **De-sloppify pass** | Not described | Not described | De-sloppify pattern (cleanup pass removing over-engineering) | ECC's concept, formalized: Phase 4.9 with 8 specific categories of agent-introduced bloat (unnecessary null checks, over-engineered error handling, redundant tests, dead code, premature abstractions, unnecessary type assertions, unnecessary comments, verbose patterns). |
| **Test strategy** | 3+ million tests, selective runs, autofixes | "Provide verification criteria" — tests as verification | TDD-first with `tdd-guide` agent, 80%+ coverage mandatory | Functional testing (Suki) when architect flags it + Playwright e2e for all UI changes + existing test suites. Not TDD-first like ECC, but verification-driven like Claude Docs. |

## Cost & Token Optimization

| Capability | Stripe | Claude Docs | ECC | DTF |
|---|---|---|---|---|
| **Cost philosophy** | Devboxes are cheap; token savings via deterministic nodes | Context is the bottleneck — manage it aggressively | Haiku for subagents, Sonnet default, Opus for deep reasoning. Budget tracking. | All three: Stripe-style deterministic nodes (zero-token scripts) + Claude Docs' aggressive context management (strategic compaction, on-demand skills) + ECC-style model routing (Sonnet for devs, Opus for architect/reviewer). Plus early triage checkpoint to kill tickets before tokens are spent. |
| **Token optimization** | Conditional rule scoping, deterministic nodes | Short CLAUDE.md, skills on-demand, `/clear` between tasks | `MAX_THINKING_TOKENS: 10000`, `AUTOCOMPACT: 50%`, `SUBAGENT_MODEL: haiku` | ECC's token caps (`MAX_THINKING_TOKENS: 16000`, `AUTOCOMPACT: 50%`) + Claude Docs' on-demand skills + Stripe's deterministic nodes. No haiku for devs (4% write failure rate confirmed). |
| **Cost tracking** | Not described (likely internal dashboards) | `/cost` command | `cost-aware-llm-pipeline` skill with budget tracking | Beyond ECC: `cost-tracker.sh` (per-session reports with relative units per tool) + `phase-cost-tracker.sh` (per-phase trends across sessions — compare architecture vs implementation vs review costs). |
| **Budget caps** | 2-round CI cap bounds compute | "After 2 failed corrections, clear and restart" | Immutable budget tracking in cost-aware pipeline | Stripe's CI cap (2 rounds) + ECC's budget tracking + DTF-original early triage (user kills tickets before tokens spent) + pre-hydration cap (30 tool uses per agent). Multiple layers. |
| **Tool scoping** | ~15 tools per agent from 500+ toolshed | `--allowedTools` flag for headless mode | Recommends <10 MCPs, <80 tools active | Prompt-level tool scoping per agent role (like Stripe's curated subsets). No MCP overhead (zero MCP servers — unlike ECC's 24). |

## Learning & Adaptation

| Capability | Stripe | Claude Docs | ECC | DTF |
|---|---|---|---|---|
| **Self-learning** | Rule files updated manually by teams | CLAUDE.md iteration — "observe behavior, refine" | `continuous-learning-v2`: hooks capture patterns → instincts → `/evolve` to promote | Hooks serve double duty — enforcement AND learning. `tool-usage-log.sh` (PostToolUse) captures every tool call automatically. `TeammateIdle` + `TaskCompleted` hooks force agents to write journal entries. This feeds into: hooks capture → `analyze-patterns.sh` → `/evolve` → promote to skills, conventions, scripts, or memory. Plus 5 additional paths: session retros, PR mining, Jira pushback, research articles, cross-session analysis. 6 paths total — most comprehensive learning loop of any system. |
| **Knowledge persistence** | Rule files in repo (shared via git) | CLAUDE.md + memory (200 lines, auto-loaded) | Instincts with confidence scores, project-scoped | All three: git-committed conventions (Stripe) + auto-loaded memory (Claude Docs) + project-scoped instincts (ECC) + disk-based agent notes + `dream-team-history.json` for session metrics. |
| **Convention delivery** | Directory-scoped rule files, shared with Cursor/Claude Code | CLAUDE.md hierarchy | 34 always-on rules + language-specific directories | Three-layer delivery: CLAUDE.md as index (Claude Docs' philosophy) → skills on-demand (8 skill packs, heavy conventions) → agent prompts (role-specific conventions summary from Amara). Each agent gets only the rules relevant to their work. |

## Team & Deployment

| Capability | Stripe | Claude Docs | ECC | DTF |
|---|---|---|---|---|
| **Team setup** | Custom internal infrastructure, forked from Goose | N/A (individual tool) | Plugin install: `/plugin marketplace add` | ECC-style plugin marketplace + DTF-original company-config: `dtf install` de-sanitizes generic names → real company names. One command, 5 minutes to full setup. |
| **Config distribution** | Internal repo + rule files in monorepo | Git-committed CLAUDE.md | Plugin marketplace (community installable) | 3 repos: DTF (docs + CLI), marketplace (public, sanitized for community), marketplace-private (team, real names). Both ECC's plugin model and Stripe's internal-repo model. |
| **Cross-platform** | Internal only | Claude Code CLI (macOS, Linux, WSL) | Claude Code + Cursor + OpenAI Codex + OpenCode | Claude Code only (10 terminals supported). Not cross-platform like ECC, but deeper integration with one platform. |
| **Entry points** | Slack (primary), CLI, web, integrations | CLI, IDE extensions | CLI only | CLI (`/create-stories`, `/my-dream-team`) + Jira integration (ACLI) + GitHub Actions (`@claude` in PRs). More entry points than ECC, fewer than Stripe. |

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
- **It's the flow, not the agents** — Agents are interchangeable. The orchestration (triage → hydrate → implement → verify → ship), quality gates (hooks that can't be bypassed), and learning loops (hooks capture → analyze → promote → skills, conventions, scripts, or memory) are what compound over time. The team is a small part of a much bigger system.
- **Learning is the mantra** — 6 paths feed improvements back automatically: session retros, PR mining, Jira pushback, tool usage patterns, research articles, cross-session analysis. Hooks serve double duty — enforcement AND learning capture. Every session makes the next one better.
- **The user stays in control** — Early triage checkpoint (user decides before tokens are spent) + draft PRs + human-in-the-loop at every gate. AI proposes, human disposes. Never auto-ships.
- **Combines the best of all three** — Stripe's deterministic nodes and "walls > model" philosophy + Claude Docs' verification-first approach and CLAUDE.md hygiene + ECC's continuous learning and context management. Not reinvented — assembled from proven patterns.
- **Deep PR review** — Only system with multi-agent review + independent validation + local builds + OWASP + file filtering + human-in-the-loop
- **Company-specific deployment** — One-command team install with company config de-sanitization. 5 minutes from zero to full setup.

---

## Ideas to Steal Next

| From | Idea | Effort | Impact |
|---|---|---|---|
| Stripe | **Sub-second lint daemon** — cached background process instead of running linters per-edit | High (needs custom daemon) | Medium (saves seconds per edit, adds up) |
| Stripe | **Selective test runs** — run only tests affected by changed files, not full suite | Medium (need test dependency graph) | High (faster CI, cheaper) |
| Stripe | **Pre-warmed environments** — Docker images with pre-built dependencies, cached builds | Partially done ✅ (worktrees created parallel with pre-hydration, npm i runs in background) | Remaining: Docker layer caching for faster container rebuilds |
| Claude Docs | **Interview pattern** — Claude interviews user before complex features, writes spec first | Done ✅ (`--interview` flag) | — |
| Claude Docs | **Explore-Plan-Implement-Commit** as explicit mode switching (not just context modes) | Done ✅ (lite mode phase gates) | — |
| ECC | **AgentShield for config** — scan CLAUDE.md, settings, MCP, hooks for security issues | Done ✅ (`config-scan.sh`) | — |
| ECC | **Continuous learning instincts** | Done ✅ (`analyze-patterns.sh` + `/evolve`) | — |
| ECC | **TDD-first enforcement** — dedicated TDD agent that enforces RED-GREEN-REFACTOR | Done ✅ (`/tdd` skill — confirms interface → red → green → refactor, auto-detects Vitest vs xUnit) | — |
| Community (mattpocock) | **Triage-issue** — codebase exploration → root cause → TDD fix plan → Jira ticket | Done ✅ (`/triage-issue` skill) | — |
| Community (mattpocock) | **Design-an-interface** — "Design It Twice": 3 parallel sub-agents with different constraints, pick the best | Done ✅ (`/design-an-interface` skill) | — |
| Community (mattpocock) | **Request-refactor-plan** — interview → codebase verify → tiny commits → Jira ticket | Done ✅ (`/request-refactor-plan` skill) | — |
| Community (mattpocock) | **Improve-codebase-architecture** — P1/P2 audit for confusing boundaries, shallow modules, tight coupling | Done ✅ (`/improve-codebase-architecture` skill) | — |
| Community (aihero.dev) | **Grill-me** — design-tree interview to flesh out ideas before writing code or tickets | Done ✅ (`/grill-me` skill — marketplace only, not wired into main flow) | — |
| Stripe | **Sub-second lint daemon** — cached background process instead of running linters per-edit | High (needs custom daemon) | Medium (saves seconds per edit, adds up) |
| Stripe | **Selective test runs** — run only tests affected by changed files, not full suite | Medium (need test dependency graph) | High (faster CI, cheaper) |

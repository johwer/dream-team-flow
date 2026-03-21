```
██████╗ ██████╗ ███████╗ █████╗ ███╗   ███╗    ████████╗███████╗ █████╗ ███╗   ███╗
██╔══██╗██╔══██╗██╔════╝██╔══██╗████╗ ████║    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
██║  ██║██████╔╝█████╗  ███████║██╔████╔██║       ██║   █████╗  ███████║██╔████╔██║
██║  ██║██╔══██╗██╔══╝  ██╔══██║██║╚██╔╝██║       ██║   ██╔══╝  ██╔══██║██║╚██╔╝██║
██████╔╝██║  ██║███████╗██║  ██║██║ ╚═╝ ██║       ██║   ███████╗██║  ██║██║ ╚═╝ ██║
╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝       ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝

                              F   L   O   W
                                              ╔══════════╗
                                              ║   BETA   ║
                                              ╚══════════╝
```

> **Beta** — Actively developed and used in production, but expect breaking changes between updates. Feedback and contributions welcome.

## Why DTF?

Claude Code is powerful out of the box. But running it on real tickets across a team exposes three gaps:

1. **No memory between sessions.** Claude makes the same mistakes twice. Your conventions live in your head, not in the system.
2. **No structure at scale.** Running 5 tickets in parallel with raw Claude means 5 sessions that don't coordinate, don't share learnings, and burn tokens on work that should be deterministic.
3. **No guardrails you can trust.** Claude can ignore a CLAUDE.md instruction. It can skip a step. When agents run unattended, "best effort" isn't enough.

Dream Team Flow fills these gaps with **a flow that learns, scales, and enforces** — built entirely on Claude Code's native architecture (subagents, hooks, tasks, structured tool use). No wrappers, no middleware, no vendor lock-in.

**The flow is the product, not the agents.** Agents are interchangeable. What compounds over time is the orchestration (triage → hydrate → implement → verify → ship), the quality gates (hooks that can't be bypassed), and the learning loops (hooks capture → analyze → promote → skills, conventions, scripts, or memory).

**Every session makes the next one better.** 6 learning paths feed improvements back automatically. The same mistake never happens twice.

**The user stays in control.** Early triage before tokens are spent. Draft PRs. Human-in-the-loop at every gate. AI proposes, human disposes.

### [Self-learning — the same mistake never happens twice](#adapt-to-your-codebase)

Hooks capture data automatically. 6 learning paths feed improvements back into agent prompts, coding style docs, and pre-hydrated context:

| Path | Source | Destination |
|------|--------|-------------|
| Session retros | Agents reflect after every ticket | Agent prompts, conventions |
| PR review mining | Patterns from merged PR feedback | Convention updates, review templates |
| Jira pushback | AI reviewer comment analysis | Ticket triage rules |
| Tool usage patterns | `hooks capture → analyze → promote` | Skills, conventions, scripts, or memory |
| Research & reading | Articles, docs, best-practice guides | Backend/frontend conventions |
| Cross-session analysis | Pattern detection across all retros | Process improvements |

Agents that just know "React + .NET" produce generic code. Agents that know **your** serialization gotchas, **your** idempotency rules, **your** permission model produce code that passes review on the first try.

### [Parallel everything — your review capacity is the bottleneck, not code](docs/parallel.md)

Run as many tickets simultaneously as you want. Each ticket gets its own git worktree, its own Docker containers with isolated ports, and its own agent team — completely independent, zero conflicts. Backend and frontend agents work in parallel within each ticket via a shared API contract. Pause overnight, resume the next day from disk — zero token cost between sessions.

### [Lean by design — cut your AI spend, not your output](docs/token-efficiency.md)

| What | How | Tokens saved |
|------|-----|-------------|
| Formatting, linting, builds | `quality-gate.sh` (shell script) | 100% — zero LLM tokens |
| Early triage | User decides GO/SKIP before agents run | 100% on skipped tickets |
| Pre-hydration | Budget-capped at 30 tool uses per ticket | ~50% vs uncapped |
| Hidden reasoning | `MAX_THINKING_TOKENS: 16000` | ~70% reduction |
| Context management | Strategic compaction at phase boundaries | Prevents quality degradation |
| Cost visibility | `cost-tracker.sh` + `phase-cost-tracker.sh` | Know exactly where tokens go |
| Mode routing | Full team / lite / local per ticket | Trivial tickets cost near zero |

### [Built for teams — onboard in minutes, not days](docs/built-for-teams.md)

One command to install, role-based setup, customizable workflow steps. `company-config.json` auto-configures service names, Jira domain, paths, and role definitions. 12 roles: Developer (Frontend/Backend/Fullstack), Data Engineer, Data Analyst, Infra/DevOps, QA/Tester, UAT Stakeholder, Product Owner, Sales, Marketing, Customer Operations. Each role gets tailored agents, skills, and default workflow steps. `dtf configure` lets existing users add their role anytime. `dtf steps` manages personal workflow steps (automated checks + reminders).

### [Secure by default — compliance without slowing down](SECURITY.md)

Every PR gets a 7-category OWASP security scan before it reaches a human reviewer. Schema changes require Mermaid diagrams and explicit human approval — agents cannot autonomously change your data model. Quality hooks physically prevent agents from skipping steps.

Three-tier permission ladder — personal sandbox, shared standards, team-enforced lockdown. For regulated industries, security review and change governance are built into the pipeline, not bolted on after.

### [Code review that filters its own false positives](docs/review-modes.md)

Most AI code review produces a wall of findings — some real, some noise. DTF's `/review-pr --deep` solves this:

1. **4 parallel agents** review the PR (2x convention on Sonnet, 2x bug/security on Opus)
2. **Every finding gets independently verified** by a fresh validation agent
3. **Only confirmed issues reach you** — false positives are silently filtered out

Three depth levels: **fast** (API-only, seconds), **full** (local builds), **deep** (multi-agent + validation). Combine `--deep --full` for maximum thoroughness.

---

## Repository Architecture

Dream Team Flow is split across three repos:

| Repo | Visibility | Purpose |
|------|-----------|---------|
| **[dream-team-flow](https://github.com/johwer/dream-team-flow)** | Public | This repo — DTF documentation, improvement plan, `dtf` CLI, company config templates |
| **[marketplace](https://github.com/johwer/marketplace)** | Public | Plugin marketplace — all commands, agents, scripts, hooks, and docs (sanitized) |
| **marketplace-private** | Private | Same plugin files, unsanitized — for team use without de-sanitization |

**Why the split?**
- **Plugin files** (commands, agents, scripts) live in the marketplace repos so any project can install them via Claude Code's plugin system — not tied to Dream Team Flow specifically
- **DTF docs and CLI** live here — framework documentation, improvement plan, company config templates, setup guides
- **Team members** install from `marketplace-private` (real names, no setup needed). **Community users** install from `marketplace` and run `dtf install --company-config` to de-sanitize

---

## How It Works

```
Ticket → Architect → Parallel Dev → Code Review → Test → PR → Human Review → Ship
```

1. **You say:** [`/create-stories`](docs/commands.md#create-stories) `PROJ-1234 PROJ-1235`
2. **Dream Team does:**
   - Fetches all tickets from Jira and **pre-analyzes them in parallel** (scope, complexity, key files, conventions)
   - Presents a recommendations table — you choose Dream Team, Lite, or Just Worktree per ticket
   - Creates git worktrees, installs deps, writes pre-hydrated context files
   - Opens terminals with Claude Code sessions that start with full context
   - Spawns only the agents each ticket actually needs
   - Implements backend and frontend in parallel using a shared API contract
   - Creates a draft PR so the team can follow progress from the start
   - Runs a deterministic quality gate script (formatting, linting, type checks) before every push
   - Reviews the code for security (OWASP) and conventions
   - Polls AI bots (Gemini, Copilot) and CI — fixes issues with a 2-round cap (escalates to user after)
   - PR stays **draft** until you explicitly confirm — then marks ready and assigns reviewers
   - Moves ticket to Done and cleans up

See **[Workflow Phases](docs/workflow-phases.md)** for detailed flowcharts of full, lite, and local modes.

### Understanding the Building Blocks

DTF is built on Claude Code's 7 instruction delivery mechanisms — each with a specific role. Understanding when to use CLAUDE.md vs Skills vs Commands vs Agents vs Hooks is key to making the system work:

**[Instruction Delivery Guide](docs/instruction-delivery.md)** — How CLAUDE.md, skills, commands, agents, hooks, memory, and plugins work together, when to use each, and common anti-patterns to avoid.

---

## Features

### New — Role-Based Flows
- **12 roles** — Frontend, Backend, Fullstack, Data Engineer, Data Analyst, Infra/DevOps, QA/Tester, UAT Stakeholder, PO, Sales, Marketing, Customer Ops
- **Custom workflow steps** — Automated checks (⚡) and reminders (📋) at 5 phases: on-start, before-commit, before-push, before-pr, after-pr. Add, remove, customize anytime with `dtf steps`
- **`dtf configure`** — Set or change role and steps for existing users (no reinstall)
- **`/infra-ticket`** — Full Terraform workflow: Jira → branch → plan → PR with structured plan summary

### New — Performance & Code Quality
- **Performance skills** — Frontend (Core Web Vitals, bundle, React 19), Backend (EF Core, N+1, caching), AWS (CloudWatch, RDS, cost optimization)
- **Code insights** — Opt-in refactoring nudges on your changed files + DTO analysis with mermaid diagrams for PR descriptions
- **Memory hygiene** — Automatic memory health check at session start (0 token cost bash script)
- **15 external plugins** — Trail of Bits security (3.8k stars), Vercel React (21k stars), dotnet-skills (658 stars), codebase auditors, and more

### Core
- **Parallel context pre-hydration** — All tickets analyzed in parallel before sessions start
- **Dynamic team sizing** — Architect spawns only the agents the ticket needs
- **Draft PR from the start** — Created after architecture analysis; stays draft until user explicitly confirms
- **Drift detection** — Build baseline captured before implementation, compared before push — regressions caught locally, not in CI
- **Crash recovery** — Agents write notes to disk; crashed agents respawn with full context
- **Stale worktree cleanup** — Merged/closed PRs detected automatically; orphan worktrees cleaned up before new ones are created
- **Standalone PR review** — `/review-pr` reviews any PR with line-level GitHub comments. Three depth levels: fast, full (`--full`), deep (`--deep` — 4 parallel agents + validation)
- **De-sloppify pass** — Cleanup phase before commit: removes over-engineering, dead code, premature abstractions
- **Strategic compaction** — Proactive context management at phase boundaries
- **Context modes** — Dev/review/research mindsets with distinct priorities
- **Self-learning** — 6 learning paths: session retros, PR mining, Jira scraping, tool usage patterns, research, cross-session analysis
- **Cost tracking** — Session cost reports, config health scanner (A-F grading)

See **[Features](docs/features.md)** for the full list.

---

## Documentation

| Guide | Description |
|-------|-------------|
| **[Installation](docs/installation.md)** | Prerequisites, install methods, role selection, workflow steps |
| **[Built for Teams](docs/built-for-teams.md)** | Role-based setup, company config, `dtf configure`, `dtf steps`, onboarding |
| **[The Team](docs/the-team.md)** | 29 agents in 8 domains, per-role loading, team sizing, personas |
| **[Usage](docs/usage.md)** | Modes (full, lite, local), flags, PR review, reviewer auto-assignment |
| **[Commands](docs/commands.md)** | All slash commands including `/infra-ticket`, DTF CLI |
| **[Workflow Phases](docs/workflow-phases.md)** | Flowcharts for full, lite, and local modes |
| **[Parallel Everything](docs/parallel.md)** | Cross-ticket parallelism, Docker isolation, pause/resume |
| **[Worktree Port Setup](docs/worktree-port-setup.md)** | How to adapt Vite, Docker, and ports for any project |
| **[Features](docs/features.md)** | Full feature list — orchestration, review, resilience, self-learning |
| **[Self-Learning System](docs/retrospectives.md)** | Six learning channels, routing rules, compounding effect |
| **[Security Guide](SECURITY.md)** | Security ladder (3 levels), sandbox, network isolation |
| **[Token Efficiency](docs/token-efficiency.md)** | Cost architecture: baseline ~5,750 tokens, everything else on-demand |
| **[Instruction Delivery](docs/instruction-delivery.md)** | How CLAUDE.md, skills, commands, agents, hooks, memory work together |
| **[Project Structure](docs/project-structure.md)** | Repo architecture — what lives where across the three repos |
| **[Best-in-Class Comparison](docs/comparison.md)** | Side-by-side with Stripe Minions, Claude Code best practices, and ECC |
| **[Improvement Plan](docs/improvement-plan.md)** | Architecture decisions, prioritized roadmap |
| **[Setup Guide](SETUP-GUIDE.md)** | Full reference — company config, DTF CLI, troubleshooting |

---

## Quick Start

### Option A: Plugin Install (recommended)

Install the plugin marketplace and the toolkit:

```bash
# Public (community — needs de-sanitization with company config)
/plugin marketplace add johwer/marketplace
/plugin install claude-toolkit@marketplace

# Private (team — ready to use, no de-sanitization needed)
/plugin marketplace add johwer/marketplace-private
/plugin install claude-toolkit@marketplace-private
```

### Option B: DTF CLI Install (full setup with company config)

```bash
git clone https://github.com/johwer/dream-team-flow.git
bash dream-team-flow/scripts/dtf.sh install https://github.com/johwer/dream-team-flow
brew install tmux jq
```

Pass a company config for team installs:

```bash
bash dream-team-flow/scripts/dtf.sh install https://github.com/johwer/dream-team-flow \
  --company-config company-config.json
```

### Option C: Both (recommended for teams)

Use the plugin for commands/agents/scripts, and the DTF CLI for company-specific setup:

```bash
# 1. Install plugin (gets all commands, agents, scripts)
/plugin marketplace add johwer/marketplace-private
/plugin install claude-toolkit@marketplace-private

# 2. Run DTF CLI for company config (sets Jira domain, service names, personal config)
bash dream-team-flow/scripts/dtf.sh install https://github.com/johwer/dream-team-flow \
  --company-config company-config.json
```

See **[Installation](docs/installation.md)** for prerequisites, team/enterprise setup, and supported terminals.

---

## Usage

### Daily Work
```
/create-stories PROJ-1234                        # Full lifecycle — ticket to PR
/my-dream-team --lite <ticket>                   # Claude decides agent usage
/infra-ticket PROJ-2345                          # Terraform workflow — Jira to PR
/review-pr 1670                                  # Review any PR
```

### Your Workflow
```
dtf configure                                    # Pick role, customize steps
dtf steps list                                   # See your steps
dtf steps add                                    # Add a custom check or reminder
```

### Code Quality
```
/code-insights                                   # Refactoring nudges + DTO analysis on your diff
/code-review                                     # Official 4-agent diff review
```

### Analytics
```
bash ~/.claude/scripts/memory-health.sh              # Memory health (0 tokens)
bash ~/.claude/scripts/analyze-patterns.sh           # Detect usage patterns
bash ~/.claude/scripts/cost-tracker.sh report        # Session cost report
bash ~/.claude/scripts/config-scan.sh                # Config health check (A-F)
```

Three modes: **Full** (multi-agent team), **Lite** (Claude decides, same quality gates), and **Local** (no PR/push). See **[Usage Guide](docs/usage.md)** for all modes, flags, and reviewer auto-assignment.

---

## The Team

29 specialized agents across 8 domains — engineering, data, design, infrastructure, marketing, operations, product, and testing. Your role determines which agents load (3-7 per role, not all 29). The architect analyzes each ticket and dynamically spawns only the agents needed.

```
engineering/     (7)  frontend-dev, backend-dev, architect, pr-reviewer,
                      api-designer, performance-analyst, migration-planner
data/            (4)  data-engineer, data-analyst, pipeline-builder, insights-reporter
design/          (2)  ui-designer, ux-researcher
infrastructure/  (3)  infra-engineer, ci-cd-engineer, security-auditor
marketing/       (4)  marketing-ops, sales-enablement, content-creator, social-strategist
operations/      (2)  customer-ops, support-responder
product/         (3)  po-analyst, requirements-analyst, sprint-prioritizer
testing/         (4)  qa-tester, uat-tester, api-tester, performance-benchmarker
```

Read more: **[The Team](docs/the-team.md)** — full agent roster, team sizing logic, and agent definitions.

---

## Adapt to Your Codebase

Dream Team Flow isn't just configurable — it **learns your codebase** through six learning channels that continuously feed knowledge into agent prompts, coding style docs, and project conventions:

| Channel | Source | Example |
|---------|--------|---------|
| **Session retros** | Agents reflect after every ticket | "Handlers should use atomic upserts" |
| **PR review insights** | Patterns from merged PR feedback | "6 PRs had missing i18n — add to quality gate" |
| **Jira pushback scraping** | AI reviewer comment analysis | "Tickets without ACs get 3x more review cycles" |
| **Tool usage patterns** | Behavioral analysis from tool logs | "settings.json read 12x — add to CLAUDE.md" |
| **Research & reading** | Internet articles, docs, best-practice guides | Microservices messaging patterns from an online guide |
| **Cross-session analysis** | Pattern detection across retros | "4 sessions mentioned soft delete confusion" |

Every learning flows to the right destination — agent prompts, coding style docs, pre-hydrated context, or command logic. Both humans and AI agents read the same docs, so knowledge compounds for everyone.

**Example:** Your team reads an article on microservice messaging and extracts key patterns — idempotent handlers, no sync calls from event handlers, transactional outbox. Those learnings become:
- A new section in your backend coding style guide (repo docs, via Jira + PR)
- A critical rule in the backend agent's prompt ("every handler MUST be idempotent")
- Pre-hydrated context for any ticket touching message handlers

New team members inherit **everything** on day one — the accumulated knowledge isn't in someone's head, it's in agent prompts, coding style docs, and context files that every session reads automatically.

Read more: **[Self-Learning System](docs/retrospectives.md)** — all five channels, routing rules, destinations, and the compounding effect.

### Tech Stack

Built for monorepos with:
- **Frontend:** React 19, TypeScript, Vite, Tailwind CSS v4, RTK Query
- **Backend:** .NET Web API, Entity Framework Core, C#
- **Infrastructure:** Terraform, AWS, Docker Compose, GitHub Actions

Agent definitions, coding style docs, and context templates are all customizable — swap in your stack, your conventions, your domain-specific rules.

### By the Numbers
<!-- STATS:START -->
| What | Count |
|------|-------|
| Agents | 29 (in 8 domains) |
| Skills | 74+ (conventions, performance, workflows, security, marketing) |
| Commands | 21 (orchestration, review, triage, infra, analytics) |
| Scripts | 33 (quality gates, terraform, memory, cost tracking) |
| Roles | 12 (dev, data, infra, QA, PO, sales, marketing, ops) |
| Token baseline | ~5,750 per prompt (0.6% of context) |
| Everything else | 0 tokens until used |
<!-- STATS:END -->

---

## Project Structure

Three repos, clear separation:

```
dream-team-flow/                    ← This repo: docs + dtf CLI
├── docs/                           # Framework documentation
│   ├── improvement-plan.md         # Architecture decisions & roadmap
│   ├── installation.md             # Install guide
│   ├── usage.md                    # Usage guide
│   └── ...                         # Workflow, features, team, etc.
├── security/                       # Security config templates (3 levels)
├── CLAUDE.md.template              # Template for ~/.claude/CLAUDE.md
├── dtf-config.template.json        # Per-user config template
├── company-config.example.json     # Example company config
├── SETUP-GUIDE.md                  # Full setup reference
└── SECURITY.md                     # Security ladder guide

marketplace/ (or marketplace-private/)  ← Plugin repos: commands + agents + scripts
├── .claude-plugin/
│   ├── marketplace.json            # Plugin catalog
│   └── plugin.json                 # Plugin manifest
├── commands/                       # 21 slash commands
├── agents/                         # 29 agents in 8 domain subdirectories
│   ├── engineering/                # frontend-dev, backend-dev, architect, pr-reviewer, ...
│   ├── data/                       # data-engineer, data-analyst, pipeline-builder, ...
│   ├── infrastructure/             # infra-engineer, ci-cd-engineer, security-auditor
│   ├── testing/                    # qa-tester, uat-tester, api-tester, ...
│   └── ...                         # design, marketing, operations, product
├── scripts/                        # 33 shell scripts (quality gates, terraform, hooks, etc.)
├── skills/                         # 42+ skills (conventions, performance, workflows, etc.)
└── docs/                           # Operational docs (dtf-roles, checklist, learning system)
```

See **[Project Structure](docs/project-structure.md)** for the full annotated file tree.

---

## Contributing

This is an actively evolving project. Contributions are welcome:

- **Workflow improvements:** After Dream Team sessions, run `dtf contribute` to export your retro learnings as a PR
- **New agent types:** Add agent definitions to the marketplace repo for your tech stack
- **Terminal support:** Add new terminals to `scripts/open-terminal.sh`
- **Bug fixes & features:** Standard GitHub PR workflow

---

## License

MIT

# Features

## Role-Based Flows

- 🎭 **12 roles** — Developer (Frontend/Backend/Fullstack), Data Engineer, Data Analyst, Infra/DevOps, QA/Tester, UAT Stakeholder, Product Owner, Sales, Marketing, Customer Operations
- 🤖 **29 agents in 8 domains** — Engineering, Data, Design, Infrastructure, Marketing, Operations, Product, Testing. Your role loads 2-7 agents, not all 29
- 🔧 **Custom workflow steps** — Build your own workflow with automated checks (⚡) and reminders (📋) at 5 phases: on-start, before-commit, before-push, before-pr, after-pr. `dtf steps add/remove/reset`
- 🔄 **Role switching** — `dtf configure` changes your role and steps anytime, no reinstall needed
- 📋 **Role-specific skills** — Each role gets tailored conventions, performance checks, and workflow guides loaded on demand

## Team & Setup

- 🚀 **One-command team setup** — `dtf install` runs wizard (name, paths, terminal, role, workflow steps), symlinks everything, generates config
- 🏢 **Company config with roles** — Share a `company-config.json` with role definitions, service names, Jira domain, paths — new members pick their role during install
- 🧠 **Shared learnings** — `dtf contribute` exports retro insights as PRs; team curates into shared knowledge base
- 🖥️ **10 terminals supported** — macOS, Linux, and Windows (WSL) across Alacritty, Kitty, WezTerm, Ghostty, Warp, and more
- 📊 **Auto-sync** — `/sync-config` pushes all changes to GitHub repos; README stats auto-update from live file counts

## Agent Orchestration

- 📐 **Dynamic team sizing** — Architect analyzes complexity and spawns only the agents needed
- 🔀 **Parallel implementation** — Backend and frontend work simultaneously using a shared API contract
- 💬 **Structured agent communication** — Handoffs include files touched, ports, commands, contract deviations
- ⚡ **Lite mode** — `--lite` flag lets Claude decide whether to spawn agents or work solo, keeping all quality gates intact
- 📂 **No-worktree mode** — `--no-worktree` flag to work in-place without workspace setup/cleanup
- 🧠 **Parallel context pre-hydration** — `/create-stories` analyzes all tickets in parallel before launching sessions; agents start with pre-analyzed scope, key files, and conventions instead of exploring from scratch
- 🎯 **Per-ticket mode selection** — When launching multiple tickets, choose Dream Team, Lite, or Just Worktree per ticket based on scope and complexity recommendations

## Code Review & Quality

- 🔒 **Security scanning** — Every PR gets a 6-category OWASP-aligned security review
- 🔎 **Standalone PR review** — Review any PR with [`/review-pr`](commands.md#review-pr), no local checkout needed
- 👥 **PR reviewer auto-assignment** — Pre-configure GitHub reviewers per category (frontend, backend, fullstack, infra, data); auto-assigned when PRs go ready
- 🤖 **AI review polling** — Waits for GitHub AI bots (Gemini, Copilot) before human review
- ✅ **CI check polling with 2-round cap** — Monitors GitHub Actions, routes failures to the right agent; escalates to user after 2 failed fix attempts instead of looping
- 🔧 **Deterministic quality gate script** — `quality-gate.sh` runs formatting, linting, type checks, and builds before every push without burning LLM tokens
- 📋 **PR stays draft until user confirms** — PRs remain draft through AI review and CI; only marked ready when user explicitly says "ship it", then reviewers are assigned
- 📝 **Jira completion comment** — When a ticket is done, posts a comment to Jira with the PR link and summary, @mentioning the ticket creator if different from the assignee
- 🚪 **Completion gate checklist** — Hard gate before marking Done: all PR comments resolved, screenshots on disk, retro completed, Jira comment posted, CI green, PR description complete
- 👁️ **Visual verification** — Frontend devs can verify against designs using Chrome extension
- 📋 **How to Test section** — Every PR includes exact URLs, steps, and expected results

## Resilience & Safety

- 💾 **Working notes & crash recovery** — Agents write to `.dream-team/notes/` on disk; crashed agents respawn with full context
- ⏸️ **Pause/resume** — Close for the day, pick up tomorrow with context rebuilt from persistent notes
- 🔃 **Merge conflict prevention** — Pulls latest main before branching, rebases before every push
- 🛡️ **Non-destructive PR updates** — Reads current PR body before editing, preserving manually added images
- 🚧 **Guardrail hooks** — Migration guard, lock file guard, auto-lint reminders prevent common mistakes
- 🚦 **TeammateIdle gate** — Hook prevents dev agents from going idle without notes, journal entries, and clean formatting
- ✋ **TaskCompleted gate** — Hook prevents dev agents from marking tasks complete without notes, journal, code changes, and passing type checks
- 📋 **Granular task decomposition** — Each agent gets 5-6 small tasks instead of 1-2 big ones, enabling better progress tracking and quality checkpoints
- 🔌 **Worktree port isolation** — Each worktree gets unique ports (Vite + API services) derived from the ticket number, preventing collisions when running multiple worktrees simultaneously. Uses `allocate-ports.sh` + env-var-aware `vite.config.mts`. Scripts live in `~/.claude/scripts/` as permanent DTF tooling.
- 🧹 **Orchestrator cleanup** — Worktree removal, branch deletion, tmux kill handled from outside the workspace

## Self-Learning

Five channels continuously feed knowledge into agent prompts, coding style docs, and project conventions:

- 🔄 **Session retrospectives** — Every session ends with a team retro: agents vote on improvements, learnings are tagged with destinations and saved for routing
- 📊 **PR review insights** — [`/pr-insights`](commands.md#pr-insights) scrapes merged PR review comments to surface recurring patterns — what reviewers keep asking for, what conventions are unclear, what mistakes repeat
- 🎯 **Jira pushback scraping** — [`/scrape-jira-pushback`](commands.md#scrape-jira-pushback) extracts learnings from AI ticket reviewer comments — ticket quality patterns, domain knowledge gaps, requirements patterns
- 📚 **Research & reading** — Point Claude at an internet article, documentation page, or best-practice guide — it reads the content, extracts patterns that apply to your codebase, and distributes them into agent prompts, coding style docs, and pre-hydrated context. Source URLs preserved for reference
- 🗺️ **Cross-session analysis** — [`/retro-proposals`](commands.md#retro-proposals) analyzes accumulated retro learnings across multiple sessions to find systemic patterns and route improvements to the right destination

All learnings route to agent prompts (direct apply), coding style docs (Jira + PR), or project conventions — so every future ticket benefits automatically. See **[Self-Learning System](retrospectives.md)** for the full guide.

## Code Quality & Performance

- 💡 **Code insights** — Opt-in refactoring nudges after your first draft. Scans only changed files, React 19 aware (no useMemo/useCallback nudges). Max 5-7 suggestions with pros/cons
- 🏗️ **DTO & architecture analysis** — Deep analysis with mermaid diagrams (data flow, entity relationships, cross-service impact) ready to paste in PR description
- ⚡ **Frontend performance** — Core Web Vitals targets, bundle analysis checklist, React rendering patterns, RTK Query optimization
- ⚡ **Backend performance** — EF Core query optimization, N+1 detection, caching strategies, async/await patterns, memory profiling
- ☁️ **AWS performance** — CloudWatch monitoring, RDS tuning, auto-scaling, S3 lifecycle, cost optimization quick wins
- 🔍 **15+ external plugins installed** — Trail of Bits security (3.8k stars), Vercel React (21k stars), dotnet-skills (658 stars), codebase audit suite, and more

## Infrastructure Workflows

- 🏗️ **`/infra-ticket`** — Full Terraform workflow: Jira → branch → explore modules → implement → plan → PR with structured plan in body
- 📊 **Structured plan output** — `terraform-plan-summary.sh` shows add/change/destroy counts in a box, warns loudly on destroys
- ✅ **GH Actions verification** — `verify-infra-workflows.sh` checks plan/apply workflows exist, CODEOWNERS covers infra/, lock files committed
- 📐 **Infra conventions** — WAF rate limiting, monitoring patterns, ECR security, RDS SSL, deployment notifications

## Non-Developer Workflows

- 📋 **Product Owner** — `/ticket-scout` batch triage (READY/REFINE/PUSH BACK/SKIP), `/ticket-refine` deep quality gate, impact analysis — no code knowledge needed
- 📈 **Sales** — PowerPoint generation (official PPTX skill), ROI models, customer data insights, competitive analysis
- 📝 **Marketing** — 12 marketing skills (SEO audit, AI SEO, copywriting, email sequences, social content, content strategy, competitor alternatives, lead magnets, launch strategy)
- 🔧 **Customer Ops** — Integration configuration patterns, ITSM ticket investigation, customer onboarding
- 🧪 **UAT** — Acceptance criteria checklists, permission matrix testing, structured Jira bug reports — no code contact

## Cost & Memory Management

- 💰 **Token baseline ~5,750** — CLAUDE.md + MEMORY.md + system = 0.6% of context. Everything else on demand
- 🧹 **Memory hygiene** — `memory-health.sh` runs at session start (0 tokens), flags stale memories and oversized files
- 📉 **Promotion path** — Stable memories get promoted to CLAUDE.md/conventions docs, then deleted. Learn → remember → formalize → forget
- 📊 **Cost tracker** — `cost-tracker.sh` shows session costs, `config-scan.sh` grades config health A-F

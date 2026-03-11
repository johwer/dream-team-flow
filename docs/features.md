# Features

## Team & Setup

- 🚀 **One-command team setup** — `dtf install` symlinks everything, generates config, merges hooks — new team members are productive in minutes
- 🏢 **Company config** — Share a `company-config.json` to auto-configure service names, Jira domain, paths for your whole team
- 🧠 **Shared learnings** — `dtf contribute` exports retro insights as PRs; team curates into shared knowledge base
- 🖥️ **10 terminals supported** — macOS, Linux, and Windows (WSL) across Alacritty, Kitty, WezTerm, Ghostty, Warp, and more

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
- 🔌 **Worktree port isolation** — Each worktree gets unique ports (Vite + API services) derived from the ticket number, preventing collisions when running multiple worktrees simultaneously. Uses `allocate-ports.sh` + env-var-aware `vite.config.mts`. Overlay script applies the infrastructure transparently until the feature branch merges to main.
- 🧹 **Orchestrator cleanup** — Worktree removal, branch deletion, tmux kill handled from outside the workspace

## Self-Learning

Five channels continuously feed knowledge into agent prompts, coding style docs, and project conventions:

- 🔄 **Session retrospectives** — Every session ends with a team retro: agents vote on improvements, learnings are tagged with destinations and saved for routing
- 📊 **PR review insights** — [`/pr-insights`](commands.md#pr-insights) scrapes merged PR review comments to surface recurring patterns — what reviewers keep asking for, what conventions are unclear, what mistakes repeat
- 🎯 **Jira pushback scraping** — [`/scrape-jira-pushback`](commands.md#scrape-jira-pushback) extracts learnings from AI ticket reviewer comments — ticket quality patterns, domain knowledge gaps, requirements patterns
- 📚 **Research & reading** — Point Claude at an internet article, documentation page, or best-practice guide — it reads the content, extracts patterns that apply to your codebase, and distributes them into agent prompts, coding style docs, and pre-hydrated context. Source URLs preserved for reference
- 🗺️ **Cross-session analysis** — [`/retro-proposals`](commands.md#retro-proposals) analyzes accumulated retro learnings across multiple sessions to find systemic patterns and route improvements to the right destination

All learnings route to agent prompts (direct apply), coding style docs (Jira + PR), or project conventions — so every future ticket benefits automatically. See **[Self-Learning System](retrospectives.md)** for the full guide.

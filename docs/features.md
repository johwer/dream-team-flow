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

## Code Review & Quality

- 🔒 **Security scanning** — Every PR gets a 6-category OWASP-aligned security review
- 🔎 **Standalone PR review** — Review any PR with [`/review-pr`](commands.md#review-pr), no local checkout needed
- 👥 **PR reviewer auto-assignment** — Pre-configure GitHub reviewers per category (frontend, backend, fullstack, infra, data); auto-assigned when PRs go ready
- 🤖 **AI review polling** — Waits for GitHub AI bots (Gemini, Copilot) before human review
- ✅ **CI check polling** — Monitors GitHub Actions, routes failures to the right agent
- 👁️ **Visual verification** — Frontend devs can verify against designs using Chrome extension
- 📋 **How to Test section** — Every PR includes exact URLs, steps, and expected results

## Resilience & Safety

- 💾 **Working notes & crash recovery** — Agents write to `.dream-team/notes/` on disk; crashed agents respawn with full context
- ⏸️ **Pause/resume** — Close for the day, pick up tomorrow with context rebuilt from persistent notes
- 🔃 **Merge conflict prevention** — Pulls latest main before branching, rebases before every push
- 🛡️ **Non-destructive PR updates** — Reads current PR body before editing, preserving manually added images
- 🚧 **Guardrail hooks** — Migration guard, lock file guard, auto-lint reminders prevent common mistakes
- 🧹 **Orchestrator cleanup** — Worktree removal, branch deletion, tmux kill handled from outside the workspace

## Self-Learning

- 🔄 **Retrospectives** — Every session ends with a team retro: agents vote on improvements, learnings are tagged with destinations and saved for routing
- 🗺️ **Learning Router** — [`/team-review`](commands.md#team-review) analyzes accumulated retro learnings and routes them to the right place: personal config files are applied directly, shared repo files (CLAUDE.md, AGENTS.md, docs/) go through Jira ticket + PR for team review

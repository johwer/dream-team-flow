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

**A multi-agent team powered by [Claude Code](https://docs.anthropic.com/en/docs/claude-code) that takes a ticket and delivers a complete implementation — architecture, code, review, testing, and PR — autonomously.**

Dream Team Flow is a set of Claude Code custom commands, scripts, and specialized agents that orchestrate a team of AI developers. Give it a Jira ticket, and it handles everything: workspace setup, architecture analysis, parallel implementation, code review, testing, PR creation, and cleanup.

**Built for teams.** One command to install, one command to update. Share a company config with your team to auto-configure service names, Jira domain, paths, and conventions — new developers are productive in minutes. Retro learnings aggregate across the team via PRs. Works on macOS, Linux, and Windows (WSL) with 10 supported terminals.

---

## Documentation

| Guide | Description |
|-------|-------------|
| **[Installation](docs/installation.md)** | Prerequisites, install, team/enterprise setup, supported terminals |
| **[Usage](docs/usage.md)** | Modes (full, lite, local), flags, PR review, reviewer auto-assignment |
| **[Commands](docs/commands.md)** | All slash commands, flags, DTF CLI, typical workflow |
| **[Workflow Phases](docs/workflow-phases.md)** | Flowcharts for full, lite, and local modes with comparison table |
| **[The Team](docs/the-team.md)** | Agent roster, roles, dynamic team sizing, agent definitions |
| **[Retrospectives](docs/retrospectives.md)** | Self-learning loop, learning destinations, feedback routing |
| **[Security Guide](SECURITY.md)** | Security ladder (3 levels), sandbox, network isolation, deny rules, bypass mode |
| **[Project Structure](docs/project-structure.md)** | Annotated file tree — commands, agents, scripts, security, docs |
| **[Integrations](docs/integrations.md)** | Hooks, subagents, GitHub Actions, Slack |
| **[Setup Guide](SETUP-GUIDE.md)** | Full reference — company config creation, DTF CLI, lifecycle walkthrough, troubleshooting |

---

## How It Works

```
Ticket → Architect → Parallel Dev → Code Review → Test → PR → Human Review → Ship
```

1. **You say:** `/create-stories PROJ-1234`
2. **Dream Team does:**
   - Fetches the Jira ticket
   - Creates a git worktree and branch
   - Installs dependencies
   - Opens a terminal with a Claude Code session
   - Spawns a team of specialized agents
   - Implements the feature in parallel
   - Reviews the code for security and conventions
   - Creates a draft PR with structured description
   - Waits for your feedback
   - Cleans up when done

---

## Quick Start

```bash
git clone https://github.com/your-username/dream-team-flow.git
bash dream-team-flow/scripts/dtf.sh install https://github.com/your-username/dream-team-flow
brew install tmux jq
```

The installer symlinks all commands, agents, and scripts into `~/.claude/` and generates your config. For team installs, pass a `company-config.json` to auto-configure service names, Jira domain, and paths.

See **[Installation](docs/installation.md)** for prerequisites, team/enterprise setup, and supported terminals.

---

## Usage

```
/create-stories PROJ-1234                        # Full lifecycle — ticket to PR
/my-dream-team --lite <ticket>                   # Claude decides agent usage
/review-pr 1670                                  # Review any PR
```

Three modes: **Full** (multi-agent team), **Lite** (Claude decides), and **Local** (no PR/push). Flags like `--no-worktree` and `--local` can be combined.

See **[Usage Guide](docs/usage.md)** for all modes, flags, PR review, and reviewer auto-assignment.

---

## The Team

11 specialized agents — architect, backend/frontend developers, data engineer, infra, reviewer, tester, visual verifier, and summary writer. The architect analyzes each ticket and dynamically spawns only the agents needed: 2-3 for simple changes, the full team for complex multi-service work.

Read more: **[The Team](docs/the-team.md)** — full agent roster, team sizing logic, and agent definitions.

---

## Workflow Phases

Three modes: **Full** (multi-agent orchestration), **Lite** (Claude decides agent usage), and **Local** (no PR/push, stops after review). Each mode has a visual flowchart showing the pipeline from ticket to ship.

Read more: **[Workflow Phases](docs/workflow-phases.md)** — flowcharts, mode comparison table, and flag details.

---

## Retrospectives & Learning Router

Every session ends with a team retro. Learnings are tagged with destinations and routed automatically — personal config changes are applied directly, shared repo changes go through Jira ticket + PR for team review.

Read more: **[Retrospectives](docs/retrospectives.md)** — how it works, where learnings go, and the feedback loop.

---

## Key Features

- 🚀 **One-command team setup** — `dtf install` symlinks everything, generates config, merges hooks — new team members are productive in minutes
- 🏢 **Company config** — Share a `company-config.json` to auto-configure service names, Jira domain, paths for your whole team
- 🧠 **Shared learnings** — `dtf contribute` exports retro insights as PRs; team curates into shared knowledge base
- ⚡ **Lite mode** — `--lite` flag lets Claude decide whether to spawn agents or work solo, keeping all quality gates intact
- 📂 **No-worktree mode** — `--no-worktree` flag to work in-place without workspace setup/cleanup
- 📐 **Dynamic team sizing** — Architect analyzes complexity and spawns only the agents needed
- 🔀 **Parallel implementation** — Backend and frontend work simultaneously using a shared API contract
- 💬 **Structured agent communication** — Handoffs include files touched, ports, commands, contract deviations
- 💾 **Working notes & crash recovery** — Agents write to `.dream-team/notes/` on disk; crashed agents respawn with full context
- 🔄 **Retrospectives & self-learning** — Every session ends with a team retro: agents vote on improvements, learnings are tagged with destinations and saved for routing
- 🗺️ **Learning Router** — `/team-review` analyzes accumulated retro learnings and routes them to the right place: personal config files are applied directly, shared repo files (CLAUDE.md, AGENTS.md, docs/) go through Jira ticket + PR for team review
- ⏸️ **Pause/resume** — Close for the day, pick up tomorrow with context rebuilt from persistent notes
- 🧹 **Orchestrator cleanup** — Worktree removal, branch deletion, tmux kill handled from outside the workspace
- 🔃 **Merge conflict prevention** — Pulls latest main before branching, rebases before every push
- 🛡️ **Non-destructive PR updates** — Reads current PR body before editing, preserving manually added images
- 🤖 **AI review polling** — Waits for GitHub AI bots (Gemini, Copilot) before human review
- ✅ **CI check polling** — Monitors GitHub Actions, routes failures to the right agent
- 🚧 **Guardrail hooks** — Migration guard, lock file guard, auto-lint reminders prevent common mistakes
- 👁️ **Visual verification** — Frontend devs can verify against designs using Chrome extension
- 🔒 **Security scanning** — Every PR gets a 6-category OWASP-aligned security review
- 👥 **PR reviewer auto-assignment** — Pre-configure GitHub reviewers per category (frontend, backend, fullstack, infra, data); auto-assigned when PRs go ready
- 🔎 **Standalone PR review** — Review any PR with `/review-pr`, no local checkout needed
- 📋 **How to Test section** — Every PR includes exact URLs, steps, and expected results
- 🖥️ **10 terminals supported** — macOS, Linux, and Windows (WSL) across Alacritty, Kitty, WezTerm, Ghostty, Warp, and more

---

## Tech Stack

Built for monorepos with:
- **Frontend:** React, TypeScript, Vite, Tailwind CSS, RTK Query
- **Backend:** .NET Web API, Entity Framework Core, C#
- **Infrastructure:** Docker Compose, EF Core Migrations

The agent prompts reference these technologies, but the framework is adaptable. You can modify the agent definitions in `commands/my-dream-team.md` to match your stack.

---

## Project Structure

Commands, agents, scripts, security configs, and docs — all symlinked into `~/.claude/` after install. Updates are instant via `git pull`.

See **[Project Structure](docs/project-structure.md)** for the full annotated file tree.

---

## Contributing

This is an actively evolving project. Contributions are welcome:

- **Workflow improvements:** After Dream Team sessions, run `dtf contribute` to export your retro learnings as a PR
- **New agent types:** Add agent definitions to `agents/` for your tech stack
- **Terminal support:** Add new terminals to `scripts/open-terminal.sh`
- **Bug fixes & features:** Standard GitHub PR workflow

---

## License

MIT

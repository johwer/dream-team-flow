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
| **[Features](docs/features.md)** | Full feature list — team setup, orchestration, review, resilience, self-learning |
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

## Features

- 📐 **Dynamic team sizing** — Architect spawns only the agents needed
- 🔀 **Parallel implementation** — Backend and frontend work simultaneously via shared API contracts
- 💾 **Crash recovery** — Agents persist working notes to disk; crashed agents respawn with full context
- 🔄 **Self-learning** — Every session ends with a retro that feeds improvements back into agents and project docs
- 🔒 **Security scanning** — Every PR gets a 6-category OWASP-aligned review
- 🚀 **One-command setup** — `dtf install` gets new team members productive in minutes

See **[Features](docs/features.md)** for the full list — team & setup, agent orchestration, code review & quality, resilience & safety, and self-learning.

---

## Workflow Phases

Three modes: **Full** (multi-agent orchestration), **Lite** (Claude decides agent usage), and **Local** (no PR/push, stops after review). Each mode has a visual flowchart showing the pipeline from ticket to ship.

Read more: **[Workflow Phases](docs/workflow-phases.md)** — flowcharts, mode comparison table, and flag details.

---

## Retrospectives & Learning Router

Every session ends with a team retro. Learnings are tagged with destinations and routed automatically — personal config changes are applied directly, shared repo changes go through Jira ticket + PR for team review.

Read more: **[Retrospectives](docs/retrospectives.md)** — how it works, where learnings go, and the feedback loop.

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

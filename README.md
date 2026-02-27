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

**A multi-agent team powered by [Claude Code](https://docs.anthropic.com/en/docs/claude-code) that turns a Jira ticket into a complete, reviewed, merged PR — without the token bloat.**

### Lean by design
Most AI coding workflows get expensive fast: MCP servers, bloated tool schemas, agents that load entire codebases into context. Dream Team Flow is built the opposite way. Agents read only what they need, write decisions to disk instead of holding them in memory, and skip spawning entirely on simple tickets. You get a full team — architect, backend dev, frontend dev, security reviewer, tester — working in parallel, at a fraction of the context cost.

### Built for teams
One command to install, one command to update. Share a `company-config.json` to auto-configure service names, Jira domain, and paths — new developers are productive in minutes. Retro learnings aggregate across the team via PRs. Works on macOS, Linux, and Windows (WSL) with 10 supported terminals.

### Secure by default
Ships with a three-tier permission ladder — personal sandbox, shared project standard, and team-enforced lockdown. Control exactly what agents are allowed to read, write, and execute. Every PR gets a 6-category OWASP-aligned security scan before it ever reaches a human reviewer.

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

1. **You say:** [`/create-stories`](docs/commands.md#create-stories) `PROJ-1234`
2. **Dream Team does:**
   - Moves ticket to In Progress in Jira
   - Creates a git worktree and branch
   - Opens a terminal with a Claude Code session
   - Spawns only the agents the ticket actually needs
   - Implements backend and frontend in parallel using a shared API contract
   - Creates a draft PR so the team can follow progress from the start
   - Reviews the code for security (OWASP) and conventions
   - Polls AI bots (Gemini, Copilot) and waits for CI before requesting human review
   - Waits for your feedback, then marks the PR ready
   - Moves ticket to Done and cleans up

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

- 📐 **Dynamic team sizing** — Architect spawns only the agents the ticket needs — no wasted capacity
- 🔀 **Parallel implementation** — Backend and frontend work simultaneously via a shared API contract
- 📋 **Draft PR from the start** — Created after architecture analysis so the team can track progress on GitHub
- 💾 **Crash recovery** — Agents write working notes to disk; crashed agents respawn with full context from their notes file
- 🔄 **Self-learning** — Every session ends with a retro that feeds improvements back into agent prompts and project docs
- 👁️ **Visual verification** — Frontend agents record before/after GIFs via Chrome for UI changes
- 🔒 **Security-first** — Every PR gets a 6-category OWASP-aligned security scan before it's ever marked ready

See **[Features](docs/features.md)** for the full list — team setup, orchestration, review, resilience, and self-learning.

---

## Token-Efficient by Design

Most AI coding setups grow expensive fast — MCP servers, large tool schemas, and bloated context windows add up quickly. Dream Team Flow is built differently:

- **No MCP servers** — agents use plain file reads and CLI tools instead of context-heavy server integrations
- **Disk-based memory** — agents write decisions and findings to `.dream-team/notes/` on disk and read them back when needed, rather than keeping everything in the context window
- **Targeted reads** — agents use Grep to find what they need rather than loading entire files or docs
- **Lite mode** — for smaller tickets, Claude skips agent spawning entirely and works solo, with no team coordination overhead
- **Dynamic team sizing** — the architect only spawns agents the ticket actually needs; extra agents are never started

The result: multi-agent sessions that stay lean even on large tickets.

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

The agent prompts reference these technologies, but the framework is adaptable. You can modify the agent definitions in [`commands/my-dream-team.md`](commands/my-dream-team.md) to match your stack.

---

## Security

Every PR goes through a 6-category OWASP-aligned security scan — injection, auth/authz, data exposure, path traversal, hardcoded secrets, and insecure defaults — before it's ever marked ready for human review.

Dream Team Flow itself ships with a three-tier security ladder: personal sandbox defaults, shared project standards, and team-enforced lockdown. Configure once, enforce across your team.

See **[Security Guide](SECURITY.md)** — sandbox configuration, network isolation, deny rules, and bypass mode.

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

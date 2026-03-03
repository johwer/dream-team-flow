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

**Free, open-source multi-agent orchestration for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Give it a Jira ticket — get back a production-ready, security-scanned, human-reviewed PR.**

Run tickets in parallel with isolated worktrees and Docker — multiply your team's story output without multiplying headcount. Keep AI costs predictable with shell-based quality gates, disk-based memory, and agents that read only what they need — no MCP servers, no bloated context windows. Onboard new developers in minutes with one install command and shared config. Ship every PR through a 7-category OWASP security scan — built into the pipeline, not bolted on after.

Built on Claude Code's native multi-agent architecture — subagents, hooks, task coordination, structured tool use — following Anthropic's official patterns. No wrappers, no middleware, no vendor lock-in. When Claude Code ships a new feature, Dream Team Flow uses it directly.

### [Parallel everything — 4x story output or more](docs/parallel.md)

Run 4, 6, 10 tickets simultaneously. Each ticket gets its own git worktree, its own Docker containers with isolated ports, and its own agent team — completely independent, zero conflicts. Backend and frontend agents work in parallel within each ticket via a shared API contract. Pause overnight, resume the next day from disk — zero token cost between sessions.

A single developer can sustain the story output of a 4-person team — or more — because the work happens concurrently, not sequentially.

### [Lean by design — cut your AI spend, not your output](docs/token-efficiency.md)

Each ticket is routed to the right mode — full team, lite, or just a worktree — so trivial tickets cost zero and only complex ones get the full team. Formatting, linting, and builds run as shell scripts — zero LLM tokens. Structured handoff templates eliminate agent back-and-forth. Deadlock detection catches stuck agents at 10 minutes. CI fixes capped at 2 rounds.

Per-ticket API costs stay predictable regardless of complexity.

### [Built for teams — onboard in minutes, not days](docs/built-for-teams.md)

One command to install, one command to update. `company-config.json` auto-configures service names, Jira domain, and paths — new developers ship PRs in minutes, not days. Updates deep-merge without breaking personal config. `/ticket-scout` flags vague requirements before sprint starts. i18n ships with all languages from day one.

Every session ends with a retro that feeds improvements back into prompts and docs. The team gets smarter with every ticket shipped.

### [Secure by default — compliance without slowing down](SECURITY.md)

Every PR gets a 7-category OWASP security scan before it reaches a human reviewer. Schema changes require Mermaid diagrams and explicit human approval — agents cannot autonomously change your data model. Quality hooks physically prevent agents from skipping steps.

Three-tier permission ladder — personal sandbox, shared standards, team-enforced lockdown. For regulated industries, security review and change governance are built into the pipeline, not bolted on after.

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

---

## Features

- **Parallel context pre-hydration** — All tickets analyzed in parallel before sessions start
- **Dynamic team sizing** — Architect spawns only the agents the ticket needs
- **Draft PR from the start** — Created after architecture analysis; stays draft until user explicitly confirms
- **Drift detection** — Build baseline captured before implementation, compared before push — regressions caught locally, not in CI
- **Crash recovery** — Agents write notes to disk; crashed agents respawn with full context
- **Stale worktree cleanup** — Merged/closed PRs detected automatically; orphan worktrees cleaned up before new ones are created
- **Non-destructive PR updates** — PR description edits preserve manually added images and screenshots
- **Jira completion comments** — Ticket creator auto-notified with PR link and summary when work is done
- **Standalone PR review** — `/review-pr` reviews any PR with line-level GitHub comments via API — no local checkout needed. `--full` mode adds local builds, type checks, and test runs for deeper analysis
- **Granular task decomposition** — 5-6 small tasks per agent instead of 1-2 big ones — better progress visibility, checkpoint-level quality enforcement, and less work lost on crashes

See **[Features](docs/features.md)** for the full list — team setup, orchestration, review, resilience, and self-learning.

---

## Documentation

| Guide | Description |
|-------|-------------|
| **[Installation](docs/installation.md)** | Prerequisites, install, team/enterprise setup, supported terminals |
| **[Usage](docs/usage.md)** | Modes (full, lite, local), flags, PR review, reviewer auto-assignment |
| **[Commands](docs/commands.md)** | All slash commands, flags, DTF CLI, typical workflow |
| **[Workflow Phases](docs/workflow-phases.md)** | Flowcharts for full, lite, and local modes with comparison table |
| **[Parallel Everything](docs/parallel.md)** | Cross-ticket parallelism, Docker isolation, pause/resume, Chrome queue, merge pre-check |
| **[Built for Teams](docs/built-for-teams.md)** | Install, update, company config, ticket scout, i18n automation, self-learning retros |
| **[Features](docs/features.md)** | Full feature list — team setup, orchestration, review, resilience, self-learning |
| **[The Team](docs/the-team.md)** | Agent roster, roles, dynamic team sizing, agent definitions |
| **[Retrospectives](docs/retrospectives.md)** | Self-learning loop, learning destinations, feedback routing |
| **[Security Guide](SECURITY.md)** | Security ladder (3 levels), sandbox, network isolation, deny rules, bypass mode |
| **[Project Structure](docs/project-structure.md)** | Annotated file tree — commands, agents, scripts, security, docs |
| **[Token Efficiency](docs/token-efficiency.md)** | How DTF minimizes AI costs — no MCP, deterministic nodes, disk-based memory, targeted reads |
| **[Integrations](docs/integrations.md)** | Hooks, subagents, GitHub Actions, Slack |
| **[Setup Guide](SETUP-GUIDE.md)** | Full reference — company config creation, DTF CLI, lifecycle walkthrough, troubleshooting |

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

## Tech Stack

Built for monorepos with:
- **Frontend:** React, TypeScript, Vite, Tailwind CSS, RTK Query
- **Backend:** .NET Web API, Entity Framework Core, C#
- **Infrastructure:** Docker Compose, EF Core Migrations

The agent prompts reference these technologies, but the framework is adaptable. You can modify the agent definitions in [`commands/my-dream-team.md`](commands/my-dream-team.md) to match your stack.

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

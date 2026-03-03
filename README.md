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

### Parallel everything — 4x story output or more

Run 4, 6, 10 tickets simultaneously. Each ticket gets its own git worktree, its own Docker containers with isolated ports, and its own agent team — completely independent, zero conflicts.

Backend and frontend agents work in parallel within each ticket via a shared API contract defined upfront by the architect. The orchestrator pre-analyzes all tickets in parallel before any session starts, so agents begin with full context from minute one.

Pause a workspace overnight (zero token cost), resume the next day with full context rebuilt from disk — multi-day tickets don't break the flow. A Chrome browser queue coordinates visual sign-off across parallel worktrees so multiple tickets can verify without conflicts. Known hot files are checked against `origin/main` before every push — merge conflicts caught early, not during review.

The bottleneck stops being "how fast can one developer code" and becomes "how many tickets can your team review." A single developer can sustain the story output of a 4-person team — or more — because the work happens concurrently, not sequentially.

### Lean by design — cut your AI spend, not your output

Most AI coding workflows burn tokens fast: MCP servers that inject thousands of schema tokens per call, agents that load entire codebases into context, and retry loops that run until the budget is gone. Dream Team Flow is built the opposite way.

Each ticket is analyzed and routed to the right mode — full multi-agent team, lite, or just a worktree — so trivial tickets cost zero AI spend and only complex ones get the full team. Right-sizing per ticket is the single biggest lever for controlling costs.

Formatting, linting, type checks, and builds run as shell scripts — zero LLM tokens. Agents use structured handoff templates (files touched, contract deviations, exact next steps) instead of free-text messages, eliminating 3-5 rounds of back-and-forth per handoff.

Deadlock detection catches stuck agents at 10 minutes — no more silently burning tokens on idle sessions. CI fixes are capped at 2 rounds, then escalated. Per-ticket API costs stay predictable regardless of ticket complexity.

### Built for teams — onboard in minutes, not days

One command to install, one command to update. Share a `company-config.json` to auto-configure service names, Jira domain, ticket prefixes, and paths — new developers go from zero to shipping PRs in minutes, not days of setup.

`dtf update` deep-merges new hooks and commands with each developer's personal config — team-wide rollouts without breaking anyone's setup.

`/ticket-scout` pre-analyzes upcoming tickets before sprint planning, flagging vague requirements and missing acceptance criteria before any development time is spent — a calibration loop from completed tickets improves estimates over time.

i18n is automated: new UI text ships with all supported languages from day one via Lokalise API calls, with a hard gate that blocks the PR until every key is created.

Every session ends with a structured retrospective: learnings are routed automatically — personal config changes apply immediately, shared conventions go through Jira tickets and PRs for team review. The team gets smarter with every ticket shipped. Works on macOS, Linux, and Windows (WSL) with 10 supported terminals.

### Secure by default — compliance without slowing down

Every PR goes through a 7-category OWASP-aligned security scan — injection, auth/authz, data exposure, path traversal, hardcoded secrets, insecure defaults, and XSS — before it ever reaches a human reviewer. No separate security tooling to buy, configure, or maintain.

When any agent needs to change the database schema, work stops — the architect produces multiple options with Mermaid ER diagrams, posts them to the PR, and waits for explicit human approval. Agents cannot autonomously change your data model.

`TaskCompleted` and `TeammateIdle` hooks physically prevent agents from marking tasks done or going idle without notes, journal entries, code changes, and passing type checks — quality enforcement is mechanical, not voluntary.

Dream Team Flow ships with a three-tier permission ladder — personal sandbox, shared project standards, and team-enforced lockdown — so you control exactly what agents can read, write, and execute. For regulated industries, this means security review and change governance are built into the pipeline, not bolted on after.

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

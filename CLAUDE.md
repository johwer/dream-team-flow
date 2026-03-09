# Global Claude Configuration

## Team Setup (DTF CLI)

Dream Team Flow supports team-wide deployment via the `dtf` CLI. One command to install, one command to update.

**For new team members:**
```bash
# Public repo (generic):
dtf install https://github.com/johwer/dream-team-flow

# With company config (de-sanitizes names, sets defaults):
dtf install https://github.com/johwer/dream-team-flow --company-config company-config.json
```

**Key commands:**
| Command | What it does |
|---------|-------------|
| `dtf install <URL> [--company-config <path>]` | Clone repo, interactive wizard, symlink everything into `~/.claude/` |
| `dtf update` | Pull latest changes, verify symlinks, regenerate CLAUDE.md |
| `dtf doctor` | Health check — config, symlinks, required tools |
| `dtf contribute` | Export your retro learnings as a PR to the shared repo |

**Company config** (`company-config.json`) — shared by a team lead, contains:
- Project/repo name, Jira domain, ticket prefix
- Service name mappings (any number)
- Default paths and extra project-specific paths
- During install, all generic names get replaced with real ones

**Personal config** (`~/.claude/dtf-config.json`) — per-user, never committed:
- Monorepo path, worktree parent, terminal preference
- Extra paths (from company config + user-added)
- All commands read this config and adapt automatically

See `~/.claude/docs/integrations.md` for full details.

## Custom Commands

These commands are available globally from any project:

**Dream Team & Workspace:**
- `/create-stories` — Full lifecycle orchestrator: takes one or more ticket IDs, sets up worktrees, launches Dream Teams, and handles cleanup when done
- `/workspace-launch` — Create a git worktree from a Jira ticket and spin up a Dream Team session
- `/workspace-cleanup` — Tear down a worktree, tmux session, and optionally delete the branch
- `/my-dream-team` — Orchestrate a multi-agent team to implement a Repo feature ticket. Flags: `--lite` (Claude decides agent usage), `--no-worktree` (work in current dir), `--local` (no PR/push), `--resume`

**Code Review & Analysis:**
- `/review-pr` — Review a PR with line-level GitHub comments. Auto-detects PR from current branch, or specify a PR number. Fast (API-only) or full (local worktree + builds + deeper review with `--full`)
- `/ticket-scout` — Batch sprint triage: scan tickets, assign story points 1-4, verdict (READY/REFINE/PUSH BACK/SKIP)
- `/ticket-refine` — Deep quality gate for a single ticket: push back on missing info, domain model impact, UX flows, conflicts. Depth scales with story points
- `/ticket-examples` — On-demand code variation examples: enumerate all enum/type combinations from existing codebase patterns for a ticket

**Team & Config:**
- `/reviewers` — Manage pre-configured PR reviewers per category (frontend, backend, fullstack, infra, data). Auto-assigned when Dream Team PRs go ready.
- `/team-stats` — Dream Team leaderboard and history
- `/retro-proposals` — Analyze Dream Team learnings and route improvements to destination files
- `/pr-insights` — Surface review patterns from scraped PR data and propose convention changes
- `/sync-config` — Push all Claude config to GitHub (private + sanitized public repos). New commands/skills must be added to `PLUGIN_FILES`/`PLUGIN_DIRS` in `~/.claude/scripts/sync-config.sh` to be tracked
- `/acli-jira-cheatsheet` — Reference for ACLI Jira CLI commands

## Subagents

Standalone agents in `~/.claude/agents/` — usable from any project:

| Agent | Model | Purpose |
|-------|-------|---------|
| `architect` | Opus | Architecture analysis, conventions summaries, implementation plans |
| `backend-dev` | Sonnet | .NET backend implementation |
| `frontend-dev` | Sonnet | React/TypeScript frontend implementation |
| `pr-reviewer` | Opus | Code review with categorized feedback (MUST FIX / SUGGESTION / QUESTION / PRAISE) |
| `data-engineer` | Sonnet | Data mapping, EF Core migrations, pipelines |

Usage: "Use the pr-reviewer subagent to review this" or Claude delegates automatically based on task.

## Hooks

Active hooks in `~/.claude/settings.json`:
- **Tool usage logging** — Logs all tool calls for analytics (async, non-blocking)
- **Desktop notification** — macOS notification when Claude needs attention (idle, permission prompt)
- **Migration guard** — Warns when editing files in `migrations/` directories
- **Lock file guard** — Warns when editing lock files (package-lock.json, pnpm-lock.yaml, yarn.lock)
- **Auto-lint reminder** — Reminds to run CSharpier (.cs) or ESLint (.ts/.tsx) before committing
- **Teammate idle gate** — Prevents dev agents from going idle without notes, journal, and clean formatting (TeammateIdle hook)
- **Task completed gate** — Prevents dev agents from marking tasks complete without notes, journal, code changes, and passing type checks (TaskCompleted hook)

## Integrations

See `~/.claude/docs/integrations.md` for full details including prerequisites and setup instructions.

| Integration | Status |
|-------------|--------|
| GitHub Actions (`@claude` in PRs) | Workflow ready — needs `ANTHROPIC_API_KEY` repo secret |
| Slack (`@Claude` in channels) | Documented — needs Claude Code on the Web + Pro/Max/Teams plan |
| Code intelligence plugin | Documented — run `/plugin` to browse marketplace |

## Jira Integration

- Use `acli jira workitem` commands to interact with Jira (see `/acli-jira-cheatsheet` for full reference)
- **Jira attachments** — download via API (preferred) or Chrome (fallback):
  ```bash
  # API download (uses ACLI OAuth token from keychain — no Chrome needed)
  bash ~/.claude/scripts/jira-download-attachments.sh <TICKET_ID> [OUTPUT_DIR]

  # Fallback: open in Chrome for authenticated download
  open -a "Google Chrome" "<ATTACHMENT_URL>"
  ```

## Pre-PR Quality Gates

Before pushing code or creating PRs, follow the shared checklist: `~/.claude/docs/dev-workflow-checklist.md`
Covers: visual verification, i18n/TranslationService, PR lifecycle, review comment resolution, formatting, CI iteration cap (2 rounds max).

**Deterministic quality gate script** — run before every push to handle formatting/linting/builds without burning LLM tokens:
```bash
bash ~/.claude/scripts/quality-gate.sh <worktree-path>
```

## Workspace Preferences

- **Terminal app:** `Alacritty` — used when opening new windows for worktrees
- To change, update the terminal app name above
- Supported terminals (10):
  - Cross-platform: `Alacritty`, `Kitty`, `WezTerm`, `Ghostty`, `Warp`
  - macOS only: `Terminal`, `iTerm`/`iTerm2`
  - Linux only: `GNOME-Terminal`, `Konsole`
  - Windows (WSL): `Windows-Terminal`

## Repo Monorepo

- Main repo: `~/Documents/Repo`
- Worktrees (Dream Team): `~/Documents/<TICKET_ID>`
- Worktrees (PR Review): `~/Documents/Repo/.claude/worktrees/pr-review-<PR>`
- Tech stack: React/Vite/TypeScript/Tailwind frontend, .NET microservices backend

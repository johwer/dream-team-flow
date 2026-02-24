# Dream Team Flow — Setup Guide

```
██████╗ ██████╗ ███████╗ █████╗ ███╗   ███╗    ████████╗███████╗ █████╗ ███╗   ███╗
██╔══██╗██╔══██╗██╔════╝██╔══██╗████╗ ████║    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
██║  ██║██████╔╝█████╗  ███████║██╔████╔██║       ██║   █████╗  ███████║██╔████╔██║
██║  ██║██╔══██╗██╔══╝  ██╔══██║██║╚██╔╝██║       ██║   ██╔══╝  ██╔══██║██║╚██╔╝██║
██████╔╝██║  ██║███████╗██║  ██║██║ ╚═╝ ██║       ██║   ███████╗██║  ██║██║ ╚═╝ ██║
╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝       ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
```

Detailed setup and reference for Dream Team Flow. For quick start, see [README.md](README.md).

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Install (Individual)](#2-install-individual)
3. [Install (Team / Enterprise)](#3-install-team--enterprise)
4. [Creating a Company Config](#4-creating-a-company-config)
5. [DTF CLI Reference](#5-dtf-cli-reference)
6. [Tool Installation](#6-tool-installation)
7. [Claude Code Settings](#7-claude-code-settings)
8. [Supported Terminals](#8-supported-terminals)
9. [Full Lifecycle Walkthrough](#9-full-lifecycle-walkthrough)
10. [Pause & Resume](#10-pause--resume)
11. [Hooks & Guardrails](#11-hooks--guardrails)
12. [Subagents](#12-subagents)
13. [Troubleshooting](#13-troubleshooting)
14. [File Reference](#14-file-reference)

---

## 1. Prerequisites

| Tool | Required | Install |
|------|----------|---------|
| [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) | Yes | `npm install -g @anthropic-ai/claude-code` |
| Git | Yes | Pre-installed on macOS; `apt install git` on Linux |
| [Homebrew](https://brew.sh) | Recommended | `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"` |
| tmux | Yes | `brew install tmux` |
| jq | Yes | `brew install jq` |
| [gh](https://cli.github.com) | Recommended | `brew install gh` |
| Node.js | For frontend | Via [nvm](https://github.com/nvm-sh/nvm) |
| A supported terminal | Yes | See [Section 8](#8-supported-terminals) |

**Optional:**

| Tool | Purpose | Install |
|------|---------|---------|
| [ACLI](https://developer.atlassian.com/cloud/jira/platform/acli/) | Jira integration | `brew tap atlassian/homebrew-acli && brew install acli` |
| Chrome | Jira attachment viewing | Pre-installed or download |

---

## 2. Install (Individual)

For solo use or trying it out:

```bash
# 1. Clone the repo
git clone https://github.com/your-username/dream-team-flow.git

# 2. Install CLI tools
brew install tmux jq

# 3. Run the installer
bash dream-team-flow/scripts/dtf.sh install https://github.com/your-username/dream-team-flow
```

The installer will ask you:
1. Your name and GitHub username
2. Where your monorepo lives (e.g., `~/Documents/MyProject`)
3. Where to create worktrees (e.g., `~/Documents`)
4. Which terminal you use (pick from 10)

**What it does:**
- Creates `~/.claude/dtf-config.json` with your personal settings
- Symlinks all commands, scripts, agents, skills, and docs into `~/.claude/`
- Merges hooks into your existing `~/.claude/settings.json`
- Generates `~/.claude/CLAUDE.md` from the template with your settings
- Adds `dtf` to your PATH

---

## 3. Install (Team / Enterprise)

For teams sharing a workflow:

### Option A: Company fork with config baked in

Your team lead forks the repo, adds `company-config.json` to the fork, and shares the fork URL:

```bash
# Team members just run:
bash dream-team-flow/scripts/dtf.sh install https://github.com/your-org/dream-team-flow
```

The installer detects `company-config.json` in the repo and applies it automatically.

### Option B: Public repo + separate config file

Your team lead shares a `company-config.json` file (via Slack, email, or internal docs):

```bash
bash dream-team-flow/scripts/dtf.sh install https://github.com/your-username/dream-team-flow \
  --company-config ~/Downloads/company-config.json
```

### What company config does

During install, the company config:
1. **De-sanitizes generic names** — Replaces `Repo` with your project name, `ServiceA` with real service names, `PROJ-` with your Jira prefix
2. **Sets default paths** — Suggests your team's standard paths (users can override)
3. **Asks about extra paths** — Project-specific directories defined by the team lead
4. **Configures Jira** — Sets your Jira domain and ticket prefix

After install, each team member has a fully personalized setup that follows team conventions.

---

## 4. Creating a Company Config

Team leads create a `company-config.json` to standardize the setup for their team.

### Template

```json
{
  "projectName": "YourProject",
  "repoUrl": "git@github.com:your-org/your-repo.git",
  "ticketPrefix": "PROJ",
  "jiraDomain": "your-company.atlassian.net",

  "services": {
    "ServiceA": "RealServiceName",
    "ServiceB": "AnotherService"
  },

  "defaultPaths": {
    "monorepo": "~/Documents/YourProject",
    "worktreeParent": "~/Documents"
  },

  "extraPaths": {
    "frontendApp": {
      "description": "Frontend app directory (relative to monorepo)",
      "default": "apps/web"
    },
    "backendServices": {
      "description": "Backend services directory (relative to monorepo)",
      "default": "services"
    }
  }
}
```

### Field Reference

| Field | Required | Description |
|-------|----------|-------------|
| `projectName` | Yes | Replaces `Repo` in all files |
| `repoUrl` | No | Git URL shown as default during install |
| `ticketPrefix` | Yes | Replaces `PROJ-` (e.g., `PLRS`, `JIRA`) |
| `jiraDomain` | No | Your Jira instance (e.g., `company.atlassian.net`) |
| `services` | No | Map of generic → real service names. Add as many as needed |
| `defaultPaths` | No | Suggested paths shown during install (users override) |
| `extraPaths` | No | Project-specific named paths. Each has a `description` and `default` |

**Services** can be any number — the installer replaces all occurrences in all text files:
```json
"services": {
  "ServiceA": "Absence",
  "ServiceB": "HCM",
  "ServiceC": "IAM",
  "ServiceD": "Messenger",
  "TranslationService": "Lokalise"
}
```

**Extra paths** are asked during install. Users can accept the default or enter their own:
```json
"extraPaths": {
  "frontendApp": {
    "description": "Path to the frontend app within the monorepo (relative to monorepo root)",
    "default": "apps/web"
  }
}
```

See `company-config.example.json` in the repo for a fully documented example.

---

## 5. DTF CLI Reference

After install, the `dtf` command is available globally.

### `dtf install <URL> [--company-config <path>]`

Full setup: clone repo, interactive wizard, create symlinks, apply company config, generate CLAUDE.md.

### `dtf update`

```bash
dtf update
```

Pulls latest changes from the workflow repo, verifies symlinks, re-merges settings.json, regenerates CLAUDE.md, and shows what changed.

### `dtf doctor`

```bash
dtf doctor
```

Health check that verifies:
- `~/.claude/dtf-config.json` exists and is valid
- All symlinks are intact
- Required tools are installed (jq, tmux, gh)
- Monorepo path exists

### `dtf contribute`

```bash
dtf contribute
```

Exports your local Dream Team retro learnings as a PR to the workflow repo. Team leads review and curate into `learnings/aggregated-learnings.md`.

---

## 6. Tool Installation

### tmux

Used for session management — running Claude in background tmux sessions.

```bash
brew install tmux
tmux -V  # verify
```

**Key tmux commands:**

| Command | What it does |
|---------|-------------|
| `tmux attach -t PROJ-1234` | Attach to a running session |
| `tmux list-sessions` | List all sessions |
| `Ctrl+B` then `D` | Detach (keeps session running) |
| `tmux kill-session -t PROJ-1234` | Kill a session |

### jq

Used by DTF scripts for JSON config parsing.

```bash
brew install jq
```

### ACLI (Jira CLI) — Optional

Enables Claude to fetch Jira tickets automatically.

```bash
brew tap atlassian/homebrew-acli
brew install acli
acli jira auth login --web  # authenticate via browser
acli jira workitem view PROJ-1234  # verify
```

### gh (GitHub CLI) — Recommended

Used for PR creation, review, and CI polling.

```bash
brew install gh
gh auth login  # authenticate
```

---

## 7. Claude Code Settings

The `dtf install` command merges these settings into your `~/.claude/settings.json` automatically. For reference:

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "preferences": {
    "tmuxSplitPanes": true
  }
}
```

| Setting | Purpose |
|---------|---------|
| `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` | Enables multi-agent team features |
| `tmuxSplitPanes` | Allows Claude to use tmux split panes |

Hooks are also merged — see [Section 11](#11-hooks--guardrails).

---

## 8. Supported Terminals

Dream Team Flow supports 10 terminals across macOS, Linux, and Windows (WSL).

| Terminal | macOS | Linux | Windows (WSL) | Install |
|----------|-------|-------|---------------|---------|
| **Alacritty** | yes | yes | yes | `brew install --cask alacritty` |
| **Kitty** | yes | yes | - | `brew install --cask kitty` |
| **WezTerm** | yes | yes | yes | `brew install --cask wezterm` |
| **Ghostty** | yes | yes | - | [ghostty.org](https://ghostty.org) |
| **Warp** | yes | yes | - | [warp.dev](https://warp.dev) |
| **Terminal.app** | yes | - | - | Built-in on macOS |
| **iTerm/iTerm2** | yes | - | - | `brew install --cask iterm2` |
| **GNOME Terminal** | - | yes | - | `apt install gnome-terminal` |
| **Konsole** | - | yes | - | `apt install konsole` |
| **Windows Terminal** | - | - | yes | Microsoft Store |

Your terminal preference is set during `dtf install` and stored in `~/.claude/dtf-config.json`. To change it later, edit the `terminal` field.

Platform guards prevent selecting a terminal that doesn't work on your OS (e.g., Terminal.app on Linux).

---

## 9. Full Lifecycle Walkthrough

### Starting work on a ticket

```
/create-stories PROJ-1234
```

Or multiple tickets:

```
/create-stories PROJ-1234 PROJ-1235
```

**What happens automatically:**

1. **Fetches ticket** from Jira via ACLI
2. **Handles attachments** — opens in Chrome for authenticated download
3. **Confirms** ticket details with you
4. **Creates git worktree** at `<worktreeParent>/PROJ-1234` with a new branch
5. **Installs dependencies** in the frontend
6. **Copies `.env.local`** from the main repo
7. **Opens your terminal** with a new window
8. **Starts Claude in tmux** with `--dangerously-skip-permissions`
9. **Sends `/my-dream-team`** with the ticket description

### What the Dream Team does

| Phase | What happens |
|-------|-------------|
| **1. Architecture** | Amara analyzes the ticket, reads codebase, determines scope, sizes the team |
| **2. Implementation** | Spawns agents (Kenji, Ingrid, Diego, etc.) based on architect's analysis — work in parallel |
| **3. Review** | Maya reviews all changes for security, conventions, i18n, tests |
| **4. Testing** | Suki runs functional tests (when flagged by architect) |
| **5. PR & CI** | Creates draft PR, polls CI checks and AI bot reviews |
| **6. User Review** | You review — ship it, give feedback, or test first |
| **7. Cleanup** | Worktree removed, branch optionally deleted, tmux killed |

### The feedback loop (Phase 6)

After the team finishes, you get three options:

- **"Done — ship it"** — triggers cleanup, merges PR
- **"I have feedback"** — describe what to change, agents fix it, re-review
- **"Let me test first"** — team stays alive while you test

### Standalone team (no lifecycle management)

Already have a branch? Run the team directly:

```
/my-dream-team <paste ticket description or Jira ID>
```

Local only (no PR, no push):

```
/my-dream-team --local <paste ticket description>
```

### PR review (no local checkout needed)

```
/review-pr              # auto-detect from current branch
/review-pr 1670         # fast mode (API only)
/review-pr 1670 --full  # full mode (local worktree + builds)
```

---

## 10. Pause & Resume

### Pause (close for the day)

```
pause PROJ-1234
```

Keeps the worktree intact but kills the tmux session and stops any dev servers.

### Resume (continue tomorrow)

```
resume PROJ-1234
```

Rebuilds context from agent notes in `.dream-team/notes/`, starts a fresh tmux session in the worktree directory, and relaunches Claude.

---

## 11. Hooks & Guardrails

These hooks are merged into `~/.claude/settings.json` during install:

| Hook | Trigger | What it does |
|------|---------|-------------|
| **Tool usage logging** | PostToolUse | Logs all tool calls to file for analytics |
| **Desktop notification** | Notification | macOS notification when Claude needs attention |
| **Migration guard** | Edit/Write | Warns when editing files in `migrations/` directories |
| **Lock file guard** | Edit/Write | Warns when editing lock files (package-lock.json, etc.) |
| **Auto-lint reminder** | Edit/Write | Reminds to run CSharpier (.cs) or ESLint (.ts/.tsx) before committing |

Hooks are non-destructive — they warn but don't block. Add more by editing `~/.claude/settings.json` or the `settings.json` in the workflow repo.

---

## 12. Subagents

Standalone agents available from any project:

| Agent | Model | Purpose |
|-------|-------|---------|
| `architect` | Opus | Architecture analysis, conventions, implementation plans |
| `backend-dev` | Sonnet | .NET backend implementation |
| `frontend-dev` | Sonnet | React/TypeScript frontend implementation |
| `pr-reviewer` | Opus | Code review with MUST FIX / SUGGESTION / QUESTION / PRAISE categories |
| `data-engineer` | Sonnet | Data mapping, EF Core migrations, pipelines |

**Usage:** Claude delegates automatically, or invoke explicitly:

```
Use the pr-reviewer subagent to review the changes in this PR
Use the architect subagent to analyze what files need changing
```

These are general-purpose standalone agents. The Dream Team (`/my-dream-team`) uses its own detailed prompts with coordination, context management, and phase-specific instructions on top.

---

## 13. Troubleshooting

### `dtf: command not found`

The installer creates a symlink at `/usr/local/bin/dtf`. If your PATH doesn't include that:

```bash
# Add to ~/.zshrc or ~/.bashrc:
export PATH="$PATH:/usr/local/bin"
```

Or run directly: `bash ~/.claude/scripts/dtf.sh <command>`

### `dtf doctor` reports broken symlinks

```bash
dtf update  # re-creates broken symlinks automatically
```

### Claude doesn't start in tmux

The launcher uses `sleep 8` to wait for Claude to boot. On slower machines, increase this in `~/.claude/scripts/launch-workspace.sh`.

### CLAUDECODE environment variable error

Claude Code sets `CLAUDECODE` to detect nested sessions. The launcher script runs `unset CLAUDECODE` automatically. If you still get errors, check that you're using the launcher script (not starting Claude manually inside an existing Claude session).

### Jira authentication expired

```bash
acli jira auth login --web
```

### Terminal window stays open after cleanup

After `tmux kill-session`, the terminal window may remain open but empty. Close it manually — this is a known limitation of terminal automation.

### Config file not found

If commands aren't finding your config:

```bash
# Check it exists:
cat ~/.claude/dtf-config.json

# Regenerate if missing:
dtf install <your-repo-url>
```

---

## 14. File Reference

### After `dtf install`, your `~/.claude/` looks like:

```
~/.claude/
  CLAUDE.md                              # Generated from template
  settings.json                          # Merged with hooks
  dtf-config.json                        # Personal config (never committed)
  commands/
    create-stories.md        → repo      # /create-stories
    my-dream-team.md         → repo      # /my-dream-team
    workspace-launch.md      → repo      # /workspace-launch
    workspace-cleanup.md     → repo      # /workspace-cleanup
    review-pr.md             → repo      # /review-pr
    acli-jira-cheatsheet.md  → repo      # /acli-jira-cheatsheet
    ticket-scout.md          → repo      # /ticket-scout
    team-stats.md            → repo      # /team-stats
    team-review.md           → repo      # /team-review
  scripts/
    dtf.sh                   → repo      # DTF CLI
    dtf-env.sh               → repo      # Config loader
    launch-workspace.sh      → repo      # Terminal launcher
    open-terminal.sh         → repo      # Cross-platform terminal opener
    resume-workspace.sh      → repo      # Resume paused workspace
    pause-workspace.sh       → repo      # Pause for the day
    poll-ai-reviews.sh       → repo      # AI bot review polling
    poll-ci-checks.sh        → repo      # CI check polling
    chrome-queue.sh          → repo      # Chrome browser queue
    migration-guard.sh       → repo      # Hook: migration guard
    lockfile-guard.sh        → repo      # Hook: lock file guard
    auto-lint-notify.sh      → repo      # Hook: lint reminders
  agents/
    architect.md             → repo      # Architecture analysis
    backend-dev.md           → repo      # .NET backend
    frontend-dev.md          → repo      # React/TypeScript frontend
    pr-reviewer.md           → repo      # Code review
    data-engineer.md         → repo      # Data engineering
  skills/
    mermaid-diagram/         → repo      # Mermaid diagram generation
  docs/
    integrations.md          → repo      # Integration reference
```

`→ repo` = symlinked to the workflow repo. Changes via `git pull` are reflected immediately.

### Personal config (`~/.claude/dtf-config.json`)

```json
{
  "version": 1,
  "user": {
    "name": "Your Name",
    "githubUsername": "your-username"
  },
  "paths": {
    "monorepo": "~/Documents/YourProject",
    "worktreeParent": "~/Documents",
    "workflowRepo": "~/path/to/dream-team-flow"
  },
  "extraPaths": {
    "frontendApp": "apps/web"
  },
  "terminal": "Alacritty"
}
```

This file is `.gitignore`d and never committed. Each team member has their own.

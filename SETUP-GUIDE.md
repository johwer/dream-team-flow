# Dream Team — Complete Setup Guide

```
██████╗ ██████╗ ███████╗ █████╗ ███╗   ███╗    ████████╗███████╗ █████╗ ███╗   ███╗
██╔══██╗██╔══██╗██╔════╝██╔══██╗████╗ ████║    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
██║  ██║██████╔╝█████╗  ███████║██╔████╔██║       ██║   █████╗  ███████║██╔████╔██║
██║  ██║██╔══██╗██╔══╝  ██╔══██║██║╚██╔╝██║       ██║   ██╔══╝  ██╔══██║██║╚██╔╝██║
██████╔╝██║  ██║███████╗██║  ██║██║ ╚═╝ ██║       ██║   ███████╗██║  ██║██║ ╚═╝ ██║
╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝       ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
```

This guide covers everything needed to set up the Claude Code Dream Team workflow for your monorepo. Follow each section in order.

---

## Quick Install

Clone the repo and run:

```bash
git clone https://github.com/your-username/shared-claude-files.git
cd shared-claude-files

# Create directories
mkdir -p ~/.claude/{commands,scripts,skills/mermaid-diagram}

# Copy everything
cp commands/*.md ~/.claude/commands/
cp scripts/launch-workspace.sh ~/.claude/scripts/
chmod +x ~/.claude/scripts/launch-workspace.sh
cp skills/mermaid-diagram/*.md ~/.claude/skills/mermaid-diagram/
cp CLAUDE.md ~/.claude/CLAUDE.md
cp settings.json ~/.claude/settings.json

# Install CLI tools
brew install tmux
brew tap atlassian/homebrew-acli
brew install acli

# Authenticate Jira
acli jira auth login --web

echo "Setup complete! Start Claude Code and try: /create-stories PROJ-1234"
```

> **After installing**, edit `~/.claude/CLAUDE.md` to set your repo path and terminal preference. See [Section 9](#9-configure-claudemd) for details.

For a detailed breakdown of each step, continue reading below.

---

## Summary

Everything is packaged in the `shared-claude-files/` folder. Here's what's included:

### Files

| File | Purpose |
|------|---------|
| `SETUP-GUIDE.md` | This document — complete setup documentation |
| `CLAUDE.md` | Global Claude config with workspace preferences |
| `settings.json` | Claude Code settings (agent teams + tmux split panes) |
| `commands/create-stories.md` | `/create-stories` — Full lifecycle orchestrator |
| `commands/workspace-launch.md` | `/workspace-launch` — Create worktree and start Dream Team |
| `commands/workspace-cleanup.md` | `/workspace-cleanup` — Tear down workspace |
| `commands/my-dream-team.md` | `/my-dream-team` — Multi-agent implementation team |
| `commands/acli-jira-cheatsheet.md` | `/acli-jira-cheatsheet` — Jira CLI reference |
| `scripts/launch-workspace.sh` | Self-contained terminal launcher script |
| `skills/mermaid-diagram/SKILL.md` | Mermaid diagram skill definition |
| `skills/mermaid-diagram/common-errors.md` | Common Mermaid syntax errors |
| `skills/mermaid-diagram/flowchart-reference.md` | Flowchart syntax reference |
| `skills/mermaid-diagram/sequence-reference.md` | Sequence diagram syntax reference |
| `skills/mermaid-diagram/class-reference.md` | Class diagram syntax reference |

### What this guide covers

1. **Prerequisites** — what you need before starting
2. **Claude Code settings** — `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` and `tmuxSplitPanes`
3. **tmux** — install via Homebrew for session management
4. **ACLI** — Jira CLI install + authentication
5. **Chrome plugin** — for viewing Jira attachment images
6. **Custom commands** — where to place them (`~/.claude/commands/`)
7. **Launcher script** — where to place it (`~/.claude/scripts/`)
8. **Mermaid skill** — where to place it (`~/.claude/skills/mermaid-diagram/`)
9. **CLAUDE.md config** — terminal preference and repo paths
10. **Supported terminals** — Alacritty, Terminal.app, iTerm
11. **Full lifecycle walkthrough** — from `/create-stories` to cleanup
12. **Work in progress** — known limitations and planned improvements
13. **File reference** — directory structure and one-shot install script

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Claude Code Settings](#2-claude-code-settings)
3. [Install tmux](#3-install-tmux)
4. [Install ACLI (Jira CLI)](#4-install-acli-jira-cli)
5. [Chrome Claude Plugin](#5-chrome-claude-plugin)
6. [Place Custom Commands](#6-place-custom-commands)
7. [Place the Launcher Script](#7-place-the-launcher-script)
8. [Install the Mermaid Diagram Skill](#8-install-the-mermaid-diagram-skill)
9. [Configure CLAUDE.md](#9-configure-claudemd)
10. [Supported Terminals](#10-supported-terminals)
11. [Full Lifecycle Walkthrough](#11-full-lifecycle-walkthrough)
12. [Work in Progress](#12-work-in-progress)
13. [File Reference](#13-file-reference)

---

## 1. Prerequisites

- **Claude Code CLI** installed (`claude` command available in terminal)
- **Homebrew** installed (https://brew.sh)
- **Git** installed
- **Node.js** (managed via nvm, the project uses v25)
- A terminal app: **Alacritty**, **Terminal.app**, or **iTerm**

---

## 2. Claude Code Settings

Claude Code needs experimental agent teams enabled and tmux split panes configured.

**File:** `~/.claude/settings.json`

Copy the provided `settings.json` to `~/.claude/settings.json`:

```bash
cp shared-claude-files/settings.json ~/.claude/settings.json
```

Or create it manually with this content:

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

**What each setting does:**

| Setting | Purpose |
|---------|---------|
| `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` | Enables the multi-agent team features (TeamCreate, SendMessage, etc.) |
| `tmuxSplitPanes` | Allows Claude to use tmux split panes for parallel agent work |

> **Note:** If you already have a `settings.json` with other settings (hooks, statusLine, etc.), just merge the `env` and `preferences` keys into your existing file.

---

## 3. Install tmux

tmux is used to run Claude sessions in the background so you can detach/reattach.

```bash
brew install tmux
```

Verify it works:

```bash
tmux -V
```

**Basic tmux commands you'll need:**

| Command | What it does |
|---------|-------------|
| `tmux attach -t PROJ-1234` | Attach to a running session |
| `tmux list-sessions` | List all tmux sessions |
| `Ctrl+B` then `D` | Detach from a session (keeps it running) |
| `tmux kill-session -t PROJ-1234` | Kill a session |

---

## 4. Install ACLI (Jira CLI)

ACLI lets Claude fetch ticket details from Jira automatically.

### Install

```bash
brew tap atlassian/homebrew-acli
brew install acli
```

### Authenticate

```bash
acli jira auth login --web
```

This opens your browser for OAuth authentication. Follow the prompts to log in with your Jira account.

### Verify

```bash
acli jira workitem view PROJ-1234
```

(Replace with any valid ticket ID)

### Troubleshooting

- If `acli` is not found after install, restart your terminal or run `source ~/.zshrc`
- If authentication expires, re-run `acli jira auth login --web`
- See the `acli-jira-cheatsheet.md` command for a full reference of Jira CLI operations

---

## 5. Chrome Claude Plugin

The Chrome plugin is needed for Claude to view images and screenshots from Jira tickets.

### Install the MCP Chrome Connector

1. Open Chrome and go to the Chrome Web Store
2. Search for **"Claude Code Chrome Connector"** (or the Puppeteer MCP connector your team uses)
3. Install the extension
4. Enable it in Chrome settings

### Why it's needed

- Jira attachments (design mockups, screenshots) require browser authentication
- `curl`/`wget` will get 401 Unauthorized on Jira attachment URLs
- The workflow uses `open -a "Google Chrome" "<URL>"` to download attachments through the authenticated browser session
- Claude can then read the downloaded files from `~/Downloads/`

### How it works in the workflow

When a Jira ticket has attachments:
1. Claude opens each attachment URL in Chrome
2. Chrome downloads the file (authenticated session)
3. Claude reads the downloaded file to understand the design/context

---

## 6. Place Custom Commands

Custom commands are slash commands (`/command-name`) available in Claude Code. They go in `~/.claude/commands/`.

### Create the directory

```bash
mkdir -p ~/.claude/commands
```

### Copy the command files

```bash
cp shared-claude-files/commands/*.md ~/.claude/commands/
```

### What each command does

| File | Slash Command | Purpose |
|------|--------------|---------|
| `create-stories.md` | `/create-stories` | Full lifecycle orchestrator: fetches Jira ticket, creates worktree, installs deps, opens terminal, launches Dream Team |
| `workspace-launch.md` | `/workspace-launch` | Creates a git worktree from a ticket and sets up the workspace |
| `workspace-cleanup.md` | `/workspace-cleanup` | Tears down a worktree, tmux session, and optionally deletes the branch |
| `my-dream-team.md` | `/my-dream-team` | Orchestrates a multi-agent team (architect, devs, reviewer) to implement a feature |
| `acli-jira-cheatsheet.md` | `/acli-jira-cheatsheet` | Quick reference for ACLI Jira CLI commands |

### Verify

Start Claude Code and type `/` — you should see all commands listed.

---

## 7. Place the Launcher Script

The launcher script runs in new terminal windows to start Claude sessions without the "nested session" error.

### Create the directory

```bash
mkdir -p ~/.claude/scripts
```

### Copy the script

```bash
cp shared-claude-files/scripts/launch-workspace.sh ~/.claude/scripts/
chmod +x ~/.claude/scripts/launch-workspace.sh
```

### What it does

The script is called automatically by `/create-stories`. It:
1. `cd`s to the worktree directory
2. Unsets the `CLAUDECODE` environment variable (prevents nested session error)
3. Starts a tmux session
4. Launches `claude --dangerously-skip-permissions` inside tmux
5. Waits for Claude to boot, then sends the `/my-dream-team` command
6. Attaches to the tmux session so you can see the output

### Manual usage

```bash
bash ~/.claude/scripts/launch-workspace.sh PROJ-1234 "/my-dream-team Your ticket description here"
```

---

## 8. Install the Mermaid Diagram Skill

Skills are reusable capabilities that Claude can invoke. The mermaid-diagram skill helps create valid Mermaid diagrams for domain model proposals.

### Create the directory

```bash
mkdir -p ~/.claude/skills/mermaid-diagram
```

### Copy the skill files

```bash
cp shared-claude-files/skills/mermaid-diagram/*.md ~/.claude/skills/mermaid-diagram/
```

### Skill files

| File | Purpose |
|------|---------|
| `SKILL.md` | Main skill definition — Claude reads this to understand how to create diagrams |
| `common-errors.md` | List of common Mermaid syntax errors and how to avoid them |
| `flowchart-reference.md` | Flowchart diagram syntax reference |
| `sequence-reference.md` | Sequence diagram syntax reference |
| `class-reference.md` | Class diagram syntax reference |

### How it's used

The Dream Team's tech-architect uses this skill when domain model changes are proposed. It generates ER diagrams, class diagrams, and flow charts for the user to review before approving schema changes.

### Downloading from source

If you want the latest version instead of the copy provided here:
1. Go to the skill's source repository/marketplace
2. Download the skill package (usually a `.zip` or folder)
3. Extract/place all `.md` files into `~/.claude/skills/mermaid-diagram/`
4. The `SKILL.md` file is required — it must have the YAML frontmatter with `name`, `description`, and `allowed-tools`

---

## 9. Configure CLAUDE.md

`CLAUDE.md` is Claude Code's global instruction file. It tells Claude about your project setup, preferences, and available commands.

### Copy the template

```bash
cp shared-claude-files/CLAUDE.md ~/.claude/CLAUDE.md
```

### Customize

Edit `~/.claude/CLAUDE.md` to set your preferences:

**Terminal preference** — change `Alacritty` to your preferred terminal:

```markdown
- **Terminal app:** `Alacritty` (options: `Terminal`, `Alacritty`, `iTerm`)
```

**Monorepo paths** — update if your repo is in a different location:

```markdown
- Main repo: `~/Documents/Repo`
- Worktrees: `~/Documents/<TICKET_ID>`
```

---

## 10. Supported Terminals

The workspace launcher supports three terminal emulators. Set your preference in `~/.claude/CLAUDE.md`.

| Terminal | Launch Method | Notes |
|----------|-------------|-------|
| **Alacritty** | `alacritty -e bash ...` | Fast GPU-accelerated terminal. Install: `brew install --cask alacritty` |
| **Terminal.app** | AppleScript `do script` | Built into macOS, no install needed |
| **iTerm** | AppleScript iTerm API | Popular macOS terminal. Install: `brew install --cask iterm2` |

To change your default, edit `~/.claude/CLAUDE.md`:

```markdown
- **Terminal app:** `Terminal` (options: `Terminal`, `Alacritty`, `iTerm`)
```

---

## 11. Full Lifecycle Walkthrough

Here's how everything works end-to-end:

### Starting work on a ticket

```
/create-stories PROJ-1234
```

or for multiple tickets:

```
/create-stories PROJ-1234 PROJ-1235
```

**What happens automatically:**

1. **Fetches ticket** from Jira via ACLI
2. **Handles attachments** — opens in Chrome if the ticket has design mockups
3. **Confirms** ticket details with you
4. **Creates git worktree** at `~/Documents/PROJ-1234` with a new branch
5. **Installs npm dependencies** in the frontend
6. **Copies `.env.local`** from the main repo
7. **Opens a new terminal window** (your configured terminal)
8. **Starts Claude in tmux** with `--dangerously-skip-permissions`
9. **Sends `/my-dream-team`** with the ticket description

### What the Dream Team does

The team works in phases:

| Phase | What happens |
|-------|-------------|
| **1. Architecture** | Tech Architect analyzes the ticket, reads docs, explores codebase, determines scope |
| **2. Implementation** | Spawns needed agents (backend-dev, frontend-dev, infra-engineer) based on architect's analysis |
| **3. Coordination** | Team Lead monitors progress, routes questions between agents, handles blockers |
| **4. PR Review** | PR Reviewer checks all changes for security, conventions, tests, i18n |
| **5. Summary** | Lead Summary Writer produces a structured report of all changes |
| **6. User Review** | You are asked for feedback — provide changes or say "done" |
| **7. Cleanup** | Team shuts down, worktree is removed, branch optionally deleted, tmux session killed |

### The feedback loop (Phase 6)

After the team finishes, you get three options:

- **"Done — ship it"** — triggers cleanup, removes worktree, kills tmux
- **"I have feedback"** — describe what to change, agents fix it, re-review cycle
- **"Let me test first"** — team stays alive while you test, come back when ready

### Manual cleanup (if needed)

From your main Claude session:

```
/workspace-cleanup PROJ-1234
```

---

## 12. Work in Progress

These items are known limitations or planned improvements:

### Timing sensitivity
The launcher script uses `sleep 8` to wait for Claude to boot before sending the `/my-dream-team` command. On slower machines, this might not be enough. If the command doesn't go through, you can manually type it in the tmux session.

### tmux socket isolation
When launching tmux from a new terminal window, the tmux server runs independently. The parent Claude session cannot send commands to it via `tmux send-keys`. The launcher script works around this by running everything self-contained in the new terminal.

### CLAUDECODE environment variable
Claude Code sets a `CLAUDECODE` env var to detect nested sessions. When launching Claude from within another Claude session (even via tmux/osascript), this variable can leak through. The launcher script explicitly runs `unset CLAUDECODE` to prevent this.

### Terminal support
Currently three terminals are supported (Alacritty, Terminal.app, iTerm). Adding a new terminal requires updating the launch commands in both `create-stories.md` and `workspace-launch.md`.

### Self-cleanup limitations
The Dream Team can clean up its own worktree by `cd`-ing to the main repo first, then removing the worktree directory. The final `tmux kill-session` command terminates the session from within — this works but the terminal window may remain open (empty). Close it manually.

---

## 13. File Reference

### Complete directory structure

```
~/.claude/
  CLAUDE.md                              # Global instructions & preferences
  settings.json                          # Claude Code settings (agent teams, tmux)
  commands/
    create-stories.md                    # /create-stories — full lifecycle orchestrator
    workspace-launch.md                  # /workspace-launch — create worktree & start team
    workspace-cleanup.md                 # /workspace-cleanup — tear down workspace
    my-dream-team.md                     # /my-dream-team — multi-agent implementation team
    acli-jira-cheatsheet.md              # /acli-jira-cheatsheet — Jira CLI reference
  scripts/
    launch-workspace.sh                  # Self-contained launcher for new terminal windows
  skills/
    mermaid-diagram/
      SKILL.md                           # Skill definition
      common-errors.md                   # Common Mermaid syntax errors
      flowchart-reference.md             # Flowchart syntax reference
      sequence-reference.md              # Sequence diagram syntax reference
      class-reference.md                 # Class diagram syntax reference
```

### Quick install

See the [Quick Install](#quick-install) section at the top of this guide.

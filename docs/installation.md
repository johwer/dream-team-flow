# Installation

## Prerequisites

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) installed (v1.0.33+ for plugin support)
- [Homebrew](https://brew.sh) (macOS/Linux)
- Git, Node.js (via nvm), jq
- A supported terminal (see below)

## Install Methods

Dream Team Flow supports three install methods. Choose based on your setup:

| Method | Best for | What you get |
|--------|---------|-------------|
| **Plugin only** | Quick start, trying it out | Commands, agents, scripts via Claude Code plugin system |
| **DTF CLI only** | Legacy installs, no plugin support | Symlinks everything into `~/.claude/`, generates config |
| **Plugin + DTF CLI** | Teams (recommended) | Plugin for commands/agents, DTF CLI for company config |

### Method 1: Plugin Install

Install the marketplace and toolkit directly in Claude Code:

```bash
# Team (private — unsanitized, ready to use)
/plugin marketplace add johwer/marketplace-private
/plugin install claude-toolkit@marketplace-private

# Community (public — sanitized, needs company config to de-sanitize)
/plugin marketplace add johwer/marketplace
/plugin install claude-toolkit@marketplace
```

This gives you all commands (`/create-stories`, `/my-dream-team`, `/review-pr`, etc.), agents, scripts, and docs via Claude Code's built-in plugin system with auto-updates.

### Method 2: DTF CLI Install

```bash
git clone https://github.com/johwer/dream-team-flow.git
bash dream-team-flow/scripts/dtf.sh install https://github.com/johwer/dream-team-flow
brew install tmux jq
```

The installer:
1. Asks your name, GitHub username, monorepo path, and terminal preference
2. **Asks your role** (12 roles: Frontend Dev, Backend Dev, Fullstack, Data Engineer, Data Analyst, Infra/DevOps, QA/Tester, UAT Stakeholder, PO, Sales, Marketing, Customer Ops)
3. **Shows default workflow steps** for your role — you can customize, add, or remove
4. **Recommends external plugins** based on your role
5. Symlinks all commands, scripts, agents, and skills into `~/.claude/`
6. Generates your personal `CLAUDE.md` with your settings
7. Merges hooks into `settings.json`

### Method 3: Plugin + DTF CLI (recommended for teams)

Use the plugin for the toolkit and the DTF CLI for company-specific setup:

```bash
# 1. Install plugin (commands, agents, scripts)
/plugin marketplace add johwer/marketplace-private
/plugin install claude-toolkit@marketplace-private

# 2. Run DTF CLI for company config (Jira domain, service names, personal config)
git clone https://github.com/johwer/dream-team-flow.git
bash dream-team-flow/scripts/dtf.sh install https://github.com/johwer/dream-team-flow \
  --company-config company-config.json

# 3. Install CLI tools
brew install tmux jq
```

## Team / Enterprise Install

If your team lead shared a `company-config.json`, pass it during DTF CLI install:

```bash
bash dream-team-flow/scripts/dtf.sh install https://github.com/your-org/dream-team-flow \
  --company-config ~/Downloads/company-config.json
```

This de-sanitizes all generic names (Repo, ServiceA, PROJ-) with your company's real names, sets default paths, and asks about any project-specific paths your team uses.

For teams using the private marketplace, no de-sanitization is needed — files already have real names.

## Auto-Onboarding (for repo owners)

Add the marketplace to your project's `.claude/settings.json` so new team members get prompted automatically when they trust the project:

```json
{
  "extraKnownMarketplaces": {
    "marketplace-private": {
      "source": {
        "source": "github",
        "repo": "johwer/marketplace-private"
      }
    }
  },
  "enabledPlugins": {
    "claude-toolkit@marketplace-private": true
  }
}
```

## Update

**Plugin:** Updates happen automatically on startup (if `GITHUB_TOKEN` is set for private repos), or manually:
```bash
/plugin marketplace update
```

**DTF CLI:**
```bash
dtf update      # Pull latest, verify symlinks, regenerate CLAUDE.md
dtf configure   # Set or change role and workflow steps (existing users)
dtf steps list  # See your current workflow steps
dtf steps add   # Add a custom step (automated check or reminder)
dtf doctor      # Health check — config, symlinks, tools
```

## macOS Permissions

For visual verification (screenshots from agents), your terminal app needs **Screen Recording** permission:

1. **System Settings → Privacy & Security → Screen Recording**
2. Add your terminal app (e.g., Alacritty) — click **+** if not listed
3. Toggle it **on**
4. **Restart the terminal** for the change to take effect

You can open the settings pane directly:
```bash
open "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture"
```

Without this, agents can navigate Chrome and click elements via AppleScript, but cannot take screenshots for visual verification.

## Supported Terminals (10)

| Terminal | macOS | Linux | Windows (WSL) |
|----------|-------|-------|---------------|
| Alacritty | yes | yes | yes |
| Kitty | yes | yes | - |
| WezTerm | yes | yes | yes |
| Ghostty | yes | yes | - |
| Warp | yes | yes | - |
| Terminal.app | yes | - | - |
| iTerm/iTerm2 | yes | - | - |
| GNOME Terminal | - | yes | - |
| Konsole | - | yes | - |
| Windows Terminal | - | - | yes |

For detailed setup, company config creation, DTF CLI reference, and troubleshooting, see [SETUP-GUIDE.md](../SETUP-GUIDE.md).

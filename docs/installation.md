# Installation

## Prerequisites

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) installed
- [Homebrew](https://brew.sh) (macOS/Linux)
- Git, Node.js (via nvm), jq
- A supported terminal (see below)

## Install (one command)

```bash
# Clone and run the installer:
git clone https://github.com/your-username/dream-team-flow.git
bash dream-team-flow/scripts/dtf.sh install https://github.com/your-username/dream-team-flow

# Install CLI tools:
brew install tmux jq
```

The installer:
1. Asks your name, GitHub username, monorepo path, and terminal preference
2. Symlinks all commands, scripts, agents, and skills into `~/.claude/`
3. Generates your personal `CLAUDE.md` with your settings
4. Merges hooks into `settings.json`

## Team / Enterprise Install

If your team lead shared a `company-config.json`, pass it during install to auto-configure everything:

```bash
bash dream-team-flow/scripts/dtf.sh install https://github.com/your-org/dream-team-flow \
  --company-config ~/Downloads/company-config.json
```

This de-sanitizes all generic names (Repo, ServiceA, PROJ-) with your company's real names, sets default paths, and asks about any project-specific paths your team uses.

## Update

```bash
dtf update    # Pull latest, verify symlinks, regenerate CLAUDE.md
dtf doctor    # Health check — config, symlinks, tools
```

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

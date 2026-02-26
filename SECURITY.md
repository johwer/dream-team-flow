# Dream Team Flow — Security Guide

```
🔒 Security is not optional — it's the foundation everything else builds on.
```

Dream Team Flow uses Claude Code's security features to create safe, fast, autonomous development. This guide explains what's available, how to adopt it progressively, and how it works with the Dream Team's `--dangerously-skip-permissions` mode.

---

## Table of Contents

1. [Why Security Matters for AI Agents](#1-why-security-matters-for-ai-agents)
2. [The Security Ladder](#2-the-security-ladder)
3. [Quick Start](#3-quick-start)
4. [Level 1 — Personal Baseline](#4-level-1--personal-baseline)
5. [Level 2 — Project Standard](#5-level-2--project-standard)
6. [Level 3 — Team Enforced](#6-level-3--team-enforced)
7. [How It Works With --dangerously-skip-permissions](#7-how-it-works-with---dangerously-skip-permissions)
8. [The Sandbox Explained](#8-the-sandbox-explained)
9. [Network Isolation & The Proxy](#9-network-isolation--the-proxy)
10. [Permission Rules Deep Dive](#10-permission-rules-deep-dive)
11. [Settings File Hierarchy](#11-settings-file-hierarchy)
12. [Auditing & Monitoring](#12-auditing--monitoring)
13. [All Available Settings](#13-all-available-settings)
14. [FAQ](#14-faq)

---

## 1. Why Security Matters for AI Agents

When you run Dream Team Flow, you're giving AI agents access to:
- Your source code (read + write)
- Your terminal (bash commands)
- Your git history and credentials
- Your Docker environment
- Network access (API calls, package installs)

In full Dream Team mode with `--dangerously-skip-permissions`, agents run autonomously without asking you to approve each action. This is powerful — but it means **the safety net must be built into the configuration**, not into manual approval.

The security ladder below gives you that safety net. Each level adds controls that work **even in bypass mode**, so agents can move fast while staying within boundaries you define.

---

## 2. The Security Ladder

| Level | Name | Who | File | What it does |
|-------|------|-----|------|-------------|
| 0 | Default | Everyone (out of the box) | — | No sandbox, prompts for everything |
| **1** | **Personal Baseline** | All developers | `~/.claude/settings.local.json` | Sandbox + network isolation + secret protection |
| **2** | **Project Standard** | Teams sharing a repo | `<repo>/.claude/settings.json` | Approved command allowlist + curl/wget blocked |
| **3** | **Team Enforced** | Admins (Claude Teams/Enterprise) | Admin console | Managed settings users can't override |

**Recommendation:** Every DTF user should be at **Level 1** minimum. Teams should aim for **Level 2**. Enterprise deployments should use **Level 3**.

```
Level 0        Level 1              Level 2                Level 3
Default   →   Sandbox ON      →   Shared allowlist   →   Managed lockdown
              Secrets blocked      curl/wget blocked      Users can't override
              Network limited      Team-wide rules        Admin-controlled
              Auto-approve bash    Based on real data     No unsandboxed cmds
```

---

## 3. Quick Start

### Interactive setup (recommended)

```
/security-setup
```

This walks you through the ladder, audits your current state, and applies your chosen level.

### Manual setup

```bash
# Level 1 — copy to your personal settings
cp <dtf-repo>/security/level-1-personal.json ~/.claude/settings.local.json

# Level 2 — copy to your project (and commit)
cp <dtf-repo>/security/level-2-project.json <monorepo>/.claude/settings.json
cd <monorepo> && git add .claude/settings.json && git commit -m "Add Claude Code security settings"
```

### Audit only

```
/security-setup audit
```

---

## 4. Level 1 — Personal Baseline

**File:** `~/.claude/settings.local.json` (personal, never committed)

### What it does

| Control | Setting | Effect |
|---------|---------|--------|
| 🏗️ Sandbox | `sandbox.enabled: true` | Bash commands run in an isolated environment |
| 🌐 Network | `sandbox.network.allowedDomains` | Only GitHub, npm, NuGet, localhost can be reached |
| 🔑 Secrets | `permissions.deny: Read(.env*)` | .env, .ssh, credential files blocked from reading |
| 💥 Destructive | `permissions.deny: Bash(rm -rf /)` | Catastrophic commands blocked |
| 🐳 Docker | `sandbox.excludedCommands: ["docker"]` | Docker runs outside sandbox (needs host access) |
| ⚡ Auto-approve | `sandbox.autoAllowBashIfSandboxed: true` | Sandboxed bash skips permission prompts |
| 🔌 Localhost | `sandbox.network.allowLocalBinding: true` | Dev servers (Vite, dotnet) can bind ports |

### Why this makes Claude faster

With sandbox enabled and `autoAllowBashIfSandboxed: true`, Claude **stops asking permission for every bash command**. The sandbox is the trust boundary — anything inside it is safe by design. You get fewer interruptions AND better security.

### Config file

```json
{
  "permissions": {
    "deny": [
      "Read(.env*)",
      "Read(**/.ssh/**)",
      "Read(**/*credential*)",
      "Read(**/*secret*)",
      "Bash(rm -rf /)",
      "Bash(rm -rf ~)",
      "Bash(git push --force *)",
      "Bash(git reset --hard*)",
      "Bash(git clean -fd*)"
    ]
  },
  "sandbox": {
    "enabled": true,
    "autoAllowBashIfSandboxed": true,
    "excludedCommands": ["docker", "docker-compose"],
    "allowUnsandboxedCommands": true,
    "network": {
      "allowedDomains": [
        "github.com", "*.github.com",
        "api.anthropic.com",
        "registry.npmjs.org", "*.npmjs.org",
        "nuget.org", "*.nuget.org",
        "localhost"
      ],
      "allowUnixSockets": ["/var/run/docker.sock"],
      "allowLocalBinding": true
    }
  }
}
```

### Allowed network domains explained

| Domain | Why |
|--------|-----|
| `github.com`, `*.github.com` | git push/pull, gh CLI, API calls |
| `api.anthropic.com` | Claude API (required) |
| `registry.npmjs.org`, `*.npmjs.org` | npm install |
| `nuget.org`, `*.nuget.org` | dotnet restore |
| `localhost` | Local API testing, dev servers |

---

## 5. Level 2 — Project Standard

**File:** `<monorepo>/.claude/settings.json` (committed, shared with team)

### What it adds

Level 2 adds a **command allowlist** — pre-approved bash commands that Claude can run without prompts, even without sandbox. This is based on **real usage data from Dream Team sessions** (5244 logged tool calls analyzed).

### Allow list (based on real DTF usage)

| Category | Commands | Calls observed |
|----------|----------|---------------|
| **Node.js** | `npm run *`, `npm install*`, `npx *` | 85 |
| **dotnet** | `dotnet *` | 23 |
| **Git (safe)** | `git status*`, `git diff*`, `git log*`, `git branch*`, `git stash*`, `git fetch*`, `git checkout*`, `git add *`, `git commit *`, `git pull*`, `git push`, `git push origin *`, `git push -u *`, `git worktree *`, `git rebase *` | 312 |
| **GitHub CLI** | `gh *` | 87 |
| **Jira** | `acli *` | 63 |
| **Docker** | `docker *`, `docker-compose *` | 84 |
| **tmux** | `tmux *` | 12 |
| **File ops** | `ls *`, `mkdir *`, `cp *`, `chmod *`, `cat *`, `head *`, `tail *`, `wc *`, `pwd` | 65+ |
| **System** | `lsof *`, `ps *`, `sleep *` | 27+ |
| **DTF scripts** | `bash ~/.claude/scripts/*`, `bash scripts/*` | 94 |
| **Open** | `open *` | 7 |

### Deny list

| Command | Why blocked |
|---------|------------|
| `curl *` | Prevents arbitrary downloads. Use `WebFetch` tool instead |
| `wget *` | Same as curl |
| `rm -rf /`, `rm -rf ~` | Catastrophic filesystem destruction |
| `git push --force *` | Destructive force push (use `--force-with-lease` instead) |
| `git reset --hard*` | Discards all uncommitted work |
| `git clean -fd*` | Deletes untracked files permanently |
| `Read(.env*)` | Protects secrets and credentials |
| `Read(**/.ssh/**)` | Protects SSH keys |

### About curl

We observed 23 curl calls in real sessions — **100% were to localhost** for API testing (health checks, endpoint verification). If your team needs this, add a specific allow:

```json
"allow": ["Bash(curl *localhost*)"]
```

This allows local API testing while still blocking curl to external URLs.

### Config file

See `security/level-2-project.json` in the DTF repo.

---

## 6. Level 3 — Team Enforced

**File:** Managed settings via Claude for Teams/Enterprise admin console

### What it adds

| Control | Setting | Effect |
|---------|---------|--------|
| 🔒 No unsandboxed | `allowUnsandboxedCommands: false` | Every bash command must run in sandbox |
| 🌐 Managed domains | `allowManagedDomainsOnly: true` | Users can't add their own domains |
| 📋 Managed rules | `allowManagedPermissionRulesOnly: true` | Users can't add their own allow/deny rules |
| 🪝 Managed hooks | `allowManagedHooksOnly: true` | Users can't add their own hooks |

### How to apply

1. Go to **claude.ai** → **Admin Settings** → **Claude Code** → **Managed settings**
2. Paste the contents of `security/level-3-team.json`
3. Save

These settings are delivered from Anthropic's servers and **take highest precedence** — users cannot override them with local settings files.

### Config file

See `security/level-3-team.json` in the DTF repo.

---

## 7. How It Works With --dangerously-skip-permissions

This is the most important section. Dream Team worktrees use `--dangerously-skip-permissions` so agents can work autonomously. Here's what that flag actually does:

### What `--dangerously-skip-permissions` DOES

- Skips interactive **permission prompts** (the "Allow this?" dialogs)
- Claude doesn't pause to ask before running bash, editing files, etc.

### What `--dangerously-skip-permissions` does NOT do

- **Does NOT bypass deny rules** — if you deny `Bash(rm -rf /)`, it stays denied
- **Does NOT disable sandbox** — if sandbox is enabled, bash still runs sandboxed
- **Does NOT bypass network restrictions** — allowed domains still enforced
- **Does NOT bypass hooks** — PreToolUse/PostToolUse hooks still fire

### The security model

```
┌─────────────────────────────────────────────┐
│  --dangerously-skip-permissions             │
│  "Don't ask me, just do it"                 │
│                                             │
│  ┌───────────────────────────────────────┐  │
│  │  Deny Rules (always enforced)         │  │
│  │  "But NEVER do these things"          │  │
│  │                                       │  │
│  │  ┌───────────────────────────────┐    │  │
│  │  │  Sandbox (always enforced)    │    │  │
│  │  │  "And stay within these walls"│    │  │
│  │  │                               │    │  │
│  │  │  ┌───────────────────────┐    │    │  │
│  │  │  │  Network Proxy        │    │    │  │
│  │  │  │  "Only talk to these  │    │    │  │
│  │  │  │   domains"            │    │    │  │
│  │  │  └───────────────────────┘    │    │  │
│  │  └───────────────────────────────┘    │  │
│  └───────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
```

This means: **bypass mode with Level 1+ security is safer than default mode without it.** The bypass removes the prompts (speed), while the deny rules + sandbox provide the actual safety (protection).

---

## 8. The Sandbox Explained

### What it is

When `sandbox.enabled: true`, Claude Code creates an isolated execution environment for bash commands:

- **Filesystem**: Commands can only write to the current working directory and subdirectories
- **Network**: Only allowed domains can be reached (via a local proxy)
- **Process**: Commands run with restricted system access

### Platform support

| Platform | Technology | Install |
|----------|-----------|---------|
| macOS | Seatbelt framework | Built-in (no install needed) |
| Linux | bubblewrap + socat | `apt install bubblewrap socat` |
| WSL2 | bubblewrap + socat | `apt install bubblewrap socat` |
| WSL1 | Not supported | Use WSL2 instead |

### Excluded commands

Some commands need host-level access. These run **outside** the sandbox:

```json
"excludedCommands": ["docker", "docker-compose"]
```

Docker needs to talk to the Docker daemon socket, which the sandbox blocks. By excluding it, Docker commands work normally while everything else stays sandboxed.

### Auto-approve sandboxed bash

```json
"autoAllowBashIfSandboxed": true
```

This is the key setting that makes sandbox **improve speed**. Since sandboxed commands can't escape, Claude auto-approves them without prompting you. Fewer interruptions, same safety.

---

## 9. Network Isolation & The Proxy

### How it works

When you set `sandbox.network.allowedDomains`, Claude Code runs a **local HTTP/SOCKS proxy** that intercepts all outbound connections from sandboxed bash commands.

```
Bash command → tries to connect to example.com
       ↓
Local proxy checks: is example.com in allowedDomains?
       ↓
  YES → connection allowed
  NO  → 502 Bad Gateway (blocked)
```

### What the proxy prevents

- **Data exfiltration**: A compromised package can't phone home
- **Supply chain attacks**: Can't download arbitrary scripts from the internet
- **Accidental exposure**: API keys/tokens can't be sent to unknown servers

### What the proxy allows

- **Package installs**: npm, NuGet via their registries
- **Git operations**: Push/pull via GitHub
- **Local development**: localhost for dev servers and API testing
- **Claude API**: Required for Claude Code to function

### Domain wildcards

```json
"allowedDomains": ["*.github.com"]  // matches api.github.com, raw.github.com, etc.
```

### Unix sockets

Docker uses a Unix socket (`/var/run/docker.sock`), not TCP. Allow it separately:

```json
"allowUnixSockets": ["/var/run/docker.sock"]
```

### Localhost binding

Dev servers (Vite on :3000, .NET on :5001) need to bind ports on localhost:

```json
"allowLocalBinding": true
```

---

## 10. Permission Rules Deep Dive

### Evaluation order

**Deny > Ask > Allow** — deny rules always win.

### Rule syntax

| Pattern | Example | Matches |
|---------|---------|---------|
| Tool only | `Bash` | All bash commands |
| Tool + command | `Bash(npm run *)` | npm run build, npm run test, etc. |
| Tool + glob | `Read(.env*)` | .env, .env.local, .env.production |
| Tool + path | `Read(**/.ssh/**)` | Any file under any .ssh directory |
| Wildcard | `Bash(git *)` | All git commands |

### Important: deny rules apply EVEN in bypass mode

```json
{
  "permissions": {
    "deny": ["Bash(rm -rf /)"]  // This CANNOT be bypassed
  }
}
```

### Recommended deny rules for development

```json
"deny": [
  "Read(.env*)",           // Secrets in env files
  "Read(**/.ssh/**)",      // SSH keys
  "Read(**/*credential*)", // Credential files
  "Read(**/*secret*)",     // Secret files
  "Bash(rm -rf /)",        // Nuke root
  "Bash(rm -rf ~)",        // Nuke home
  "Bash(git push --force *)",   // Destructive force push
  "Bash(git reset --hard*)",    // Discard all work
  "Bash(git clean -fd*)"        // Delete untracked files
]
```

### Why `git push --force-with-lease` is allowed

`--force-with-lease` is the safe version of force push — it checks that you're not overwriting someone else's work. Dream Team uses it for rebasing. Only `--force` (without `--with-lease`) is blocked.

---

## 11. Settings File Hierarchy

Settings are merged with this precedence (highest wins):

```
1. Managed settings (admin console)         ← Highest priority
2. Command-line arguments (--model, etc.)
3. Project local  (.claude/settings.local.json)    ← Not committed
4. Project        (.claude/settings.json)          ← Committed (Level 2)
5. User local     (~/.claude/settings.local.json)  ← Not committed (Level 1)
6. User           (~/.claude/settings.json)        ← Your main settings
```

### Which file for what

| Purpose | File | Committed? |
|---------|------|-----------|
| **Your hooks, env, preferences** | `~/.claude/settings.json` | No |
| **Your security settings (Level 1)** | `~/.claude/settings.local.json` | No |
| **Team security settings (Level 2)** | `<repo>/.claude/settings.json` | Yes |
| **Your project overrides** | `<repo>/.claude/settings.local.json` | No |
| **Admin lockdown (Level 3)** | Admin console | N/A |

---

## 12. Auditing & Monitoring

### Tool usage logging

DTF includes a PostToolUse hook that logs every tool call:

```
~/.claude/logs/tool-usage.csv
```

Format: `timestamp, session_id, tool_name, summary`

Use `/security-setup audit` to analyze this data and see what commands are actually being used.

### Monitoring with OpenTelemetry

Claude Code supports OpenTelemetry metrics export for enterprise monitoring. See [Claude Code docs on monitoring](https://code.claude.com/docs/en/monitoring-usage).

### ConfigChange hooks

Audit settings changes in real-time:

```json
{
  "hooks": {
    "ConfigChange": [{
      "matcher": "",
      "hooks": [{
        "type": "command",
        "command": "echo \"$(date) Config changed\" >> ~/.claude/logs/config-changes.log",
        "timeout": 5
      }]
    }]
  }
}
```

---

## 13. All Available Settings

### Complete field reference

<details>
<summary>Click to expand — all 80+ configurable fields</summary>

#### Permissions
| Field | Type | Description |
|-------|------|-------------|
| `permissions.defaultMode` | string | `default`, `acceptEdits`, `plan`, `dontAsk`, `bypassPermissions` |
| `permissions.allow` | string[] | Tool patterns to auto-approve |
| `permissions.ask` | string[] | Tool patterns requiring confirmation |
| `permissions.deny` | string[] | Tool patterns to always block |
| `permissions.additionalDirectories` | string[] | Extra dirs Claude can access |
| `permissions.disableBypassPermissionsMode` | string | Set to `"disable"` to block bypass mode (managed only) |

#### Sandbox
| Field | Type | Description |
|-------|------|-------------|
| `sandbox.enabled` | boolean | Enable bash sandboxing |
| `sandbox.autoAllowBashIfSandboxed` | boolean | Auto-approve sandboxed bash |
| `sandbox.excludedCommands` | string[] | Commands that bypass sandbox |
| `sandbox.allowUnsandboxedCommands` | boolean | Allow `dangerouslyDisableSandbox` |
| `sandbox.enableWeakerNestedSandbox` | boolean | Weaker sandbox for Docker/nested |

#### Sandbox Network
| Field | Type | Description |
|-------|------|-------------|
| `sandbox.network.allowedDomains` | string[] | Outbound domain whitelist (supports `*` wildcards) |
| `sandbox.network.allowManagedDomainsOnly` | boolean | Lock to managed domains (managed only) |
| `sandbox.network.allowUnixSockets` | string[] | Allowed Unix socket paths |
| `sandbox.network.allowAllUnixSockets` | boolean | Allow all Unix sockets |
| `sandbox.network.allowLocalBinding` | boolean | Allow localhost port binding |
| `sandbox.network.httpProxyPort` | number | Custom HTTP proxy port |
| `sandbox.network.socksProxyPort` | number | Custom SOCKS5 proxy port |

#### Managed-Only (admin console)
| Field | Type | Description |
|-------|------|-------------|
| `allowManagedPermissionRulesOnly` | boolean | Lock permission rules |
| `allowManagedHooksOnly` | boolean | Lock hooks |
| `allowManagedMcpServersOnly` | boolean | Lock MCP servers |
| `sandbox.network.allowManagedDomainsOnly` | boolean | Lock network domains |
| `allow_remote_sessions` | boolean | Allow/block Remote Control |

#### Model & Auth
| Field | Type | Description |
|-------|------|-------------|
| `model` | string | Override model (`opus`, `sonnet`, `haiku`, `opusplan`) |
| `availableModels` | string[] | Restrict selectable models |
| `effortLevel` | string | Reasoning effort: `low`, `medium`, `high` |
| `apiKeyHelper` | string | Script to generate auth |
| `forceLoginMethod` | string | `claudeai` or `console` |

#### Hooks
| Field | Type | Description |
|-------|------|-------------|
| `hooks.PreToolUse` | array | Before tool execution |
| `hooks.PostToolUse` | array | After tool execution |
| `hooks.Notification` | array | On notifications |
| `hooks.ConfigChange` | array | On config changes |

#### Environment
| Field | Type | Description |
|-------|------|-------------|
| `env` | object | Environment variables for all sessions |

</details>

---

## 14. FAQ

### Does sandbox work on macOS?
Yes. macOS uses the Seatbelt framework (built-in, no install needed). It's the most mature platform for Claude Code sandboxing.

### Does sandbox slow things down?
No measurable difference. The proxy adds <1ms per connection. In practice, sandbox makes Claude **faster** because `autoAllowBashIfSandboxed` eliminates permission prompts.

### Can agents escape the sandbox?
The sandbox is a defense-in-depth measure. Commands excluded from sandbox (`docker`) or using `dangerouslyDisableSandbox` run unrestricted. Deny rules are enforced regardless.

### Why not block `--dangerously-skip-permissions`?
Dream Team worktrees launch Claude with this flag for autonomous operation. The deny rules + sandbox provide the actual safety net. Blocking bypass mode would break the Dream Team workflow. If your organization needs to block it, use Level 3 managed settings with `disableBypassPermissionsMode: "disable"`.

### Can I allow curl for localhost only?
Yes. Add to your allow list:
```json
"allow": ["Bash(curl *localhost*)"]
```
This allows local API health checks while blocking external curl.

### What about MCP servers?
MCP servers have their own security model. See `allowedMcpServers`, `deniedMcpServers`, and `allowManagedMcpServersOnly` in the settings reference.

### How do I audit what Claude has been doing?
DTF logs all tool calls to `~/.claude/logs/tool-usage.csv`. Run `/security-setup audit` to analyze the data. For enterprise monitoring, use OpenTelemetry export.

---

## Related Resources

- [Claude Code Security Docs](https://code.claude.com/docs/en/security)
- [Claude Code Sandboxing](https://code.claude.com/docs/en/sandboxing)
- [Claude Code Permissions](https://code.claude.com/docs/en/permissions)
- [Claude Code Settings Reference](https://code.claude.com/docs/en/settings)
- [Anthropic Trust Center](https://trust.anthropic.com)

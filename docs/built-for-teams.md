# Built for Teams — Onboard in Minutes, Not Days

Dream Team Flow is designed for team-wide deployment from day one. One command to install, one command to update, and every session makes the team smarter.

---

## One-Command Install

```bash
dtf install <REPO_URL> --company-config company-config.json
```

The installer runs an interactive wizard:
1. Name, GitHub username, monorepo path, terminal
2. **Role selection** — 12 roles: Developer (Frontend/Backend/Fullstack), Data Engineer, Data Analyst, Infra/DevOps, QA/Tester, UAT Stakeholder, PO, Sales, Marketing, Customer Ops
3. **Workflow steps** — default steps per role, customize right away
4. Extra project paths from company config

Your role determines which agents (3-7 of 29), skills, and default workflow steps you get.

### Company Config

Shared by the team lead, contains:
- Project/repo name, Jira domain, ticket prefix
- Service name mappings (any number)
- **Role definitions** with agent/skill mappings per role
- Default paths and extra project-specific paths
- During install, all generic placeholder names get replaced with real ones

### Personal Config

`~/.claude/dtf-config.json` (version 2) — per-user, never committed:
- **Role** and role config (agents, skills)
- **Workflow steps** (automated checks + reminders per phase)
- Monorepo path, worktree parent, terminal preference
- Extra paths (from company config + user-added)

### Existing Users — Add Role Later

```bash
dtf configure    # Pick role, get defaults, customize steps
```

No reinstall needed. Preserves all existing paths and settings.

### Custom Workflow Steps

Every role gets default steps. Customize anytime:

```bash
dtf steps list     # See steps grouped by phase
dtf steps add      # Add automated check or reminder
dtf steps remove   # Remove a step
dtf steps reset    # Reset to role defaults
```

Two types: ⚡ automated (runs command) and 📋 reminder (checklist).
Five phases: on-start, before-commit, before-push, before-pr, after-pr.

### Health Check

```bash
dtf doctor
```

Verifies the entire installation: config files, required tools (jq, tmux, gh, git), optional tools (acli), symlink integrity, CLAUDE.md existence, and terminal configuration.

---

## Non-Destructive Updates

```bash
dtf update
```

Pulls latest changes, verifies symlinks, and regenerates CLAUDE.md. Critically, `settings.json` is deep-merged — hooks arrays are concatenated with deduplication by command, so user-added hooks are preserved across updates. Team-wide rollouts without breaking anyone's personal config.

---

## Sprint Planning with Ticket Scout

`/ticket-scout` pre-analyzes upcoming Jira tickets before sprint planning:

- Rates complexity (S/M/L/XL)
- Assesses requirement quality (Clear/Partial/Vague)
- Recommends team composition and model tiers
- Flags specific requirement gaps — "no acceptance criteria," "missing error handling requirements," "API contract not defined"
- Optionally posts pre-observations as Jira comments

A `done` mode learns from completed tickets to improve future estimates — actual complexity vs estimated complexity creates a calibration loop that improves planning accuracy over time.

---

## i18n Automation

New UI text ships with translations in all supported languages from day one via automated Lokalise API calls. This is a hard gate — the PR cannot proceed until every new translation key is created with all languages.

No follow-up tickets for forgotten translations. No "we shipped the feature but forgot i18n" problems that require re-deployment.

---

## Self-Learning Retrospectives

Every session ends with a structured retrospective. Agents are asked about instruction gaps, process issues, convention discoveries, and team sizing. Improvements are voted on by all agents.

Learnings are routed automatically via the **Learning Router**:
- **Personal config** (agent prompts, commands, skills) — applied directly
- **Shared repo** (coding conventions, project docs) — go through Jira tickets and PRs for team review

This prevents one person's retro from silently changing shared conventions. Over time, each sprint's conventions are better than the last — the team compounds improvements with every ticket shipped.

### Team-Wide Learning Aggregation

```bash
dtf contribute
```

Exports your retro learnings as a PR to the shared repo. The team reviews and curates learnings into an aggregated file. Everyone pulls improvements via `dtf update`.

---

## Cross-Platform Support

Works on macOS, Linux, and Windows (WSL) with 10 supported terminals:

- **Cross-platform:** Alacritty, Kitty, WezTerm, Ghostty, Warp
- **macOS only:** Terminal, iTerm/iTerm2
- **Linux only:** GNOME-Terminal, Konsole
- **Windows (WSL):** Windows-Terminal

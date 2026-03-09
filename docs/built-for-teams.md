# Built for Teams — Onboard in Minutes, Not Days

Dream Team Flow is designed for team-wide deployment from day one. One command to install, one command to update, and every session makes the team smarter.

---

## One-Command Install

```bash
dtf install https://github.com/johwer/dream-team-flow
```

The installer runs an interactive wizard, symlinks all commands, agents, and scripts into `~/.claude/`, and generates a personal config file. For team installs, pass a `company-config.json` to auto-configure everything:

```bash
dtf install https://github.com/johwer/dream-team-flow --company-config company-config.json
```

### Company Config

Shared by the team lead, contains:
- Project/repo name, Jira domain, ticket prefix
- Service name mappings (any number)
- Default paths and extra project-specific paths
- During install, all generic placeholder names get replaced with real ones

### Personal Config

`~/.claude/dtf-config.json` — per-user, never committed:
- Monorepo path, worktree parent, terminal preference
- Extra paths (from company config + user-added)
- All commands read this config and adapt automatically

### Health Check

```bash
dtf doctor
```

Verifies the entire installation: config files, required tools (jq, tmux, gh, git), optional tools (acli), symlink integrity, CLAUDE.md existence, and terminal configuration. Reduces onboarding support from 30-minute debugging sessions to 5-minute self-service.

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

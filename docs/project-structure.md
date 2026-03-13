# Project Structure

Dream Team Flow is split across three repos with clear separation of concerns.

## Three Repos

| Repo | Visibility | Purpose |
|------|-----------|---------|
| `dream-team-flow` | Public | DTF documentation, improvement plan, `dtf` CLI, company config templates, security configs |
| `marketplace` | Public | Plugin marketplace — sanitized commands, agents, scripts, hooks, docs |
| `marketplace-private` | Private | Same plugin files, unsanitized — for team use without de-sanitization |

## dream-team-flow (this repo)

Documentation, setup tools, and company configuration. No plugin files — those live in the marketplace repos.

```
dream-team-flow/
  README.md                       # Overview, architecture, quick start
  SETUP-GUIDE.md                  # Full setup reference
  SECURITY.md                     # Security ladder, sandbox, permissions guide
  LICENSE                         # MIT
  CLAUDE.md                       # Generated global Claude config (sanitized)
  CLAUDE.md.template              # Template → generates ~/.claude/CLAUDE.md
  dtf-config.template.json        # Template for per-user config
  company-config.example.json     # Example company config with docs
  NAME-MAPPING.md                 # Sanitization mapping reference
  security/
    level-1-personal.json         # Personal baseline (sandbox + deny rules)
    level-2-project.json          # Project standard (shared allowlist)
    level-3-team.json             # Team enforced (managed lockdown)
  docs/
    installation.md               # Prerequisites, install methods, terminals
    usage.md                      # Modes, flags, PR review, reviewers
    commands.md                   # All slash commands, flags, DTF CLI
    workflow-phases.md            # Flowcharts for full, lite, local modes
    parallel.md                   # Cross-ticket parallelism, Docker, Chrome queue
    built-for-teams.md           # Team onboarding, company config, retros
    features.md                   # Full feature list
    the-team.md                   # Agent roster, roles, team sizing
    retrospectives.md             # Self-learning loop and routing
    token-efficiency.md           # AI cost optimization
    improvement-plan.md           # Architecture decisions & roadmap
    project-structure.md          # This file
```

## marketplace / marketplace-private

Plugin files distributed via Claude Code's plugin system. Both repos have the same structure — `marketplace` is sanitized (generic names), `marketplace-private` has real names.

```
marketplace/
  .claude-plugin/
    marketplace.json              # Plugin catalog (points to "." as source)
    plugin.json                   # Plugin manifest (name, version)
  README.md                       # Install instructions
  commands/
    create-stories.md             # /create-stories — full lifecycle
    my-dream-team.md              # /my-dream-team — agent team
    workspace-launch.md           # /workspace-launch — create worktree
    workspace-cleanup.md          # /workspace-cleanup — tear down
    review-pr.md                  # /review-pr — standalone PR review
    reviewers.md                  # /reviewers — manage PR reviewer assignments
    ticket-scout.md               # Pre-sprint ticket analysis
    retro-proposals.md            # Analyze retro learnings, route improvements
    pr-insights.md                # Surface review patterns from PR data
    scrape-pr-history.md          # Extract findings from merged PRs
    team-stats.md                 # Session statistics and leaderboard
    sync-config.md                # Push config to GitHub
    acli-jira-cheatsheet.md       # Jira CLI reference
    commands.md                   # Command index
  agents/
    architect.md                  # Architecture analysis (Opus, persistent memory)
    backend-dev.md                # .NET backend implementation (Sonnet)
    frontend-dev.md               # React/TypeScript frontend (Sonnet)
    data-engineer.md              # Data mapping & migrations (Sonnet)
    infra-engineer.md             # EF Core migrations, Docker, schema (Sonnet)
    pr-reviewer.md                # Code review (Opus, persistent memory)
    security-reviewer.md          # OWASP security scanning (Opus)
    functional-tester.md          # API + integration testing (Sonnet)
    visual-verifier.md            # Playwright e2e tests + screenshots (Sonnet)
    summary-writer.md             # PR summaries + how-to-test (Sonnet)
  scripts/
    dtf.sh                        # DTF CLI (install, update, doctor, contribute)
    dtf-env.sh                    # Config loader for shell scripts
    launch-workspace.sh           # Terminal launcher (starts Claude in tmux)
    open-terminal.sh              # Cross-platform terminal opener (10 terminals)
    resume-workspace.sh           # Resume paused workspace
    pause-workspace.sh            # Pause workspace for the day
    sync-config.sh                # Sync config to all three repos
    quality-gate.sh               # Deterministic pre-push checks (format, lint, build)
    chrome-queue.sh               # Chrome browser queue (multi-agent coordination)
    poll-ai-reviews.sh            # Poll for AI bot reviews
    poll-ci-checks.sh             # Poll GitHub Actions (2-round CI cap)
    jira-download-attachments.sh  # Download Jira attachments via API
    migration-guard.sh            # Hook: warns on migration edits
    lockfile-guard.sh             # Hook: warns on lock file edits
    auto-lint-notify.sh           # Hook: lint reminders for .cs/.ts/.tsx
    teammate-idle-gate.sh         # Hook: enforces quality gates before idle
    task-completed-gate.sh        # Hook: enforces quality gates before task completion
    tool-usage-log.sh             # Hook: log all tool calls for analytics
    worktree-port-overlay.sh      # Worktree port isolation overlay
  skills/
    mermaid-diagram/              # Mermaid diagram generation skill
  docs/
    dev-workflow-checklist.md     # Shared quality gates (all modes)
    learning-system.md            # How the learning loop works
    integrations.md               # Integration reference & setup
```

## Sync Flow

`sync-config` pushes `~/.claude/` files to all three repos:

```
~/.claude/ (source of truth)
    │
    ├──→ marketplace-private    (unsanitized plugin files + config backup)
    ├──→ marketplace            (sanitized plugin files)
    └──→ dream-team-flow        (DTF templates only)
```

Team members install from `marketplace-private` (no de-sanitization needed). Community installs from `marketplace` and uses `dtf install --company-config` to de-sanitize.

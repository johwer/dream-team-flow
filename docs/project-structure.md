# Project Structure

```
dream-team-flow/                  # Public repo (or company fork)
  .gitignore                      # Ignores dtf-config.json (personal)
  README.md                       # Overview and documentation hub
  SETUP-GUIDE.md                  # Detailed setup reference
  SECURITY.md                     # Security ladder, sandbox, permissions guide
  CLAUDE.md.template              # Template → generates ~/.claude/CLAUDE.md
  dtf-config.template.json        # Template for per-user config
  company-config.example.json     # Example company config with docs
  reviewers.json                  # PR reviewer assignments per category
  settings.json                   # Claude Code settings (hooks, env)
  commands/
    create-stories.md             # /create-stories — full lifecycle
    my-dream-team.md              # /my-dream-team — agent team
    workspace-launch.md           # /workspace-launch — create worktree
    workspace-cleanup.md          # /workspace-cleanup — tear down
    review-pr.md                  # /review-pr — standalone PR review
    reviewers.md                  # /reviewers — manage PR reviewer assignments
    acli-jira-cheatsheet.md       # Jira CLI reference
    security-setup.md             # Interactive security configuration
    ticket-scout.md               # Pre-sprint ticket analysis
    team-stats.md                 # Session statistics
    team-review.md                # Team performance review
  scripts/
    dtf.sh                        # DTF CLI (install, update, doctor, contribute)
    dtf-env.sh                    # Config loader for shell scripts
    launch-workspace.sh           # Terminal launcher (starts Claude in tmux)
    open-terminal.sh              # Cross-platform terminal opener (10 terminals)
    resume-workspace.sh           # Resume paused workspace
    pause-workspace.sh            # Pause workspace for the day
    poll-ai-reviews.sh            # Poll for AI bot reviews
    poll-ci-checks.sh             # Poll GitHub Actions
    chrome-queue.sh               # Chrome browser queue
    migration-guard.sh            # Hook: warns on migration edits
    lockfile-guard.sh             # Hook: warns on lock file edits
    auto-lint-notify.sh           # Hook: lint reminders for .cs/.ts/.tsx
  agents/
    architect.md                  # Architecture analysis subagent
    backend-dev.md                # .NET backend implementation
    frontend-dev.md               # React/TypeScript frontend
    pr-reviewer.md                # Code review subagent
    data-engineer.md              # Data mapping & migrations
  skills/
    mermaid-diagram/              # Mermaid diagram generation
  security/
    level-1-personal.json         # Personal baseline (sandbox + deny rules)
    level-2-project.json          # Project standard (shared allowlist)
    level-3-team.json             # Team enforced (managed lockdown)
  docs/
    installation.md               # Prerequisites, install, terminals
    usage.md                      # Modes, flags, PR review, reviewers
    workflow-phases.md            # Flowcharts for full, lite, local modes
    retrospectives.md             # Self-learning loop and routing
    commands.md                   # All slash commands, flags, DTF CLI
    the-team.md                   # Agent roster, roles, team sizing
    project-structure.md          # This file
    integrations.md               # Integration reference & setup
  learnings/
    aggregated-learnings.md       # Team-curated retro learnings
    contributions/                # Per-user retro submissions
```

After `dtf install`, everything is symlinked into `~/.claude/` — updates are instant via `git pull`.

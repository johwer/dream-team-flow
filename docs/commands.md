# Commands Reference

All slash commands available in Dream Team Flow.

## Dream Team & Workspace

| Command | Description |
|---------|-------------|
| `/create-stories PROJ-1234` | Full lifecycle — Jira fetch, worktree, team launch, PR, cleanup |
| `/create-stories PROJ-1234 PROJ-1235` | Multiple tickets in parallel |
| `/my-dream-team <ticket>` | Standalone team — run on an existing branch |
| `/workspace-launch PROJ-1234` | Create a git worktree and start a Dream Team session |
| `/workspace-cleanup PROJ-1234` | Tear down worktree, tmux session, optionally delete branch |

### Flags

| Flag | Effect | Works with |
|------|--------|-----------|
| `--lite` | Claude decides whether to spawn agents or work solo | `/create-stories`, `/my-dream-team` |
| `--no-worktree` | Skip worktree creation, work in current directory | `/create-stories`, `/my-dream-team` |
| `--local` | No PR, no push — stops after review | `/my-dream-team` |
| `--resume` | Resume a paused session from agent notes | `/my-dream-team` |

Flags can be combined:
```
/my-dream-team --lite --no-worktree <ticket>
/create-stories PROJ-1234 --lite --no-worktree
```

### Pause & Resume

| Command | What happens |
|---------|-------------|
| `pause PROJ-1234` | Close for the day — keeps worktree, kills tmux |
| `resume PROJ-1234` | Continue tomorrow — rebuilds context from agent notes |

## Code Review

| Command | Description |
|---------|-------------|
| `/review-pr 1670` | Review a PR with line-level GitHub comments |
| `/review-pr 1670 --full` | Full review — local worktree + builds + deeper analysis |
| `/review-pr 1670 --focus "src/components/**"` | Focus review on specific paths |
| `/review-pr 1670 --no-approve` | Review without approving |

## PR Reviewers

| Command | Description |
|---------|-------------|
| `/reviewers list` | Show configured reviewers |
| `/reviewers add frontend github-user` | Add a reviewer to a category |
| `/reviewers remove infra github-user` | Remove a reviewer from a category |

Categories: `frontend`, `backend`, `fullstack`, `infra`, `data`

When the Dream Team marks a PR ready, it maps the ticket scope to a category and auto-assigns the configured reviewers.

## Analysis & Learning

| Command | Description |
|---------|-------------|
| `/ticket-scout` | Pre-analyze upcoming Jira tickets before sprint planning |
| `/team-review` | Analyze accumulated retro learnings and route them |
| `/team-stats` | Dream Team leaderboard and session history |

## Config & Utilities

| Command | Description |
|---------|-------------|
| `/sync-config` | Push Claude config to GitHub (private + sanitized public repos) |
| `/acli-jira-cheatsheet` | Reference for ACLI Jira CLI commands |
| `/security-setup` | Interactive security configuration (sandbox, deny rules, network) |
| `/security-setup audit` | Audit current security state and tool usage |

## DTF CLI

| Command | Description |
|---------|-------------|
| `dtf install <URL>` | Clone repo, interactive wizard, symlink into `~/.claude/` |
| `dtf install <URL> --company-config <path>` | Install with company-specific configuration |
| `dtf update` | Pull latest, verify symlinks, regenerate CLAUDE.md |
| `dtf doctor` | Health check — config, symlinks, required tools |
| `dtf contribute` | Export retro learnings as a PR to the shared repo |

## Typical workflow

| Step | Command | What happens |
|------|---------|-------------|
| 1 | <kbd>/create-stories PROJ-1234</kbd> | Work on tickets — retros run automatically at session end |
| | <kbd>/my-dream-team --lite ...</kbd> | |
| 2 | <kbd>pause PROJ-1234</kbd> | Close for the day — keeps worktree, kills tmux |
| | <kbd>resume PROJ-1234</kbd> | Continue tomorrow — rebuilds context from agent notes |
| 3 | <kbd>/team-review</kbd> | Review accumulated learnings and route them (every 5-10 sessions) |
| 4 | <kbd>/review-pr \<PR number\></kbd> | Review the PR that `/team-review` created for shared repo changes |
| 5 | <kbd>/sync-config</kbd> | Sync personal config changes to your config repo |

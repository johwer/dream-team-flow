# Global Claude Configuration

## Custom Commands

These commands are available globally from any project:

**Dream Team & Workspace:**
- `/create-stories` — Full lifecycle orchestrator: takes one or more ticket IDs, sets up worktrees, launches Dream Teams, and handles cleanup when done
- `/workspace-launch` — Create a git worktree from a Jira ticket and spin up a Dream Team session
- `/workspace-cleanup` — Tear down a worktree, tmux session, and optionally delete the branch
- `/my-dream-team` — Orchestrate a multi-agent team to implement a Repo feature ticket

**Code Review & Analysis:**
- `/review-pr` — Review a PR with line-level GitHub comments. Fast (API-only) or full (local worktree + builds + deeper review with `--full`)
- `/ticket-scout` — Pre-analyze upcoming Jira tickets before sprint planning

**Team & Config:**
- `/team-stats` — Dream Team leaderboard and history
- `/team-review` — Analyze Dream Team learnings and propose improvements
- `/sync-config` — Push all Claude config to GitHub (private + sanitized public repos)
- `/acli-jira-cheatsheet` — Reference for ACLI Jira CLI commands

## Subagents

Standalone agents in `~/.claude/agents/` — usable from any project:

| Agent | Model | Purpose |
|-------|-------|---------|
| `architect` | Opus | Architecture analysis, conventions summaries, implementation plans |
| `backend-dev` | Sonnet | .NET backend implementation |
| `frontend-dev` | Sonnet | React/TypeScript frontend implementation |
| `pr-reviewer` | Opus | Code review with categorized feedback (MUST FIX / SUGGESTION / QUESTION / PRAISE) |
| `data-engineer` | Sonnet | Data mapping, EF Core migrations, pipelines |

Usage: "Use the pr-reviewer subagent to review this" or Claude delegates automatically based on task.

## Hooks

Active hooks in `~/.claude/settings.json`:
- **Tool usage logging** — Logs all tool calls for analytics (async, non-blocking)
- **Desktop notification** — macOS notification when Claude needs attention (idle, permission prompt)

## Integrations

See `~/.claude/docs/integrations.md` for full details including prerequisites and setup instructions.

| Integration | Status |
|-------------|--------|
| GitHub Actions (`@claude` in PRs) | Workflow ready — needs `ANTHROPIC_API_KEY` repo secret |
| Slack (`@Claude` in channels) | Documented — needs Claude Code on the Web + Pro/Max/Teams plan |
| Code intelligence plugin | Documented — run `/plugin` to browse marketplace |

## Jira Integration

- Use `acli jira workitem` commands to interact with Jira (see `/acli-jira-cheatsheet` for full reference)
- Jira attachments require browser authentication — use `open` or AppleScript with Chrome to download them, as `curl`/`wget` will get 401 Unauthorized
- To open a Jira attachment URL in Chrome for authenticated download:
  ```bash
  open -a "Google Chrome" "<ATTACHMENT_URL>"
  ```

## Workspace Preferences

- **Terminal app:** `Alacritty` (options: `Terminal`, `Alacritty`, `iTerm` — used when opening new windows for worktrees)
- To change, update the terminal app name above

## Repo Monorepo

- Main repo: `~/Documents/Repo`
- Worktrees (Dream Team): `~/Documents/<TICKET_ID>`
- Worktrees (PR Review): `~/Documents/Repo/.claude/worktrees/pr-review-<PR>`
- Tech stack: React/Vite/TypeScript/Tailwind frontend, .NET microservices backend

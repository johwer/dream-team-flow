# Global Claude Configuration

## Custom Commands

These commands are available globally from any project:

- `/create-stories` — Full lifecycle orchestrator: takes one or more ticket IDs, sets up worktrees, launches Dream Teams, and handles cleanup when done
- `/workspace-launch` — Create a git worktree from a Jira ticket and spin up a Dream Team session
- `/workspace-cleanup` — Tear down a worktree, tmux session, and optionally delete the branch
- `/my-dream-team` — Orchestrate a multi-agent team to implement a Repo feature ticket
- `/acli-jira-cheatsheet` — Reference for ACLI Jira CLI commands

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
- Worktrees: `~/Documents/<TICKET_ID>`
- Tech stack: React/Vite/TypeScript/Tailwind frontend, .NET microservices backend

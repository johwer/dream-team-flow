# Usage

## Full Lifecycle (recommended)

Handles everything end-to-end: Jira fetch, worktree creation, dependency install, team launch, PR creation, and cleanup.

```
/create-stories PROJ-1234
```

Multiple tickets:

```
/create-stories PROJ-1234 PROJ-1235
```

## Standalone Team

Already have a branch? Run the team directly:

```
/my-dream-team <paste ticket description or Jira ID>
```

## Lite Mode (Claude decides agent usage)

Claude analyzes the ticket and decides whether to spawn agents or work solo. Still does everything else: PRs, Jira updates, summaries, retro, GitHub review handling.

```
/my-dream-team --lite <ticket description>
/create-stories PROJ-1234 --lite
```

## No Worktree (work in current directory)

Skip worktree creation — work on the current branch in the current directory:

```
/my-dream-team --no-worktree <ticket description>
/create-stories PROJ-1234 --no-worktree
```

## Local Only (no PR, no push)

Skip all git remote operations:

```
/my-dream-team --local <paste ticket description>
```

## Combined Flags

Flags can be mixed:

```
/my-dream-team --lite --no-worktree <ticket description>
/my-dream-team --lite --local <ticket description>
/create-stories PROJ-1234 --lite --no-worktree
```

## Worktree Port Isolation

When running multiple worktrees simultaneously, each needs unique ports to avoid collisions. Dream Team Flow handles this automatically via `/create-stories`, but you can also apply it manually:

```bash
bash ~/.claude/scripts/allocate-ports.sh PROJ-1234
```

**What it does:**
1. Derives unique ports from the ticket number
2. Generates `.env` and `.env.local` with port mappings
3. All generated files are git-invisible (never appears in PRs)

**Port scheme:**
- Vite dev server: `31xx` (e.g., ticket 1234 → slot 47 → port 3147)
- API services: base `10000 + (slot * 100)`, then +1 per service

**Generated files** (all git-invisible):
- `.env` — Docker Compose port mappings
- `.env.local` — Vite proxy port overrides (appended to existing)
- `docker-compose.worktree.yml` — Worktree API services with `-wt` suffix

**Scripts** (all in `~/.claude/scripts/`):
- `allocate-ports.sh` — Unique port allocation per worktree
- `worktree-service.sh` — Docker service management for worktrees
- `generate-api.sh` — RTK Query codegen with worktree ports

**Running worktree API services:**
```bash
bash ~/.claude/scripts/worktree-service.sh up hcm-api     # Start a service
bash ~/.claude/scripts/worktree-service.sh logs hcm-api    # Tail logs
bash ~/.claude/scripts/worktree-service.sh down            # Stop all
bash ~/.claude/scripts/worktree-service.sh status          # Show ports and health
```

Services connect to the main stack's infrastructure (postgres, redis, rabbitmq) while running your worktree's code on separate ports.

## PR Review

Review any pull request with line-level comments — no local checkout needed:

```
/review-pr 1670
/review-pr 1670 --focus "src/components/**" --no-approve
```

## PR Reviewer Auto-Assignment

Configure GitHub reviewers per category. When a Dream Team PR is marked ready, reviewers are auto-assigned based on the ticket scope.

```
# Manage reviewers
/reviewers list
/reviewers add frontend github-user-1
/reviewers add backend github-user-2
/reviewers remove infra github-user-3
```

Categories: `frontend`, `backend`, `fullstack`, `infra`, `data`

Config stored in `~/.claude/reviewers.json` — sanitized automatically for public repos (usernames replaced with `reviewer-1`, `reviewer-2`, etc.).

PRs stay as **drafts** through AI review and CI checks. When the user explicitly confirms ("Done — assign reviewers & ship it"), the PR is marked ready and reviewers are auto-assigned. The Dream Team maps the ticket scope to a category (`frontend-only` → `frontend`, `full-stack` → `fullstack`, etc.) and runs `gh pr edit --add-reviewer` with all configured reviewers for that category. Reviewers are **never** auto-assigned before user confirmation.

See also: **[Commands Reference](commands.md)** for the full list of slash commands, flags, and DTF CLI.

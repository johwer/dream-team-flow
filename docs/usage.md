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

When the Dream Team marks a PR ready (Phase 5.5), it maps the ticket scope to a category (`frontend-only` → `frontend`, `full-stack` → `fullstack`, etc.) and runs `gh pr edit --add-reviewer` with all configured reviewers for that category.

See also: **[Commands Reference](commands.md)** for the full list of slash commands, flags, and DTF CLI.

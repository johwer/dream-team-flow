# Parallel Everything — 4x Story Output or More

A single developer using Dream Team Flow can sustain the story output of a 4-person team — or more — because the work happens concurrently, not sequentially. The bottleneck stops being "how fast can one developer code" and becomes "how many tickets can your team review."

---

## Cross-Ticket Parallelism

Run 4, 6, 10 tickets simultaneously. Each ticket gets its own git worktree, its own Docker containers with isolated ports, and its own agent team — completely independent, zero conflicts.

### Isolated Worktrees
Every ticket runs in a dedicated git worktree branched from `main`. Worktrees are created automatically by `/create-stories` or `/workspace-launch`, with npm dependencies installed and environment files copied.

### Docker Port Isolation
Each worktree gets unique ports derived from the ticket number — Vite dev server on `31xx` and API services on a `10000 + (slot * 100)` base — preventing collisions when running multiple worktrees simultaneously. `allocate-ports.sh` generates `.env` and `.env.local` automatically. Worktree API services run via `docker-compose.worktree.yml` with `-wt` suffixed container names to avoid Docker DNS round-robin with the main stack.

### Parallel Pre-Analysis
The orchestrator (`/create-stories`) pre-analyzes all tickets in parallel before any session starts. One Haiku-model agent per ticket fetches from Jira simultaneously; then one Sonnet-model agent per ticket performs lightweight architectural analysis. Results are written to `.dream-team/context.md` so agents begin with full context from minute one — no wasted exploration.

---

## Within-Ticket Parallelism

### Shared API Contract
Backend and frontend agents work in parallel within each ticket via a shared API contract defined upfront by the architect — endpoint paths, HTTP methods, request/response DTOs with sample JSON payloads. Frontend builds types and components against the contract without waiting for backend to finish. Deviations are flagged immediately via structured handoff messages.

### Structured Handoff Templates
Agents use structured handoff templates (files touched, contract deviations, Docker ports, exact next steps) instead of free-text messages. This eliminates 3-5 rounds of back-and-forth per handoff, keeping parallel work streams from blocking each other.

---

## Pause and Resume Across Days

Pause a workspace overnight (zero token cost), resume the next day with full context rebuilt from disk-based notes, journals, git state, and PR status. Multi-day tickets don't mean multi-day token burn.

- **Pause**: Kills tmux session but preserves worktree, code, notes, journals, draft PR, and git branch
- **Resume**: Reads `.dream-team/` notes and journals, checks git diff, PR status, and Jira — then spawns fresh agents that pick up where the previous ones left off

---

## Chrome Browser Queue

When multiple Dream Team sessions run concurrently, they share a single Chrome extension for visual verification. A file-based queue (`chrome-queue.sh`) coordinates access — agents join, wait their turn, use Chrome on port 3000, then release. Holders heartbeat every 2 minutes to keep their slot; crashed sessions auto-expire after 3 minutes.

---

## Merge Conflict Pre-Check

When running parallel tickets, merge conflicts on shared files (route registrations, tab definitions, shared components) are nearly guaranteed. Known hot files are checked against `origin/main` before every push — conflicts caught early, when they're simplest to fix. The team rebases onto main before each push during review cycles.

---

## Stale Worktree Cleanup

Every time `/create-stories` runs, it automatically checks all existing worktrees for merged/closed PRs and orphan tmux sessions, presents them to the user, and offers to clean them up before creating new ones. Prevents disk bloat and developer confusion from accumulated abandoned worktrees.

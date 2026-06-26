# Token-Efficient by Design

Most AI coding setups grow expensive fast — MCP servers, large tool schemas, and bloated context windows add up quickly. Dream Team Flow is built differently.

---

## How DTF Minimizes Token Usage

### No MCP servers
Agents use plain file reads and CLI tools instead of context-heavy server integrations. MCP servers inject thousands of schema tokens per call — DTF avoids this entirely.

### Pre-hydrated context
`/create-stories` pre-analyzes tickets in parallel before launching sessions. Agents start with scope, key files, and conventions already determined — no wasted exploration tokens. When pre-hydrated context exists, the architect validates and refines instead of exploring from scratch, cutting Phase 1 time by ~70%.

### Per-ticket mode selection
Each ticket is analyzed and routed to the right mode — full multi-agent team, lite, or just a worktree. Trivial tickets cost zero AI spend; only complex ones get the full team. Right-sizing per ticket is the single biggest lever for controlling costs.

### Deterministic nodes
Formatting, linting, type checks, and builds run as shell scripts (`quality-gate.sh`), not as LLM-reasoned steps. Every check that would otherwise require an Opus-tier model to reason about happens deterministically in bash — zero tokens.

Similarly, `poll-ci-checks.sh` and `poll-ai-reviews.sh` poll GitHub's REST API in a loop — no LLM involvement to wait for CI or bot reviews.

### Disk-based memory
Agents write decisions and findings to `.dream-team/notes/` on disk and read them back when needed, rather than keeping everything in the context window. Notes persist across sessions for crash recovery and pause/resume.

### Targeted reads
Agents use Grep to find what they need rather than loading entire files or docs. The architect prepares a focused conventions summary for each agent — same information, far less context consumed.

### Structured handoff templates
Agents use structured handoff templates (files touched, contract deviations, exact next steps) instead of free-text messages. This eliminates 3-5 rounds of back-and-forth per handoff — direct token savings on every agent interaction.

### Dynamic team sizing
The architect only spawns agents the ticket actually needs. The bias is explicitly toward fewer agents — each extra agent costs coordination overhead and token budget. For full-stack tickets with 15+ files, lite mode is recommended because coordination overhead can exceed the parallelism benefit.

### Deadlock detection
Tasks stuck for 10+ minutes with no activity get pinged; 15 minutes triggers escalation. Prevents stuck agents from silently burning tokens on idle sessions that produce nothing.

### CI iteration cap
2 fix rounds max before escalating to user, preventing infinite token-burning retry loops. Diminishing returns beyond 2 attempts means the LLM probably can't fix it — escalating is cheaper than retrying.

### Lite mode
For smaller tickets, Claude skips agent spawning entirely and works solo, with no team coordination overhead. All quality gates still apply — only the agent overhead is removed.

### Conventions summary per agent
The architect prepares a focused bullet-point conventions summary for each agent rather than having each one independently read entire docs. Same information delivered to each agent, far less context consumed across the team.

### Verified file paths
The architect verifies every file path with Read or Glob before including it in the architecture report. Downstream agents get full resolved paths directly, eliminating silent Read failures and wasted round-trips.

### Compact early, at phase boundaries
DTF sets `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE: 50`, so context is compacted at ~50% capacity rather than waiting until it overflows. A full window is a slow, expensive window: every subsequent call re-reads bloated context, and quality degrades as the model loses the thread. The `strategic-compact` skill complements this by compacting at *logical* breakpoints (after research, after a milestone, after debugging) — never mid-implementation — so the summary keeps what matters and drops the noise. This is a borrowed best practice: the broader agent community has converged on "compact proactively, well before the limit" as one of the highest-leverage cost controls for long sessions.

### Memory hygiene
Persistent memory (`MEMORY.md` plus per-fact files) is loaded into context every session, so unbounded memory is a recurring per-prompt tax. DTF keeps it lean: `memory-health.sh` runs as a zero-token bash check at the start of `/create-stories` (Step 0.5), flagging when `MEMORY.md` exceeds its ~1,500-token budget, when learnings files grow too large, or when files have gone stale (90+ days untouched). The `memory-hygiene` skill then archives, prunes, and consolidates on demand. The principle mirrors context hygiene generally — only pay for the memory you actually use each prompt.

### Capped thinking budget
`MAX_THINKING_TOKENS: 16000` bounds hidden reasoning tokens per turn (~70% reduction versus uncapped extended thinking) while leaving enough headroom for the planning DTF actually needs. Most steps don't require unbounded deliberation; the cap prevents silent token burn on over-thinking.

### Model right-sizing per task
DTF tiers the model to the difficulty of each step rather than running everything on the most capable (and most expensive) model. Cheap, mechanical work — fetching tickets, extracting data — runs on Haiku; pre-hydration and most implementation run on Sonnet; only genuinely hard reasoning (architecture, synthesis, adversarial review) is reserved for Opus. The same right-sizing logic that picks a mode per ticket applies one level down, per agent and per task.

### Cost observability
`cost-tracker.sh` and `phase-cost-tracker.sh` record token spend per session and per phase, so cost is measured rather than guessed. Right-sizing decisions (mode, team size, model tier) are fed by real data on where tokens actually go, turning cost control into a feedback loop instead of a one-time setting.

---

## The Result

Multi-agent sessions that stay lean even on large tickets. Per-ticket API costs stay predictable regardless of ticket complexity.

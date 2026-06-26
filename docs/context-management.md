# Context Management

The context window is the real bottleneck in agentic coding — not the model. A full window is slow, expensive, and lossy: the model re-reads bloated context on every call and loses the thread as the session grows. DTF treats context as a managed resource from the first prompt to the last, across every phase of a Dream Team run.

This page describes what DTF does with context in its own terms. For how these mechanisms translate into cost, see **[Token Efficiency](token-efficiency.md)**. For how DTF's approach compares to Stripe Minions, Claude Docs, and ECC, see the Context Management chapter in the **[Comparison](comparison.md)**.

---

## Hydration — start full, not empty

Agents don't begin by exploring from scratch. `/create-stories` runs a pre-flight pipeline before any implementation session starts:

1. **Fetch** — pull the Jira ticket(s) and attachments up front.
2. **Triage checkpoint** — the user decides GO / SKIP / JUST WORKTREE *before* tokens are spent. Blocked or trivial tickets never get analyzed.
3. **Parallel pre-hydration** — one agent per GO ticket analyzes scope, key files, conventions, and recommended mode against the codebase, **capped at 30 tool uses** so triage can't balloon into a full exploration.
4. **Persist to disk** — results land in `.dream-team/context.md`, the single source of truth every downstream agent reads.

When pre-hydrated context exists, the architect *validates and refines* it instead of re-exploring — cutting Phase 1 work substantially. Each agent starts with scope, resolved file paths, and a focused conventions summary already in hand.

## Window strategy — compact early, at the right moments

DTF doesn't wait for the window to overflow:

- **Compact at ~50%** — `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE: 50` triggers compaction well before the limit, keeping every call operating on a lean window.
- **Strategic compaction** — the `strategic-compact` skill compacts at *logical* breakpoints (after research, after a milestone, after debugging) and never mid-implementation, so the summary keeps what matters and drops the noise.
- **Checkpoint on compact** — a `PreCompact` hook auto-saves a checkpoint before compaction, so nothing critical is lost and a session can be resumed or recovered.

## Rule scoping — load what matters, when it matters

DTF uses a CLAUDE.md hierarchy (global → project → subdirectory): small, high-signal instruction files that act as a table of contents. The heavy material — coding conventions, performance playbooks, domain docs — lives in **skills that cost zero tokens until invoked**. Rules that must always apply are always loaded; bulky references load on demand. Hooks enforce the non-negotiable rules deterministically, so compliance doesn't depend on the model remembering.

## Context modes — the right mindset per task

Three modes — **dev**, **review**, and **research** — shift priorities, tool preferences, and output style. They auto-activate per command (`/my-dream-team` → dev, `/review-pr` → review, `/ticket-refine` → research), so the session carries only the framing the current task needs.

## Disk-based memory + hygiene

Agents write decisions and findings to `.dream-team/notes/` on disk and read them back when needed, rather than holding everything in the window. Notes persist across sessions for pause/resume and crash recovery.

Persistent cross-session memory (`MEMORY.md` plus per-fact files) is loaded every session, so unbounded memory is a recurring per-prompt tax. DTF keeps it lean:

- **`memory-health.sh`** runs as a zero-token check at the start of `/create-stories`, flagging when `MEMORY.md` exceeds its ~1,500-token budget, when learnings files grow too large, or when files have gone stale (90+ days untouched).
- **`memory-hygiene`** skill archives, prunes, and consolidates on demand.

The result: you pay only for the memory you actually use each prompt.

---

## In short

| Concern | What DTF does |
|---|---|
| Starting context | Pre-flight fetch → triage → parallel pre-hydration → `.dream-team/context.md` (30-tool-use cap) |
| Window growth | 50% autocompact + `strategic-compact` at phase boundaries + `PreCompact` checkpoint |
| Rules & docs | CLAUDE.md hierarchy + on-demand skills (0 tokens until invoked) + deterministic hook enforcement |
| Task framing | dev / review / research modes, auto-activated per command |
| Memory | Disk-based `.dream-team/notes/` + `memory-health.sh` + `memory-hygiene` |

Context stays lean even on large, multi-ticket, multi-agent runs — which is what keeps quality high and cost predictable.

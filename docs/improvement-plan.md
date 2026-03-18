# Dream Team Flow — Improvement Plan & Architecture Decisions

Living document tracking Claude Code platform features, how DTF relates to them, decisions made, and planned improvements. Updated after each documentation review.

**Last reviewed:** 2026-03-05 (Claude Code docs at code.claude.com/docs)

---

## Feature Comparison: DTF vs Native Claude Code

### Multi-Agent Orchestration

DTF has two modes: **full mode** (multi-agent with tmux sessions) and **`--lite` mode** (team lead does most work itself, spawns agents only when needed). Native Agent Teams overlaps with both.

| Aspect | DTF full mode | DTF `--lite` mode | Native Agent Teams |
|--------|--------------|-------------------|-------------------|
| **How it works** | `/my-dream-team` spawns named agents in separate tmux sessions, each in a worktree. Team lead coordinates via file-based messaging (`.dream-team/`) | Team lead does architecture + implementation directly. Spawns 0-2 agents based on complexity (simple: 0, medium: 1, complex: as needed) | Built-in `TeamCreate`/`SendMessage`/`TaskCreate` tools. Shared task list, direct messaging, split panes |
| **When to use** | Complex tickets (8+ files, multi-discipline, cross-service) | Simple/medium tickets (1-8 files, single discipline). Also recommended for 15+ file tickets where coordination overhead exceeds parallelism benefit | Experimental — not used by DTF |
| **Communication** | File-based (journal, context.md, notes) | Direct — lead has full context, no messaging needed | Native mailbox system, automatic message delivery |
| **Task tracking** | Manual via team lead prompt | Lead tracks in own context | Built-in task list with states, dependencies, file-locking for claims |
| **Quality gates** | Same gates in both modes — `dev-workflow-checklist.md` applies identically | Same gates | No built-in quality gates |
| **Retros & learnings** | Full retro (Phase 6.75) with all agents contributing | Lead writes own retro using same 4 categories + destination hints | No equivalent |
| **Plan approval** | Architect reviews before devs start (prompt-based) | Lead produces architecture report itself | Native plan approval — teammate works read-only until lead approves |
| **Hooks** | `TeammateIdle` and `TaskCompleted` hooks (already using) | Same hooks when agents are spawned | Same hooks, plus `SubagentStart`/`SubagentStop` |
| **Status** | DTF is stable and battle-tested | Used in production for most tickets | Agent Teams is **experimental**, disabled by default |

**Key insight:** `--lite` is NOT Agent Teams — it's the same DTF orchestration with the team lead doing more work itself. The phases, quality gates, retros, and process are identical. Only WHO does the work changes (lead vs spawned agents). This is the mode most similar to what Agent Teams offers, but with DTF's full lifecycle on top.

**Decision:** Keep DTF orchestration for now. Agent Teams is experimental with known limitations (no session resumption, task status lag, one team per session). DTF's `--lite` mode already covers the "fewer agents, less overhead" use case that Agent Teams targets, while keeping retros, journal, learnings, achievement tracking, and quality gates. **Revisit when Agent Teams exits experimental.**

**Future:** When Agent Teams stabilizes, evaluate migrating Dream Team to use native task list and messaging while keeping DTF's higher-level workflows (retros, quality gates, Jira integration).

---

### Visual Testing & Browser Automation

DTF uses a two-tier approach: AppleScript as the always-available primary, Chrome extension (`--chrome`) as the enhanced path when an agent wins the queue.

| Aspect | AppleScript (primary) | Chrome Extension (enhanced) |
|--------|----------------------|----------------------------|
| **How it works** | `execute javascript` in Chrome tabs via AppleScript. JS click-by-index, DOM reading, navigation | `claude --chrome` flag enables MCP connection to Chrome extension. Native `gif_creator` tool |
| **Availability** | Always — no special flags, no MCP, works in every agent session | One agent at a time — requires `--chrome` flag and winning the Chrome Browser Queue |
| **Capabilities** | Screenshots (`screencapture`), JS execution, navigation, clicking by index | Click, type, read console, record GIFs natively, read DOM, interact with auth'd sites |
| **GIF recording** | `screencapture -v` → `ffmpeg` conversion, or Pillow screenshot stitch | `gif_creator action=start_recording` → `action=stop_recording` → `action=export` |
| **Reliability** | Retina coordinate issues for System Events clicks (JS clicks work fine). Tab management requires explicit tab selection | Native integration, handles tabs and modals. But only one session can connect |
| **Documentation** | `visual-testing.md` — full patterns for JS click-by-index, accordions, toggles, radio buttons | `dev-workflow-checklist.md` Section 1 — recording steps via `gif_creator` |

#### Why AppleScript stays primary

AppleScript doesn't use MCP. It works in every agent session without any special flags or queue coordination. When Dream Team runs 2-5 parallel agents, all of them can use AppleScript for basic visual checks (screenshots, DOM inspection, navigation) without waiting. This matters because visual verification is a hard gate — every UI agent needs it.

#### How Chrome extension fits in (the queue)

The Chrome extension connects to **one Claude session at a time**. You can't launch every agent with `--chrome` — they'd compete for the single connection. DTF solves this by **reopening the worktree terminal with `--chrome`** when it's that agent's turn:

1. Agent needs Chrome (for GIF recording or richer interaction) → calls `chrome-queue.sh join <TICKET_ID> <AGENT_NAME>`
2. Polls `chrome-queue.sh my-turn <TICKET_ID>` — waits until first in line
3. **Worktree terminal reopens with `--chrome` flag** — now this agent has the MCP Chrome connection
4. Agent starts Vite on port 3000 (Chrome plugin connects there), records GIFs via `gif_creator`, does visual work
5. Calls `chrome-queue.sh done <TICKET_ID>` — kills port 3000 so the next agent can bind it
6. Stale entries (no heartbeat for 3+ minutes) auto-clean so a crashed agent doesn't block the queue

The queue is purely file-based (`~/.claude/chrome/queue.txt`) — no external dependencies, works across tmux sessions and worktrees.

#### Summary

- **Most visual work** (screenshots, DOM checks, navigation) → AppleScript, no queue needed
- **GIF recording and rich interaction** → Chrome extension via queue, terminal reopens with `--chrome`
- Agents never sit idle waiting for Chrome — they do AppleScript-based checks or non-visual work while waiting

**Action items:**
- [x] ~~Document the terminal-reopen-with-chrome flow in `visual-testing.md`~~ — Done (2026-03-06)
- [ ] Add Chrome queue usage examples to agent onboarding docs

---

### Subagent Configuration

| Aspect | DTF (current) | Native Subagent Features |
|--------|--------------|--------------------------|
| **Agent definitions** | `.md` files in `~/.claude/agents/` with name, description, model | Same, plus: `memory`, `isolation`, `skills`, `hooks`, `maxTurns`, `background`, `permissionMode` fields |
| **Persistent memory** | Not used — agents start fresh each session | `memory: user` gives agents a persistent directory across sessions |
| **Worktree isolation** | Manual via `/workspace-launch` | `isolation: worktree` — automatic, auto-cleaned if no changes |
| **Skill injection** | Not used — agents read docs manually | `skills` field preloads skill content into agent context at startup |
| **Scoped hooks** | Global hooks in `settings.json` | Hooks in agent frontmatter run only while that agent is active |

**Decision:** Adopt `memory` for architect and pr-reviewer agents. These benefit most from accumulated knowledge (architecture patterns, review patterns). Don't add memory to dev agents — they should follow conventions, not learn their own.

**Action items:**
- [x] ~~Add `memory: user` to `architect.md` and `pr-reviewer.md`~~ — Done (2026-03-05)
- [x] ~~Add `skills` field to dev agents to preload coding conventions~~ — Done (2026-03-06). Created 3 skills with `!command`` pre-fetch
- [ ] Evaluate `isolation: worktree` for PR review subagent
- [ ] Add scoped hooks to dev agents (e.g., block editing wrong service directory)

---

### Model Configuration

| Aspect | DTF (current) | Native Model Features |
|--------|--------------|----------------------|
| **Model per agent** | Set in agent frontmatter (`model: sonnet`, `model: opus`) | Same, plus `opusplan` alias |
| **Effort level** | `ultrathink` keyword in skill prompts (ticket-scout, retro-proposals) | Effort slider in `/model` (low/medium/high), `CLAUDE_CODE_EFFORT_LEVEL` env var |
| **Extended context** | Not used | `sonnet[1m]` — 1M token context for long sessions |
| **Subagent model override** | Per-agent in frontmatter | `CLAUDE_CODE_SUBAGENT_MODEL` env var for global override |

**Decision:** Added `ultrathink` to `/ticket-scout` and `/retro-proposals` (2026-03-05).

#### Why not `opusplan`?

`opusplan` uses Opus for planning and auto-switches to Sonnet for execution. DTF doesn't need this because **the Opus/Sonnet split already exists at the agent level**:

- **Architect** (`model: opus`) — pure planning: reads code, analyzes scope, produces architecture reports. There's no execution phase where it writes code, so switching to Sonnet mid-session would only downgrade analysis quality during file reads.
- **Dev agents** (`model: sonnet`) — pure execution: implement the plan the architect produced. Already on the cheaper, faster model.
- **Skills** (`ultrathink`) — per-turn deep reasoning, more precise than `opusplan`'s per-session model switch. Only activates when the prompt contains the keyword.

DTF's multi-agent architecture *is* opusplan — Opus plans, Sonnet executes — just implemented as separate agents instead of a model alias. The model alias would only help in a single-agent session that does both planning and coding, which is what `--lite` mode does. But even there, the team lead needs Opus-level reasoning throughout (review triage, retro analysis, quality gate decisions), not just during initial planning.

| Candidate | Verdict | Reason |
|-----------|---------|--------|
| Architect agent | Skip | All planning, no execution phase to downgrade to Sonnet |
| `/ticket-scout` | Skip | All analysis — `ultrathink` already handles deep reasoning per-turn |
| `/retro-proposals` | Skip | All analysis — same as ticket-scout |
| `/create-stories` | Skip | Lightweight orchestration (shell commands, worktree setup) — no heavy planning |
| `--lite` team lead | Skip | Needs nuanced decisions throughout, not just during planning phase |

**Action items:**
- [x] ~~Test `opusplan` for architect agent~~ — Skipped: architect is pure planning, Sonnet downgrade would hurt. DTF's agent architecture already splits Opus (planning) and Sonnet (execution)
- [x] ~~Test `sonnet[1m]`~~ — Done (2026-03-06). Applied to backend-dev, frontend-dev, data-engineer agents
- [ ] Document when to use which model in this file

---

### Skills System

| Aspect | DTF (current) | Native Skills Features |
|--------|--------------|----------------------|
| **Commands** | `.md` files in `~/.claude/commands/` | Same, plus `SKILL.md` in `.claude/skills/` directories |
| **Supporting files** | Not used | Skill directories can contain templates, examples, scripts alongside SKILL.md |
| **Dynamic context** | Not used | `!`command`` syntax runs shell commands before skill content is sent |
| **Forked context** | Not used | `context: fork` runs skill in isolated subagent |
| **Tool restriction** | Not used | `allowed-tools` limits what Claude can do during skill |

**Decision:** Current commands work fine. Adopt new features selectively:
- `!`command`` for `/ticket-scout` — pre-fetch Jira data instead of making Claude run it
- `context: fork` for heavy skills that pollute main context
- `allowed-tools` for read-only skills like `/review-pr`

**Action items:**
- [x] ~~Convert `/ticket-scout` to use `!command`` for pre-fetching~~ — Done (2026-03-06). Pre-fetches scouted-tickets.json
- [x] ~~Add `context: fork` to `/ticket-scout` and `/retro-proposals`~~ — Done (2026-03-06)
- [ ] Add `allowed-tools` to `/review-pr` (read-only + gh CLI)
- [ ] Evaluate migrating commands/ to skills/ directory structure

---

### Plugin System

Plugins support **self-hosted private marketplaces** — no global marketplace required. A marketplace is just a `marketplace.json` file in a git repo. Teams add it with `/plugin marketplace add owner/repo` (GitHub) or any git URL. Private repos work if the user has git credentials.

| Aspect | DTF (current) | Native Plugins |
|--------|--------------|----------------|
| **Distribution** | `dtf install` CLI — clones repo, symlinks into `~/.claude/` | `/plugin install` — built-in install, versioning, namespacing |
| **Updates** | `dtf update` — pull + verify symlinks | Auto-update on startup (with `GITHUB_TOKEN` for private repos), or `/plugin marketplace update` |
| **Namespacing** | Not namespaced — commands are global | Plugin skills get `plugin-name:skill-name` prefix |
| **Packaging** | Git repo with scripts | `.claude-plugin/plugin.json` manifest + directory structure |
| **Hosting** | Public GitHub repo | GitHub, GitLab, Bitbucket, self-hosted git, local paths, npm, pip |
| **Access control** | Public only | Private repos (git credentials), managed `strictKnownMarketplaces` to lock down allowed sources |
| **Team onboarding** | `dtf install <url> --company-config <path>` | `extraKnownMarketplaces` in `.claude/settings.json` auto-prompts on project trust + `enabledPlugins` for defaults |
| **Components** | Commands (.md), agents (.md), hooks, scripts | Commands, agents, hooks, MCP servers, LSP servers — all in one package |

#### Implemented: Three-repo architecture (2026-03-05)

Plugin files now live in dedicated marketplace repos, separate from the DTF documentation repo:

| Repo | Visibility | Contents |
|------|-----------|----------|
| `marketplace-private` | Private | Unsanitized plugin files (commands, agents, scripts, docs) + config backup. Team installs from here |
| `marketplace` | Public | Sanitized plugin files. Community installs from here, de-sanitizes with `company-config.json` |
| `dream-team-flow` | Public | DTF documentation, improvement plan, `dtf` CLI, company config templates, security configs |

```
marketplace/ (or marketplace-private/)
├── .claude-plugin/
│   ├── marketplace.json          ← catalog (source: "." — points to itself)
│   └── plugin.json               ← manifest (name: "claude-toolkit")
├── commands/                     ← all slash commands
├── agents/                       ← agent definitions
├── scripts/                      ← shell scripts
├── skills/                       ← agent skills
└── docs/                         ← operational docs (checklist, learning system)
```

**Install:**
```bash
# Team (private — unsanitized, ready to use)
/plugin marketplace add johwer/marketplace-private
/plugin install claude-toolkit@marketplace-private

# Community (public — sanitized, needs company config)
/plugin marketplace add johwer/marketplace
/plugin install claude-toolkit@marketplace
```

**Why this structure:**
- Plugin files are **repo-agnostic** — any project can install `claude-toolkit`, not just Dream Team Flow users
- Private marketplace has real names (no de-sanitization needed for team)
- Public marketplace is sanitized (community uses `company-config.json` to de-sanitize)
- `sync-config` pushes `~/.claude/` to all three repos automatically
- Future plugins from other projects add entries to `marketplace.json` pointing to their own repos

#### DTF as a plugin vs `dtf` CLI — what changes

| Capability | Plugin handles | Still needs `dtf` CLI |
|-----------|:-:|:-:|
| Skills/commands (my-dream-team, review-pr, etc.) | Yes | — |
| Agents (architect, backend-dev, etc.) | Yes | — |
| Hooks (migration guard, lint reminder, etc.) | Yes | — |
| Scripts (quality-gate.sh, chrome-queue.sh, etc.) | Yes | — |
| Docs (checklist, learning-system, etc.) | Yes | — |
| Version management + auto-updates | Yes (built-in) | — |
| Namespaced commands (`claude-toolkit:my-dream-team`) | Yes | — |
| Company config de-sanitization | — | Yes |
| Personal config (`dtf-config.json`) | — | Yes |
| Jira project/domain setup | — | Yes |
| Service name mapping | — | Yes |
| Interactive install wizard | — | Yes |

**Action items:**
- [x] ~~Restructure as plugin marketplace~~ — Done (2026-03-05). Three repos: marketplace-private, marketplace, dream-team-flow
- [x] ~~Create private marketplace for team~~ — Done. `johwer/marketplace-private` with unsanitized files
- [x] ~~Update sync-config for three-repo sync~~ — Done. Pushes plugin files to both marketplaces, DTF templates to dream-team-flow
- [ ] Test `extraKnownMarketplaces` in project `.claude/settings.json` for auto-onboarding
- [ ] Test `enabledPlugins` for default-on behavior when team trusts the project
- [ ] Update `dtf` CLI to work alongside plugin install (detect if plugin is already installed)

---

### Built-in Skills

| Skill | What it does | DTF equivalent | Verdict |
|-------|-------------|----------------|---------|
| `/batch` | Parallel implementation across files, each in worktree with PR | `/create-stories` (ticket-level parallelism) | **Skip** — `/create-stories` covers ticket-level parallelism. `/batch` available natively for file-level mass changes |
| `/simplify` | 3 parallel review agents (reuse, quality, efficiency) | Maya (pr-reviewer) + security scan | **Skip** — DTF already runs code review + security scan. Third pass adds cost without clear value |
| `/debug` | Reads session debug log for troubleshooting | No equivalent | **Nice to know** — useful for debugging stuck sessions |
| `/claude-api` | API reference for building with Claude | Not relevant | Skip |

**Action items:**
- [x] ~~Document `/batch`~~ — Skipped. Available natively for file-level mass changes
- [x] ~~Test `/simplify`~~ — Skipped. Maya + security scan already cover reuse, quality, and efficiency

---

### Medium Impact Features — Reviewed (2026-03-05)

| Feature | Verdict | Reasoning |
|---------|---------|-----------|
| **`sonnet[1m]`** | **Adopt (P1)** | Long Dream Team sessions hit compaction. Using `sonnet[1m]` for dev agents that accumulate large diffs reduces compaction artifacts. Easy — just change model field in agent frontmatter |
| **`context: fork`** | **Adopt (P2)** | `/ticket-scout` and `/retro-proposals` both do heavy analysis that pollutes the main context. Forking keeps the orchestrator's context clean. One frontmatter field |
| **Subagent `skills` field** | **Adopt (P2)** | Injecting coding-style or api-conventions at agent startup means agents start with project knowledge without the orchestrator copying context. Pairs with architect's convention summaries |
| **`!command`` in skills** | **Adopt (P2)** | `/ticket-scout` currently makes Claude run `acli jira` — pre-fetching with `!acli jira...`` saves a round-trip and tokens. Same for `/create-stories` fetching ticket data |
| **`isolation: worktree`** | **Skip** | DTF creates worktrees via `launch-workspace.sh` with full port isolation, Docker port mapping, env files. Built-in isolation is designed for simpler cases |
| **Background subagents** | **Skip** | DTF uses separate terminal sessions per agent — better visibility and crash isolation. Backgrounding within one session makes the UX harder to follow |
| **`/simplify`** | **Skip** | DTF's pr-reviewer already does categorized feedback (MUST FIX / SUGGESTION / QUESTION / PRAISE). Adding a second review pass burns tokens for marginal gain |

---

### Low Impact Features — Reviewed (2026-03-05)

| Feature | Verdict | Reasoning |
|---------|---------|-----------|
| **Effort slider (`/model`)** | **Skip** | `ultrathink` keyword works fine per-turn |
| **`--agents` CLI flag** | **Skip** | Agent files are easy to edit. Testing via JSON flag adds no real value |
| **Subagent hooks (frontmatter)** | **Maybe later (P3)** | Blocking agents from editing wrong services is valuable, but DTF's worktree isolation already scopes each agent. Useful as a guardrail layer later |
| **Plan approval for teammates** | **Skip** | DTF's architect already produces a plan the orchestrator reviews before spawning devs. Agent Teams' version of what DTF already does |
| **`CLAUDE_CODE_SUBAGENT_MODEL` env var** | **Skip** | DTF explicitly sets models per agent (Opus for thinking, Sonnet for execution). A global override would break that split |

---

### Hooks

| Aspect | DTF (current) | Available but not used |
|--------|--------------|----------------------|
| **Active hooks** | Tool logging, desktop notification, migration guard, lock file guard, auto-lint reminder, TeammateIdle gate, TaskCompleted gate | `SubagentStart`, `SubagentStop`, `WorktreeCreate`, `WorktreeRemove`, `PreToolUse` per-agent, HTTP hooks, prompt hooks |
| **Hook types** | Command hooks (shell scripts) | Also: HTTP hooks (POST to URL), prompt hooks (LLM evaluates) |

**Decision:** Current hooks are sufficient. HTTP hooks could be useful if we add a dashboard. Prompt hooks are interesting for nuanced validation (e.g., "is this commit message good enough?") but add latency and cost.

**Action items:**
- [ ] Consider `SubagentStart` hook to log when Dream Team agents spawn
- [ ] Evaluate prompt hooks for PR description quality validation

---

## Improvement Priority

### Done
- [x] **Subagent `memory`** — Added to architect and pr-reviewer (2026-03-05)
- [x] **Plugin packaging** — Three-repo architecture: marketplace-private, marketplace, dream-team-flow (2026-03-05)
- [x] ~~**`opusplan`**~~ — Skipped. DTF's agent architecture already splits Opus/Sonnet
- [x] ~~**`/batch`**~~ — Skipped. `/create-stories` covers ticket-level parallelism; `/batch` available natively for file-level changes
- [x] **Community skills (2026-03-17)** — Added 6 skills from aihero.dev + mattpocock comparison: `/tdd`, `/triage-issue`, `/design-an-interface`, `/request-refactor-plan`, `/improve-codebase-architecture`, `/grill-me`. Wired into flows: dev agents auto-load `/tdd`, `/my-dream-team` suggests triage/design pre-flight, `/improve-codebase-architecture` escalates to refactor-plan for 3+ findings

### P0 — Do Soon
~~1. **Chrome Integration docs** — Done (2026-03-06). Added Chrome queue flow to `visual-testing.md`~~
~~2. **Skill `context: fork`** — Done (2026-03-06). Added to `/ticket-scout` and `/retro-proposals`~~
~~3. **`!command`` in skills** — Done (2026-03-06). Added scouted-tickets pre-fetch to `/ticket-scout`~~

### P1 — Do Next
~~4. **Subagent `skills` preloading** — Done (2026-03-06). Created `backend-conventions`, `frontend-conventions`, `data-conventions` skills with `!command`` pre-fetch from repo docs. Added to all three dev agents~~
~~5. **`sonnet[1m]`** — Done (2026-03-06). Changed backend-dev, frontend-dev, data-engineer from `sonnet` to `sonnet[1m]`~~

### P2 — Evaluate Later
6. **Agent Teams migration** — Wait for experimental flag to be removed. Track progress
7. **Plugin auto-onboarding** — Test `extraKnownMarketplaces` + `enabledPlugins` in project settings

### P3 — Monitor
8. **Subagent hooks (frontmatter)** — Service-scoped editing restrictions if cross-editing becomes a problem
9. **HTTP hooks** — If we build a Dream Team dashboard
10. **Prompt hooks** — For nuanced validation
11. **`WorktreeCreate`/`WorktreeRemove` hooks** — Custom worktree setup

---

## Changelog

| Date | Change | Section |
|------|--------|---------|
| 2026-03-05 | Initial document created from full docs review | All |
| 2026-03-05 | Added `ultrathink` to ticket-scout and retro-proposals | Model Configuration |
| 2026-03-05 | Added PR comment triage to dev-workflow-checklist Section 3 | Not in this doc (checklist) |
| 2026-03-05 | Added EF migration guideline to repo docs (PR #2006) | Not in this doc (repo docs) |
| 2026-03-05 | Corrected Chrome Integration — AppleScript primary, Chrome via queue | Visual Testing |
| 2026-03-05 | Clarified Agent Teams vs DTF `--lite` mode | Multi-Agent Orchestration |
| 2026-03-05 | Added `memory: user` to architect and pr-reviewer agents | Subagent Configuration |
| 2026-03-05 | Skipped `opusplan` — DTF agent architecture already splits Opus/Sonnet | Model Configuration |
| 2026-03-05 | Implemented three-repo plugin architecture (marketplace, marketplace-private, dream-team-flow) | Plugin System |
| 2026-03-05 | Updated sync-config for three-repo sync | Plugin System |
| 2026-03-05 | Reviewed all medium and low impact features — verdicts recorded | Medium/Low Impact, Priority |
| 2026-03-17 | Added 6 community skills: `/tdd`, `/triage-issue`, `/design-an-interface`, `/request-refactor-plan`, `/improve-codebase-architecture`, `/grill-me` | Skills System |
| 2026-03-17 | Wired skills into flows: dev agents auto-load `/tdd`; `/my-dream-team` pre-flight suggests triage/design; `/improve-codebase-architecture` escalates to refactor-plan | Skills System |
| 2026-03-17 | Updated `docs/commands.md` with Skills section | Skills System |
| 2026-03-17 | Marked ECC TDD-first + mattpocock items as Done in comparison.md | Comparison |

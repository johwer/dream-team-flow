# Team Review — Analyze Learnings & Propose Improvements

Analyze accumulated Dream Team session data (retro learnings, history, journals) to identify patterns, flag problems, and propose concrete improvements to the team workflow.

## Data Sources

Read these files (skip any that don't exist yet):

1. **Session history**: Look for `dream-team-history.json` in your project memory directory (`~/.claude/projects/*/memory/`)
   - Team sizing decisions and verdicts (good / over-spawned / under-spawned)
   - Complexity ratings, review rounds, must-fix counts
   - Journal highlights from each session
   - Achievement distribution

2. **Retro learnings**: Look for `dream-team-learnings.md` in the same project memory directory
   - Applied and deferred command file changes per session
   - Doc gaps found
   - Process notes

3. **Current command file**: `~/.claude/commands/my-dream-team.md`
   - To cross-reference whether past learnings have been addressed

## Analysis

If there are fewer than 2 sessions recorded, tell the user there isn't enough data yet and show what data will be collected after more sessions.

Otherwise, analyze across all sessions and produce a report:

```
## Dream Team Health Report

### Sessions Analyzed
[N sessions from DATE to DATE]

### Team Sizing Patterns
- Average team size: [N agents]
- Over-spawned: [N times] — [pattern description]
- Under-spawned: [N times] — [pattern description]
- **Recommendation**: [e.g., "Amara tends to over-spawn for frontend-only tickets — consider adding a rule to cap at 1 frontend dev for tickets under medium complexity"]

### Recurring Instruction Gaps
[Group journal highlights by category. If the same issue appears 2+ times, flag it.]
- **Repeated issue**: [description] — appeared in [N] sessions
- **Proposed fix**: [specific change to agent prompt in my-dream-team.md]

### Communication & Coordination
- Average review rounds: [N]
- Sessions with blocked agents: [N]
- Communication friction patterns: [from journal highlights]
- **Recommendation**: [e.g., "Kenji frequently waits for API contract details — consider having Amara provide a more detailed contract template"]

### Convention & Doc Gaps
[Recurring doc issues from retro learnings]
- [doc file]: [issue] — reported [N] times
- **Action**: [fix the doc / update agent instructions / add to conventions summary]

### Deferred Changes
[List changes from past retros that were saved but never applied]
- From [date] session: [change description]
- **Still relevant?** [yes/no based on current command file]

### Achievement Trends
- Most common: [achievement] ([N] times)
- Rarest: [achievement] ([N] times)
- Agents with no achievements yet: [names]

### Overall Health Score
Rate the team on these dimensions (1-5):
- **Instruction quality**: Are agent prompts giving them what they need?
- **Team sizing accuracy**: Is Amara calibrating well?
- **Communication flow**: Are agents coordinating without friction?
- **Review efficiency**: Are reviews catching real issues without excessive rounds?
- **Context efficiency**: Are agents staying within context limits?
```

## Learning Router

After the health report, route deferred learnings to the right destination files. This is the key value of `/team-review` — learnings don't just sit in a markdown file, they get applied where they'll actually help.

### Destination Registry

| ID | Destination | Path | Scope |
|----|-------------|------|-------|
| `dream-team` | Dream Team command | `~/.claude/commands/my-dream-team.md` | Agent prompts, phases, process |
| `agent:<name>` | Standalone agent | `~/.claude/agents/<name>.md` | Agent behavior outside Dream Team |
| `skill:<name>` | Skill/command | `~/.claude/commands/<name>.md` | Skill-specific checklist or workflow |
| `project-claude` | Project CLAUDE.md | `<monorepo>/CLAUDE.md` | Every Claude session in this repo |
| `agents-md:<path>` | Repo AGENTS.md | `<monorepo>/<path>` (e.g., `services/ServiceB/AGENTS.md`, `apps/web/AGENTS.md`) | Area-specific conventions |
| `global-claude` | Global CLAUDE.md | `~/.claude/CLAUDE.md` | Every Claude session everywhere |
| `repo-docs` | Repo docs | `docs/<file>.md` | Team-wide coding standards |
| `memory` | Memory file | Project memory directory | Notes for future reference only |

### Classification Rules

For each unaddressed learning, decide destination based on:

- **Agent coordination, communication, timing, prompting** → `dream-team`
- **Universal coding convention** (applies regardless of who codes — date helpers, Dapper, enum patterns) → `project-claude`
- **Service-specific gotcha** (e.g., "ServiceB uses soft deletes", "ServiceC seed data quirk") → `agents-md:services/<svc>/AGENTS.md`
- **Frontend-specific pattern** (component conventions, RTK Query tips, theme tokens) → `agents-md:apps/web/AGENTS.md`
- **Standalone agent should always do X** (e.g., "architect must check API endpoints") → `agent:<name>`
- **Skill checklist or workflow improvement** (e.g., "review-pr should verify API contracts") → `skill:<name>`
- **Repo-wide standard the human team should know** (naming, architecture decisions) → `repo-docs`
- **General knowledge, not actionable as a rule** → `memory`

A single learning can route to **multiple destinations** (e.g., "check API endpoints" → both `agent:architect` and `skill:review-pr`).

### Routing Workflow

1. **Scan** all "Deferred" items from `dream-team-learnings.md` that aren't struck through (`~~`). Also check items with destination hints from recent retros.

2. **Classify** each using the rules above. If the retro already tagged a destination hint, use it as a starting point but verify it's correct.

3. **Read each destination file** before proposing changes — understand what's already there so you add to the right section and avoid duplicates.

4. **Present the routing table** to the user:

   ```
   ## Learning Router — Proposed Destinations

   | # | Learning | Source Session | Destination | File | Proposed Change |
   |---|---------|---------------|-------------|------|-----------------|
   | 1 | Use Dapper for heavy SQL | PROJ-1359 | project-claude | CLAUDE.md | Add to Conventions section |
   | 2 | Check API endpoints exist | PROJ-1562 | agent:architect + skill:review-pr | architect.md, review-pr.md | Add checklist item |
   | 3 | Kenji shares contracts late | PROJ-1359 | dream-team | my-dream-team.md | Add timing instruction to Kenji prompt |
   | 4 | ServiceB note_comments missing | PROJ-1359 | agents-md | services/ServiceB/AGENTS.md | Add Known Issues section |
   | 5 | Theme token colors undocumented | PROJ-1569 | memory | ticket-patterns.md | Note only, not actionable as rule |

   ### No Route (already addressed or no longer relevant)
   - [item] — [reason it's skipped]
   ```

5. **Ask the user** to approve routing using AskUserQuestion:
   - "Route all" — Apply all proposed changes to all destination files
   - "Let me pick" — User selects which rows to apply
   - "Save routing plan only" — Record the proposed routing in learnings file without applying
   - "Skip routing"

6. **Apply** approved changes to each destination file. For each file:
   - Read the file first
   - Find the appropriate section (or create one like `## Learned Conventions` or `## Known Issues`)
   - Add the learning concisely — match the existing style of the file
   - Don't restructure the file, just append to the right section

7. **Mark applied items** in `dream-team-learnings.md`:
   - Change `- [description]` to `- ~~[description]~~ → Applied to `[destination]` on [date]`
   - This prevents re-proposing already-routed learnings in future reviews

## Actions

After presenting the health report AND the routing table, ask the user:

- "Apply health report changes + route learnings" — Do both: edit `my-dream-team.md` with health report fixes AND apply all routed learnings to their destination files
- "Apply health report changes only" — Only the `my-dream-team.md` changes (legacy behavior)
- "Route learnings only" — Skip health report changes, just apply the routed learnings
- "Save report" — Append the report to `dream-team-learnings.md` under a `## Team Review: [date]` heading
- "Skip"

After applying, offer to run `/sync-config` to push changes.

## Tips

- Run this periodically (e.g., every 5-10 sessions) to keep the team calibrated
- The report gets more useful with more data — early sessions may not show clear patterns
- Focus on **recurring** issues, not one-off problems
- The Learning Router is most valuable after 3+ sessions — that's when deferred learnings pile up
- Learnings routed to `project-claude` or `agents-md` help ALL Claude sessions, not just Dream Team — this is how lite-mode and raw Claude sessions benefit from Dream Team retros

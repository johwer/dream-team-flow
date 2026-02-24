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

## Actions

After presenting the report, ask the user:

- "Apply proposed command file changes" — Edit `my-dream-team.md` with the recommended fixes
- "Apply and sync" — Apply changes + run `/sync-config` to push
- "Just save the report" — Append the report to `dream-team-learnings.md` under a `## Team Review: [date]` heading
- "Skip"

## Tips

- Run this periodically (e.g., every 5-10 sessions) to keep the team calibrated
- The report gets more useful with more data — early sessions may not show clear patterns
- Focus on **recurring** issues, not one-off problems

# Retrospectives & Learning Router

Every Dream Team session ends with a retrospective. Agents reflect on what worked and what didn't, vote on improvements, and tag each learning with a **destination** — where it should be applied.

## How it works

1. **Retro runs** (Phase 6.75) — agents propose improvements tagged with destinations
2. **Learnings accumulate** in a session log (`dream-team-learnings.md`)
3. **`/team-review`** analyzes patterns across sessions and routes learnings

## Where learnings go

| Destination | Example | Apply mode |
|-------------|---------|------------|
| Dream Team command | "Kenji should share API contracts earlier" | Direct (personal config) |
| Standalone agent | "Architect must check API endpoint existence" | Direct (personal config) |
| Skill/command | "review-pr should verify API contracts" | Direct (personal config) |
| Project CLAUDE.md | "Use Dapper for heavyweight SQL" | Ticket + PR |
| AGENTS.md | "HCM uses soft deletes" | Ticket + PR |
| Repo docs | "Date helper convention" | Ticket + PR |

**Direct apply** — personal config files in `~/.claude/` are edited immediately and synced with `/sync-config`.

**Ticket + PR** — shared repo files that affect the whole team are never written directly. Instead, `/team-review` creates a Jira ticket and a draft PR so the team can review the changes.

See **[Commands Reference](commands.md)** for the full list of slash commands, flags, and typical workflow.

## The feedback loop

```
Session retro → learnings tagged → /team-review routes them
                                        ├── Personal config → direct apply
                                        │                     └── /sync-config
                                        └── Shared repo → Jira ticket + draft PR
                                                          └── /review-pr → team merges
```

This means Dream Team retros improve not just the Dream Team — they improve **every Claude session** in the project. Learnings routed to `CLAUDE.md` or `AGENTS.md` are picked up by raw Claude, lite mode, subagents, and any team member who pulls the changes.

# Workflow Phases

## Full Mode (default)

Multi-agent team with full orchestration.

```mermaid
flowchart TD
    Ticket["Ticket In"] --> Amara["Amara analyzes\n+ sizes team"]
    Amara -.-> Draft["Draft PR"]

    subgraph Impl["Parallel Implementation"]
        Kenji["Kenji - Backend"]
        Ingrid["Ingrid - Frontend"]
        Diego["Diego - Infra"]
    end

    Amara --> Impl

    Maya["Maya reviews"]
    Impl --> Maya
    Maya -->|"MUST FIX"| Impl

    Suki["Suki tests"]
    Maya -->|"Approved"| Suki

    Summary["Tane writes summary\nPR marked ready"]
    Suki --> Summary

    subgraph Feedback["Feedback Cycle"]
        AIBots["AI Bots review\nGemini + Copilot"]
        HumanR["Human reviewers\nauto-assigned"]
        FixIssues["Fix issues\n+ re-push"]
        UserR{"User review"}
        AIBots --> HumanR
        HumanR --> UserR
        UserR -->|"Feedback"| FixIssues
        FixIssues --> AIBots
    end

    Summary --> Feedback

    Retro["Retrospective\nvote on improvements"]
    UserR -->|"Ship it"| Retro
    Retro --> Ship["Ship"]
```

## Lite Mode (`--lite`)

Claude works solo or selectively spawns agents. Same quality gates and feedback cycle.

```mermaid
flowchart TD
    Ticket["Ticket In"] --> Analyze["Claude analyzes ticket"]
    Analyze -.-> Draft["Draft PR"]
    Analyze --> Decide{"Complexity?"}

    Decide -->|"Simple"| Solo["Claude implements\ndirectly"]
    Decide -->|"Medium"| One["Claude + 1 agent"]
    Decide -->|"Complex"| Multi["Claude + agents\nas needed"]

    Review["Claude reviews\nsecurity checklist"]
    Solo --> Review
    One --> Review
    Multi --> Review

    Summary["Summary written\nPR marked ready"]
    Review --> Summary

    subgraph Feedback["Feedback Cycle"]
        AIBots["AI Bots review\nGemini + Copilot"]
        HumanR["Human reviewers\nauto-assigned"]
        FixIssues["Fix issues\n+ re-push"]
        UserR{"User review"}
        AIBots --> HumanR
        HumanR --> UserR
        UserR -->|"Feedback"| FixIssues
        FixIssues --> AIBots
    end

    Summary --> Feedback

    Retro["Retrospective\nlearnings saved"]
    UserR -->|"Ship it"| Retro
    Retro --> Ship["Ship"]
```

## Local Mode (`--local`)

No PR, no push. Stops after review.

```mermaid
flowchart TD
    Ticket["Ticket In"] --> Analyze["Analyze ticket"]
    Analyze --> Implement["Implement"]
    Implement --> Review["Code review"]
    Review -->|"Issues"| Implement
    Review -->|"Clean"| Done["Ready for\nlocal review\ngit diff"]
```

## Mode Comparison

| Feature | Full | Lite | Local |
|---------|:----:|:----:|:-----:|
| Architecture analysis | Amara | Claude | Claude |
| Implementation | Parallel agents | Claude decides | Claude decides |
| Code review | Maya | Claude or Maya | Claude or Maya |
| Draft PR | yes | yes | - |
| AI bot feedback | yes | yes | - |
| Human reviewer assignment | yes | yes | - |
| User feedback loop | yes | yes | - |
| Summary | Tane | Claude | - |
| Retrospective | yes | yes | - |
| Jira transitions | yes | yes | - |

Add `--no-worktree` to any mode to skip worktree creation and work in the current directory.

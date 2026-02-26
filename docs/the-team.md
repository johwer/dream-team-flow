# The Dream Team

Dream Team Flow uses specialized AI agents, each with a distinct role. The architect dynamically decides team size and model tier based on ticket complexity — simple tickets get 2-3 agents, complex multi-service work gets the full team.

## Agents

| | Agent | Role | When |
|--|-------|------|------|
| 🏛️ | **Amara** 🇳🇬 | Tech Architect | Always — analyzes ticket, sizes team, defines contracts |
| ⚙️ | **Kenji** 🇯🇵 | Backend Developer | When backend changes are needed |
| 🎨 | **Ingrid** 🇸🇪 | Frontend Developer | When frontend changes are needed |
| ⚙️ | **Ravi** 🇮🇳 | Backend Dev (pool) | When 2+ backend workstreams exist |
| 🎨 | **Elsa** 🇩🇪 | Frontend Dev (pool) | When 2+ frontend workstreams exist |
| 📊 | **Mei** 🇨🇳 | Data Engineer | When complex queries, reports, or data mapping needed |
| 🐳 | **Diego** 🇲🇽 | Infrastructure Engineer | When migrations or Docker changes needed |
| 🔍 | **Maya** 🇮🇱 | PR Reviewer | Always — security, conventions, formatting |
| 🧪 | **Suki** 🇯🇵 | Functional Tester | Optional — when architect flags testing |
| 👁️ | **Lena** 🇩🇪 | Visual Verifier | When UI changes need before/after GIFs |
| 📝 | **Tane** 🇳🇿 | Summary Writer | Twice — initial for reviewers + final after approval |

## How team sizing works

The architect (Amara) analyzes the ticket and decides:

1. **Scope** — which services/layers are affected (frontend, backend, data, infra)
2. **Complexity** — simple change vs multi-service feature
3. **Team size** — spawns only the agents needed

| Ticket complexity | Typical team |
|-------------------|-------------|
| Small (S) | Amara + 1 dev + Maya |
| Medium (M) | Amara + Kenji + Ingrid + Maya + Tane |
| Large (L) | Full team — all relevant specialists |

## Agent definitions

Each agent is defined as a standalone subagent in [`agents/`](../agents/):

| Agent file | Model | Tools |
|------------|-------|-------|
| [`architect.md`](../agents/architect.md) | Opus | Read-only + Bash |
| [`backend-dev.md`](../agents/backend-dev.md) | Sonnet | Full |
| [`frontend-dev.md`](../agents/frontend-dev.md) | Sonnet | Full |
| [`pr-reviewer.md`](../agents/pr-reviewer.md) | Opus | Read-only + Bash |
| [`data-engineer.md`](../agents/data-engineer.md) | Sonnet | Full |

Agents can also be used standalone outside of Dream Team: "Use the pr-reviewer subagent to review this".

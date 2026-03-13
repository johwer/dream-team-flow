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

Each agent is defined as a standalone subagent in the [marketplace](https://github.com/johwer/marketplace) repo under `agents/`:

| Agent file | Role | Model | Tools |
|------------|------|-------|-------|
| [`architect.md`](https://github.com/johwer/marketplace/blob/main/agents/architect.md) | Tech Architect | Opus | Read-only + Bash |
| [`backend-dev.md`](https://github.com/johwer/marketplace/blob/main/agents/backend-dev.md) | Backend Developer | Sonnet | Full |
| [`frontend-dev.md`](https://github.com/johwer/marketplace/blob/main/agents/frontend-dev.md) | Frontend Developer | Sonnet | Full |
| [`data-engineer.md`](https://github.com/johwer/marketplace/blob/main/agents/data-engineer.md) | Data Engineer | Sonnet | Full |
| [`infra-engineer.md`](https://github.com/johwer/marketplace/blob/main/agents/infra-engineer.md) | Infrastructure Engineer | Sonnet | Full |
| [`pr-reviewer.md`](https://github.com/johwer/marketplace/blob/main/agents/pr-reviewer.md) | PR Reviewer | Opus | Read-only + Bash |
| [`security-reviewer.md`](https://github.com/johwer/marketplace/blob/main/agents/security-reviewer.md) | Security Reviewer | Opus | Read-only + Bash |
| [`functional-tester.md`](https://github.com/johwer/marketplace/blob/main/agents/functional-tester.md) | Functional Tester | Sonnet | Full |
| [`visual-verifier.md`](https://github.com/johwer/marketplace/blob/main/agents/visual-verifier.md) | Visual Verifier | Sonnet | Full |
| [`summary-writer.md`](https://github.com/johwer/marketplace/blob/main/agents/summary-writer.md) | Summary Writer | Sonnet | Read-only + Bash |

Pool agents (Ravi, Elsa) reuse the `backend-dev` and `frontend-dev` definitions — they're second instances spawned when the architect identifies 2+ independent workstreams in the same discipline.

Agents can also be used standalone outside of Dream Team: "Use the security-reviewer subagent to scan this PR".

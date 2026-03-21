# The Dream Team

Dream Team Flow uses 29 specialized AI agents across 8 domains. Your role determines which agents are available (3-7 per role). The architect dynamically decides team size based on ticket complexity — simple tickets get 2-3 agents, complex multi-service work gets the full set.

## Agents by Domain

### Engineering (7)
| Agent | Role | Model | When |
|-------|------|-------|------|
| `architect` | Architecture analysis, implementation plans | Opus | Always — analyzes ticket, sizes team, defines contracts |
| `frontend-dev` | React/TypeScript/Tailwind implementation | Sonnet | When frontend changes needed |
| `backend-dev` | .NET/C#/EF Core implementation | Sonnet | When backend changes needed |
| `pr-reviewer` | Code review (MUST FIX / SUGGESTION / QUESTION / PRAISE) | Opus | Always — security, conventions, formatting |
| `api-designer` | REST API contracts, OpenAPI specs, endpoint design | Sonnet | When API changes needed |
| `performance-analyst` | Database queries, API latency, bundle size, rendering | Sonnet | When performance investigation needed |
| `migration-planner` | Safe database migrations, schema evolution, rollback strategies | Opus | When schema changes needed |

### Data (4)
| Agent | Role | Model | When |
|-------|------|-------|------|
| `data-engineer` | Data mapping, EF Core migrations, dbt, pipelines | Sonnet | When data work needed |
| `data-analyst` | SQL, Jupyter notebooks, visualization, BI | Sonnet | When analysis/reporting needed |
| `pipeline-builder` | dbt models, ETL workflows, data quality checks | Sonnet | When pipeline changes needed |
| `insights-reporter` | Business reports, dashboard specs, data narratives | Sonnet | When reporting output needed |

### Design (2)
| Agent | Role | Model | When |
|-------|------|-------|------|
| `ui-designer` | Component interfaces, design tokens, visual specs | Sonnet | When new components needed |
| `ux-researcher` | Usability heuristics, user flows, accessibility | Sonnet | When UX review needed |

### Infrastructure (3)
| Agent | Role | Model | When |
|-------|------|-------|------|
| `infra-engineer` | Terraform, AWS, WAF, monitoring, RDS, ECR | Sonnet | When infra changes needed |
| `ci-cd-engineer` | GitHub Actions, deployment strategies, build optimization | Sonnet | When pipeline changes needed |
| `security-auditor` | IAM, secrets, vulnerability scanning, compliance | Opus | When security review needed |

### Marketing (4)
| Agent | Role | Model | When |
|-------|------|-------|------|
| `marketing-ops` | Content, campaigns, SEO, email marketing | Sonnet | Marketing workflows |
| `sales-enablement` | Proposals, ROI models, competitive analysis | Sonnet | Sales workflows |
| `content-creator` | Blog posts, case studies, whitepapers | Sonnet | Content creation |
| `social-strategist` | Social media content, LinkedIn, campaign calendars | Sonnet | Social media workflows |

### Operations (2)
| Agent | Role | Model | When |
|-------|------|-------|------|
| `customer-ops` | Customer onboarding, integration config, ITSM tickets | Sonnet | Customer setup |
| `support-responder` | Support ticket investigation, root cause, workarounds | Sonnet | Support workflows |

### Product (3)
| Agent | Role | Model | When |
|-------|------|-------|------|
| `po-analyst` | Ticket refinement, sprint planning, impact analysis | Opus | Product workflows |
| `requirements-analyst` | User stories, acceptance criteria, edge cases | Opus | Requirement analysis |
| `sprint-prioritizer` | Backlog prioritization, capacity planning | Sonnet | Sprint planning |

### Testing (4)
| Agent | Role | Model | When |
|-------|------|-------|------|
| `qa-tester` | E2E testing, Playwright, test planning, automation | Sonnet | When testing needed |
| `uat-tester` | UAT in staging, permission testing, structured bug reports | Sonnet | UAT workflows |
| `api-tester` | API endpoint testing, validation, error handling | Sonnet | When API testing needed |
| `performance-benchmarker` | Load testing, response times, bottleneck identification | Sonnet | When perf testing needed |

## Which Agents Load per Role

Your role (selected during `dtf install` or `dtf configure`) determines which agents are available by default:

| Role | Agents |
|------|--------|
| **Frontend Dev** | `frontend-dev`, `architect`, `pr-reviewer`, `api-designer`, `ui-designer` |
| **Backend Dev** | `backend-dev`, `architect`, `pr-reviewer`, `api-designer`, `migration-planner` |
| **Fullstack Dev** | All 7 engineering agents |
| **Data Engineer** | `data-engineer`, `pipeline-builder`, `insights-reporter`, `architect` |
| **Data Analyst** | `data-analyst`, `insights-reporter` |
| **Infra / DevOps** | `infra-engineer`, `ci-cd-engineer`, `security-auditor` |
| **QA / Tester** | `qa-tester`, `api-tester`, `performance-benchmarker` |
| **UAT Stakeholder** | `uat-tester` |
| **Product Owner** | `po-analyst`, `requirements-analyst`, `sprint-prioritizer`, `architect` |
| **Sales** | `sales-enablement`, `data-analyst`, `insights-reporter` |
| **Marketing** | `marketing-ops`, `content-creator`, `social-strategist` |
| **Customer Ops** | `customer-ops`, `support-responder` |

Agents not in your role are still accessible — reference any agent explicitly.

## How Team Sizing Works

The architect analyzes the ticket and decides:

1. **Scope** — which services/layers are affected
2. **Complexity** — simple change vs multi-service feature
3. **Team size** — spawns only the agents needed

| Ticket complexity | Typical team |
|-------------------|-------------|
| Small (S) | Architect + 1 dev + reviewer |
| Medium (M) | Architect + backend + frontend + reviewer |
| Large (L) | Full set of relevant agents |

## Dream Team Personas

In `/my-dream-team` sessions, agents get persona names for readability:

| Persona | Agent | Origin |
|---------|-------|--------|
| Amara | architect | Nigeria |
| Kenji | backend-dev | Japan |
| Ingrid | frontend-dev | Sweden |
| Ravi | backend-dev (pool) | India |
| Elsa | frontend-dev (pool) | Germany |
| Mei | data-engineer | China |
| Diego | infra-engineer | Colombia |
| Maya | pr-reviewer | Israel |
| Suki | qa-tester | Japan |
| Lena | visual verifier | Germany |
| Tane | summary writer | New Zealand |

Pool agents (Ravi, Elsa) are second instances spawned when the architect identifies 2+ independent workstreams in the same discipline.

## Agent Definitions

Each agent is a markdown file in the [marketplace](https://github.com/johwer/marketplace) repo under `agents/<domain>/`:

```
agents/
├── engineering/     frontend-dev.md, backend-dev.md, architect.md, ...
├── data/            data-engineer.md, data-analyst.md, ...
├── design/          ui-designer.md, ux-researcher.md
├── infrastructure/  infra-engineer.md, ci-cd-engineer.md, security-auditor.md
├── marketing/       marketing-ops.md, sales-enablement.md, ...
├── operations/      customer-ops.md, support-responder.md
├── product/         po-analyst.md, requirements-analyst.md, sprint-prioritizer.md
└── testing/         qa-tester.md, uat-tester.md, api-tester.md, ...
```

Agents can be used standalone outside Dream Team: "Use the security-auditor subagent to scan this PR".

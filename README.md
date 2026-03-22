```
██████╗ ██████╗ ███████╗ █████╗ ███╗   ███╗    ████████╗███████╗ █████╗ ███╗   ███╗
██╔══██╗██╔══██╗██╔════╝██╔══██╗████╗ ████║    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
██║  ██║██████╔╝█████╗  ███████║██╔████╔██║       ██║   █████╗  ███████║██╔████╔██║
██║  ██║██╔══██╗██╔══╝  ██╔══██║██║╚██╔╝██║       ██║   ██╔══╝  ██╔══██║██║╚██╔╝██║
██████╔╝██║  ██║███████╗██║  ██║██║ ╚═╝ ██║       ██║   ███████╗██║  ██║██║ ╚═╝ ██║
╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝       ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝

                              F   L   O   W
                                              ╔══════════╗
                                              ║   BETA   ║
                                              ╚══════════╝
```

> **Beta** — Actively developed and used in production, but expect breaking changes between updates. Feedback and contributions welcome.

## What is DTF?

Dream Team Flow gives every role on your team an AI-powered workflow — not just developers. Pick your role, get tailored agents, skills, and workflow steps. One CLI to install, one command to customize.

**The flow is the product, not the agents.** Agents are interchangeable. What compounds over time is the orchestration, quality gates, and learning loops. Every session makes the next one better.

---

## Pick Your Role

Each role gets its own agents, skills, default workflow steps, and recommended plugins. Click your role for the full guide:

| Role | What you get | Guide |
|------|-------------|-------|
| **Developer (Frontend)** | 5 agents, React 19 conventions, performance checks, code insights, visual verification | **[Developer Guide](docs/roles/developer.md)** |
| **Developer (Backend)** | 5 agents, .NET conventions, EF Core performance, DTO analysis, migration planning | **[Developer Guide](docs/roles/developer.md)** |
| **Developer (Fullstack)** | 7 agents, all dev skills combined | **[Developer Guide](docs/roles/developer.md)** |
| **Infrastructure / DevOps** | 3 agents, Terraform conventions, AWS performance, `/infra-ticket` flow | **[Infra Guide](docs/roles/infra.md)** |
| **Data Engineer** | 4 agents, dbt conventions, pipeline building, data analysis | **[Data Guide](docs/roles/data.md)** |
| **Data Analyst** | 2 agents, SQL/notebook workflows, visualization, insights reporting | **[Data Guide](docs/roles/data.md)** |
| **QA / Tester** | 3 agents, Playwright, test planning, API testing, performance benchmarks | **[Tester Guide](docs/roles/tester.md)** |
| **UAT Stakeholder** | 1 agent, acceptance criteria, permission testing, Jira bug reporting | **[Tester Guide](docs/roles/tester.md)** |
| **Product Owner** | 4 agents, ticket refinement, sprint planning, impact analysis, requirements | **[Product Owner Guide](docs/roles/product-owner.md)** |
| **Sales** | 3 agents, proposals, ROI models, PowerPoint generation, competitive analysis | **[Marketing & Sales Guide](docs/roles/marketing-sales.md)** |
| **Marketing** | 3 agents, content strategy, SEO, email sequences, social media | **[Marketing & Sales Guide](docs/roles/marketing-sales.md)** |
| **Customer Operations** | 2 agents, customer onboarding, integration config, support investigation | **[Customer Ops Guide](docs/roles/customer-ops.md)** |

---

## Quick Start

### New User

```bash
# 1. Install Claude Code
npm install -g @anthropic-ai/claude-code

# 2. Install DTF (wizard asks: name, paths, terminal, role, workflow steps)
dtf install <REPO_URL> --company-config company-config.json

# 3. Done — start working
/create-stories PROJ-1234
```

### Existing User — Add Your Role

```bash
dtf configure        # Pick role, get defaults, customize steps
dtf steps list       # See your workflow
```

### Plugin Install (alternative)

```bash
/plugin marketplace add johwer/marketplace
/plugin install claude-toolkit@marketplace
```

See **[Installation](docs/installation.md)** for all methods, prerequisites, and team setup.

---

## Core Features

### Custom Workflow Steps

Every role gets default steps. Build your own — automated checks and reminders at 5 phases:

```
dtf steps list     # See your steps
dtf steps add      # Add automated check or reminder
dtf steps remove   # Remove a step
dtf steps reset    # Back to role defaults
```

Two types: ⚡ automated (runs a command) and 📋 reminder (checklist you confirm).
Five phases: `on-start`, `before-commit`, `before-push`, `before-pr`, `after-pr`.

### Self-Learning

6 learning paths feed improvements back automatically:

| Path | Source | Destination |
|------|--------|-------------|
| Session retros | Agents reflect after every ticket | Agent prompts, conventions |
| PR review mining | Patterns from merged PR feedback | Convention updates |
| Jira pushback | AI reviewer comment analysis | Ticket triage rules |
| Tool usage patterns | Behavioral analysis from logs | Skills, scripts, or memory |
| Research & reading | Articles, docs, best practices | Coding style docs |
| Cross-session analysis | Pattern detection across retros | Process improvements |

### Code Insights

After your first draft, say "check my changes":

- **Quick nudges** — scans only your changed files (React 19 aware, .NET patterns), max 5-7 suggestions with pros/cons
- **DTO & architecture insights** — deeper analysis with mermaid diagrams, ready for PR description

### Performance Skills

Built-in checklists with antipatterns:
- `frontend-performance` — Core Web Vitals, bundle analysis, React rendering
- `backend-performance` — EF Core queries, N+1 detection, caching, async/await
- `aws-performance` — CloudWatch, RDS tuning, cost optimization

### Memory Hygiene

Memory files cost tokens every prompt. Automatic health check at session start (0 token cost):

```bash
bash ~/.claude/scripts/memory-health.sh
```

### Secure by Default

Every PR gets a 7-category OWASP security scan. Schema changes require Mermaid diagrams and human approval. Quality hooks physically prevent agents from skipping steps.

Three-tier permission ladder — personal sandbox, shared standards, team-enforced lockdown.

---

## 29 Agents, 8 Domains

Your role loads 2-7 agents. Not all 29.

```
agents/
├── engineering/     (7)  frontend-dev, backend-dev, architect, pr-reviewer,
│                         api-designer, performance-analyst, migration-planner
├── data/            (4)  data-engineer, data-analyst, pipeline-builder, insights-reporter
├── design/          (2)  ui-designer, ux-researcher
├── infrastructure/  (3)  infra-engineer, ci-cd-engineer, security-auditor
├── marketing/       (4)  marketing-ops, sales-enablement, content-creator, social-strategist
├── operations/      (2)  customer-ops, support-responder
├── product/         (3)  po-analyst, requirements-analyst, sprint-prioritizer
└── testing/         (4)  qa-tester, uat-tester, api-tester, performance-benchmarker
```

See **[The Team](docs/the-team.md)** for full agent details.

---

## By the Numbers

<!-- STATS:START -->
| What | Count |
|------|-------|
| Agents | 29 (in 8 domains) |
| Skills | 74+ (conventions, performance, workflows, security, marketing) |
| Commands | 21 (orchestration, review, triage, infra, analytics) |
| Scripts | 33 (quality gates, terraform, memory, cost tracking) |
| Roles | 12 (dev, data, infra, QA, PO, sales, marketing, ops) |
| Token baseline | ~5,750 per prompt (0.6% of context) |
| Everything else | 0 tokens until used |
<!-- STATS:END -->

---

## Documentation

### Role Guides
| Guide | For |
|-------|-----|
| **[Developer](docs/roles/developer.md)** | Frontend, Backend, Fullstack — full Dream Team workflow |
| **[Infrastructure](docs/roles/infra.md)** | Terraform, AWS, CI/CD — `/infra-ticket` flow |
| **[Data](docs/roles/data.md)** | dbt, SQL, notebooks, pipelines, reporting |
| **[Tester](docs/roles/tester.md)** | QA/E2E automation + UAT stakeholder flows |
| **[Product Owner](docs/roles/product-owner.md)** | Ticket refinement, sprint planning, impact analysis |
| **[Marketing & Sales](docs/roles/marketing-sales.md)** | Content, SEO, presentations, proposals |
| **[Customer Ops](docs/roles/customer-ops.md)** | Integration config, support investigation |

### Architecture & Deep Dives
| Guide | Description |
|-------|-------------|
| **[Installation](docs/installation.md)** | Prerequisites, install methods, role selection |
| **[Built for Teams](docs/built-for-teams.md)** | Company config, `dtf configure`, `dtf steps` |
| **[The Team](docs/the-team.md)** | 29 agents, per-role loading, team sizing |
| **[Workflow Phases](docs/workflow-phases.md)** | Flowcharts for full, lite, and local modes |
| **[Parallel Everything](docs/parallel.md)** | Cross-ticket parallelism, Docker isolation |
| **[Worktree Port Setup](docs/worktree-port-setup.md)** | Vite, Docker port config for any project |
| **[Token Efficiency](docs/token-efficiency.md)** | Cost architecture, zero-token patterns |
| **[Self-Learning System](docs/retrospectives.md)** | Six learning channels, routing rules |
| **[Security Guide](SECURITY.md)** | Permission ladder, OWASP scanning, hooks |
| **[Instruction Delivery](docs/instruction-delivery.md)** | How CLAUDE.md, skills, commands, agents, hooks work together |
| **[Best-in-Class Comparison](docs/comparison.md)** | DTF vs Stripe Minions, Claude Docs, ECC |
| **[Setup Guide](SETUP-GUIDE.md)** | Full reference — company config, troubleshooting |

---

## Repository Architecture

Three repos, clear separation:

```
dream-team-flow/                    ← This repo: docs + dtf CLI
├── docs/
│   ├── roles/                      # Role-specific guides
│   ├── installation.md             # Install guide
│   ├── the-team.md                 # Agent roster
│   └── ...                         # Workflow, features, learning, etc.
├── security/                       # Security config templates (3 levels)
├── company-config.example.json     # Example company config with roles
└── SETUP-GUIDE.md                  # Full setup reference

marketplace/                        ← Plugin repo: commands + agents + scripts
├── agents/                         # 29 agents in 8 domain subdirectories
├── commands/                       # 21 slash commands
├── scripts/                        # 33 shell scripts
├── skills/                         # 74+ skills
└── docs/                           # Operational docs
```

---

## Contributing

- **Workflow improvements:** Run `dtf contribute` to export retro learnings as a PR
- **New agent types:** Add agent definitions to the marketplace repo
- **New roles:** Define in `company-config.json` roles section
- **Terminal support:** Add new terminals to `scripts/open-terminal.sh`

---

## License

MIT

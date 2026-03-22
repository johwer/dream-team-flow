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

## Pick Your Role. Build Your Flow.

Dream Team Flow gives every role on your team an AI-powered workflow tailored to how you actually work. Developers get multi-agent teams and code review. Infra gets Terraform automation. POs get ticket triage. Sales gets pitch decks. Everyone gets the best version of their workflow — not a one-size-fits-all.

Pick your role → get agents, skills, and workflow steps designed for you → customize with your own checks and reminders → every session makes the next one better.

**The flow is the product, not the agents.** Agents are interchangeable. What compounds over time is the orchestration, quality gates, and learning loops that adapt to your team.

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

### Build Your Own Workflow

Every role gets default steps — then you make it yours. Add automated checks that run shell commands, or reminders that show up as a checklist at the right moment.

```bash
dtf steps list     # See your steps grouped by phase
dtf steps add      # Add your own automated check or reminder
dtf steps remove   # Remove what you don't need
dtf steps reset    # Back to role defaults
```

| Phase | When it runs | Example |
|-------|-------------|---------|
| `on-start` | Beginning of session | 📋 Acceptance criteria listed |
| `before-commit` | Before `git commit` | ⚡ `terraform fmt -check` |
| `before-push` | Before `git push` | ⚡ `dotnet test` |
| `before-pr` | Before creating PR | 📋 Visual verification done |
| `after-pr` | After PR created | 📋 Stakeholders notified |

### Tailored to Every Role

Not just different agents — different workflows entirely:

| Role | What's different |
|------|-----------------|
| **Developer** | Multi-agent teams, code insights on your diff, performance checks, parallel backend+frontend |
| **Infra** | `/infra-ticket` with structured Terraform plan, GH Actions verification, WAF/monitoring/ECR conventions |
| **Data** | dbt build/test steps, SQL review, notebook workflows, pipeline building |
| **PO** | `/ticket-scout` batch triage, `/ticket-refine` quality gate — no code knowledge needed |
| **QA** | Test plan templates, Playwright E2E, API testing, permission matrix verification |
| **UAT** | Acceptance criteria checklists, structured Jira bug reports, role-based permission testing |
| **Sales** | PowerPoint generation, ROI models, customer data insights, competitive analysis |
| **Marketing** | 12 marketing skills (SEO, copywriting, email, social), brand guidelines, content calendars |
| **Customer Ops** | Integration config patterns, ITSM ticket investigation, customer onboarding |

### Self-Learning — Every Session Makes the Next One Better

6 learning paths feed improvements back automatically. The same mistake never happens twice:

| Path | What it captures | Where it goes |
|------|-----------------|---------------|
| Session retros | What agents got wrong, what conventions they discovered | Agent prompts, coding style docs |
| PR review mining | What reviewers keep flagging | Convention updates |
| Jira pushback | Ticket quality patterns | Triage rules |
| Tool usage | Context gaps, repeated lookups | Skills, scripts, memory |
| Research | Articles, best practices | Coding style docs |
| Cross-session | Systemic patterns across retros | Process improvements |

New team members inherit all accumulated knowledge on day one.

### Lean by Design — Cost Control Built In

| What | How | Saving |
|------|-----|--------|
| Formatting, linting, builds | Shell scripts (0 tokens) | 100% |
| Workflow steps (automated) | Shell commands, not LLM | 100% |
| Skills, agents | Loaded on-demand, not always | 0 until used |
| Memory hygiene | `memory-health.sh` at session start | Prevents bloat |
| Early triage | User decides GO/SKIP before agents run | 100% on skipped |
| Mode routing | Full / lite / local per ticket | Right-size each ticket |

Token baseline: **~5,750 per prompt** (0.6% of context). Everything else is 0 until invoked.

### Secure by Default

Every PR gets a 7-category OWASP security scan. Schema changes require Mermaid diagrams and human approval. Quality hooks physically prevent agents from skipping steps.

Three-tier permission ladder — personal sandbox, shared standards, team-enforced lockdown. See **[Security Guide](SECURITY.md)**.

See **[Features](docs/features.md)** for the complete list.

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

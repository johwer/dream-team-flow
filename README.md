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

> **Beta** — Actively developed and used in production, but expect breaking changes between updates.

## Pick Your Role. Build Your Flow.

Dream Team Flow gives every role on your team an AI-powered workflow tailored to how you actually work. Developers get multi-agent teams and code review. Infra gets Terraform automation. POs get ticket triage. Sales gets pitch decks. Everyone gets the best version of their workflow — not a one-size-fits-all.

Pick your role → get agents, skills, and workflow steps → customize with your own checks and reminders → every session makes the next one better.

| Role | What you get | Guide |
|------|-------------|-------|
| **Developer** (Frontend / Backend / Fullstack) | Multi-agent teams, code insights, performance checks, parallel implementation, 3-depth code review | **[Developer Guide](docs/roles/developer.md)** |
| **Infrastructure / DevOps** | `/infra-ticket` Terraform flow, structured plan output, GH Actions verification, security auditor | **[Infra Guide](docs/roles/infra.md)** |
| **Data Engineer / Analyst** | dbt pipelines, SQL analysis, notebook workflows, insights reporting | **[Data Guide](docs/roles/data.md)** |
| **QA / Tester / UAT** | Playwright E2E, API testing, permission matrix, structured Jira bug reports | **[Tester Guide](docs/roles/tester.md)** |
| **Product Owner** | `/ticket-scout` batch triage, `/ticket-refine` quality gate, impact analysis — no code needed | **[PO Guide](docs/roles/product-owner.md)** |
| **Sales / Marketing** | PowerPoint generation, ROI models, 12 marketing skills (SEO, copywriting, email), content calendars | **[Marketing & Sales Guide](docs/roles/marketing-sales.md)** |
| **Customer Operations** | Integration config, ITSM investigation, customer onboarding | **[Customer Ops Guide](docs/roles/customer-ops.md)** |

---

## Quick Start

```bash
# New user (wizard asks: name, paths, terminal, role, workflow steps)
dtf install <REPO_URL> --company-config company-config.json

# Existing user — add role
dtf configure

# Start working
/create-stories PROJ-1234
```

See **[Installation](docs/installation.md)** for all methods, prerequisites, and team setup.

---

## What Makes DTF Different

### Every Session Makes the Next One Better

6 learning paths capture what went wrong and feed it back — into agent prompts, coding style docs, and triage rules. New team members inherit everything on day one. See **[Self-Learning System](docs/retrospectives.md)**.

### [Build Your Own Workflow](docs/workflow-steps.md)

Every role gets default workflow steps. Customize with `dtf steps add` — automated checks (⚡ runs a command) and reminders (📋 you confirm) at 5 phases. See **[Workflow Steps Guide](docs/workflow-steps.md)** for setup, examples, and defaults per role.

### Cost-First Architecture

Token baseline **~5,750 per prompt** (0.6% of context). Formatting, linting, builds run as shell scripts (0 tokens). Skills and agents load on-demand. Memory hygiene at session start prevents bloat. See **[Token Efficiency](docs/token-efficiency.md)**.

### [Secure Setup](SECURITY.md)

DTF security is built into the configuration files, not into manual approval. `company-config.json` defines exactly which agents, skills, and roles each person gets. `settings.json` controls permissions, sandbox mode, network isolation, and allowed commands — applied across the team via `dtf install`. Three levels: personal sandbox → project allowlist → team-enforced lockdown. See **[Security Guide](SECURITY.md)**.

---

## Deep Dives

| Guide | Description |
|-------|-------------|
| **[Installation](docs/installation.md)** | Prerequisites, install methods, role selection |
| **[Workflow Steps](docs/workflow-steps.md)** | Build your own workflow — add, remove, customize steps per phase |
| **[Built for Teams](docs/built-for-teams.md)** | Company config, `dtf configure`, onboarding |
| **[The Team](docs/the-team.md)** | 29 agents in 8 domains, per-role loading, team sizing |
| **[Features](docs/features.md)** | Complete feature list by role + shared features |
| **[Workflow Phases](docs/workflow-phases.md)** | Flowcharts for full, lite, and local modes |
| **[Parallel Everything](docs/parallel.md)** | Cross-ticket parallelism, Docker isolation, port setup |
| **[Token Efficiency](docs/token-efficiency.md)** | Cost architecture, zero-token patterns |
| **[Self-Learning](docs/retrospectives.md)** | Six learning channels, routing rules |
| **[Security](SECURITY.md)** | Permission ladder, scanning, hooks |
| **[Instruction Delivery](docs/instruction-delivery.md)** | How CLAUDE.md, skills, agents, hooks work together |
| **[Comparison](docs/comparison.md)** | DTF vs Stripe Minions, Claude Docs, ECC |
| **[Setup Guide](SETUP-GUIDE.md)** | Full reference — company config, troubleshooting |

---

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

## Contributing

- **Workflow improvements:** `dtf contribute` exports retro learnings as a PR
- **New agent types:** Add to marketplace repo under `agents/<domain>/`
- **New roles:** Define in `company-config.json` roles section

## License

MIT

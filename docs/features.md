# Features

Dream Team Flow's features are organized by role. Each role guide covers the features relevant to that role in detail.

## By Role

| Role | Key Features | Guide |
|------|-------------|-------|
| **Developer** | Multi-agent teams, parallel backend+frontend, code insights, code review (3 depths), performance skills, quality gates, self-learning | [Developer Guide](roles/developer.md) |
| **Infrastructure** | `/infra-ticket`, structured Terraform plan, GH Actions verification, WAF/monitoring/ECR conventions, security auditor | [Infra Guide](roles/infra.md) |
| **Data** | dbt build/test steps, pipeline building, SQL analysis, notebook workflows, insights reporting | [Data Guide](roles/data.md) |
| **QA / Tester** | Playwright E2E, API testing, performance benchmarks, test plan templates | [Tester Guide](roles/tester.md) |
| **UAT Stakeholder** | Acceptance criteria checklists, permission matrix, structured Jira bug reports — no code needed | [Tester Guide](roles/tester.md) |
| **Product Owner** | `/ticket-scout` batch triage, `/ticket-refine` quality gate, impact analysis — no code needed | [PO Guide](roles/product-owner.md) |
| **Sales** | PowerPoint generation, ROI models, competitive analysis, customer data insights | [Marketing & Sales Guide](roles/marketing-sales.md) |
| **Marketing** | 12 marketing skills (SEO, copywriting, email, social), brand guidelines, content calendars | [Marketing & Sales Guide](roles/marketing-sales.md) |
| **Customer Ops** | Integration config patterns, ITSM investigation, customer onboarding | [Customer Ops Guide](roles/customer-ops.md) |

## Shared Across All Roles

### Custom Workflow Steps
Build your own workflow with ⚡ automated checks and 📋 reminders at 5 phases: `on-start`, `before-commit`, `before-push`, `before-pr`, `after-pr`. Manage with `dtf steps add/remove/reset`. Each role gets sensible defaults.

### Self-Learning
6 learning paths feed improvements back automatically:
- Session retros → agent prompts, conventions
- PR review mining → convention updates
- Jira pushback → triage rules
- Tool usage patterns → skills, scripts, memory
- Research & reading → coding style docs
- Cross-session analysis → process improvements

New team members inherit all accumulated knowledge on day one.

### One-Command Setup
`dtf install` → wizard (name, paths, terminal, role, steps) → symlinks everything → ready in minutes. `dtf configure` for existing users. `company-config.json` for team-wide defaults with role definitions.

### Cost Control
Token baseline ~5,750 per prompt (0.6% of context). Skills, agents, and plugins are 0 tokens until invoked. Formatting, linting, builds run as shell scripts (0 tokens). Memory hygiene at session start prevents bloat.

### Security
7-category OWASP scan on every PR. Schema changes require diagrams + human approval. Quality hooks can't be bypassed. Three-tier permission ladder.

### 29 Agents, 8 Domains
Your role loads 2-7 agents. Not all 29. See [The Team](the-team.md) for the full roster.

## Feature Details

For the complete technical details on specific features:

| Feature | Guide |
|---------|-------|
| Workflow phases (full/lite/local) | [Workflow Phases](workflow-phases.md) |
| Parallel tickets & Docker isolation | [Parallel Everything](parallel.md) |
| Code review (3 depths) | [Developer Guide](roles/developer.md#code-review) |
| PR review auto-assignment | [Usage Guide](usage.md) |
| Token efficiency & cost architecture | [Token Efficiency](token-efficiency.md) |
| Worktree port setup for any project | [Worktree Port Setup](worktree-port-setup.md) |
| Security ladder (3 levels) | [Security Guide](../SECURITY.md) |
| How instructions reach agents | [Instruction Delivery](instruction-delivery.md) |
| Comparison with Stripe/ECC | [Best-in-Class Comparison](comparison.md) |

# Infrastructure / DevOps Guide

DTF's infra workflow takes a Jira ticket through Terraform planning, security checks, and automated PR creation — with structured plan output and GH Actions verification.

## What You Get

- **3 agents:** `infra-engineer`, `ci-cd-engineer`, `security-auditor`
- **2 skills:** `infra-conventions` (Terraform/AWS/WAF/monitoring), `aws-performance` (cost/perf)
- **8 workflow steps** with automated terraform checks

### Your Default Workflow Steps

```
before-commit: ⚡ terraform fmt, ⚡ terraform validate, 📋 No secrets in code
before-push:   ⚡ terraform plan (structured summary)
before-pr:     📋 WAF rules, 📋 Monitoring/Slack, 📋 Tags, ⚡ GH Actions verified
```

---

## Daily Work — `/infra-ticket`

```bash
/infra-ticket PROJ-2345
```

What happens:
1. Fetches ticket from Jira
2. Creates branch `PROJ-2345-rds-monitoring`
3. Explores `infra/` — finds relevant modules
4. Runs `terraform init`
5. Pre-flight: provider versions, state drift check
6. Implements with AI assistant (understands your Terraform structure)
7. Runs all workflow steps automatically
8. Pushes + creates PR with terraform plan in body
9. Verifies GH Actions plan/apply workflows cover the changes

### Structured Plan Output

```
┌─────────────────────────────────────┐
│        Terraform Plan Summary        │
├─────────────────────────────────────┤
│  Resources to add:              +2  │
│  Resources to change:           ~1  │
│  Resources to destroy:          -0  │
└─────────────────────────────────────┘
```

Warns loudly on any destroy operations.

---

## What the Agents Know

**infra-engineer** covers your most common tasks:
- WAF (rate limiting, IP whitelisting, XSS exceptions, environment toggles)
- Monitoring (CloudWatch → SNS → Slack, RDS Enhanced Monitoring, OpenTelemetry)
- RDS security (SSL enforcement, KMS encryption, backups, parameter tuning)
- ECR (immutable tags, vulnerability scanning, lifecycle policies)
- Terraform (plan/apply workflows, provider pinning, CODEOWNERS)

**ci-cd-engineer** handles:
- GitHub Actions workflow design
- Deployment strategies (blue-green, canary)
- Build optimization and caching
- Environment protection rules

**security-auditor** (Opus model) checks:
- IAM least privilege
- Secrets management
- Dependency vulnerabilities
- Compliance (GDPR, audit trails)

---

## Recommended Plugins

| Plugin | What it does |
|--------|-------------|
| **TerraShark** (47 stars) | Failure-mode-first Terraform (600 tokens) |
| **terraform-best-practices** (29 stars) | 37 rules across 10 categories |
| **aws-cost-ops** (200 stars) | Cost optimization with MCP servers |
| **Trail of Bits security** (3.8k stars) | Diff-scoped security analysis |

---

## Worktree Port Setup

For running multiple worktrees with isolated ports: **[Worktree Port Setup Guide](../worktree-port-setup.md)**

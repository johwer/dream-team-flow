# Build Your Own Workflow

Every role in DTF gets default workflow steps. You can accept them, remove what you don't need, or add your own — automated checks that run commands and reminders that show up as a checklist.

## Quick Reference

```bash
dtf steps list       # See your steps grouped by phase
dtf steps add        # Add a new step (guided)
dtf steps remove     # Remove a step by number
dtf steps reset      # Reset to your role's defaults
dtf configure        # Change your role (also resets steps)
```

## How Steps Work

### Two Types

| Type | Icon | What happens |
|------|------|-------------|
| **automated** | ⚡ | Runs a shell command. Reports pass/fail. |
| **reminder** | 📋 | Shows as a checklist item. You confirm manually. |

### Five Phases

Steps trigger at the right moment in your workflow:

| Phase | When it runs | Example |
|-------|-------------|---------|
| `on-start` | Beginning of a work session | 📋 Acceptance criteria listed |
| `before-commit` | Before `git commit` | ⚡ `terraform fmt -check -recursive` |
| `before-push` | Before `git push` | ⚡ `dotnet test` |
| `before-pr` | Before creating a pull request | 📋 Visual verification done |
| `after-pr` | After PR is created | 📋 Stakeholders notified |

## Setting Up Your Steps

### During Install

When you run `dtf install`, the wizard shows your role's default steps and asks if you want to customize:

```
Default workflow steps for Developer (Frontend):
[before-commit] ESLint check (automated)
[before-pr] Visual verification (reminder)
[before-pr] Screenshot capture (reminder)
[before-pr] Accessibility check (reminder)

Customize these steps? (y/N):
```

Say **N** to accept defaults, or **Y** to remove/add steps.

### After Install

Change your steps anytime without reinstalling:

#### See your current steps

```bash
$ dtf steps list

  [before-commit]
    ⚡ ESLint check → npm run lint
  [before-pr]
    📋 Visual verification
    📋 Screenshot capture
    📋 Accessibility check

  ⚡ = automated  📋 = reminder
```

#### Add a step

```bash
$ dtf steps add

  Step name: Run Vitest
  Step type:
    1. reminder
    2. automated
  Choose [1]: 2
  Shell command to run: npm run test
  When to trigger:
    1. before-commit
    2. before-push
    3. before-pr
    4. after-pr
    5. on-start
  Choose [1]: 2
  ✓ Added: [before-push] Run Vitest (automated)
```

#### Remove a step

```bash
$ dtf steps remove

  Current steps:
    1. [before-commit] ESLint check (automated)
    2. [before-push] Run Vitest (automated)
    3. [before-pr] Visual verification (reminder)
  Step number to remove: 3
  ✓ Removed: Visual verification
```

#### Reset to defaults

```bash
$ dtf steps reset
  ✓ Reset to default steps for role: frontend-dev
```

## Default Steps per Role

Each role starts with sensible defaults. See your [role guide](roles/) for the full list.

| Role | Default steps |
|------|--------------|
| **Frontend Dev** | ⚡ ESLint, 📋 Code insights, 📋 Visual verification, 📋 Screenshot, 📋 A11y |
| **Backend Dev** | ⚡ CSharpier, ⚡ Unit tests, 📋 Code insights, 📋 Swagger |
| **Fullstack** | All frontend + backend steps |
| **Data Engineer** | ⚡ dbt build, ⚡ dbt test, 📋 SQL review |
| **Data Analyst** | 📋 Notebook cleared, 📋 SQL documented, 📋 Findings summarized |
| **Infra / DevOps** | ⚡ tf fmt, ⚡ tf validate, 📋 No secrets, ⚡ tf plan, 📋 WAF, 📋 Monitoring, 📋 Tags, ⚡ GH Actions |
| **QA / Tester** | 📋 Test plan, ⚡ All tests passing, 📋 Coverage reviewed |
| **UAT** | 📋 AC listed, 📋 All roles tested, 📋 Permissions verified, 📋 Bugs filed |
| **Product Owner** | 📋 Impact analysis, 📋 AC written, 📋 Stakeholders notified |
| **Sales** | 📋 Data sources, 📋 ROI calculated, 📋 Customer data checked |
| **Marketing** | 📋 SEO keywords, 📋 Multi-language, 📋 Brand voice |
| **Customer Ops** | 📋 Patterns checked, 📋 Mapping validated, 📋 Staging test |

## Examples — Custom Steps for Your Team

### Frontend: Run Playwright before PR
```bash
dtf steps add
  → "Playwright E2E"
  → automated
  → "npx playwright test --reporter=list"
  → before-pr
```

### Backend: Check for pending migrations
```bash
dtf steps add
  → "Pending migrations check"
  → automated
  → "dotnet ef migrations has-pending-model-changes"
  → before-push
```

### Infra: AWS cost estimate
```bash
dtf steps add
  → "Cost estimate"
  → automated
  → "infracost breakdown --path infra/"
  → before-pr
```

### PO: Remind to update sprint board
```bash
dtf steps add
  → "Update sprint board"
  → reminder
  → after-pr
```

### Any role: Custom code quality check
```bash
dtf steps add
  → "No console.log"
  → automated
  → "! grep -r 'console.log' --include='*.tsx' --include='*.ts' apps/web/src/"
  → before-commit
```

## Where Steps Are Stored

Steps live in your personal `~/.claude/dtf-config.json` (version 2):

```json
{
  "workflowSteps": [
    { "name": "ESLint check", "type": "automated", "command": "npm run lint", "when": "before-commit" },
    { "name": "Visual verification", "type": "reminder", "when": "before-pr" }
  ]
}
```

This file is never committed — it's personal to you. Team defaults come from `company-config.json`.

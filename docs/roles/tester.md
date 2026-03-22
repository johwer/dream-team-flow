# QA Tester & UAT Stakeholder Guide

DTF supports two testing roles — QA/E2E automation engineers and UAT stakeholders who test in staging without writing code.

## What You Get

| | QA / Tester | UAT Stakeholder |
|--|------------|-----------------|
| **Agents** | qa-tester, api-tester, performance-benchmarker | uat-tester |
| **Skills** | testing-workflows, playwright-cli | uat-workflows |

### Default Workflow Steps

**QA / Tester:**
```
on-start:   📋 Test plan documented
before-pr:  ⚡ All tests passing, 📋 Coverage report reviewed
```

**UAT Stakeholder:**
```
on-start:   📋 Acceptance criteria listed
before-pr:  📋 All user roles tested, 📋 Permission matrix verified
after-pr:   📋 Bug reports filed
```

---

## QA / Tester

**qa-tester** handles E2E testing with Playwright, test planning, regression testing, and bug reporting.
**api-tester** systematically tests endpoints — request validation, response schemas, error handling, auth flows.
**performance-benchmarker** — load testing, response times, database profiling, bottleneck identification.

### Test Approach
- Write test cases BEFORE implementation (TDD mindset)
- Cover happy path, edge cases, and error states
- E2E: test critical user flows, not implementation details
- Use `data-testid` for stable selectors

---

## UAT Stakeholder

**uat-tester** helps with staging environment testing — no code needed. Focuses on:
- Acceptance criteria validation
- Permission matrix testing (which roles see what)
- Structured bug reports via Jira
- Business rule verification

### Bug Report Format
```
Steps to reproduce → Expected → Actual → Affected roles → Severity → Screenshots
```

---

## Recommended Plugins

| Plugin | What it does |
|--------|-------------|
| **qaskills** (83 stars) | 20+ skills: Playwright, Jest, security, a11y, k6 |
| **agentic-qe** (264 stars) | AI-powered test generation, coverage analysis |
| **playwright-qa** | No-code: record browser → auto-generate Page Object Model tests |

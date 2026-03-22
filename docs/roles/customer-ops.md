# Customer Operations Guide

DTF helps customer operations teams with integration configuration, customer onboarding, and support ticket investigation.

## What You Get

- **2 agents:** `customer-ops`, `support-responder`
- **No code skills required** — focus on configuration and investigation

### Default Workflow Steps

```
on-start:    📋 Existing customer patterns checked
before-push: 📋 Mapping validated
before-pr:   📋 Acceptance test in staging
```

---

## Agents

**customer-ops** — Customer onboarding, integration configuration (Fuse/YAML mappings), ITSM support tickets.

Typical tasks:
- New customer setup — create configuration for a new customer
- Customer changes — update mappings, adjust dates, add new configurations
- Troubleshooting — fix broken integrations, investigate data mismatches

**support-responder** — Investigates customer-reported issues by tracing through logs, code, and configuration.

Investigation flow:
1. Read the support ticket
2. Identify affected service
3. Search for errors matching reported time/user
4. Determine root cause vs symptom
5. Recommend fix or workaround

---

## Workflow

```bash
# View a ticket
acli jira workitem view ITSM-12345

# Work on customer setup
git checkout -b ITSM-12345-customer-setup

# Customer-ops agent helps with configuration
# Support-responder agent traces issues through code and logs
```

---

## Ticket Prefixes

| Prefix | Type |
|--------|------|
| ITSM-xxxx | Support/operations tickets |
| MEDH-xxxx | Internal operations |

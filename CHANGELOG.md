# Changelog

## 2026-03-22 — Docs Restructure, Security Scanning, Official Skills

### Added
- **7 role-specific guides** — `docs/roles/developer.md`, `infra.md`, `data.md`, `tester.md`, `product-owner.md`, `marketing-sales.md`, `customer-ops.md`
- **Workflow Steps guide** — `docs/workflow-steps.md` with setup, examples, defaults per role
- **Official Anthropic skills** — PDF, DOCX, PPTX, XLSX, Brand Guidelines, Skill Creator
- **12 marketing skills** — content-strategy, copywriting, email-sequence, seo-audit, ai-seo, social-content, sales-enablement, competitor-alternatives, copy-editing, lead-magnets, launch-strategy, marketing-ideas
- **Claude SEO** — 12 sub-skills: schema, E-E-A-T, Core Web Vitals
- **Context Optimization skill** — token cost reduction and KV-cache patterns
- **`config-scan.sh` security scanning** — scans skills for injection patterns, checks company-config.json, audits permissions, allowlist for known-safe skills
- **Worktree Port Setup guide** — `docs/worktree-port-setup.md` for any project
- **Auto-sync stats** — `/sync-config` auto-updates counts in DTF README via markers

### Changed
- **README restructured as landing page** — "Pick Your Role. Build Your Flow.", 261→113 lines
- **`features.md` restructured as index** — by role, linking to role guides
- **`config-scan.sh`** — skill allowlist, deny-rule guidance for skip-permissions, fenced code block exclusion
- **`code-insights` skill** — React 19 aware, removed stale useEffect→use() nudge
- **`sync-config.sh`** — copies docs to DTF repo, auto-updates README stats

### Documented
- 7 role guides with agents, skills, steps, plugins per role
- Workflow steps guide with terminal output examples and 5 custom step recipes
- DTF README rewritten as landing page
- Secure Setup section with `config-scan.sh` reference

## 2026-03-21 — Role-Based Flows

### Added
- **12 roles** — Developer (Frontend/Backend/Fullstack), Data Engineer, Data Analyst, Infra/DevOps, QA/Tester, UAT Stakeholder, Product Owner, Sales, Marketing, Customer Operations
- **`dtf configure`** — set or change role and workflow steps for existing users
- **`dtf steps`** — manage personal workflow steps (list, add, remove, reset)
- **16 new agents** organized into 8 domain subdirectories
- **Performance skills** — `frontend-performance`, `backend-performance`, `aws-performance`
- **Code insights skill** — opt-in refactoring nudges + DTO analysis with mermaid diagrams
- **Role-specific skills** — po-workflows, testing-workflows, uat-workflows, data-analysis-workflows, presentation-workflows, content-workflows, infra-conventions
- **`/infra-ticket`** command — Terraform workflow from Jira ticket to PR
- **`terraform-plan-summary.sh`** — structured plan output with add/change/destroy box
- **`verify-infra-workflows.sh`** — GH Actions + CODEOWNERS verification
- **`memory-health.sh`** — memory size check (0 token cost)
- **`memory-hygiene` skill** — triggered at session start only
- **Company config with roles** — `company-config.json` role definitions
- **Security skills** — Trail of Bits (3.8k stars), levnikolaevich auditors, code-review-skill, claudekit

### Changed
- Agents reorganized from flat to 8 domain subdirectories
- `dtf.sh` refactored for portability (`declare -A` → `case` functions, `eval` → `printf -v`)
- `dtf-config.json` upgraded to version 2
- Memory hygiene moved from compact to session-start

## 2026-03 (earlier) — Foundation

- Initial DTF framework with `dtf install`, `update`, `doctor`, `contribute`
- 5 agents: architect, backend-dev, frontend-dev, data-engineer, pr-reviewer
- 8 skills: conventions, playwright, visual dev, mermaid, TDD, context modes, strategic compact
- 19 commands: Dream Team orchestration, PR review, ticket management
- 26 scripts: quality gates, analytics, workspace management
- Learning system: session retros → learnings → convention improvements

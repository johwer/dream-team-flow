# Claude Code Integrations

Reference for all Claude Code integrations — what's active, what needs setup, and prerequisites.

## Active Integrations

### Hooks (Notifications + Guardrails)

**Status:** Active
**Location:** `~/.claude/settings.json`

| Hook | Event | What it does |
|------|-------|-------------|
| Tool usage logging | PostToolUse | Logs all tool calls to file for analytics |
| Desktop notification | Notification | macOS notification when Claude needs attention (idle, permission prompt, auth) |

To add more hooks, edit `~/.claude/settings.json` or run `/hooks` interactively.

**Useful hooks to consider adding:**
- Migration guard: Block edits to `migrations/` without architect approval
- Auto-lint: Run ESLint/CSharpier after file edits
- Lock file guard: Warn on `package-lock.json` modifications

### Custom Subagents

**Status:** Active
**Location:** `~/.claude/agents/`

| Agent | Model | Tools | Purpose |
|-------|-------|-------|---------|
| `architect` | Opus | Read-only + Bash | Architecture analysis, conventions summaries, implementation plans |
| `backend-dev` | Sonnet | Full | .NET backend implementation |
| `frontend-dev` | Sonnet | Full | React/TypeScript frontend implementation |
| `pr-reviewer` | Opus | Read-only + Bash | Code review with categorized feedback |
| `data-engineer` | Sonnet | Full | Data mapping, migrations, pipelines |

**Usage:** Claude automatically delegates to these when relevant, or invoke explicitly:
```
Use the pr-reviewer subagent to review the changes in this PR
Use the architect subagent to analyze what files need changing for this feature
```

**Relationship to Dream Team:** These are general-purpose standalone agents. The Dream Team (`/my-dream-team`) uses its own detailed prompts with team coordination, context management, and phase-specific instructions on top of the same core expertise.

### GitHub Actions — Claude Code in CI

**Status:** Workflow created, needs API key setup
**Location:** `~/Documents/Repo/.github/workflows/claude.yml`

**What it does:**
- Responds to `@claude` mentions in PR comments and issues
- Can auto-review PRs on open (disabled by default, uncomment to enable)
- Uses Sonnet with 15-turn limit and 30-minute timeout

**Prerequisites (must be done by a repo admin):**

1. **Install the Claude GitHub App:**
   ```
   https://github.com/apps/claude
   ```
   Required permissions: Contents (R/W), Issues (R/W), Pull Requests (R/W)

2. **Add API key as repository secret:**
   - Go to Repo repo → Settings → Secrets and variables → Actions
   - Create secret: `ANTHROPIC_API_KEY` with your Claude API key
   - Get key from: https://console.anthropic.com

3. **Test it:**
   - Comment `@claude explain this PR` on any pull request
   - Claude responds in the PR thread with analysis

**Cost considerations:**
- Each `@claude` invocation consumes GitHub Actions minutes + API tokens
- Sonnet is cost-effective; switch to Opus in `claude_args` for deeper analysis
- 30-minute timeout prevents runaway jobs

### Review PR (Fast + Full modes)

**Status:** Active
**Location:** `~/.claude/commands/review-pr.md`

Two modes:
- `/review-pr <PR>` — Fast: GitHub API only
- `/review-pr <PR> --full` — Full: local worktree at `.claude/worktrees/` + builds + deeper review

See the command file for full workflow details.

---

## Requires External Setup

### Slack Integration

**Status:** Not configured — requires Claude Code on the Web
**Docs:** https://code.claude.com/docs/en/slack

**What it would do:**
- `@Claude` in Slack channels routes coding tasks to Claude Code sessions
- Context from Slack threads informs the work
- Progress updates posted back to the thread
- "Create PR" button directly from Slack

**Prerequisites:**

| Requirement | Details |
|-------------|---------|
| Claude Plan | Pro, Max, Teams, or Enterprise with Claude Code access |
| Claude Code on the Web | Must be enabled at claude.ai/code |
| GitHub Account | Connected to Claude Code on the Web with Repo repo authenticated |
| Slack App | Claude app installed from Slack Marketplace by workspace admin |
| Slack Auth | Individual Slack account linked to Claude account |

**Setup steps:**
1. Workspace admin installs Claude app: https://slack.com/marketplace/A08SF47R6P4
2. Each user connects their Claude account via App Home → Connect
3. Configure Claude Code on the Web at claude.ai/code with GitHub repo access
4. Choose routing mode: "Code only" or "Code + Chat"
5. Invite Claude to channels: `/invite @Claude`

**Limitations:**
- GitHub only (no GitLab, Bitbucket)
- One PR at a time per session
- Rate limits apply per individual user plan
- Only works in channels, not DMs

### Code Intelligence Plugin

**Status:** Not installed — check marketplace availability
**Docs:** https://code.claude.com/docs/en/discover-plugins#code-intelligence

**What it would do:**
- Precise "go to definition" and "find references" navigation
- Automatic error detection after edits
- Better type hierarchy understanding

**Setup:**
```
# Inside Claude Code, run:
/plugin
# Browse marketplace for TypeScript/C# code intelligence plugins
```

**Benefit for Repo:** TypeScript + C# stack means two language servers worth of navigation. Especially useful for:
- Verifying imports resolve during PR reviews
- Following type hierarchies in EF Core models
- Finding all references to a changed interface

### Plugin Packaging (Future)

**Status:** Planned for future — not yet implemented
**Docs:** https://code.claude.com/docs/en/plugins

**What it would do:**
- Package the entire Dream Team setup (commands, scripts, agents, hooks) as a single installable plugin
- Other Repo developers install with one command
- Versioned, updatable, namespaced

**Structure would be:**
```
dream-team-plugin/
  plugin.json           # Plugin metadata
  skills/               # Commands as skills
  agents/               # Subagent definitions
  hooks/                # Hook configurations
  scripts/              # Supporting scripts
```

**When to do this:** When more than 2-3 developers want the Dream Team setup. Current sync-config approach works well for single-user distribution.

---

## Best Practices Applied

From https://code.claude.com/docs/en/best-practices:

| Practice | How we use it |
|----------|--------------|
| **Give Claude verification** | Dream Team Phase 2 baseline + Phase 5 drift check |
| **Explore first, plan, then code** | Phase 1 (architect) → Phase 2 (implementation) |
| **Provide specific context** | CLAUDE.md, AGENTS.md files, conventions docs |
| **Use CLI tools** | `gh`, `acli jira`, `docker compose` |
| **Context management** | Agent notes in `.dream-team/notes/`, `/compact` |
| **Writer/Reviewer pattern** | Maya reviews after Kenji/Ingrid implement |
| **Subagent investigation** | Architect subagent explores before devs code |
| **Headless mode** | `claude -p` used in sync-config, CI workflows |
| **Hooks for guardrails** | Tool usage logging, desktop notifications |

---

## File Locations

| Integration | Files |
|-------------|-------|
| Hooks | `~/.claude/settings.json` |
| Subagents | `~/.claude/agents/*.md` |
| GitHub Actions | `~/Documents/Repo/.github/workflows/claude.yml` |
| Commands | `~/.claude/commands/*.md` |
| Scripts | `~/.claude/scripts/*.sh` |
| Skills | `~/.claude/skills/*/SKILL.md` |
| This doc | `~/.claude/docs/integrations.md` |

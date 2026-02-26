# Security Setup — Interactive Security Configuration

Walk users through adopting Claude Code security controls step by step. Presents a security ladder with 3 levels, audits current settings, and applies the chosen level.

## Input

Optional: a level number (1, 2, 3) or `audit` to just check current state.

```
/security-setup           # Interactive — show ladder, ask which level
/security-setup audit     # Just audit current settings, don't change anything
/security-setup 1         # Apply Level 1 directly
/security-setup 2         # Apply Level 2 directly
```

## Config Resolution

Read `~/.claude/dtf-config.json` if it exists. Use:
- `paths.monorepo` for project path
- `paths.workflowRepo` for the DTF repo (where security/ configs live)

## Workflow

### Step 1: Audit Current Security State

Read and analyze the current settings:

```bash
# Read all settings files
cat ~/.claude/settings.json 2>/dev/null
cat ~/.claude/settings.local.json 2>/dev/null
cat <monorepo>/.claude/settings.json 2>/dev/null
cat <monorepo>/.claude/settings.local.json 2>/dev/null
```

Also check:
- Is sandbox enabled? (`sandbox.enabled`)
- Are there any deny rules?
- Are there any allow rules?
- Is network restricted? (`sandbox.network.allowedDomains`)
- Is `--dangerously-skip-permissions` usage present? (`skipDangerousModePermissionPrompt`)

Present a **Security Scorecard**:

```
## Current Security Scorecard

| Control | Status | Details |
|---------|--------|---------|
| Sandbox | OFF | Not enabled |
| Network isolation | OFF | No domain restrictions |
| Secret protection | OFF | .env files readable |
| Destructive cmd block | OFF | rm -rf, force push allowed |
| curl/wget block | OFF | Arbitrary downloads allowed |
| Safe commands pre-approved | OFF | Every bash prompts |
| Docker socket | N/A | Not configured |
| Localhost binding | N/A | Not configured |

**Current Level: 0 (Default)**
```

### Step 2: Present the Security Ladder

```
## Security Ladder

### Level 0: Default (your current state)
No sandbox, no restrictions. Claude asks permission for everything.
- Pros: Maximum flexibility
- Cons: Every bash command requires approval, no protection against accidents

### Level 1: Personal Baseline (recommended for all developers)
Sandbox enabled with network restrictions. Secrets protected. Safe commands auto-approved.
- Sandbox: ON — bash runs in isolated environment
- Network: GitHub, npm, NuGet, localhost only
- Secrets: .env, .ssh, credentials blocked from Read
- Destructive: rm -rf /, force push blocked
- Docker: Excluded from sandbox (needs host access)
- Auto-approve: Sandboxed bash commands skip prompts
- File: ~/.claude/settings.local.json (personal, not committed)

### Level 2: Project Standard (for teams sharing a repo)
Pre-approved command allowlist based on real usage data. Shared via git.
- Everything from Level 1, plus:
- Allow: npm, npx, dotnet, git (read+write), gh, acli, docker, tmux, scripts
- Deny: curl, wget (prevents arbitrary downloads from bash)
- File: <monorepo>/.claude/settings.json (committed, shared with team)

### Level 3: Team Enforced (for Claude Teams/Enterprise admins)
Managed settings that users cannot override.
- Everything from Level 2, plus:
- No unsandboxed commands allowed
- Network domains locked to managed list
- Permission rules locked to managed only
- Hooks locked to managed only
- File: Applied via Claude for Teams admin console
```

### Step 3: User Chooses

If no level was specified in arguments, ask with AskUserQuestion:
- "Which security level do you want to apply?"
- Options: "Level 1 — Personal Baseline (Recommended)", "Level 2 — Project Standard", "Level 3 — Team Enforced (admin only)", "Just show the audit"

### Step 4: Apply the Chosen Level

**Level 1:**
1. Read the template from `<workflowRepo>/security/level-1-personal.json`
2. Read existing `~/.claude/settings.local.json` if it exists
3. Merge the security settings (preserve any existing fields)
4. Write to `~/.claude/settings.local.json`
5. Show the user what was added

**Level 2:**
1. Apply Level 1 first (if not already applied)
2. Read the template from `<workflowRepo>/security/level-2-project.json`
3. Read existing `<monorepo>/.claude/settings.json` if it exists
4. Merge the security settings (preserve existing fields like hooks)
5. Write to `<monorepo>/.claude/settings.json`
6. Show the user what was added
7. Remind them to `git add .claude/settings.json && git commit`

**Level 3:**
1. Apply Level 1 and Level 2 first
2. Show the Level 3 config from `<workflowRepo>/security/level-3-team.json`
3. Explain this must be applied via the Claude for Teams admin console
4. Provide step-by-step instructions:
   - Go to claude.ai → Admin Settings → Claude Code → Managed settings
   - Paste the JSON config
   - Save
5. Cannot apply automatically — just show the config and instructions

### Step 5: Verify

After applying, re-run the audit to show the new scorecard:

```
## Updated Security Scorecard

| Control | Status | Details |
|---------|--------|---------|
| Sandbox | ON | Enabled with network isolation |
| Network isolation | ON | 8 domains allowed |
| Secret protection | ON | .env, .ssh, credentials blocked |
| Destructive cmd block | ON | rm -rf /, force push denied |
| curl/wget block | ON | Blocked in project settings |
| Safe commands pre-approved | ON | 35 patterns allowed |
| Docker socket | ON | /var/run/docker.sock allowed |
| Localhost binding | ON | Dev servers can start |

**Current Level: 2 (Project Standard)**
```

### Step 6: Recommendations

Based on tool usage logs (if available at `~/.claude/logs/tool-usage.csv`):

1. **Analyze actual usage** — show which commands are used most frequently
2. **Suggest additions** — if the user runs commands not in the allow list, suggest adding them
3. **Flag risks** — if curl is used heavily for localhost API testing, suggest allowing `Bash(curl *localhost*)` specifically instead of blocking all curl
4. **Show stats**:
   ```
   ## Usage Analysis (from 5244 logged tool calls)

   Top bash commands:
   - git (312 calls) — all covered by allow rules
   - docker (84 calls) — excluded from sandbox
   - gh (87 calls) — covered by allow rules
   - curl (23 calls) — currently DENIED, but 100% are localhost
     → Suggestion: Allow "Bash(curl *localhost*)" for local API testing

   No external curl/wget detected — good security posture.
   ```

## Customization

If the user wants to customize:
- Show them the template file and explain each field
- Help them add/remove domains, commands, or deny rules
- Write the customized config

## Important Notes

- Level 1 is personal — never committed to git
- Level 2 is shared — committed to the repo's `.claude/settings.json`
- Level 3 requires admin access — cannot be applied from CLI
- `--dangerously-skip-permissions` is NOT disabled at any level (Dream Team worktrees need it)
- `git push --force-with-lease` is allowed (safe force push) — only `git push --force` is blocked
- curl to localhost could be allowed specifically if the team needs API testing
- The allow lists in Level 2 are based on real usage data from Dream Team sessions

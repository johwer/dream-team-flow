# Review PR — Code Review for Any Pull Request

Review a pull request with line-level comments on GitHub. Can approve, request changes, or leave advisory comments. Supports skipping files that aren't valuable to review (generated code, large diffs, lock files).

**This is a GitHub-only review** — no local checkout or worktree needed. Everything is read from the GitHub API, keeping memory usage minimal.

## Input

The user provides a PR number, URL, or branch name. Optionally with flags.

$ARGUMENTS

## Flags

- `--skip <pattern>` — Skip files matching the glob pattern (can be repeated). Examples: `--skip "*.generated.ts"`, `--skip "package-lock.json"`
- `--skip-large <N>` — Skip files with more than N lines changed (default: no limit)
- `--no-approve` — Never approve, only leave comments (advisory mode)
- `--focus <pattern>` — Only review files matching this pattern (ignore all others)

## Workflow

### Step 1: Fetch PR Details

```bash
cd ~/Documents/Repo
gh pr view <PR> --json number,title,body,author,baseRefName,headRefName,additions,deletions,url
```

Display a summary: title, author, base branch, total additions/deletions.

### Step 2: Get Changed Files with Stats

```bash
gh api repos/{owner}/{repo}/pulls/<PR>/files --jq '.[] | "\(.filename)\t+\(.additions)\t-\(.deletions)\t\(.status)"'
```

### Step 3: Apply File Filters

Build the list of files to review:

1. Start with all changed files
2. **Always skip** these by default (user can override with `--focus`):
   - `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`
   - `*.generated.ts`, `*.generated.tsx`
   - Files matching user's `--skip` patterns
3. If `--skip-large N` is set, skip files with more than N lines changed
4. If `--focus` is set, only include files matching that pattern

Show the user which files will be reviewed and which are skipped:

```
## Files to Review (7)
- src/components/ProfileCard.tsx (+45, -12)
- src/pages/employees/EmployeeCard.tsx (+20, -5)
- ...

## Skipped Files (3)
- package-lock.json (auto-skipped: lock file)
- src/store/rtk-apis/service-b/service-bApi.generated.ts (auto-skipped: generated file)
- ...
```

Ask the user to confirm, or let them adjust the skip list.

### Step 4: Read the Diff (Only Reviewed Files)

Read the diff **per file** to keep memory usage low — don't load the entire PR diff at once if it's large:

```bash
# Get patch content per file from the API
gh api repos/{owner}/{repo}/pulls/<PR>/files --jq '.[] | select(.filename == "<FILE>") | .patch'
```

For files with very large patches (1000+ lines), summarize rather than reading every line.

### Step 5: Check Existing Reviews

Don't duplicate feedback already given:

```bash
gh api repos/{owner}/{repo}/pulls/<PR>/reviews --jq '.[] | "Author: \(.user.login) | State: \(.state)"'
gh api repos/{owner}/{repo}/pulls/<PR>/comments --jq '.[] | "\(.path):\(.line) | \(.user.login): \(.body[0:80])"'
```

### Step 6: Review the Code

For each file's diff, check for:

**Code Quality:**
- Logic errors, off-by-one errors, null/undefined handling
- Missing error handling at system boundaries
- Unused imports, dead code
- Performance concerns (N+1 queries, unnecessary re-renders)

**Security (OWASP-aligned):**
- SQL injection, XSS, command injection
- Auth/authz issues (missing checks, wrong permission level)
- Sensitive data exposure (PII in logs, secrets in code)
- Path traversal

**Patterns & Conventions:**
- Naming conventions, component patterns
- i18n usage, API conventions
- React anti-patterns (missing deps, state misuse)
- EF Core patterns (async, proper includes)

For each issue, categorize as:
- **MUST FIX** — Bugs, security issues, broken patterns
- **SUGGESTION** — Style improvements, nice-to-haves
- **QUESTION** — Needs clarification from the author
- **PRAISE** — Good patterns worth highlighting

### Step 7: Present Review to User

Before posting to GitHub, show the full review:

```
## Review Summary: PR #1670 — "Add age field to profile card"

**Verdict:** Approve with suggestions

### MUST FIX (1)
1. `src/components/ProfileCard.tsx:42` — Missing null check on `employeeData.managers`

### SUGGESTION (2)
1. `src/components/ProfileCard.tsx:55` — Consider `useMemo` here
2. `src/utils/date.ts:30` — Could use existing helper `isAfterToday`

### QUESTION (1)
1. `src/pages/EmployeeCard.tsx:120` — Was the permission check intentionally removed?

### PRAISE (1)
1. `src/utils/date.ts:15` — Great use of `getDateWithoutTzConversion`
```

Ask the user:
- **"Post this review?"** — Options: "Yes, post as-is" / "Let me edit first" / "Post comments only (no verdict)" / "Cancel"

### Step 8: Post Review to GitHub

```bash
cat > /tmp/pr-review.json << 'REVIEW_EOF'
{
  "event": "<EVENT>",
  "body": "<SUMMARY>",
  "comments": [
    {
      "path": "<FILE_PATH>",
      "line": <LINE_NUMBER>,
      "body": "<COMMENT>"
    }
  ]
}
REVIEW_EOF

gh api -X POST repos/{owner}/{repo}/pulls/<PR>/reviews --input /tmp/pr-review.json
rm /tmp/pr-review.json
```

**Event mapping:**
- All SUGGESTION/PRAISE only → `"event": "APPROVE"`
- Any MUST FIX → `"event": "REQUEST_CHANGES"`
- `--no-approve` flag → `"event": "COMMENT"` (always)
- User chose "comments only" → `"event": "COMMENT"`

**Comment formatting:**
- Prefix each comment with its category in bold: `**MUST FIX**:`, `**SUGGESTION**:`, etc.
- Include code suggestions in fenced code blocks where applicable
- Keep comments concise — one issue per comment, actionable

### Step 9: Summary

Show the user:
- Link to the PR with review posted
- Count of comments by category

## Important Rules

- **Always show the review to the user before posting** — never auto-post
- **GitHub-only**: do NOT create worktrees, clone repos, or check out code locally. Read everything from the GitHub API.
- **Memory-efficient**: read diffs per file, not the entire PR diff at once for large PRs
- **Default skip list**: lock files and generated files are always skipped unless `--focus` overrides
- **Be specific**: every comment must have a file path and line number
- **Be balanced**: include PRAISE — reviews shouldn't be all negative
- **Don't nitpick**: skip trivial formatting if auto-formatters exist
- **Check existing reviews**: don't duplicate feedback already given
- **Line numbers**: use the line numbers from the diff/patch, which correspond to the new file version. The GitHub API `line` parameter refers to the line in the diff hunk.

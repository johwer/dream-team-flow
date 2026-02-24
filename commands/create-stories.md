# Create Stories — Full Lifecycle Orchestrator

You are orchestrating the full development lifecycle for one or more Jira tickets: workspace setup, team handoff, and cleanup.

## Input

The user provides one or more **ticket IDs** (e.g., `PROJ-1234` or `PROJ-1234 PROJ-1434`), space or comma separated.

$ARGUMENTS

## Trigger

This skill should be invoked when the user says things like:
- "Create stories for PROJ-1234 and PROJ-1434"
- "Set up these tickets: PROJ-1234, PROJ-1434"
- "Work on PROJ-1234 and PROJ-1434"
- "Launch these stories: ..."

## Workflow

For **each ticket ID**, run the following steps sequentially. Complete one ticket fully before starting the next.

### Step 1: Fetch Ticket from Jira

```bash
acli jira workitem view <TICKET_ID>
```

Extract: ticket ID, summary/title, full description, acceptance criteria, attachment names/URLs.

If ACLI fails, ask the user for the ticket details.

### Step 2: Handle Attachments

If the ticket has attachments:
1. Open each in Chrome for authenticated download:
   ```bash
   open -a "Google Chrome" "<ATTACHMENT_URL>"
   ```
2. Tell the user where Chrome will download the files (typically `~/Downloads/`)
3. Ask the user to confirm once downloads are complete
4. Read any downloaded images/PDFs to understand context

### Step 3: Confirm with User

Present the extracted ticket info and ask the user to confirm before proceeding.

### Step 4: Pull Latest Main & Create Git Worktree

**Always pull latest main before creating a worktree** to minimize merge conflicts later:

```bash
cd ~/Documents/Repo && git checkout main && git pull origin main
```

Then create the worktree:

```bash
cd ~/Documents/Repo && git worktree add ~/Documents/<TICKET_ID> -b <TICKET_ID>
```

If the branch already exists:
```bash
cd ~/Documents/Repo && git worktree add ~/Documents/<TICKET_ID> <TICKET_ID>
```

### Step 5: Install Dependencies

```bash
cd ~/Documents/<TICKET_ID>/apps/web && source ~/.nvm/nvm.sh && nvm use && npm i
```

### Step 6: Copy Environment File

```bash
cp ~/Documents/Repo/apps/web/.env.local ~/Documents/<TICKET_ID>/apps/web/.env.local
```

### Step 7: Launch Claude in a New Terminal Window

This uses the self-contained launcher script at `~/.claude/scripts/launch-workspace.sh` which handles everything: cd, unset CLAUDECODE, start tmux, launch Claude, send the dream team command, and attach.

**Check the user's terminal preference** in `~/.claude/CLAUDE.md` under "Workspace Preferences" for the configured terminal app. Then open a new window running the launcher script:

```bash
bash ~/.claude/scripts/open-terminal.sh "<TERMINAL_APP>" "bash ~/.claude/scripts/launch-workspace.sh '<TICKET_ID>' '/my-dream-team <TICKET_SUMMARY>: <CONCISE_DESCRIPTION>'"
```

Replace `<TERMINAL_APP>` with the configured app (Alacritty, Terminal, iTerm, Warp, Kitty, WezTerm, or Ghostty).

**Important:** Escape any special characters (quotes, parentheses) in the ticket text. Keep the description concise.

### Step 8: Repeat for Next Ticket

If there are more tickets, go back to Step 1 for the next ticket.

### Step 9: Summary

After all tickets are launched, present a summary:
- List all created workspaces with their ticket IDs and tmux session names
- Remind the user they can attach to any session: `tmux attach -t <TICKET_ID>`
- Remind the user to run `/workspace-cleanup <TICKET_ID>` when done with each story (or they can say "clean up PROJ-1234" and you will handle it)

## Pausing a Workspace (Close for the Day)

When the user says "pause PROJ-1234", "close PROJ-1234", "stop for today", or "kill the session":

```bash
bash ~/.claude/scripts/pause-workspace.sh <TICKET_ID>
```

This kills the tmux session and any Vite dev servers, but **preserves everything else**: worktree, code, `.dream-team/` notes/journals, git branches, and the draft PR. The user can resume the next day.

To pause **all running workspaces**:
```bash
for session in $(tmux list-sessions -F '#{session_name}' 2>/dev/null | grep '^PROJ-'); do
  bash ~/.claude/scripts/pause-workspace.sh "$session"
done
```

## Resuming a Workspace

When the user says "resume PROJ-1234" or "pick up PROJ-1234" or "continue PROJ-1234":

1. **Verify the worktree exists**:
   ```bash
   cd ~/Documents/Repo && git worktree list | grep <TICKET_ID>
   ```
   If not found, tell the user the worktree doesn't exist.

2. **Check the user's terminal preference** in `~/.claude/CLAUDE.md` under "Workspace Preferences".

3. **Launch with the resume script**:

   ```bash
   bash ~/.claude/scripts/open-terminal.sh "<TERMINAL_APP>" "bash ~/.claude/scripts/resume-workspace.sh '<TICKET_ID>'"
   ```

   Replace `<TERMINAL_APP>` with the configured app from Workspace Preferences.

4. **Confirm** to the user that the workspace is resuming. Remind them to `tmux attach -t <TICKET_ID>`.

## Monitoring & Cleanup

### Check workspace status

The user can ask "how are the workspaces doing?" or "check status". Check for status files and tmux sessions:

```bash
# Check for completed workspaces (status files written by Dream Teams)
ls ~/.claude/workspace-status/*.json 2>/dev/null && cat ~/.claude/workspace-status/*.json

# Check which tmux sessions are running
tmux list-sessions 2>/dev/null

# Check which worktrees exist
cd ~/Documents/Repo && git worktree list
```

Report a summary table showing each workspace's status (running / done-awaiting-merge / no session).

### When the user says "it's merged" or "clean up"

When the user indicates a story is done or merged (e.g., "PROJ-1234 is merged", "clean up PROJ-1234", "that story is finished"):

1. **Check the status file** (if exists):
   ```bash
   cat ~/.claude/workspace-status/<TICKET_ID>.json 2>/dev/null
   ```

2. **Run cleanup from this orchestrator session** (NOT from inside the worktree). Execute these steps directly — do NOT delegate to `/workspace-cleanup` since we're already in the orchestrator:

   ```bash
   # Safety: check PR status first
   cd ~/Documents/Repo && gh pr list --head <TICKET_ID> --state all --json number,state,mergedAt,title

   # Kill tmux session if running
   tmux kill-session -t <TICKET_ID> 2>/dev/null || true

   # Remove worktree (we're in Repo, not inside the worktree)
   cd ~/Documents/Repo && git worktree remove ~/Documents/<TICKET_ID> --force

   # Clean up leftover directory
   rm -rf ~/Documents/<TICKET_ID>

   # Delete branch (ask user first if PR is not merged)
   cd ~/Documents/Repo && git branch -D <TICKET_ID>

   # Prune worktree references
   cd ~/Documents/Repo && git worktree prune

   # Remove status file
   rm -f ~/.claude/workspace-status/<TICKET_ID>.json
   ```

3. **If PR is NOT merged**, warn the user before proceeding — code may only exist on the remote branch.

4. **Confirm** by showing the updated worktree list.

### Bulk cleanup

When the user says "clean up all done workspaces" or similar:
1. Read all status files from `~/.claude/workspace-status/`
2. For each with `"status": "done"`, check PR merge status
3. Clean up all that are merged (or user-confirmed)
4. Show summary of what was cleaned

## Important Rules

- Always confirm extracted ticket info with the user before creating worktrees
- The main repo is always at `~/Documents/Repo`
- Worktrees are always at `~/Documents/<TICKET_ID>`
- tmux sessions are always named `<TICKET_ID>`
- If anything fails, stop and report — do not continue blindly
- Never use curl/wget for Jira attachments — always use Chrome
- Process tickets sequentially, not in parallel
- When sending ticket text via tmux send-keys, keep it concise if the description is very long — include the essential description and acceptance criteria

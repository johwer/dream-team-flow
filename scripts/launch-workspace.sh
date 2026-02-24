#!/bin/bash
# Launch a Claude workspace in tmux — runs self-contained in a new terminal window
# Usage: launch-workspace.sh <TICKET_ID> <DREAM_TEAM_PROMPT>

TICKET_ID="$1"
DREAM_TEAM_PROMPT="$2"

if [ -z "$TICKET_ID" ]; then
  echo "Usage: launch-workspace.sh <TICKET_ID> <DREAM_TEAM_PROMPT>"
  exit 1
fi

cd ~/Documents/"$TICKET_ID" || exit 1
unset CLAUDECODE

# Start tmux detached, send claude, wait, send dream team command, then attach
tmux new-session -d -s "$TICKET_ID"
tmux send-keys -t "$TICKET_ID" "claude --dangerously-skip-permissions --chrome" Enter

echo "Waiting for Claude to start..."
sleep 8

if [ -n "$DREAM_TEAM_PROMPT" ]; then
  tmux send-keys -t "$TICKET_ID" "$DREAM_TEAM_PROMPT" Enter
fi

tmux attach -t "$TICKET_ID"

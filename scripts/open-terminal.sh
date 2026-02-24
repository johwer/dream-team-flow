#!/bin/bash
# Open a command in a new terminal window using the user's preferred terminal app.
# Usage: open-terminal.sh <TERMINAL_APP> <COMMAND>
#
# Supported terminals:
#   Alacritty, Terminal, iTerm, Warp, Kitty, WezTerm, Ghostty
#
# Example:
#   open-terminal.sh Alacritty "bash ~/.claude/scripts/launch-workspace.sh PROJ-1234"

TERMINAL_APP="$1"
shift
COMMAND="$*"

if [ -z "$TERMINAL_APP" ] || [ -z "$COMMAND" ]; then
  echo "Usage: open-terminal.sh <TERMINAL_APP> <COMMAND>"
  echo "Supported: Alacritty, Terminal, iTerm, Warp, Kitty, WezTerm, Ghostty"
  exit 1
fi

case "$TERMINAL_APP" in
  Alacritty)
    alacritty -e bash -c "$COMMAND" &
    ;;
  Terminal)
    osascript -e "tell application \"Terminal\"
    activate
    do script \"$COMMAND\"
end tell"
    ;;
  iTerm)
    osascript -e "tell application \"iTerm\"
    activate
    set newWindow to (create window with default profile)
    tell current session of newWindow
        write text \"$COMMAND\"
    end tell
end tell"
    ;;
  Warp)
    osascript -e "tell application \"Warp\"
    activate
    delay 0.5
end tell
tell application \"System Events\"
    tell process \"Warp\"
        keystroke \"t\" using {command down}
        delay 0.3
        keystroke \"$COMMAND\"
        key code 36
    end tell
end tell"
    ;;
  Kitty)
    kitty --detach bash -c "$COMMAND"
    ;;
  WezTerm)
    wezterm start -- bash -c "$COMMAND" &
    ;;
  Ghostty)
    ghostty -e bash -c "$COMMAND" &
    ;;
  *)
    echo "Unsupported terminal: $TERMINAL_APP"
    echo "Supported: Alacritty, Terminal, iTerm, Warp, Kitty, WezTerm, Ghostty"
    exit 1
    ;;
esac

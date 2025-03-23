#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# resize/reposition the focused window
osascript -e "
tell application \"System Events\"
  set _app to name of first application process whose frontmost is true
  tell process _app
    set _window to front window
    set {x, y} to position of _window
    set {width, height} to size of _window
    set position of _window to {x - ($1 / 2), y - ($2 / 2)}
    set size of _window to {width + $1, height + $2}
    activate
  end tell
end tell
" && aerospace flatten-workspace-tree
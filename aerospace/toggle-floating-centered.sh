#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# Calculate screen dimensions
screen_dimensions=$(osascript -e 'tell application "Finder" to get bounds of window of desktop')
IFS=', ' read -r -a dims <<< "$screen_dimensions"
screen_width=$((${dims[2]} - ${dims[0]}))
screen_height=$((${dims[3]} - ${dims[1]}))

# Calculate new window dimensions (80% of screen)
new_width=$(echo "$screen_width * 0.8" | bc -l | xargs printf "%.0f")
new_height=$(echo "$screen_height * 0.8" | bc -l | xargs printf "%.0f")

# Calculate centered position
new_x=$(echo "($screen_width - $new_width) / 2" | bc -l | xargs printf "%.0f")
new_y=$(echo "($screen_height - $new_height) / 2" | bc -l | xargs printf "%.0f")

# Resize and center the focused window
aerospace layout floating && osascript -e "
tell application \"System Events\"
  set _app to name of first application process whose frontmost is true
  tell process _app
    set _window to front window
    set position of _window to {$new_x, $new_y}
    set size of _window to {$new_width, $new_height}
    activate
  end tell
end tell" && aerospace flatten-workspace-tree || aerospace layout tiling
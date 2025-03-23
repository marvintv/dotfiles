#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# Get the x/y offsets from parameters (defaulting to 0 if not provided)
x_offset=${1:-0}
y_offset=${2:-0}

# Get screen dimensions directly
screen_dimensions=$(osascript -e 'tell application "Finder" to get bounds of window of desktop')
IFS=', ' read -r -a dims <<< "$screen_dimensions"
screen_width=$((${dims[2]} - ${dims[0]}))
screen_height=$((${dims[3]} - ${dims[1]}))

# Minimum window position
MIN_X=7
MIN_Y=45

# Make sure we're in floating mode first 
aerospace layout floating &>/dev/null || true

# Get current position and calculate new position
osascript -e "
tell application \"System Events\"
  set _app to name of first application process whose frontmost is true
  tell process _app
    set _window to front window
    
    # Get current position and size
    set {current_x, current_y} to position of _window
    set {win_width, win_height} to size of _window
    
    # Calculate new position with boundaries
    set new_x to current_x + ($x_offset)
    set new_y to current_y + ($y_offset)
    
    # Ensure window doesn't go off-screen
    if new_x < $MIN_X then
      set new_x to $MIN_X
    end if
    if new_y < $MIN_Y then
      set new_y to $MIN_Y
    end if
    if (new_x + win_width) > $screen_width then
      set new_x to $screen_width - win_width
    end if
    if (new_y + win_height) > $screen_height then
      set new_y to $screen_height - win_height
    end if
    
    # Set new position
    set position of _window to {new_x, new_y}
    activate
  end tell
end tell"

# Update aerospace
aerospace flatten-workspace-tree &>/dev/null || true
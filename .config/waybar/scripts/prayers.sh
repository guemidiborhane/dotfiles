#!/bin/sh

prayer_icon="󱠧"
# How many minutes before/after a prayer to show the time
display_threshold=${1:-60}

time_to_minutes() {
  echo "$1" | awk -F: '{print $1 * 60 + $2}'
}

get_prayer_info() {
  current_mins=$(time_to_minutes "$(date +%H:%M)")

  pt prayers | grep -iE '(fajr|sunrise|dhuhr|asr|maghrib|isha)' | awk \
    -v current_mins="$current_mins" \
    -v threshold="$display_threshold" \
    '
    function minutes_to_hm(total_mins,   h, m) {
      if (total_mins < 0) {
        total_mins = -total_mins;
      }
      h = int(total_mins / 60);
      m = total_mins % 60;
      return sprintf("%02d:%02d", h, m);
    }

    BEGIN {
      next_prayer_diff = 99999
      prev_prayer_diff = -99999
      next_prayer_name = ""
    }
    
    # 1. Process and buffer all prayer lines
    {
      name = $1
      time = substr($3, 1, 5)
      
      # Buffer name and formatted line
      names[NR] = name
      lines[NR] = sprintf("%-10s<b>%s</b>", name, time)

      if (NR == 1) { first_prayer_name = name }

      # Calculate diffs
      split(time, hm, ":")
      prayer_mins = hm[1] * 60 + hm[2]
      diff = prayer_mins - current_mins
      
      # Find prev diff
      diff_prev = diff
      if (diff_prev > 720) { diff_prev -= 1440 }
      if (diff_prev < 0 && diff_prev > prev_prayer_diff) {
        prev_prayer_diff = diff_prev
      }
      
      # Find next diff
      diff_next = diff
      if (diff_next < -720) { diff_next += 1440 }
      if (diff_next >= 0 && diff_next < next_prayer_diff) {
        next_prayer_diff = diff_next
        next_prayer_name = name # Found the next prayer
      }
    }
    
    # 2. In the END block, assemble both outputs
    END {
      # --- Part 1: Calculate Status String ---
      status_string = ""
      
      if (next_prayer_diff <= threshold) {
        # Time BEFORE prayer is "-"
        status_string = "-" minutes_to_hm(next_prayer_diff)
      } else if ((-prev_prayer_diff) <= threshold) {
        # Time AFTER prayer is "+"
        status_string = "+" minutes_to_hm(prev_prayer_diff)
      }
      
      # Print the status string as the first line
      print status_string
      
      # --- Part 2: Calculate Tooltip String ---
      
      # Handle wrap-around for highlight (if after Isha)
      if (next_prayer_name == "") {
        next_prayer_name = first_prayer_name
      }
      
      tooltip = ""
      for (i = 1; i <= NR; i++) {
        line = lines[i]
        if (names[i] == next_prayer_name) {
          # Add highlight
          line = "<b><span color='\''#f1fa8c'\''>" line "</span></b>"
        }
        
        # Append line and the \n separator
        tooltip = tooltip line (i == NR ? "" : "\\n")
      }
      
      # Print the tooltip string as the second line
      print tooltip
    }
  '
}

while true; do
  # Run the function, get its two-line output
  output=$(get_prayer_info)

  status=$(echo "$output" | sed -n '1p')
  tooltip=$(echo "$output" | sed -n '2p')

  text="$prayer_icon"

  if [ -n "$status" ]; then
    text="$text $status"
  fi

  printf '{"text": "%s", "tooltip": "%s"}\n' "$text" "$tooltip"

  sleep $((60 - $(date +%S)))
done

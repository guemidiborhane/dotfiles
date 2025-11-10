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
    function minutes_to_hm(total_mins,   h, m, sign) {
      sign = (total_mins < 0) ? "+" : "-"
      total_mins = (total_mins < 0) ? -total_mins : total_mins
      h = int(total_mins / 60)
      m = total_mins % 60
      return sprintf("%s%02d:%02d", sign, h, m)
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

      if (NR == 1) { first_prayer_name = name }

      # Calculate diffs
      split(time, hm, ":")
      prayer_mins = hm[1] * 60 + hm[2]
      diff = prayer_mins - current_mins

      diff_prev = diff
      if (diff_prev > 720) { diff_prev -= 1440 }

      if (diff_prev < 0) {
        if (diff_prev > prev_prayer_diff) {
          prev_prayer_diff = diff_prev
          prev_prayer_name = name
        }
      }

      diff_next = diff
      if (diff_next < -720) { diff_next += 1440 }

      if (diff_next >= 0) {
        if (diff_next < next_prayer_diff) {
          next_prayer_diff = diff_next
          next_prayer_name = name
        }
      }

      # Buffer data: name, time, raw diff
      names[NR] = name
      times[NR] = time
    }

    # 2. In the END block, assemble both outputs
    END {
      # Handle wrap-around logic
      if (next_prayer_name == "") {
        next_prayer_name = first_prayer_name

        # Calculate next_prayer_diff for wrapped Fajr
        for (i = 1; i <= NR; i++) {
          if (names[i] == next_prayer_name) {
            split(times[i], hm, ":")
            prayer_mins = hm[1] * 60 + hm[2]
            next_prayer_diff = prayer_mins - current_mins + 1440
            break
          }
        }
      }

      if (prev_prayer_name == "") {
        # Find the last prayer name (Isha)
        for (i = 1; i <= NR; i++) {
          prev_prayer_name = names[i]
        }
        # Recalculate diff for the last prayer, relative to yesterday
        split(times[NR], hm, ":")
        prayer_mins_last = hm[1] * 60 + hm[2]
        prev_prayer_diff = prayer_mins_last - current_mins - 1440
      }

      # --- Part 1: Calculate Status String ---
      status_string = ""

      if (next_prayer_diff <= threshold) {
        # The next prayer is in the future, so the diff is displayed as negative (-)
        status_string = minutes_to_hm(next_prayer_diff)
      } 
      else if ((-prev_prayer_diff) <= threshold) {
        # The previous prayer is in the past, so the diff is displayed as positive (+)
        status_string = minutes_to_hm(prev_prayer_diff)
      }

      print status_string

      # --- Part 2: Calculate Tooltip String ---

      tooltip = ""
      for (i = 1; i <= NR; i++) {
        name = names[i]
        time = times[i]

        diff_str = ""

        if (name == next_prayer_name) {
          diff_str = "  (" minutes_to_hm(next_prayer_diff) ")"
        } else if (name == prev_prayer_name) {
          diff_str = "  (" minutes_to_hm(prev_prayer_diff) ")"
        }

        line = sprintf("%-10s<b>%s</b>%s", name, time, diff_str)

        if (name == next_prayer_name) {
          line = "<b><span color='\''#f1fa8c'\''>" line "</span></b>"
        }

        tooltip = tooltip line (i == NR ? "" : "\\n")
      }

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

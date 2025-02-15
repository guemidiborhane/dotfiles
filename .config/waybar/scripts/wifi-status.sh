#!/bin/sh

if ! command -v nmcli &>/dev/null; then
  echo "{\"text\": \"󰤮\", \"tooltip\": \"nmcli utility is missing\"}"
  exit 1
fi

wifi_status=$(nmcli radio wifi)

if [ "$wifi_status" = "disabled" ]; then
  echo "{\"text\": \"󰤮 \", \"tooltip\": \"Wi-Fi Disabled\"}"
  exit 0
fi

wifi_info=$(nmcli -t -f active,ssid,signal,security dev wifi | grep "^yes")

if [ -z "$wifi_info" ]; then
  essid="No Connection"
  signal=0
  tooltip="No Connection"
else
  ip_address="127.0.0.1"
  security=$(echo "$wifi_info" | awk -F: '{print $4}')
  chan="N/A"
  signal=$(echo "$wifi_info" | awk -F: '{print $3}')
  active_device=$(nmcli -t -f DEVICE,STATE device status |
    grep -w "connected" |
    grep -v -E "^(dummy|lo:|docker|br-)" |
    awk -F: '{print $1}')

  if [ -n "$active_device" ]; then
    output=$(nmcli -e no -g ip4.address,ip4.gateway,general.hwaddr device show "$active_device")

    ip_address=$(echo "$output" | sed -n '1p')
    line=$(nmcli -e no -t -f active,bssid,chan,freq device wifi | grep "^yes")

    chan=$(echo "$line" | awk -F':' '{print $8}')
    freq=$(echo "$line" | awk -F':' '{print $9}')
    chan="$chan ($freq)"
    essid=$(echo "$wifi_info" | awk -F: '{print $2}')

    tooltip="${essid} (${ip_address})"
    tooltip+="\nSecurity:\t${security}"
    tooltip+="\nChannel:\t${chan}"
    tooltip+="\nStrength:\t${signal} / 100"
  fi
fi

if [ "$signal" -ge 80 ]; then
  icon="󰤨" # Strong signal
elif [ "$signal" -ge 60 ]; then
  icon="󰤥" # Good signal
elif [ "$signal" -ge 40 ]; then
  icon="󰤢" # Weak signal
elif [ "$signal" -ge 20 ]; then
  icon="󰤟" # Very weak signal
else
  icon="󰤭" # No signal
fi

echo "{\"text\": \"${icon}\", \"tooltip\": \"${tooltip}\"}"

#!/usr/bin/env bash
# pagespeed — measure website response time and TLS certificate validity.
set -euo pipefail
export LC_ALL=C

usage() {
	cat <<'EOF'
Usage: pagespeed <url> [--json]

Measure website response time and TLS certificate validity

Options:
  --json        Output results in JSON format
  -h, --help    Show this help message

Examples:
  pagespeed https://example.com
  pagespeed https://example.com --json
EOF
}

# ── Colors (disabled when not a terminal or when NO_COLOR is set) ────────────
if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
	RED=$'\e[31m' GREEN=$'\e[32m' YELLOW=$'\e[33m' BLUE=$'\e[34m'
	MAGENTA=$'\e[35m' BOLD=$'\e[1m' RESET=$'\e[0m'
else
	RED='' GREEN='' YELLOW='' BLUE='' MAGENTA='' BOLD='' RESET=''
fi
if [[ -t 2 && -z "${NO_COLOR:-}" ]]; then
	ERR_RED=$'\e[31m' ERR_RESET=$'\e[0m'
else
	ERR_RED='' ERR_RESET=''
fi

err() { printf '%sError: %s%s\n' "$ERR_RED" "$1" "$ERR_RESET" >&2; }

json_escape() {
	local s=${1//\\/\\\\}
	printf '%s' "${s//\"/\\\"}"
}

# ── Arguments ────────────────────────────────────────────────────────────────
json_output=false
target_url=""

for arg in "$@"; do
	case "$arg" in
	--json) json_output=true ;;
	-h | --help)
		usage
		exit 0
		;;
	-*)
		err "Unknown flag: $arg"
		echo "Usage: pagespeed <url> [--json]" >&2
		exit 1
		;;
	*) target_url=$arg ;;
	esac
done

if [[ -z "$target_url" ]]; then
	err "No URL provided"
	echo "Usage: pagespeed <url> [--json]" >&2
	echo "Run 'pagespeed --help' for more information" >&2
	exit 1
fi

if [[ ! "$target_url" =~ ^https?:// ]]; then
	err "Invalid URL format. Must start with http:// or https://"
	exit 1
fi

# Host and port for the certificate check
rest=${target_url#*://}
authority=${rest%%[/?#]*}
authority=${authority##*@}
host_name=${authority%%:*}
port=443
[[ "$authority" == *:* ]] && port=${authority##*:}

if [[ "$json_output" == false ]]; then
	printf 'Checking %s...\r' "$target_url" >&2
fi

# ── Request (follows up to 10 redirects) ─────────────────────────────────────
curl_status=0
curl_output=$(
	curl -s -L --max-redirs 10 -o /dev/null \
		--connect-timeout 10 --max-time 30 \
		-w '%{response_code}\n%{time_namelookup}\n%{time_connect}\n%{time_pretransfer}\n%{time_starttransfer}\n%{time_total}\n%{url_effective}\n' \
		"$target_url" 2>/dev/null
) || curl_status=$?

# ── TLS certificate ──────────────────────────────────────────────────────────
cert_days=""
if [[ "$target_url" == https://* ]]; then
	cert_date=$(
		timeout 10 openssl s_client -servername "$host_name" -connect "$host_name:$port" </dev/null 2>/dev/null |
			openssl x509 -noout -enddate 2>/dev/null |
			cut -d= -f2
	) || true
	if [[ -n "$cert_date" ]] && cert_epoch=$(date -d "$cert_date" +%s 2>/dev/null); then
		diff=$((cert_epoch - $(date +%s)))
		if ((diff < 0)); then
			cert_days=$((-((-diff + 86399) / 86400))) # floor for negative values
		else
			cert_days=$((diff / 86400))
		fi
	fi
fi

if [[ "$json_output" == false ]]; then
	printf '\033[2K\r' >&2
fi

if ((curl_status != 0)); then
	if [[ "$json_output" == true ]]; then
		printf '{"error": "Failed to connect to %s", "details": "Possible reasons: invalid URL, network issue, or timeout"}\n' \
			"$(json_escape "$target_url")" >&2
	else
		printf '%sFailed to connect to %s%s\n' "$ERR_RED" "$target_url" "$ERR_RESET" >&2
		echo "Possible reasons: invalid URL, network issue, or timeout" >&2
	fi
	exit 1
fi

# ── Parse and compute ────────────────────────────────────────────────────────
mapfile -t f <<<"$curl_output"
response_code=$((10#${f[0]}))
url_effective=${f[6]}

read -r ms_namelookup ms_connect ms_tls ms_server ms_transfer ms_total perf_text < <(
	awk -v dns="${f[1]}" -v con="${f[2]}" -v pre="${f[3]}" -v st="${f[4]}" -v tot="${f[5]}" 'BEGIN {
    t = tot * 1000
    perf = "Excellent"
    if (t > 1000) perf = "Slow"; else if (t > 500) perf = "Fair"; else if (t > 200) perf = "Good"
    printf "%.2f %.2f %.2f %.2f %.2f %.2f %s\n",
      dns * 1000, con * 1000, (pre - con) * 1000, (st - pre) * 1000, (tot - st) * 1000, t, perf
  }'
)

# ── Output ───────────────────────────────────────────────────────────────────
if [[ "$json_output" == true ]]; then
	printf '{\n'
	printf '  "url": "%s",\n' "$(json_escape "$url_effective")"
	printf '  "response_code": %s,\n' "$response_code"
	if [[ -n "$cert_days" ]]; then
		printf '  "certificate_days_remaining": %s,\n' "$cert_days"
	fi
	printf '  "timings": {\n'
	printf '    "dns_lookup_ms": %s,\n' "$ms_namelookup"
	printf '    "tcp_connection_ms": %s,\n' "$ms_connect"
	printf '    "tls_handshake_ms": %s,\n' "$ms_tls"
	printf '    "server_processing_ms": %s,\n' "$ms_server"
	printf '    "content_transfer_ms": %s,\n' "$ms_transfer"
	printf '    "total_ms": %s\n' "$ms_total"
	printf '  }\n'
	printf '}\n'
	exit 0
fi

if ((response_code >= 200 && response_code < 300)); then
	status_color=$GREEN
elif ((response_code >= 300 && response_code < 400)); then
	status_color=$YELLOW
else
	status_color=$RED
fi

section() {
	printf '\n%s%s%s%s\n' "$BOLD" "$YELLOW" "$1" "$RESET"
	printf '%s────────────────────────────────────────────────────────────%s\n' "$YELLOW" "$RESET"
}

bar_row() {
	local label=$1 ms=$2 n bar
	n=$(awk -v v="$ms" -v t="$ms_total" 'BEGIN { n = (t > 0) ? int(v / t * 30) : 0; if (n < 1) n = 1; print n }')
	printf -v bar '%*s' "$n" ''
	printf '%-25s %s%8s ms%s  %s%s%s\n' "$label" "$MAGENTA" "$ms" "$RESET" "$BLUE" "${bar// /█}" "$RESET"
}

printf '\n'
printf '%s%-12s%s %s%s%s\n' "$BOLD" "URL:" "$RESET" "$BLUE" "$url_effective" "$RESET"
printf '%s%-12s%s %s%s%s\n' "$BOLD" "Status:" "$RESET" "$status_color" "$response_code" "$RESET"
printf '%s%-12s%s %s (%s ms)\n' "$BOLD" "Speed:" "$RESET" "$perf_text" "$ms_total"

if [[ -n "$cert_days" ]]; then
	section "TLS Certificate"
	if ((cert_days < 0)); then
		cert_color=$RED cert_status="EXPIRED"
	elif ((cert_days < 7)); then
		cert_color=$RED cert_status="CRITICAL - Expires in $cert_days days"
	elif ((cert_days < 30)); then
		cert_color=$YELLOW cert_status="Expiring Soon"
	else
		cert_color=$GREEN cert_status="Valid"
	fi
	printf '%-25s %s%s (%s)%s\n' "Days Remaining:" "$cert_color" "$cert_days" "$cert_status" "$RESET"
fi

section "Timing Breakdown"
bar_row "DNS Lookup:" "$ms_namelookup"
bar_row "TCP Connection:" "$ms_connect"
bar_row "TLS Handshake:" "$ms_tls"
bar_row "Server Processing:" "$ms_server"
bar_row "Content Transfer:" "$ms_transfer"

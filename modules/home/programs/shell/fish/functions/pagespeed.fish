function pagespeed --argument url
    set -lx LC_NUMERIC C
    # Parse arguments
    set -l json_output false
    set -l target_url ""

    for arg in $argv
        switch $arg
            case --json
                set json_output true
            case -h --help
                echo "Usage: pagespeed <url> [--json]"
                echo ""
                echo "Measure website response time and TLS certificate validity"
                echo ""
                echo "Options:"
                echo "  --json        Output results in JSON format"
                echo "  -h, --help    Show this help message"
                echo ""
                echo "Examples:"
                echo "  pagespeed https://example.com"
                echo "  pagespeed https://example.com --json"
                return 0
            case '-*'
                echo (set_color red)"Error: Unknown flag: $arg"(set_color normal) >&2
                echo "Usage: pagespeed <url> [--json]" >&2
                return 1
            case '*'
                set target_url $arg
        end
    end

    # Validate URL
    if test -z "$target_url"
        echo (set_color red)"Error: No URL provided"(set_color normal) >&2
        echo "Usage: pagespeed <url> [--json]" >&2
        echo "Run 'pagespeed --help' for more information" >&2
        return 1
    end

    if not string match -qr '^https?://' $target_url
        echo (set_color red)"Error: Invalid URL format. Must start with http:// or https://"(set_color normal) >&2
        return 1
    end

    # Extract hostname for certificate check
    set -l host_name (string replace -r '^https?://([^/:]+).*' '$1' $target_url)
    set -l is_https (string match -q 'https://*' $target_url; and echo true; or echo false)

    # Show loading indicator for non-JSON output
    if test $json_output = false
        printf "Checking %s...\r" $target_url >&2
    end

    # Run curl with redirect following until 200 or max 10 redirects
    set -l curl_output (curl -s -L --max-redirs 10 -w '\n%{response_code}\n%{time_namelookup}\n%{time_connect}\n%{time_pretransfer}\n%{time_starttransfer}\n%{time_total}\n%{url_effective}' -o /dev/null --connect-timeout 10 --max-time 30 $target_url 2>&1)
    set -l curl_status $status

    # Get certificate info for HTTPS
    set -l cert_days ""
    if test "$is_https" = true
        set -l cert_date (echo | openssl s_client -servername $host_name -connect $host_name:443 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)
        if test -n "$cert_date"
            set -l cert_epoch (date -d "$cert_date" +%s 2>/dev/null)
            set -l now_epoch (date +%s)
            if test -n "$cert_epoch"
                set cert_days (math "floor(($cert_epoch - $now_epoch) / 86400)")
            end
        end
    end

    # Clear loading indicator
    if test $json_output = false
        printf "\033[2K\r" >&2
    end

    # Check curl status
    if test $curl_status -ne 0
        if test $json_output = true
            printf '{"error": "Failed to connect to %s", "details": "Possible reasons: invalid URL, network issue, or timeout"}\n' $target_url >&2
        else
            echo (set_color red)"Failed to connect to $target_url"(set_color normal) >&2
            echo "Possible reasons: invalid URL, network issue, or timeout" >&2
        end
        return 1
    end

    # Parse curl output
    set -l lines (string split \n $curl_output)
    set -l response_code $lines[-7]
    set -l time_namelookup $lines[-6]
    set -l time_connect $lines[-5]
    set -l time_pretransfer $lines[-4]
    set -l time_starttransfer $lines[-3]
    set -l time_total $lines[-2]
    set -l url_effective $lines[-1]

    # Convert to milliseconds and format
    set -l ms_namelookup (printf "%.2f" (math "$time_namelookup * 1000"))
    set -l ms_connect (printf "%.2f" (math "$time_connect * 1000"))
    set -l ms_pretransfer (printf "%.2f" (math "$time_pretransfer * 1000"))
    set -l ms_starttransfer (printf "%.2f" (math "$time_starttransfer * 1000"))
    set -l ms_total (printf "%.2f" (math "$time_total * 1000"))

    # Calculate derived metrics
    set -l ms_tls (printf "%.2f" (math "$ms_pretransfer - $ms_connect"))
    set -l ms_server (printf "%.2f" (math "$ms_starttransfer - $ms_pretransfer"))
    set -l ms_transfer (printf "%.2f" (math "$ms_total - $ms_starttransfer"))

    # Performance assessment
    set -l perf_text Excellent
    set -l total_numeric (string replace '.' '' $ms_total)
    if test $total_numeric -gt 100000
        set perf_text Slow
    else if test $total_numeric -gt 50000
        set perf_text Fair
    else if test $total_numeric -gt 20000
        set perf_text Good
    end

    # Output
    if test $json_output = true
        printf '{\n'
        printf '  "url": "%s",\n' $url_effective
        printf '  "response_code": %s,\n' $response_code
        if test -n "$cert_days"
            printf '  "certificate_days_remaining": %s,\n' $cert_days
        end
        printf '  "timings": {\n'
        printf '    "dns_lookup_ms": %s,\n' $ms_namelookup
        printf '    "tcp_connection_ms": %s,\n' $ms_connect
        printf '    "tls_handshake_ms": %s,\n' $ms_tls
        printf '    "server_processing_ms": %s,\n' $ms_server
        printf '    "content_transfer_ms": %s,\n' $ms_transfer
        printf '    "total_ms": %s\n' $ms_total
        printf '  }\n'
        printf '}\n'
    else
        # Color code response
        if test $response_code -ge 200 -a $response_code -lt 300
            set status_color (set_color green)
        else if test $response_code -ge 300 -a $response_code -lt 400
            set status_color (set_color yellow)
        else
            set status_color (set_color red)
        end

        printf "\n"
        printf "%-20s %s\n" (set_color --bold)"URL:"(set_color normal) (set_color blue)$url_effective(set_color normal)
        printf "%-20s %s%s%s\n" (set_color --bold)"Status:"(set_color normal) $status_color $response_code (set_color normal)
        printf "%-20s %s (%s ms)\n" (set_color --bold)"Speed:"(set_color normal) $perf_text $ms_total

        # Certificate info
        if test -n "$cert_days"
            printf "\n"
            printf "%sTLS Certificate%s\n" (set_color --bold yellow) (set_color normal)
            printf "%s────────────────────────────────────────────────────────────%s\n" (set_color yellow) (set_color normal)

            # Color code certificate status
            if test $cert_days -lt 0
                set cert_color (set_color red)
                set cert_status EXPIRED
            else if test $cert_days -lt 7
                set cert_color (set_color red)
                set cert_status "CRITICAL - Expires in $cert_days days"
            else if test $cert_days -lt 30
                set cert_color (set_color yellow)
                set cert_status "Expiring Soon"
            else
                set cert_color (set_color green)
                set cert_status Valid
            end

            printf "%-25s %s%s (%s)%s\n" "Days Remaining:" $cert_color $cert_days $cert_status (set_color normal)
        end

        printf "\n"
        printf "%sTiming Breakdown%s\n" (set_color --bold yellow) (set_color normal)
        printf "%s────────────────────────────────────────────────────────────%s\n" (set_color yellow) (set_color normal)

        # Visual bar chart for timings
        set -l max_bar_width 30
        set -l total_float (math "$ms_total")

        printf "%-25s %s%8s ms%s  " "DNS Lookup:" (set_color magenta) $ms_namelookup (set_color normal)
        set -l bar_len (math "floor($ms_namelookup / $total_float * $max_bar_width)")
        printf "%s%s%s\n" (set_color blue) (string repeat -n (math "max(1, $bar_len)") "█") (set_color normal)

        printf "%-25s %s%8s ms%s  " "TCP Connection:" (set_color magenta) $ms_connect (set_color normal)
        set bar_len (math "floor($ms_connect / $total_float * $max_bar_width)")
        printf "%s%s%s\n" (set_color blue) (string repeat -n (math "max(1, $bar_len)") "█") (set_color normal)

        printf "%-25s %s%8s ms%s  " "TLS Handshake:" (set_color magenta) $ms_tls (set_color normal)
        set bar_len (math "floor($ms_tls / $total_float * $max_bar_width)")
        printf "%s%s%s\n" (set_color blue) (string repeat -n (math "max(1, $bar_len)") "█") (set_color normal)

        printf "%-25s %s%8s ms%s  " "Server Processing:" (set_color magenta) $ms_server (set_color normal)
        set bar_len (math "floor($ms_server / $total_float * $max_bar_width)")
        printf "%s%s%s\n" (set_color blue) (string repeat -n (math "max(1, $bar_len)") "█") (set_color normal)

        printf "%-25s %s%8s ms%s  " "Content Transfer:" (set_color magenta) $ms_transfer (set_color normal)
        set bar_len (math "floor($ms_transfer / $total_float * $max_bar_width)")
        printf "%s%s%s\n" (set_color blue) (string repeat -n (math "max(1, $bar_len)") "█") (set_color normal)
    end
end
# vim: ft=fish

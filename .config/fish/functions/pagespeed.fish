function pagespeed --argument url
    # Parse arguments
    set -l json_output false
    set -l target_url ""

    for arg in $argv
        switch $arg
            case --json
                set json_output true
            case '-*'
                echo (set_color red)"Error: Unknown flag: $arg"(set_color normal)
                echo "Usage: pagespeed <url> [--json]"
                return 1
            case '*'
                set target_url $arg
        end
    end

    # Check if URL argument is provided
    if test -z "$target_url"
        echo (set_color red)"Error: No URL provided"(set_color normal)
        echo "Usage: pagespeed <url> [--json]"
        return 1
    end

    # Validate URL format (basic check)
    if not string match -qr '^https?://' $target_url
        echo (set_color red)"Error: Invalid URL format. Must start with http:// or https://"(set_color normal)
        return 1
    end

    # Make the curl request and capture output
    set -l output (curl -s -L -w '\n%{response_code}\n%{time_namelookup}\n%{time_connect}\n%{time_pretransfer}\n%{time_starttransfer}\n%{time_total}\n%{url_effective}' -o /dev/null --connect-timeout 10 --max-time 30 $target_url 2>&1)

    # Check if curl succeeded
    if test $status -ne 0
        if test $json_output = true
            printf '{"error": "Failed to connect to %s", "details": "Possible reasons: invalid URL, network issue, or timeout"}\n' $target_url
        else
            echo (set_color red)"Error: Failed to connect to $target_url"(set_color normal)
            echo "Possible reasons: invalid URL, network issue, or timeout"
        end
        return 1
    end

    # Parse curl output (last 7 lines contain our metrics)
    set -l lines (string split \n $output)
    set -l response_code $lines[-7]
    set -l time_namelookup $lines[-6]
    set -l time_connect $lines[-5]
    set -l time_pretransfer $lines[-4]
    set -l time_starttransfer $lines[-3]
    set -l time_total $lines[-2]
    set -l url_effective $lines[-1]

    # Convert seconds to milliseconds
    set -l ms_namelookup (math "$time_namelookup * 1000")
    set -l ms_connect (math "$time_connect * 1000")
    set -l ms_pretransfer (math "$time_pretransfer * 1000")
    set -l ms_starttransfer (math "$time_starttransfer * 1000")
    set -l ms_total (math "$time_total * 1000")

    # Format to 2 decimal places
    set ms_namelookup (printf "%.2f" $ms_namelookup)
    set ms_connect (printf "%.2f" $ms_connect)
    set ms_pretransfer (printf "%.2f" $ms_pretransfer)
    set ms_starttransfer (printf "%.2f" $ms_starttransfer)
    set ms_total (printf "%.2f" $ms_total)

    # Calculate derived metrics
    set -l ms_tls (math "$ms_pretransfer - $ms_connect")
    set -l ms_server (math "$ms_starttransfer - $ms_pretransfer")
    set -l ms_transfer (math "$ms_total - $ms_starttransfer")

    # Format derived metrics
    set ms_tls (printf "%.2f" $ms_tls)
    set ms_server (printf "%.2f" $ms_server)
    set ms_transfer (printf "%.2f" $ms_transfer)

    # Output based on format
    if test $json_output = true
        # JSON output
        printf '{\n'
        printf '  "url": "%s",\n' $url_effective
        printf '  "response_code": %s,\n' $response_code
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
        # Color code based on response code
        if test $response_code -ge 200 -a $response_code -lt 300
            set status_color (set_color green)
        else if test $response_code -ge 300 -a $response_code -lt 400
            set status_color (set_color yellow)
        else
            set status_color (set_color red)
        end

        # Display results with colors
        printf "\n"
        printf "%sTesting Website Response Time%s\n" (set_color --bold cyan) (set_color normal)
        printf "%sURL: %s%s\n" (set_color blue) $url_effective (set_color normal)
        printf "\n"
        printf "%sResponse Code:%s\t\t%s%s%s\n" (set_color --bold) (set_color normal) $status_color $response_code (set_color normal)
        printf "\n"
        printf "%sTiming Breakdown:%s\n" (set_color --bold yellow) (set_color normal)
        printf "  DNS Lookup:\t\t%s%s ms%s\n" (set_color magenta) $ms_namelookup (set_color normal)
        printf "  TCP Connection:\t%s%s ms%s\n" (set_color magenta) $ms_connect (set_color normal)
        printf "  TLS Handshake:\t%s%s ms%s\n" (set_color magenta) $ms_tls (set_color normal)
        printf "  Server Processing:\t%s%s ms%s\n" (set_color magenta) $ms_server (set_color normal)
        printf "  Content Transfer:\t%s%s ms%s\n" (set_color magenta) $ms_transfer (set_color normal)
        printf "\n"
        printf "%sTotal Time:\t\t%s ms%s\n" (set_color --bold green) $ms_total (set_color normal)
        printf "\n"
    end
end
# vim: ft=fish

function pagespeed --argument url
    # Check if URL argument is provided
    if not set -q url[1]
        echo (set_color red)"Error: No URL provided"(set_color normal)
        echo "Usage: pagespeed <url>"
        return 1
    end

    # Validate URL format (basic check)
    if not string match -qr '^https?://' $url
        echo (set_color red)"Error: Invalid URL format. Must start with http:// or https://"(set_color normal)
        return 1
    end

    # Make the curl request and capture output
    set -l output (curl -s -L -w '\n%{response_code}\n%{time_namelookup}\n%{time_connect}\n%{time_pretransfer}\n%{time_starttransfer}\n%{time_total}\n%{url_effective}' -o /dev/null --connect-timeout 10 --max-time 30 $url 2>&1)

    # Check if curl succeeded
    if test $status -ne 0
        echo (set_color red)"Error: Failed to connect to $url"(set_color normal)
        echo "Possible reasons: invalid URL, network issue, or timeout"
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
    printf "  TLS Handshake:\t%s%s ms%s\n" (set_color magenta) (math "$ms_pretransfer - $ms_connect") (set_color normal)
    printf "  Server Processing:\t%s%s ms%s\n" (set_color magenta) (math "$ms_starttransfer - $ms_pretransfer") (set_color normal)
    printf "  Content Transfer:\t%s%s ms%s\n" (set_color magenta) (math "$ms_total - $ms_starttransfer") (set_color normal)
    printf "\n"
    printf "%sTotal Time:\t\t%s ms%s\n" (set_color --bold green) $ms_total (set_color normal)
    printf "\n"
end
# vim: ft=fish

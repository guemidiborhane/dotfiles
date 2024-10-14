function pagespeed --argument url
    set -q url[1]; or return

    curl -s -w 'Testing Website Response Time for: %{url_effective}\n\nResponse Code:\t\t%{response_code}\nCookup Time:\t\t%{time_namelookup}\nConnect Time:\t\t%{time_connect}\nPre-transfer Time:\t%{time_pretransfer}\nStart-transfer Time:\t%{time_starttransfer}\n\nTotal Time:\t\t%{time_total}\n' -o /dev/null --connect-timeout 1 $url
end

function mkcd --argument name
    set -q name[1]; or return

    mkdir $name
    cd $name
end

function secure_random --argument size
    set -q size[1]; or set size 64
    tr -cd '[:alnum:]' < /dev/urandom | fold -w $size | head -n 1 | tr -d '\n' | xclip -sel clip
end

# vim: ft=fish

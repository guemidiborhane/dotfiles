function pagespeed --argument url
    set -q url[1]; or return

    curl -s -w 'Testing Website Response Time for: %{url_effective}\n\nResponse Code:\t\t%{response_code}\nCookup Time:\t\t%{time_namelookup}\nConnect Time:\t\t%{time_connect}\nPre-transfer Time:\t%{time_pretransfer}\nStart-transfer Time:\t%{time_starttransfer}\n\nTotal Time:\t\t%{time_total}\n' -o /dev/null --connect-timeout 1 $url
end

function kickoff --argument name
    set template "git@git.netsys.dz:guemidiborhane/kickoff.git"
    set -q name[1]; or return

    if test -d $name
        echo "Directory $name already exists"
        return 1
    end

    git clone --depth 1 $template $name
    cd $name

    sh install.sh
end

function tn --argument session_name
    set -q session_name[1]; or set session_name (basename $PWD)

    if not tmux has-session -t "$session_name"
        tmux new-session -ds "$session_name"
    end

    if test -z "$TMUX"
        tmux attach-session -t "$session_name"
    else 
        tmux switch-client -t "$session_name"
    end
end

function mkcd --argument name
    set -q name[1]; or return

    mkdir $name
    cd $name
end

function clone --argument name
    set -q name[1]; or return

    set repo_name (basename $name | sed -E 's/.git//')
    git clone $name $repo_name
    cd $repo_name
end

function pwd
    set dir (/usr/bin/pwd)
    echo $dir
    echo -n $dir | xclip -sel clipboard
end

function secure_random --argument size
    set -q size[1]; or set size 64
    tr -cd '[:alnum:]' < /dev/urandom | fold -w $size | head -n 1 | tr -d '\n' | xclip -sel clip
end

# vim: ft=fish

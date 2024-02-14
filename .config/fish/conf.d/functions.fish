function pagespeed
    curl -s -w 'Testing Website Response Time for: %{url_effective}\n\nResponse Code:\t\t%{response_code}\nCookup Time:\t\t%{time_namelookup}\nConnect Time:\t\t%{time_connect}\nPre-transfer Time:\t%{time_pretransfer}\nStart-transfer Time:\t%{time_starttransfer}\n\nTotal Time:\t\t%{time_total}\n' -o /dev/null --connect-timeout 1 $argv[1]
end

function kickoff
    if test -d $argv[1]
        echo "Directory $argv[1] already exists"
        return 1
    end

    set git_repo "git@git.netsys.dz:guemidiborhane/kickoff.git"
    git clone $git_repo $argv[1]
    cd $argv[1]
    bash install.sh
end

function tn
    if test (count $argv) -gt 0
        set session_name $argv[1]
    else
        set session_name (basename $PWD)
    end
    tmux new-session -As "$session_name"
end

function mkcd
    mkdir $argv[1]
    cd $argv[1]
end

function clone
    set repo_name (basename $argv[1] | sed -E 's/.git//')
    git clone $argv[1] $repo_name
    cd $repo_name
end

function pwd
    set dir (/usr/bin/pwd)
    echo $dir
    echo -n $dir | xclip -sel clipboard
end

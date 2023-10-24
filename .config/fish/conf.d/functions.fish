function pagespeed
    curl -s -w 'Testing Website Response Time for: %{url_effective}\n\nResponse Code:\t\t%{response_code}\nCookup Time:\t\t%{time_namelookup}\nConnect Time:\t\t%{time_connect}\nPre-transfer Time:\t%{time_pretransfer}\nStart-transfer Time:\t%{time_starttransfer}\n\nTotal Time:\t\t%{time_total}\n' -o /dev/null --connect-timeout 1 $1
end

function kickoff
    if test -d $1
        echo "Directory $1 already exists"
        return 1
    end

    set git_repo "git@git.netsys.dz:guemidiborhane/kickoff.git"
    git clone $git_repo $1
    cd $1
    bash install.sh
    code .
end

function tn
    if count $argv > 0
        set session_name $argv[1]
    else
        set session_name (basename $PWD)
    end
    tmux new-session -As "$session_name"
end

bind \ct 'tn \n'


function mkcd
    mkdir $argv[1]
    cd $argv[1]
end

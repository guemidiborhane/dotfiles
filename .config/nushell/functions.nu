# Helper Functions
def has-env [name: string] {
    ($env | get -i $name | default "") != ""
}

# Clipboard Management
def clip [--paste (-p)] {
    let clipboard_cmd = match $env.XDG_SESSION_TYPE { 
        "x11" => ["xclip", "-sel", "clip"],
        "wayland" => ['wl-copy'],
        _ => { error make { msg: "Unknown session type" } },
    }
    
    $in | ^($clipboard_cmd | get 0) ...($clipboard_cmd | range 1..)
}

# File and Directory Operations
def --env mkcd [name: string] {
    if ($name | is-empty) {
        error make {msg: "Directory name required"}
    }

    if ($name | path exists) {
        error make {msg: $"Directory ($name) already exists"}
    }

    ^mkdir -p $name
    cd $name
}

# Project Templates
def kickoff [name: string] {
    let template = "git@git.netsys.dz:guemidiborhane/kickoff.git"
    
    if ($name | is-empty) {
        error make {msg: "Project name required"}
    }

    if ($name | path exists) {
        error make {msg: $"Directory ($name) already exists"}
    }

    git clone --depth 1 $template $name
    cd $name
    sh install.sh
}

# Web Tools
def pagespeed [url: string] {
    if ($url | is-empty) {
        error make {msg: "URL required"}
    }

    curl -s -w $'Testing Website Response Time for: %{url_effective}\n\nResponse Code:\t\t%{response_code}\nCookup Time:\t\t%{time_namelookup}\nConnect Time:\t\t%{time_connect}\nPre-transfer Time:\t%{time_pretransfer}\nStart-transfer Time:\t%{time_starttransfer}\n\nTotal Time:\t\t%{time_total}\n' -o /dev/null --connect-timeout 1 $url
}

# System Commands
def pwd [] {
    let dir = (/usr/bin/pwd | str trim)
    echo $dir
    echo $dir | clip
}

def clear [] { 
    ^clear
    fastfetch
}

def n [...args] {
    xdg-open ...$args
}

# SSH Management
def sshkey [] {
    let keys = ls ~/.ssh/*.pub | get name
    if ($keys | is-empty) {
        error make {msg: "No public keys found"}
    }
    
    let selected = ($keys | path basename | str replace '.pub' '' 
        | input list 'Select SSH key to copy:')
    
    if not ($selected | is-empty) {
        let ssh_key_path = $env.HOME + $"/.ssh/($selected).pub"
        open $ssh_key_path | str trim | clip
        notify-send -t 5000 $"($selected) public Key copied to clipboard" -i ~/.icons/key_ok.png
    }
}

# Session Management
def start_session [] {
    let options = [
        [display command];
        ["Hyprland" "~/.config/hypr/hyprstart"]
        ["i3" "startx"]
    ]
    
    let selected = ($options 
        | get display 
        | to text
        | fzf --reverse
        | str trim)
    
    if not ($selected | is-empty) {
        $options
        | where display == $selected
        | get command
        | first
    }
}


def t [] {
    sesh connect (sesh list -i | gum filter --limit 1 --placeholder 'Pick a sesh' --prompt=' ')
}

# TMUX Management
def tn [
    session_name?: string
    --kill (-k)
] {
    let session_name = if ($session_name | is-empty) {
        (pwd | path basename)
    } else {
        $session_name
    }

    if $kill {
        tmux kill-session -t $session_name
        return
    }

    let has_session = (do { tmux has-session -t $session_name } | complete).exit_code == 0
    
    if not $has_session {
        tmux new-session -ds $session_name
    }

    if not (has-env "TMUX") {
        tmux attach-session -t $session_name
    } else {
        tmux switch-client -t $session_name
    }
}

# Git Operations

# File Finding
def v [] { 
    fd --type f --hidden --exclude .git --exclude node_modules --exclude cache --exclude log 
    | fzf-tmux -p --reverse --preview "bat -p --color=always {}" 
    | xargs -r nvim 
}

def zid [] { 
    eza -D | xargs -I {} zoxide add {} 
}

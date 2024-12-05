#!/usr/bin/env nu

def parse_fish_entry [entry: string] {
    mut cmd = ""
    mut when = 0
    mut path = ""
    
    let lines = ($entry | lines)
    
    for line in $lines {
        if ($line | str starts-with "- cmd:") {
            $cmd = ($line | str replace "- cmd: " "" | str trim)
        } else if ($line | str starts-with "  when:") {
            $when = ($line | str replace "  when: " "" | str trim | into int)
        } else if ($line | str starts-with "  paths:") {
            # Get the first path from the paths list
            let next_line = ($lines | skip until {|l| $l starts-with "    -"} | first | default "")
            if not ($next_line | is-empty) {
                $path = ($next_line | str replace "    - " "" | str trim)
            }
        }
    }
    
    return {
        command: $cmd,
        timestamp: $when,
        cwd: $path
    }
}

def main [] {
    # Define paths
    let fish_history = ($env.HOME | path join ".local/share/fish/fish_history")
    let nu_history = ($env.HOME | path join ".config/nushell/history.sqlite3")
    
    # Read fish history file contents
    let entries = (
        open $fish_history 
        | str trim
        | split chars
        | window 2
        | reduce -f { 
            content: [], 
            current_entry: "" 
        } {|window, acc| 
            if $window.0 == "\n" and $window.1 == "-" {
                $acc | upsert content ($acc.content | append $acc.current_entry) | upsert current_entry ""
            } else {
                $acc | upsert current_entry ($acc.current_entry + $window.0)
            }
        }
        | get content
        | where {|entry| not ($entry | is-empty)}
        | each {|entry| parse_fish_entry $entry}
        | where command != ""
    )
    
    # Get hostname
    let hostname = (sys host | get hostname)
    let session_id = (random int 1000000..9999999)
    
    # Build SQL insert statements
    let sql_commands = (
        $entries
        | each {|entry|
            let cmd = ($entry.command | str replace -a "'" "''")  # Escape single quotes
            let cwd = ($entry.cwd | str replace -a "'" "''")
            let sql = [
                "INSERT INTO history (command_line, start_timestamp, session_id, hostname, cwd, duration_ms, exit_status, more_info) VALUES ('",
                $cmd,
                "', ",
                ($entry.timestamp | into string),
                ", ",
                ($session_id | into string),
                ", '",
                $hostname,
                "', '",
                $cwd,
                "', 0, 0, NULL);"
            ]
            $sql | str join ""
        }
        | str join "\n"
    )
    
    echo $sql_commands | save /tmp/fish_history.sql

    print $"Created sql file to import run: bash -c 'sqlite3 $(nu_history) < /tmp/fish_history.sql'"
}

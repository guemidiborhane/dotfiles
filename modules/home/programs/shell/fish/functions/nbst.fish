function nbst --wraps 'netbird status'
    argparse 's/status=' 't/connection-type=' -- $argv

    set connection_status
    if set -q _flag_status
        set connection_status $_flag_status
    end

    set connection_type
    if set -q _flag_connection_type
        set connection_type $_flag_connection_type
    end

    set peers (netbird status --json | jq -r '.peers.details')
    set output $peers

    if test -n "$connection_type"
        set output (echo $output | jq -r --arg connection_type $connection_type '[.[] | select(.connectionType == $connection_type)]')
    end

    if test -n "$connection_status"
        set output (echo $output | jq -r --arg connection_status $connection_status '[.[] | select(.status == $connection_status)]')
    end

    echo $output | jq -r '.[] | [.fqdn, .netbirdIp, .connectionType, .status] | @tsv' | column -t | sort -k3 -k1 -k4
end

# vim ft=fish

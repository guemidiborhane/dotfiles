function kubectl --wraps kubectl --description "Wraps kubectl with correct version from mise for each cluster"
    set -l context_name
    set -l kubectl_args

    set -l i 1
    while test $i -le (count $argv)
        set -l arg $argv[$i]

        if test "$arg" = --context
            set i (math $i + 1)
            set context_name $argv[$i]
        else if string match -qr '^--context=(.+)$' -- "$arg"
            set context_name (string replace -r '^--context=(.+)$' '$1' -- "$arg")
        else
            set -a kubectl_args $arg
        end

        set i (math $i + 1)
    end

    if test -z "$context_name"
        set context_name (kubectx --current)
    end

    set -l kubectl_version (yq --arg name "$context_name" '.contexts[] | select(.name == $name) | .version' ~/.kube/versions -rj)

    if test -z "$kubectl_version" -o "$kubectl_version" = null
        set kubectl_version (tomlq '.tools.kubectl' ~/.config/mise/config.toml -rj)
    end

    # Find position to inject --context (after first subcommand, before its args)
    set -l final_args
    set -l context_injected 0

    for arg in $kubectl_args
        set -a final_args $arg

        # Inject context after the first non-flag argument (the subcommand)
        if test $context_injected -eq 0; and not string match -qr '^-' -- "$arg"
            set -a final_args --context $context_name
            set context_injected 1
        end
    end

    # If no subcommand found (e.g., just "kubectl --help"), add context at the beginning
    if test $context_injected -eq 0
        set final_args --context $context_name $final_args
    end

    if set -q KUBECTL_WRAPPER_DEBUG
        echo "Running: mise exec kubectl@$kubectl_version -- kubectl $final_args"
    end

    mise exec kubectl@$kubectl_version -- kubectl $final_args
end

# vim ft=fish

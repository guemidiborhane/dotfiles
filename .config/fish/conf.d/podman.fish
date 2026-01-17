if [ -z (set -q DOCKER_HOST && echo "$DOCKER_HOST" || echo '') ]
    if [ (id -u | string collect; or echo) -eq 0 ]
        set -gx DOCKER_HOST 'unix:///run/podman/podman.sock'
    else
        if [ -n (set -q XDG_RUNTIME_DIR && echo "$XDG_RUNTIME_DIR" || echo '') ]
            set -gx DOCKER_HOST 'unix://'"$XDG_RUNTIME_DIR"'/podman/podman.sock'
        end
    end
end

# vim ft=fish

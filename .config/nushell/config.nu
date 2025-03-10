$env.config = ($env.config? | default {} | merge {
    ls: {
        use_ls_colors: true
        clickable_links: false
    }
    table: {
        mode: compact
        index_mode: always
        show_empty: true
        header_on_separator: true
    }
    edit_mode: vi
    show_banner: false
    history: {
        max_size: 100_000
        sync_on_enter: true
        file_format: "sqlite"
        isolation: false
    }

    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "prefix"
        external: {
            enable: true
            max_results: 100
            completer: null
        }
        use_ls_colors: true
    }
})

source ~/.config/nushell/functions.nu
source ~/.config/nushell/aliases.nu
source ~/.config/nushell/completions.nu
source $"($nu.default-config-dir)/abbreviations.nu"

let tty_out = (tty | str trim)
if (not ($env | has-env DISPLAY) and
    (($env | get -i XDG_VTNR | default "") == "1") and
    not ($env | has-env SSH_CONNECTION) and 
    ($tty_out | str contains "/dev/tty")) {

    let choice = (start_session)
    if not ($choice | is-empty) {
        ^sh -c $choice
    }
}

# Auto-start tmux in SSH
if ($env | get -i LAST_EXIT_CODE | default 0) == 0 and ($env | get -i TMUX | default "") == "" and ($env | get -i SSH_TTY | default "") != "" {
    exec tmux -u new-session -As workshop
}

# Source external configurations
source ~/.cache/nushell/carapace.nu
source ~/.cache/nushell/zoxide.nu
source ~/.cache/nushell/atuin.nu
use ~/.cache/nushell/mise.nu
use ~/.cache/nushell/starship.nu

# Initial greeting
fastfetch


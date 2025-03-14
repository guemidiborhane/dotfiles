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
        use_ls_colors: true
    }
})

# Source external configurations
source $"($cache_path)/carapace.nu"
source $"($cache_path)/zoxide.nu"
source $"($cache_path)/atuin.nu"
use    $"($cache_path)/mise.nu"
use    $"($cache_path)/starship.nu"

source $"($nu.default-config-dir)/functions.nu"
source $"($nu.default-config-dir)/aliases.nu"
source $"($nu.default-config-dir)/abbreviations.nu"
source $"($nu.cache-dir)/abbreviations.nu"
source $"($nu.default-config-dir)/completions.nu"

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

# Initial greeting
fastfetch

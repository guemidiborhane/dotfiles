let abbreviations = {
    k: 'kubectl'
    
    # ping
    p1: 'ping 1.1.1.1'
    p8: 'ping 8.8.8.8'

    # YADM
    ye: 'yadm edit'
    yu: 'yadm pull'
    yp: 'yadm push'
    yl: 'yadm enter lazygit'
    ys: 'yadm st'

    # System Control
    sc: 'systemctl'
    scu: 'systemctl --user'
}

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

    keybindings: [
      {
        name: abbr_menu
        modifier: none
        keycode: enter
        mode: [emacs, vi_normal, vi_insert]
        event: [
            { send: menu name: abbr_menu }
            { send: enter }
        ]
      }
      {
        name: abbr_menu
        modifier: none
        keycode: space
        mode: [emacs, vi_normal, vi_insert]
        event: [
            { send: menu name: abbr_menu }
            { edit: insertchar value: ' '}
        ]
      }
    ]

    menus: [
        {
            name: abbr_menu
            only_buffer_difference: false
            marker: none
            type: {
                layout: columnar
                columns: 1
                col_width: 20
                col_padding: 2
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: yellow
            }
            source: { |buffer, position|
                let match = $abbreviations | columns | where $it == $buffer
                if ($match | is-empty) {
                    { value: $buffer }
                } else {
                    { value: ($abbreviations | get $match.0) }
                }
            }
        }
    ]
})

# Source external configurations
use ~/.cache/nushell/starship.nu
source ~/.cache/nushell/carapace.nu
source ~/.cache/nushell/zoxide.nu
source /opt/asdf-vm/asdf.nu
source ~/.asdf/plugins/golang/set-env.nu


source ~/.config/nushell/functions.nu
source ~/.config/nushell/aliases.nu

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


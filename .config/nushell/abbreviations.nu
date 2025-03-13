# source: https://hackmd.io/Y9S7BmRsSvWxG_1AqS_xFw#3-abbr

$env.config = (
  $env.config | upsert keybindings (
    $env.config.keybindings
    | append [
        {
        name: abbr
        modifier: none
        keycode: space
        mode: [emacs, vi_normal, vi_insert]
        event: [
          { send: menu name: abbr_menu }
          { edit: insertchar, value: ' ' }
        ]
      },
      {
        name: abbr
        modifier: none
        keycode: Enter
        mode: [emacs, vi_normal, vi_insert]
        event: [
          { send: menu name: abbr_menu }
          { send: enter }
        ]
      }
    ]
  )
)

$env.config = (
  $env.config | upsert menus (
    $env.config.menus
    | append {
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
        let match = scope aliases | where name == $"_($buffer)" | get expansion
        if (($match | is-empty) or $match.0 =~ "zoxide") {
          { value: $buffer }
        } else {
          { value: $match.0 }
        }
      }
    }
  )
)

scope aliases | where name =~ '^_' | each { |alias|
  $"alias ($alias.name | str replace -r '^_' '') = ($alias.expansion)"
} | save -f $"($cache_path)/abbreviations.nu"


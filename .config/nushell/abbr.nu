# source: https://hackmd.io/Y9S7BmRsSvWxG_1AqS_xFw#3-abbr

$env.config = ($env.config? | default {} | merge {
  keybindings: [
    {
      name: abbr
      modifier: none
      keycode: space
      mode: [emacs, vi_normal, vi_insert]
      event: [
        { send: menu name: abbr_menu }
        { edit: insertchar, value: ' '}
      ]
    }
    {
      name: abbr
      modifier: none
      keycode: enter
      mode: [emacs, vi_normal, vi_insert]
      event: [
        { send: menu name: abbr_menu }
        { send: enter }
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
        let match = scope aliases | where name == $buffer
        if ($match | is-empty) {
          { value: $buffer }
        } else {
          $match | each {|it| { value: $it.expansion }}
        }
      }
    }
  ]
})

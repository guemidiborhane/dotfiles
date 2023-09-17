return {
  "goolord/alpha-nvim",
  cmd = "Alpha",
  opts = function()
    local dashboard = require "alpha.themes.dashboard"
    dashboard.section.header.val = {
      "[[          ▀████▀▄▄              ▄█ ]]",
      "[[            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█ ]]",
      "[[    ▄        █          ▀▀▀▀▄  ▄▀  ]]",
      "[[   ▄▀ ▀▄      ▀▄              ▀▄▀  ]]",
      "[[  ▄▀    █     █▀   ▄█▀▄      ▄█    ]]",
      "[[  ▀▄     ▀▄  █     ▀██▀     ██▄█   ]]",
      "[[   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █  ]]",
      "[[    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀  ]]",
      "[[   █   █  █      ▄▄           ▄▀   ]]",
    }

    dashboard.section.header.opts.hl = "DashboardHeader"

    local button, get_icon = require("astronvim.utils").alpha_button, require("astronvim.utils").get_icon
    dashboard.section.buttons.val = {
      button("LDR f f", get_icon("Search", 2, true) .. "Find File  "),
      button("LDR n  ", get_icon("FileNew", 2, true) .. "New File  "),
      button("LDR f o", get_icon("DefaultFile", 2, true) .. "Recents  "),
      button("LDR f w", get_icon("WordFile", 2, true) .. "Find Word  "),
      button("LDR S l", get_icon("Refresh", 2, true) .. "Last Session  "),
    }
    return dashboard
  end,
}

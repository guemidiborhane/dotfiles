-- add new colors that can be used by heirline
return function(hl)
  local get_hlgroup = require("astronvim.utils").get_hlgroup
  -- use helper function to get highlight group properties
  hl.blank_bg = get_hlgroup("Folded").fg
  hl.file_info_bg = get_hlgroup("Visual").bg
  hl.nav_icon_bg = get_hlgroup("String").fg
  hl.nav_fg = hl.nav_icon_bg
  hl.folder_icon_bg = get_hlgroup("Error").fg
  return hl
end

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.editing-support.refactoring-nvim" },
  { import = "astrocommunity.recipes.telescope-nvchad-theme" },
  -- { import = "astrocommunity.recipes.heirline-nvchad-statusline" },
  -- { import = "astrocommunity.recipes.heirline-vscode-winbar" },
  -- import/override with your plugins folder
}

-- return {
--   {
--     'sainnhe/gruvbox-material',
--     priority = 1000,
--     config = function()
--       vim.o.background = 'dark'
--       vim.g.gruvbox_material_background = 'hard'
--       vim.g.gruvbox_material_foreground = 'original'
--       vim.g.gruvbox_material_disable_italic_comment = true
--       vim.g.gruvbox_material_ui_contrast = 'high'
--       vim.g.gruvbox_material_visual = 'reverse'
--       vim.cmd.colorscheme 'gruvbox-material'
--     end,
--   },
-- }
return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    vim.cmd.colorscheme 'tokyonight-night'
  end,
}

return {
  {
    'zenbones-theme/zenbones.nvim',
    priority = 1000,
    lazy = false,
    config = function()
      vim.g.bones_compat = 1
      vim.cmd.colorscheme 'zenburned'
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et

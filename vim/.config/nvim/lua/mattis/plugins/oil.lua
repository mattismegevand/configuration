return {
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup {
        delete_to_trash = false,
        view_options = {
          show_hidden = true,
        },
      }

      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'oil: Open parent directory' })
      vim.keymap.set('n', '<space>-', require('oil').toggle_float, { desc = 'oil: Open parent directory in floating window' })
    end,
  },
}

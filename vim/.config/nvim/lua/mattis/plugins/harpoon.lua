return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },

    config = function()
      local harpoon = require 'harpoon'

      harpoon:setup()

      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end, { desc = 'harpoon: harpoon file' })
      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = 'harpoon: harpoon quick menu' })

      for i = 1, 5 do
        vim.keymap.set('n', '<leader>' .. i, function()
          harpoon:list():select(i)
        end, { desc = 'harpoon: harpoon to file ' .. i })
      end
    end,
  },
}

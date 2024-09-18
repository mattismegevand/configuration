return {
  {
    'jpalardy/vim-slime',
    config = function()
      vim.g.slime_target = 'tmux'
      vim.g.slime_default_config = { socket_name = 'default', target_pane = '{last}' }

      vim.keymap.set({ 'n', 'x' }, '<leader>rs', ':SlimeSend<CR>', { desc = 'slime: [r]epl [s]end' })
    end,
  },
}

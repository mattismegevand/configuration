return {
  {
    'linrongbin16/gitlinker.nvim',
    cmd = 'GitLink',
    opts = {},
    keys = {
      { '<leader>gb', '<cmd>GitLink<cr>', mode = { 'n', 'v' }, desc = 'gitlinker: Yank git link' },
      { '<leader>gB', '<cmd>GitLink!<cr>', mode = { 'n', 'v' }, desc = 'gitlinker: Open git link' },
    },
  },
}

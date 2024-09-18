vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Open file at the last position it was edited earlier',
  ---@diagnostic disable-next-line: undefined-global
  group = misc_augroup,
  pattern = '*',
  command = 'silent! normal! g`"zv',
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_user_command('CopyCodeBlock', function(opts)
  local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, true)
  local content = table.concat(lines, '\n')
  local result = string.format('```%s\n%s\n```', vim.bo.filetype, content)
  vim.fn.setreg('+', result)
  vim.notify 'Text copied to clipboard'
end, { desc = 'Yank selection into a code block', range = true })

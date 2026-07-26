vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Editing
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.undofile = true

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- Interface
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 4
vim.opt.termguicolors = true
vim.opt.colorcolumn = '80'
vim.opt.clipboard = 'unnamedplus'

vim.keymap.set('n', '<Esc>', '<Cmd>nohlsearch<CR>')

-- Neovim 0.12's built-in package manager keeps this config dependency-light.
vim.pack.add({
  {
    src = 'https://github.com/nvim-mini/mini.nvim',
    version = 'stable',
  },
})

vim.cmd.colorscheme('minicyan')

require('mini.icons').setup()

local pick = require('mini.pick')
pick.setup()

require('mini.statusline').setup()

require('mini.files').setup({
  options = {
    -- File removals go to MiniFiles' trash directory instead of being permanent.
    permanent_delete = false,
    use_as_default_explorer = true,
  },
})

require('mini.diff').setup({
  view = {
    style = 'sign',
    signs = { add = '+', change = '~', delete = '-' },
  },
})

local function open_files()
  local path = vim.api.nvim_buf_get_name(0)
  require('mini.files').open(path ~= '' and path or vim.uv.cwd(), false)
end

local function pick_files()
  local options = vim.fs.root(vim.uv.cwd(), '.git') and { tool = 'git' } or nil
  pick.builtin.files(options)
end

vim.keymap.set('n', '<leader>e', open_files, { desc = 'Browse files' })
vim.keymap.set('n', '<leader>f', pick_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>g', pick.builtin.grep_live, { desc = 'Search text' })
vim.keymap.set('n', '<leader>b', pick.builtin.buffers, { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>h', pick.builtin.help, { desc = 'Find help' })
vim.keymap.set('n', '<leader>d', require('mini.diff').toggle_overlay, {
  desc = 'Toggle current file diff',
})

local function open_git_diff(command)
  local root = vim.fs.root(0, '.git') or vim.uv.cwd()
  local args = { 'git', '-C', root, 'diff', '--no-ext-diff' }
  vim.list_extend(args, vim.split(command.args, '%s+', { trimempty = true }))

  local result = vim.system(args, { text = true }):wait()
  if result.code ~= 0 then
    vim.notify(result.stderr, vim.log.levels.ERROR)
    return
  end

  local lines = vim.split(result.stdout, '\n', { plain = true })
  if #lines == 1 and lines[1] == '' then
    vim.notify('No changes')
    return
  end

  vim.cmd.tabnew()
  local buffer = vim.api.nvim_get_current_buf()
  vim.bo[buffer].buftype = 'nofile'
  vim.bo[buffer].bufhidden = 'wipe'
  vim.bo[buffer].swapfile = false
  vim.bo[buffer].filetype = 'diff'
  vim.api.nvim_buf_set_name(buffer, 'Git diff')
  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
  vim.bo[buffer].modifiable = false
end

vim.api.nvim_create_user_command('GitDiff', open_git_diff, {
  desc = 'Open the working tree diff; accepts git diff arguments',
  nargs = '*',
})

vim.keymap.set('n', '<leader>D', '<Cmd>GitDiff<CR>', {
  desc = 'Open working tree diff',
})

-- Language servers
vim.lsp.config('gopls', {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.work', 'go.mod', '.git' },
})

vim.lsp.config('pyright', {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = {
    { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt' },
    '.git',
  },
})

vim.lsp.config('typescript', {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },
  root_markers = { { 'package.json', 'tsconfig.json', 'jsconfig.json' }, '.git' },
})

vim.lsp.config('lua', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
      telemetry = { enable = false },
      workspace = { checkThirdParty = false },
    },
  },
})

vim.lsp.enable({ 'gopls', 'pyright', 'typescript', 'lua' })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-keymaps', { clear = true }),
  callback = function(event)
    local map = function(modes, lhs, rhs, description)
      vim.keymap.set(modes, lhs, rhs, {
        buffer = event.buf,
        desc = description,
      })
    end

    map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
    map('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
    map('n', '<leader>le', vim.diagnostic.open_float, 'Show diagnostic')
    map('n', '<leader>lr', vim.lsp.buf.rename, 'Rename symbol')
    map({ 'n', 'x' }, '<leader>la', vim.lsp.buf.code_action, 'Code action')
    map({ 'n', 'x' }, '<leader>lf', function()
      vim.lsp.buf.format({ async = true })
    end, 'Format code')
  end,
})

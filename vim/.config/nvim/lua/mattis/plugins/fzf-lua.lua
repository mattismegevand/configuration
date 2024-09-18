return {
  {
    'ibhagwan/fzf-lua',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      local fzf = require 'fzf-lua'

      fzf.setup {
        'telescope',
        file_ignore_patterns = { '.venv', 'node_modules' },
        fzf_colors = false,
      }

      vim.keymap.set('n', '<leader>sh', fzf.helptags, { desc = 'fzf: [S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', fzf.keymaps, { desc = 'fzf: [S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', function()
        fzf.files { resume = true }
      end, { desc = 'fzf: [S]earch [f]iles resume' })
      vim.keymap.set('n', '<leader>sF', fzf.files, { desc = 'fzf: [S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', fzf.builtin, { desc = 'fzf: [S]earch [S]elect fzf-lua' })
      vim.keymap.set('n', '<leader>sw', fzf.grep_cword, { desc = 'fzf: [S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', function()
        fzf.live_grep { resume = true }
      end, { desc = 'fzf: [S]earch by [g]rep resume' })
      vim.keymap.set('n', '<leader>sG', fzf.live_grep, { desc = 'fzf: [S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sp', function()
        fzf.live_grep_glob { resume = true }
      end, { desc = 'fzf: [S]earch by Grep [p]attern resume' })
      vim.keymap.set('n', '<leader>sP', fzf.live_grep_glob, { desc = 'fzf: [S]earch by Grep [P]attern' })
      vim.keymap.set('n', '<leader>sd', fzf.diagnostics_document, { desc = 'fzf: [S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', fzf.resume, { desc = 'fzf: [S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', fzf.oldfiles, { desc = 'fzf: [S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', fzf.buffers, { desc = 'fzf: [ ] Find existing buffers' })

      fzf.register_ui_select()
    end,
  },
}

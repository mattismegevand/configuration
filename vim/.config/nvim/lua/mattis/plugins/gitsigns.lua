return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'gitsigns: Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'gitsigns: Jump to previous git [c]hange' })

        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'gitsigns: stage git hunk' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'gitsigns: reset git hunk' })

        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'gitsigns: [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'gitsigns: [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'gitsigns: [S]tage buffer' })
        map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'gitsigns: [u]ndo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'gitsigns: [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'gitsigns: [p]review hunk' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'gitsigns: [b]lame line' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'gitsigns: [d]iff against index' })
        map('n', '<leader>hD', function()
          gitsigns.diffthis '@'
        end, { desc = 'gitsigns: [D]iff against last commit' })

        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'gitsigns: [T]oggle git show [b]lame line' })
        map('n', '<leader>tD', gitsigns.toggle_deleted, { desc = 'gitsigns: [T]oggle git show [D]eleted' })
      end,
    },
  },
}

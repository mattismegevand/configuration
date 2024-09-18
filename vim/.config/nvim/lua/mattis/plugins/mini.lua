return {
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      require('mini.pairs').setup()

      local sessions = require 'mini.sessions'
      sessions.setup {
        autoread = true,
        directory = '',
      }
      vim.keymap.set('n', '<leader>Sr', function()
        sessions.select('read', {})
      end, { desc = 'mini-[S]essions: [r]ead session' })
      vim.keymap.set('n', '<leader>Sw', function()
        sessions.select('write', {})
      end, { desc = 'mini-[S]essions: [w]rite session' })

      local statusline = require 'mini.statusline'
      statusline.setup {
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
            local git = MiniStatusline.section_git { trunc_width = 40 }
            local filename = MiniStatusline.section_filename { trunc_width = 140 }
            local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
            local location = MiniStatusline.section_location { trunc_width = 75 }
            local search = MiniStatusline.section_searchcount { trunc_width = 75 }

            return MiniStatusline.combine_groups {
              { hl = mode_hl, strings = { mode } },
              { hl = 'MiniStatuslineDevinfo', strings = { git } },
              '%<', -- Mark general truncate point
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%=', -- End left alignment
              { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
              { hl = mode_hl, strings = { search, location } },
            }
          end,
        },
        use_icons = vim.g.have_nerd_font,
      }

      local orig_sm = statusline.section_mode
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_mode = function(args)
        local mode, mode_hl = orig_sm(args)
        return string.upper(mode), mode_hl
      end

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_fileinfo = function()
        local filetype = vim.bo.filetype
        if (filetype == '') or vim.bo.buftype ~= '' then
          return ''
        end
        local file_name, file_ext = vim.fn.expand '%:t', vim.fn.expand '%:e'

        if vim.g.have_nerd_font then
          local devicons = require 'nvim-web-devicons'
          local icon = devicons.get_icon(file_name, file_ext, { default = true })
          if icon ~= '' then
            filetype = string.format('%s %s', icon, filetype)
          end
        end

        return filetype
      end

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
}

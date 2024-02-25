return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        -- calling `setup` is optional for customization
        local fzf = require("fzf-lua")

        vim.keymap.set('n', '<leader>ff', fzf.files, {})
        vim.keymap.set('n', '<leader>fg', fzf.live_grep, {})
        vim.keymap.set('n', '<leader>fd', fzf.git_files, {})
        vim.keymap.set('n', '<leader>fb', fzf.buffers, {})
        vim.keymap.set('n', '<leader>fh', fzf.help_tags, {})
    end,
}

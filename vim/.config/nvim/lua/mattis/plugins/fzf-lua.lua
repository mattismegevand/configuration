return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        -- calling `setup` is optional for customization
        local fzf = require("fzf-lua")

        vim.keymap.set('n', '<leader>pf', fzf.files, {})
        vim.keymap.set('n', '<C-p>', fzf.git_files, {})
        vim.keymap.set('n', '<leader>ps', fzf.live_grep, {})
    end,
}

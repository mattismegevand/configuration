return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local fzf = require("fzf-lua")

        vim.keymap.set('n', '<leader>ff', fzf.files, {})
        vim.keymap.set('n', '<leader>fg', fzf.live_grep, {})
        vim.keymap.set('n', '<leader>fr', fzf.live_grep_glob, {})
        vim.keymap.set('n', '<leader>fd', fzf.git_files, {})
        vim.keymap.set('n', '<leader>fb', fzf.buffers, {})
        vim.keymap.set('n', '<leader>fh', fzf.help_tags, {})

        vim.keymap.set('n', 'gd', fzf.lsp_definitions, {})
        vim.keymap.set('n', 'gr', fzf.lsp_references, {})
        vim.keymap.set('n', 'gI', fzf.lsp_implementations, {})

        fzf.setup({ 'telescope' })
    end,
}

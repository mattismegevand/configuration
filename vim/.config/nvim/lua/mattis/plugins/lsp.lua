return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
    },

    config = function()
        local _ = require("cmp_nvim_lsp")

        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "pyright",
            },
        })
        require("mason-lspconfig").setup_handlers {
            function(server_name) -- default handler (optional)
                require("lspconfig")[server_name].setup {}
            end,
        }

        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
        vim.keymap.set('n', ',d', vim.diagnostic.goto_prev)
        vim.keymap.set('n', ';d', vim.diagnostic.goto_next)
        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

        vim.api.nvim_create_autocmd('LspAttach', {
            desc = 'LSP actions',
            callback = function(event)
                local bufmap = function(mode, lhs, rhs)
                    local opts = { buffer = event.buf }
                    vim.keymap.set(mode, lhs, rhs, opts)
                end

                bufmap('i', '<C-Space>', '<C-x><C-o>')
                bufmap('n', 'K', vim.lsp.buf.hover)

                bufmap('n', '<space>f', function()
                    vim.lsp.buf.format { async = true }
                end)
            end
        })

        vim.diagnostic.config({
            virtual_text = false,
            signs = false,
        })
    end,
}

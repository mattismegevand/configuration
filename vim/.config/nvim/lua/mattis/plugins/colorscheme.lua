return {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
        local configs = require("rose-pine")
        configs.setup({
            styles = { italic = false },
        })
        vim.cmd("colorscheme rose-pine")
    end,
}

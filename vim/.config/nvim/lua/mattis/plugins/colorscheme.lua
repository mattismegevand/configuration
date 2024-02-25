return {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    config = function()
        require("kanagawa").setup({
            commentStyle = { italic = false },
            keywordStyle = { italic = false },
        })
        vim.cmd("colorscheme kanagawa-lotus")
    end,
}

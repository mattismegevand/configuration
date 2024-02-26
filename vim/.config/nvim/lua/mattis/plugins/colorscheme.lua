return {
    "mcchrish/zenbones.nvim",
    config = function()
        vim.opt.termguicolors = true
        vim.opt.background = light
        vim.g.bones_compat = true
        vim.cmd.colorscheme("zenbones")
    end,
}

return {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    config = function()
        require("nightfox").setup({})

        vim.cmd("colorscheme carbonfox")

        vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "#1a1b26" })
        vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { fg = "#7aa2f7" })
        vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#2f3346", fg = "#c0caf5" })
        vim.api.nvim_set_hl(0, "BlinkCmpLabel", { fg = "#c0caf5" })
        vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { fg = "#7aa2f7", bold = true })
        vim.api.nvim_set_hl(0, "BlinkCmpKind", { fg = "#9d7cd8" })
        vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "#1a1b26" })
        vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = "#7aa2f7" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1a1b26" })
        vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#7aa2f7" })
        vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#c0caf5", bold = true })
    end,
}

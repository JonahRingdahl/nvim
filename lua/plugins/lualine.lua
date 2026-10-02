return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("lualine").setup({
            -- Shipped with cyberdream.nvim, keeps the statusline on-palette.
            options = { theme = "cyberdream" },
        })
    end,
}
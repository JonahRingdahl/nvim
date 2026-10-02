-- Color scheme: cyberdream (high-contrast, vibrant).
return {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("cyberdream").setup({
            variant = "default",
            -- Opaque background, matching the previous carbonfox setup.
            transparent = false,
            extensions = {
                -- Only the plugins actually installed here; the base highlight
                -- groups are always loaded by cyberdream itself.
                default = false,
                blinkcmp = true,
                dapui = true,
                gitsigns = true,
                lazy = true,
                markdown = true,
                noice = true,
                notify = true,
                snacks = true,
                telescope = true,
                treesitter = true,
                trouble = true,
                whichkey = true,
            },
        })

        vim.cmd("colorscheme cyberdream")
    end,
}

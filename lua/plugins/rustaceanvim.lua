return {
    "mrcjkb/rustaceanvim",
    version = "^9",
    lazy = false,
    init = function()
        vim.g.rustaceanvim = {
            tools = {
                inlay_hints = {
                    enabled = true,
                },
            },
        }
    end,
}
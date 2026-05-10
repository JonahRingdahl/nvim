return {
    "GustavEikaas/easy-dotnet.nvim",
    ft = { "cs", "csproj", "sln", "slnx", "props", "csx", "targets" },
    cmd = "Dotnet",
    config = function()
        local dotnet = require("easy-dotnet")

        dotnet.setup({
            debugger = {
                external_terminal = "alacritty",
                console = "integratedTerminal",
            },
            mappings = {
                run_project = "<C-p>",
            },
            lsp = {
                config = {
                    ["csharp|formatting"] = {
                        use_tab = false,
                        tab_size = 4,
                        indent_size = 4,
                    },
                },
            },
        })

        vim.keymap.set("n", "<C-p>", function()
            dotnet.run_project()
        end, { desc = "Run .NET project" })
    end,
}
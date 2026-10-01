return {
  "GustavEikaas/easy-dotnet.nvim",
  ft = { "cs", "csproj", "sln", "slnx", "props", "csx", "targets" },
  cmd = "Dotnet",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/snacks.nvim",
    "mfussenegger/nvim-dap",
  },
  config = function()
    local dotnet = require("easy-dotnet")

    dotnet.setup({
      -- Use the snacks picker for all of easy-dotnet's pickers.
      picker = "snacks",
      managed_terminal = {
        auto_hide = true,
        auto_hide_delay = 1000,
      },
      -- easy-dotnet ships its own Roslyn LSP; no separate roslyn server needed.
      lsp = {
        enabled = true,
        preload_roslyn = true,
        config = {
          ["csharp|formatting"] = {
            use_tab = false,
            tab_size = 4,
            indent_size = 4,
          },
        },
      },
      -- netcoredbg is provided by easy-dotnet-server; auto registers the DAP
      -- adapter and debug configurations for cs/fsharp buffers.
      debugger = {
        engine = "netcoredbg",
        console = "integratedTerminal",
        auto_register_dap = true,
      },
      external_terminal = {
        command = "alacritty",
        args = { "-e" },
      },
      test_runner = {
        auto_start_testrunner = true,
        viewmode = "float",
      },
      auto_bootstrap_namespace = {
        type = "block_scoped",
        enabled = true,
      },
    })

    vim.keymap.set("n", "<C-p>", function()
      dotnet.run_profile_default()
    end, { desc = "Run .NET project" })
  end,
}

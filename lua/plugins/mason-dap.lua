return {
  "jay-babu/mason-nvim-dap.nvim",
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "mfussenegger/nvim-dap",
  },
  opts = {
    ensure_installed = {
      "codelldb",
      "netcoredbg",
      "debugpy",
    },
    automatic_installation = true,
  },
}

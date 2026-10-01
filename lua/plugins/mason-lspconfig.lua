return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  },
  opts = {
    ensure_installed = {
      "html",
      "cssls",
      "ts_ls",
      "ols",
      "zls",
      "clangd",
      "lua_ls",
    },
    automatic_enable = {
      exclude = { "rust_analyzer" },
    },
  },
}


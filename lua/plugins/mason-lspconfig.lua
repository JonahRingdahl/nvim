return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
  config = function()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "html",
        "cssls",
        "ts_ls",
        "ols",
        "zls",
        "clangd",
        "lua_ls",
      },
      automatic_installation = true,
      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = require('blink.cmp').get_lsp_capabilities(),
            on_attach = function(client, bufnr)
            end,
          })
        end,
        ["rust_analyzer"] = function()
          require("lspconfig").rust_analyzer.setup({
            capabilities = require('blink.cmp').get_lsp_capabilities(),
            on_attach = function(client, bufnr)
            end,
            settings = {
              ["rust-analyzer"] = {
                formatting = {
                  use_tab = false,
                  tab_size = 2,
                  indent_width = 2,
                },
              },
            },
          })
        end,
        ["clangd"] = function()
          require("lspconfig").clangd.setup({
            capabilities = require('blink.cmp').get_lsp_capabilities(),
            on_attach = function(client, bufnr)
            end,
            settings = {
              clangd = {
                formatting = {
                  use_tab = false,
                  tab_size = 2,
                  indent_width = 2,
                },
              },
            },
          })
        end,
      },
    })
  end,
}


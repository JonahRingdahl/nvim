-- LSP client configuration via the native Neovim 0.11+ API.
-- Servers are enabled by mason-lspconfig automatically; this file only adds
-- global keybindings and buffer behaviour on attach.

local function on_attach(ev)
  local opts = { buffer = ev.buf }

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "LSP goto definition" }))
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "LSP goto declaration" }))
  vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "LSP references" }))
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "LSP goto implementation" }))
  vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "LSP hover" }))
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "LSP signature help" }))
  -- LSP actions live under <leader>c. <leader>a belongs to agentic.nvim.
  vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "LSP rename" }))
  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "LSP code action" }))
  vim.keymap.set("n", "<leader>ci", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, vim.tbl_extend("force", opts, { desc = "Toggle inlay hints" }))

  -- Format on save, only when the buffer has a real filetype
  local group = vim.api.nvim_create_augroup("LspFormat." .. ev.buf, { clear = true })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    buffer = ev.buf,
    callback = function()
      vim.lsp.buf.format({ bufnr = ev.buf, async = true })
    end,
  })
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = on_attach,
})

-- Base capabilities for every server. blink.cmp's plugin file reads these and
-- merges its own on top when it loads, so completion works without ordering
-- concerns. Must be a table, not a function: blink passes it straight through.
vim.lsp.config("*", {
  capabilities = vim.lsp.protocol.make_client_capabilities(),
})

-- Per-server settings that need to apply to every instance of that server.
vim.lsp.config("clangd", {
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

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim", "Snacks" } },
      workspace = { checkThirdParty = false },
    },
  },
})

-- easy-dotnet's Roslyn client. Neovim's file watching is more accurate than the
-- server's, and this machine's fd limit is high, so opt in explicitly.
vim.lsp.config("easy_dotnet", {
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
})

-- LSP handlers customized via noice

-- Rust-specific keymaps. rustaceanvim creates a :RustLsp command on attach,
-- so these are only defined when that command actually exists.
local bufnr = vim.api.nvim_get_current_buf()
local has_rust_lsp = vim.fn.exists(":RustLsp") == 2

if has_rust_lsp then
  vim.keymap.set("n", "<leader>a", "<cmd>RustLsp codeAction<cr>", { silent = true, buffer = bufnr, desc = "Rust LSP code action" })
  vim.keymap.set("n", "K", "<cmd>RustLsp hover actions<cr>", { silent = true, buffer = bufnr, desc = "Rust LSP hover actions" })
end

-- General keybindings that aren't tied to specific plugins

vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split pane vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split pane horizontally" })

-- Open Terminal in new pane
vim.keymap.set("n", "<leader><Return>", "<C-w>s<C-w>j:terminal<CR>", { desc = "Open Terminal" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Escape from terminal" })

-- navigate panes
vim.keymap.set("n", "<leader>h", "<C-w>h", { desc = "Navigate pane left" })
vim.keymap.set("n", "<leader>j", "<C-w>j", { desc = "Navigate pane down" })
vim.keymap.set("n", "<leader>k", "<C-w>k", { desc = "Navigate pane up" })
vim.keymap.set("n", "<leader>l", "<C-w>l", { desc = "Navigate pane right" })

-- close current pane
vim.keymap.set("n", "<leader>q", ":close<CR>", { desc = "Close current pane" })

-- Close nvim
vim.keymap.set("n", "<leader>Q", ":qa!<CR>", { desc = "Close nvim" })

-- File finding: snacks.nvim owns these keys (see lua/plugins/snacks.lua).
-- <leader>ff find files, <leader>fg live grep, <leader>fs grep word,
-- <leader>fb buffers, <leader>fr recent, <leader>fp projects.
--
-- Telescope remains available for its own pickers and is kept as a dependency
-- of easy-dotnet, so keep a few direct entry points:
vim.keymap.set("n", "<leader>tf", require("telescope.builtin").find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>tg", require("telescope.builtin").live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>tb", require("telescope.builtin").buffers, { desc = "Telescope buffers" })

-- Utility keybindings
vim.keymap.set("n", "<leader>th", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })

-- DAP keybindings are set in lua/plugins/dap.lua once nvim-dap has loaded.

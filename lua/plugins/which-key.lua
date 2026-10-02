-- Keymap hints: shows a popup of available mappings as you type the leader.
return {
  "folke/which-key.nvim",
  -- VeryLazy (not a keymap trigger) so the automatic <leader> triggers exist
  -- before you press anything.
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = 200,
    win = {
      border = "rounded",
      padding = { 1, 2 },
      wo = { winblend = 10 },
    },
    spec = {
      -- Window management reuses the <C-w> defaults, so no new mapping needed.
      { "<leader>w", proxy = "<c-w>", group = "windows" },
      { "<leader>f", group = "find" },
      { "<leader>s", group = "split" },
      { "<leader>t", group = "terminal / telescope" },
      { "<leader>d", group = "debug" },
      { "<leader>q", group = "quit" },
      { "<leader>a", group = "agentic" },
      { "<leader>c", group = "code action / rename / inlay hints" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer local keymaps (which-key)",
    },
  },
}

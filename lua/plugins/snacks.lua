return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    picker = {
      ui_select = true,
      layout = {
        preset = function()
          return vim.o.columns >= 120 and "default" or "vertical"
        end,
      },
    },
  },
  keys = {
    {
      "<leader>ff",
      function()
        require("snacks").picker.files()
      end,
      desc = "Snacks find files",
    },
    {
      "<leader>fg",
      function()
        require("snacks").picker.grep()
      end,
      desc = "Snacks live grep",
    },
    {
      "<leader>fs",
      function()
        require("snacks").picker.grep_word()
      end,
      desc = "Snacks grep word",
      mode = { "n", "x" },
    },
    {
      "<leader>fb",
      function()
        require("snacks").picker.buffers()
      end,
      desc = "Snacks buffers",
    },
    {
      "<leader>fr",
      function()
        require("snacks").picker.recent()
      end,
      desc = "Snacks recent",
    },
    {
      "<leader>fp",
      function()
        require("snacks").picker.projects()
      end,
      desc = "Snacks projects",
    },
  },
}

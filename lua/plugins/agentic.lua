-- Agentic chat, driven by opencode via the ACP provider.
--
-- Keys are a pure prefix group under <leader>a so which-key lists them:
--   <leader>aa  toggle chat
--   <leader>ac  add file/visual selection to the context
--   <leader>an  new session
--
-- These deliberately replaced the previous <C-\>, <C-'> and <C-,> bindings.
-- Note <leader>a used to be LSP code action; that now lives on <leader>ca.
return {
  "carlos-algms/agentic.nvim",
  opts = {
    provider = "opencode-acp",
  },
  keys = {
    {
      "<leader>aa",
      function()
        require("agentic").toggle()
      end,
      mode = { "n", "i" },
      desc = "Toggle Agentic Chat",
    },
    {
      "<leader>ac",
      function()
        require("agentic").add_selection_or_file_to_context()
      end,
      mode = { "n", "v" },
      desc = "Add file/selection to context",
    },
    {
      "<leader>an",
      function()
        require("agentic").new_session()
      end,
      mode = { "n" },
      desc = "New Agentic Session",
    },
  },
}
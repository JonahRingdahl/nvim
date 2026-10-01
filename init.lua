require("vim._core.ui2").enable({})

-- ~/.local/bin holds tree-sitter (nvim-treesitter) and dotnet-easydotnet, but it
-- is not on the fish PATH. Prepend it so child processes and mason tools find them.
local user_bin = vim.fn.expand("~/.local/bin")
if vim.fn.isdirectory(user_bin) == 1 then
  vim.env.PATH = user_bin .. ":" .. vim.env.PATH
end

require("config.lazy")
require("config.lsp")
require("config.diagnostics")
require("config.keys")
require("config.options")

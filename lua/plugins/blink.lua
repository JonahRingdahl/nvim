-- The documentation popout should never be shorter than the suggestion list.
local min_doc_height = 10

-- Hover docs regularly contain ``` fenced code blocks. nvim-treesitter's
-- injection handling crashes when blink parses the popout buffer as markdown
-- (`attempt to call method 'range' (a nil value)`), which kills the whole
-- render. Dropping the language tag keeps the fence as a plain markdown code
-- block, so the docs still render instead of erroring.
local function drop_code_fence_langs(documentation)
    if type(documentation) ~= "table" or type(documentation.value) ~= "string" then
        return documentation
    end

    local lines = {}
    for _, line in ipairs(vim.split(documentation.value, "\n", { plain = true })) do
        local indent, fence = line:match("^(%s*)(```+)%s*%w+%s*$")
        table.insert(lines, indent and (indent .. fence) or line)
    end

    return { kind = documentation.kind or "markdown", value = table.concat(lines, "\n") }
end

return {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
        "rafamadriz/friendly-snippets",
    },
    config = function()
         require("blink.cmp").setup({
             keymap = {
                 preset = "default",
                 ["<CR>"] = { "accept", "fallback" },
                 ["<Tab>"] = { "select_next", "fallback" },
                 ["<S-Tab>"] = { "select_prev", "fallback" },
                 ["<C-e>"] = { "cancel", "fallback" },
             },
             appearance = {
                 nerd_font_variant = "mono",
             },
             sources = {
                 default = { "lsp", "path", "snippets", "buffer" },
                 providers = {
                     lsp = {
                         name = "blink.cmp.lsp",
                         module = "blink.cmp.sources.lsp",
                     },
                     path = {
                         name = "blink.cmp.path",
                         module = "blink.cmp.sources.path",
                     },
                     snippets = {
                         name = "blink.cmp.snippets",
                         module = "blink.cmp.sources.snippets",
                     },
                     buffer = {
                         name = "blink.cmp.buffer",
                         module = "blink.cmp.sources.buffer",
                     },
                 },
             },
             completion = {
                 menu = {
                     border = "rounded",
                     winblend = 10,
                     -- Keep the suggestion list compact so the documentation
                     -- window beside it stays large enough to read.
                     max_height = 8,
                     min_width = 20,
                     scrolloff = 1,
                     draw = {
                         columns = { { "kind_icon", "label", "label_description", gap = 1 } },
                         components = {
                             label = { width = { fill = true, max = 30 } },
                             label_description = { width = { max = 20 } },
                         },
                     },
                 },
                 documentation = {
                     -- Second window: pops open next to the menu with the LSP
                     -- hover docs for the selected completion item.
                     auto_show = true,
                     auto_show_delay_ms = 0,
                     -- Blink requires >= 50ms; keeps the window from flickering
                     -- when the selection changes while scrolling the menu.
                     update_delay_ms = 100,
                     draw = function(opts)
                         local documentation = drop_code_fence_langs(opts.item.documentation)

                         -- Never let one bad hover break the popout.
                         if not pcall(opts.default_implementation, { documentation = documentation }) then
                             pcall(opts.default_implementation, {
                                 documentation = documentation,
                                 use_treesitter_highlighting = false,
                             })
                         end

                         -- Pad with empty lines so the popout is at least as
                         -- tall as the suggestion list next to it.
                         local menu = require("blink.cmp.completion.windows.menu")
                         local target = math.max(menu.win:get_height(), min_doc_height)
                         local bufnr = opts.window:get_buf()
                         local current = vim.api.nvim_buf_line_count(bufnr)
                         if current < target then
                             local padding = {}
                             for _ = current + 1, target do
                                 table.insert(padding, "")
                             end
                             vim.api.nvim_set_option_value("modifiable", true, { buf = bufnr })
                             vim.api.nvim_buf_set_lines(bufnr, current, current, false, padding)
                             vim.api.nvim_set_option_value("modified", false, { buf = bufnr })
                             vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })
                         end
                     end,
                     window = {
                         border = "rounded",
                         winblend = 0,
                         min_width = 60,
                         max_width = 110,
                         max_height = 30,
                         desired_min_width = 70,
                         desired_min_height = 16,
                         scrollbar = true,
                         -- Always east/west of the menu so it reads as a second
                         -- window instead of stacking above/below the list.
                         direction_priority = {
                             menu_north = { "e", "w" },
                             menu_south = { "e", "w" },
                         },
                     },
                 },
             },
         })
    end,
}
# AGENTS.md

This repository is a Neovim configuration using Lua and the lazy.nvim plugin manager. This guide helps agentic coding agents understand the codebase structure and conventions.

Target: **Neovim 0.12.5** on Linux/Wayland, with `mapleader = " "` and `maplocalleader = "\\"`.

## Project Structure

```
.
├── init.lua                 # Entry point: PATH fix, ui2, then config.* requires
├── lazy-lock.json           # Plugin lockfile
├── after/
│   └── ftplugin/rust.lua    # Rust buffer-local keymaps (guarded on :RustLsp)
└── lua/
    ├── config/              # Loaded directly by init.lua
    │   ├── lazy.lua         # Bootstrap + lazy.nvim setup
    │   ├── options.lua      # Basic editor options
    │   ├── keys.lua         # Keybindings not owned by a plugin
    │   ├── lsp.lua          # vim.lsp.config + LspAttach keymaps
    │   └── diagnostics.lua  # vim.diagnostic.config
    └── plugins/             # lazy.nvim specs, auto-imported by lua/config/lazy.lua
        ├── agentic.lua      # agentic.nvim (opencode-acp provider)
        ├── autopair.lua     # Auto bracket pairing
        ├── blink.lua        # Completion engine
        ├── cyberdream.lua   # Color scheme
        ├── dap.lua          # nvim-dap + dap-ui + virtual text
        ├── easy-dotnet.lua  # C#/F# LSP, DAP, test runner, solution tree
        ├── gitsigns.lua     # Git integration
        ├── lualine.lua      # Status line
        ├── mason.lua        # Tool installer
        ├── mason-dap.lua    # Installs DAP servers (codelldb, netcoredbg, debugpy)
        ├── mason-lspconfig.lua # Installs + auto-enables LSP servers
        ├── noice.lua        # LSP progress / command UI
        ├── rustaceanvim.lua # rust-analyzer (owns rust_analyzer)
        ├── snacks.lua       # snacks.nvim picker (primary find UX)
        ├── supermaven.lua   # AI completion
        ├── telescope.lua    # Telescope (secondary finder)
        ├── todo-comments.lua # TODO highlighting
        ├── trouble.lua      # Diagnostics viewer
        ├── ts.lua           # nvim-treesitter (branch = "master")
        └── which-key.lua    # Keymap hint popup on <leader>
```

Note: there is no `roslyn.lua`. easy-dotnet ships and manages Roslyn itself, so a separate C# LSP spec is not needed.

## Build/Lint/Test Commands

No build system. Validation happens on Neovim startup.

- **Load config**: `nvim`
- **Plugin management**: `:Lazy`
- **Sync**: `nvim --headless -c 'Lazy! sync' -c 'qa'`
- **Health**: `:checkhealth` (or `:checkhealth snacks`, `:checkhealth lsp`, ...)

### Verifying a change headlessly

`--headless` is fine for most checks. Two known headless-only artifacts, not real bugs:

- `:checkhealth snacks` may report `` `vim.ui.select` is not set to `Snacks.picker.select` ``. snacks loads the picker on the `UIEnter` autocmd, which does not fire in headless. Run health after `UIEnter` (from a `VimEnter` autocmd + `vim.schedule`) to see the real result.
- Anything gated on `Insert`/`BufRead` events (blink, gitsigns, treesitter, supermaven, autopairs) will not have loaded yet. Force them with `require("lazy").load({ plugins = { "<name>" } })` before `require`-ing.

### Single File Testing

1. Start Neovim: `nvim`
2. Reload a config file: `:lua dofile('lua/config/options.lua')`
3. Confirm: `:lua print("ok")`

## Code Style Guidelines

### General Lua Style
- 2 spaces for indentation, `expandtab`, `smartindent` (see `options.lua`)
- Lua 5.1 / LuaJIT compatible syntax

### Module Structure
Plugin spec:
```lua
return {
    "plugin-author/plugin-name",
    opts = { ... },          -- preferred; lazy calls setup() for you
    config = function(_, opts) -- use when the plugin has no setup(), or to key off opts
        ...
    end,
}
```

Config module:
```lua
vim.opt.some_option = true
vim.keymap.set("n", "<leader>key", function() end, { desc = "Description" })
```

### Naming Conventions
- **Files**: lowercase with hyphens (`mason-lspconfig.lua`)
- **Locals/functions**: `snake_case`
- **Options**: `vim.opt.option_name = value`

### Plugin Configuration Patterns
- Prefer `opts = {}` over `config = function() ... require(...) end`; lazy.nvim calls the plugin's `setup()` for you
- Declare `dependencies` explicitly
- Repo names matter: mason is `mason-org/*`, but the DAP installer is still `jay-babu/mason-nvim-dap.nvim` (there is no `mason-org/mason-nvim-dap`)

### Keybinding Conventions
- `<leader>` for custom mappings, always with `desc` for which-key
- Plugin-owned keys live in that plugin's `keys` table, not in `config/keys.lua`
- `config/keys.lua` only holds keys with no plugin owner; comment it when a key deliberately moves to a plugin

Current keymap surface:

| Group | Keys |
| --- | --- |
| Find (snacks) | `<leader>ff` files, `fg` live grep, `fs` grep word, `fb` buffers, `fr` recent, `fp` projects |
| Find (telescope) | `<leader>tf`, `tg`, `tb` |
| Windows | `<leader>sv` split right, `sh` split below, `h/j/k/l` navigate, `q` close pane, `Q` quit |
| Terminal | `<leader><Return>` new pane, `<Esc>` in terminal-mode |
| Debugging | `<F5>` continue, `<F10>` over, `<F11>` into, `<F12>` out, `<leader>b` breakpoint, `<leader>dr` REPL |
| LSP goto | `gd` definition, `gD` declaration, `gr` references, `gi` implementation, `K` hover, `<C-k>` signature help |
| LSP code | `<leader>ca` code action, `<leader>cr` rename, `<leader>ci` toggle inlay hints |
| .NET | `<C-p>` run profile |
| Agentic | `<leader>aa` toggle chat, `<leader>ac` add context, `<leader>an` new session |
| Hints | `<leader>?` buffer-local keymaps |

### Current Plugin Ecosystem
- **Find**: `snacks.nvim` picker is primary; `telescope.nvim` kept (also an easy-dotnet dependency)
- **Completion**: `blink.cmp` (LSP, path, snippets, buffer)
- **LSP**: `mason.nvim` + `mason-lspconfig.nvim`; `clangd` for C/C++, `rust-analyzer` via `rustaceanvim` for Rust, Roslyn via `easy-dotnet` for C#/F#
- **Debugging**: `nvim-dap` + `nvim-dap-ui` + `nvim-dap-virtual-text`; `mason-nvim-dap` installs servers
- **Git**: `gitsigns.nvim`
- **UI**: `noice.nvim`, `lualine.nvim` (cyberdream theme), `cyberdream.nvim`
- **Utilities**: `nvim-autopairs`, `todo-comments.nvim`, `trouble.nvim`
- **AI**: `supermaven-nvim` (inline), `agentic.nvim` (chat, via `opencode-acp`)
- **Syntax**: `nvim-treesitter` on `branch = "master"`
- **Hints**: `which-key.nvim` v3 on `VeryLazy`; `<leader>w` is a proxy for `<c-w>`, not a real mapping
- `<leader>a` is agentic, `<leader>c` is LSP code actions. LSP goto keys stay unprefixed (`gd`, `gr`, `K`) since they get typed constantly.

### LSP Configuration
- Uses the native `vim.lsp.config` / `LspAttach` API (Neovim 0.11+). Do **not** reintroduce `williamboman/*` repos or `handlers = {}`; those are dead in mason-lspconfig v2.
- `capabilities` must be a **table**, not a function: blink reads `vim.lsp.config["*"].capabilities` directly.
- Attach keymaps in the `LspAttach` autocmd; format on save in a buffer-scoped `BufWritePre` augroup.
- `rust_analyzer` is excluded from mason-lspconfig's `automatic_enable` — rustaceanvim manages it, and manual setup conflicts.

## Common Patterns

### Adding a New Plugin
1. Create `lua/plugins/plugin-name.lua`
2. Return the spec (prefer `opts = {}`)
3. Put keybindings in the spec's `keys` table
4. Verify: `nvim --headless -c 'Lazy! sync' -c 'qa'`, then `require` it

### Debugging Configuration
- `:lua vim.print(value)` to inspect
- `:checkhealth <plugin>` for a focused report
- Reload with `:lua dofile('init.lua')`

## Environment Notes

- `init.lua` prepends `~/.local/bin` to `$PATH`; the fish shell does not include it. `tree-sitter` and `dotnet-easydotnet` are installed there.
- C# setup uses `dotnet-easydotnet` (a `dotnet tool` in `~/.local/bin`) plus easy-dotnet.nvim, with `alacritty` as the external terminal.
- No `sudo` access; system-wide installs are not possible.
- Optional, not installed: `wl-clipboard`/`xdg-utils` (system clipboard, needed for agentic image paste), `dotnet-ef` (EF migrations), `lazygit`, kitty/wezterm/ghostty (snacks image rendering).

## Notes for Agents
- Personal Neovim config; modify with care
- Plugin versions pinned in `lazy-lock.json`
- LSP formatting runs on save automatically
- Keep the config minimal and functional; prefer removing a spec over layering workarounds

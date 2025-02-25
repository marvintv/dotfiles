# Neovim LazyVim Configuration Reference

## Plugin Management
### Fixing nvim-cmp Module Load Issues
- Set `lazy = false` and high `priority` for nvim-cmp to ensure it loads first
- All completion sources should be declared as direct dependencies of nvim-cmp:
  ```lua
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    priority = 1000,
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local cmp = require("cmp")
      -- setup code
    end
  }
  ```
- Add source module preload protection in init.lua:
  ```lua
  -- Global protection for cmp sources
  for _, source in ipairs({ "buffer", "path", "nvim_lsp" }) do
    package.preload["cmp_" .. source] = function()
      local cmp_ok, cmp = pcall(require, "cmp")
      if not cmp_ok then
        error("cmp not loaded when requiring cmp_" .. source)
      end
      return require("cmp_" .. source .. ".core")
    end
  end
  ```
- Use standard LSP capabilities setup pattern:
  ```lua
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if status then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end
  ```

## System Environment
- Using zsh shell (`/bin/zsh`)
- macOS system

## Plugin Loading Behavior
- All custom plugins load at startup by default (`lazy = false` in config/lazy.lua)
- To make a plugin lazy-loaded, explicitly set `lazy = true` in its config
- Common lazy-loading triggers: `event`, `cmd`, `ft`, and `keys`

## Custom Keymaps
- `<leader>e` - Toggle Neo-tree file explorer
- `<leader>ff/fg/fb` - Telescope find files/grep/buffers
- `<leader>/` - Toggle comments (also `gcc` for line, `gc` for motion)
- `<leader>w` - Save current buffer
- `<leader>p/n` - Previous/next buffer
- `<leader>x` - Close buffer

## Markdown Preview
- Open a markdown file (*.md)
- Use `<leader>mp` or `:MarkdownPreviewToggle` to toggle preview
- Use `:MarkdownPreview` to start preview in browser
- Use `:MarkdownPreviewStop` to stop preview
- Uses macOS default browser via `open` command
- Preview URL is displayed in the messages (check with `:messages`)
- Troubleshooting: If browser doesn't open, check that:
  1. Node.js is installed (run `node --version` in terminal)
  2. Try running the URL manually from terminal: `open http://127.0.0.1:8090`
  3. Try `:call mkdp#util#install()` to reinstall dependencies
  4. Check if the server is running: `lsof -i :8090`

## Common Commands

### Configuration Management
- Reload configuration: `:source $MYVIMRC` or `:so %`
- Check health: `:checkhealth`

### Plugin Management (Lazy.nvim)
- Open plugin manager: `:Lazy`
- Install plugins: `:Lazy install`
- Update plugins: `:Lazy update`
- Clean removed plugins: `:Lazy clean`

### LSP and Linting
- LSP information: `:LspInfo`
- Format document: `:lua vim.lsp.buf.format()`
- Mason package manager: `:Mason`

### Telescope (File Finding)
- Find files: `<leader>ff` or `:Telescope find_files`
- Live grep: `<leader>fg` or `:Telescope live_grep`
- Browse buffers: `<leader>fb` or `:Telescope buffers`

## Lua Style Guidelines

### Code Style
- Indentation: 2 spaces (per stylua.toml)
- Max line width: 120 columns

### Organization
- `init.lua` bootstraps lazy.nvim
- `lua/config/` holds core configuration
- `lua/plugins/` contains plugin specifications

### Plugin Declaration Format
```lua
return {
  {
    "plugin/name",
    dependencies = { "dependency/name" },
    opts = {
      -- configuration options
    },
  },
}
```

### Common Patterns
- Use `vim.keymap.set("mode", "keys", "command", { desc = "Description" })`
- LazyVim plugins can be disabled with `enabled = false`
- Add new plugins by creating files in `lua/plugins/`

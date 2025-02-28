-- bootstrap lazy.nvim, LazyVim and your plugins
-- Set high-priority options early (like PATH modification)
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
vim.env.PATH = mason_bin .. ":" .. vim.env.PATH

-- Set up completion options before loading plugins
vim.opt.completeopt = "menu,menuone,noselect"

-- Global flag to prevent duplicate completion setup
_G.cmp_setup_complete = false

-- Disable lazy-loading for nvim-cmp to ensure it loads first
vim.g.cmp_lazy_loaded = false

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

-- Bootstrap lazy.nvim
require("config.lazy")

-- disable auto spell check
vim.opt.spell = true

-- enable cursorline
vim.opt.cursorline = true

-- set the cursor to a thin vertical line

vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

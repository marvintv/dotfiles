-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope lsp_references<CR>", { desc = "Find references" })

-- Map to find references using LSP
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })

-- Map to highlight current word (like * but without moving cursor)
vim.keymap.set("n", "<leader>h", "*N", { desc = "Highlight current word" })

-- Turn off search highlighting with leader key
vim.keymap.set("n", "<leader>n", ":noh<CR>", { silent = true, desc = "Clear search highlight" })

-- Markdown Preview
vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Toggle Markdown Preview" })

-- yank to clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])

-- yank entire file to clipboard
vim.keymap.set("n", "<leader>ya", "<cmd>%y+<CR>", { desc = "Yank entire file to clipboard" })

-- save file
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })

-- Reset file to last saved state
vim.keymap.set("n", "<leader>r", ":e!<CR>", { silent = true, desc = "Reset file to last saved state" })

-- Terminal
vim.keymap.set("n", "<C-_>", function()
  require("lazyvim.util.terminal").open(nil, { cwd = require("lazyvim.util").root() })
end, { desc = "Terminal (Root Dir)" })

vim.keymap.set("t", "<C-_>", "<cmd>close<CR>", { desc = "Hide Terminal", noremap = true, silent = true })

-- format code using Telescope
vim.keymap.set("n", "<leader>fmd", vim.lsp.buf.format)

-- Oil.nvim
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

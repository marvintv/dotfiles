-- keymaps are automatically loaded on the verylazy event
-- default keymaps that are always set: https://github.com/lazyvim/lazyvim/blob/main/lua/lazyvim/config/keymaps.lua
-- add any additional keymaps here

-- telescope - using function calls directly instead of commands
vim.keymap.set("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { desc = "find files" })
vim.keymap.set("n", "<leader>fg", function() require("telescope.builtin").live_grep() end, { desc = "live grep" })
vim.keymap.set("n", "<leader>fb", function() require("telescope.builtin").buffers() end, { desc = "buffers" })
vim.keymap.set("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, { desc = "help tags" })
vim.keymap.set("n", "<leader>fr", function() require("telescope.builtin").lsp_references() end, { desc = "find references" })

-- map to find references using lsp
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "go to references" })

-- map to highlight current word (like * but without moving cursor)
vim.keymap.set("n", "<leader>h", "*n", { desc = "highlight current word" })

-- turn off search highlighting with leader key
vim.keymap.set("n", "<leader>n", ":noh<cr>", { silent = true, desc = "clear search highlight" })

-- markdown preview
vim.keymap.set("n", "<leader>mp", "<cmd>markdownpreviewtoggle<cr>", { desc = "toggle markdown preview" })

-- yank to clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])

-- yank entire file to clipboard
vim.keymap.set("n", "<leader>ya", "<cmd>%y+<cr>", { desc = "yank entire file to clipboard" })

-- save file
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "save file" })

-- reset file to last saved state
vim.keymap.set("n", "<leader>r", ":e!<cr>", { silent = true, desc = "reset file to last saved state" })

--
vim.keymap.set("n", "<leader>t", function()
  if vim.bo.buftype == "nofile" then
    vim.cmd("hide")
  else
    vim.cmd("enew")
  end
end, { desc = "toggle between hiding nofile buffer or creating new buffer" })

-- terminal
vim.keymap.set("n", "<c-_>", function()
  require("lazyvim.util.terminal").open(nil, { cwd = require("lazyvim.util").root() })
end, { desc = "terminal (root dir)" })
-- terminal
vim.keymap.set("t", "<c-_>", "<cmd>close<cr>", { desc = "hide terminal", noremap = true, silent = true })

-- format code using telescope
vim.keymap.set("n", "<leader>fmd", vim.lsp.buf.format)

-- Oil.nvim
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

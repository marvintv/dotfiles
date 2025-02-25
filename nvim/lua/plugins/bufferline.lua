return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              separator = true,
              padding = 1,
            },
          },
          separator_style = "thin",
        },
      })

      -- Custom keymaps for buffer navigation
      -- <leader>w to save

      -- <leader>p to toggle to previous buffer (:bp)
      vim.keymap.set("n", "<leader>p", ":bp<CR>", { desc = "Previous buffer" })

      -- <leader>n to toggle to next buffer (:bn)
      vim.keymap.set("n", "<leader>n", ":bn<CR>", { desc = "Next buffer" })

      -- <leader>x to close buffer (:bd)
      vim.keymap.set("n", "M-x", ":bd<CR>", { desc = "Close buffer" })
    end,
  },
}


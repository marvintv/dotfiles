return {
  {
    "terrortylor/nvim-comment",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim_comment").setup({
        -- Create default mappings (gcc, gc)
        create_mappings = true,
        -- Normal mode mapping (gc + motion)
        operator_mapping = "gc",
        -- Comment empty lines
        comment_empty = false,
        -- Hook functions to run after commenting
        hook = nil,
      })
      
      -- Additional keymaps (optional)
      vim.keymap.set("n", "<leader>/", ":CommentToggle<CR>", { desc = "Toggle comment" })
      vim.keymap.set("v", "<leader>/", ":CommentToggle<CR>", { desc = "Toggle comment" })
    end,
  },
}
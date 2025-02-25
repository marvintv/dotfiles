return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>mp", "<cmd>ObsidianPreview<CR>", desc = "Obsidian Markdown Preview" },
    },
    config = function()
      require("obsidian").setup({
        workspaces = {
          {
            name = "personal",
            path = "~/notes",
          },
        },
        new_notes_location = "current_dir",
        disable_frontmatter = false,
      })
    end,
  },
}
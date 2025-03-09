return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          file_ignore_patterns = {
            "%.git/.*",
            "node_modules/.*",
          },
          path_display = { "truncate" },
          -- Simplified pattern to avoid NFA regexp errors
          generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
          file_sorter = require("telescope.sorters").get_fuzzy_file(),
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        },
      })
      -- Load extensions
      require("telescope").load_extension("fzf")
    end,
  },
}

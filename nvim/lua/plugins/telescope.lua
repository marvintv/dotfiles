return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    -- Force telescope to be loaded immediately
    lazy = false,
    priority = 9999,
    config = function()
      -- First load the module
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      
      -- Setup configuration
      telescope.setup({
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
        pickers = {
          live_grep = {
            additional_args = function(opts)
              return {"--hidden"}
            end
          },
        },
      })
      
      -- Load the FZF extension
      pcall(telescope.load_extension, "fzf")
      
      -- Create Vim commands
      vim.api.nvim_create_user_command("Telescope", function(opts)
        require("telescope.command").load(opts)
      end, { nargs = "*", complete = require("telescope.command").complete })
      
      -- Set keymaps directly with function calls
      vim.keymap.set("n", "<leader>ff", function() builtin.find_files() end, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fg", function() builtin.live_grep() end, { desc = "Live Grep" })
      vim.keymap.set("n", "<leader>fb", function() builtin.buffers() end, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fh", function() builtin.help_tags() end, { desc = "Help Tags" })
      vim.keymap.set("n", "<leader>fr", function() builtin.lsp_references() end, { desc = "Find References" })
      
      -- Fixed user commands for direct access
      vim.api.nvim_create_user_command("TelescopeFindFiles", function() builtin.find_files() end, {})
      vim.api.nvim_create_user_command("TelescopeLiveGrep", function() builtin.live_grep() end, {})
      vim.api.nvim_create_user_command("TelescopeBuffers", function() builtin.buffers() end, {})
      vim.api.nvim_create_user_command("TelescopeHelpTags", function() builtin.help_tags() end, {})
    end,
  },
}

return {
  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,  -- Recommended build method
    config = function()
      -- Debug: Show preview URL in messages
      vim.g.mkdp_echo_preview_url = 1
      
      -- Set filetypes
      vim.g.mkdp_filetypes = { "markdown" }
      
      -- Use macOS open command via custom function
      vim.g.mkdp_browserfunc = function(url)
        vim.notify("Markdown preview URL: " .. url)
        vim.fn.system({"open", url})  -- Uses macOS default browser
      end
      
      -- Custom page title
      vim.g.mkdp_page_title = '${name} - Markdown Preview'
      
      -- Port settings (fix for macOS)
      vim.g.mkdp_port = '8090'
      
      -- Refresh on events
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_preview_options = {
        sync_scroll_type = 'middle',
      }
    end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", desc = "Toggle Markdown Preview" },
    },
  },
  
  -- Surround plugin (similar to vim-surround)
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  
  -- Todo comments highlighting and navigation
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find TODOs" },
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
    },
  },
}

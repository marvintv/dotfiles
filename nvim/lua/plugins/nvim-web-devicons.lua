return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false, -- Make sure it loads immediately
    config = function()
      require("nvim-web-devicons").setup({
        -- Override icon colors with your colorscheme if needed
        override_by_filename = {
          -- Add specific file overrides here if needed
        },
        -- Enable folder icons
        strict = true,
        -- Don't get overridden by devicons
        default = true,
      })
      
      -- Force reload of neo-tree to update icons
      if package.loaded["neo-tree"] then
        vim.defer_fn(function()
          vim.cmd("Neotree close")
          vim.cmd("Neotree show")
        end, 100)
      end
    end,
  },
}
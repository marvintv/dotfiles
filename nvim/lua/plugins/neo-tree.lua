return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  lazy = false, -- Ensure it's loaded at startup
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-tree/nvim-web-devicons", 
      lazy = false -- Ensure web-devicons loads at startup
    },
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true,
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
      },
    })
  end,
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle Neo-tree" },
  },
}
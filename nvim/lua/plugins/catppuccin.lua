return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    enabled = false, -- Disable the plugin entirely
    priority = 1000,
    lazy = false,
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        neo_tree = false, -- Turn off Neo-tree integration
        telescope = true,
        treesitter = true,
        mason = true,
        which_key = true,
        dashboard = true,
        noice = true,
        notify = true,
      },
    },
  },

  -- Use default tokyonight colorscheme instead
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
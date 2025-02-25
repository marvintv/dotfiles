return {
  {
    "echasnovski/mini.icons",
    version = false,
    config = function()
      require("mini.icons").setup()
      
      -- Optional: Use mini.icons with neo-tree
      -- This assumes you have both plugins loaded
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          if package.loaded["neo-tree"] then
            -- This will run after neo-tree is loaded
            local mini_icons = require("mini.icons")
            -- You can customize which sets of icons to use with neo-tree
          end
        end,
      })
    end,
  }
}
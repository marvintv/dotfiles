return {
  "echasnovski/mini.move",
  version = "*",
  config = function()
    require("mini.move").setup({
      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        -- Move visual selection in Visual mode using Ctrl + hjkl
        left = '<C-h>',    -- Ctrl + h
        right = '<C-l>',   -- Ctrl + l
        down = '<C-j>',    -- Ctrl + j
        up = '<C-k>',      -- Ctrl + k

        -- Move current line in Normal mode using Ctrl + hjkl
        line_left = '<C-h>',   -- Ctrl + h
        line_right = '<C-l>',  -- Ctrl + l
        line_down = '<C-j>',   -- Ctrl + j
        line_up = '<C-k>',     -- Ctrl + k
      },

      -- Options which control moving behavior
      options = {
        -- Automatically reindent selection during linewise vertical move
        reindent_linewise = true,
      },
    })
  end,
}

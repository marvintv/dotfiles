return {
  "echasnovski/mini.move",
  version = "*",
  config = function()
    require("mini.move").setup({
      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        -- Move visual selection in Visual mode using Option(⌥) + hjkl on macOS
        left = '<M-h>',    -- Option + h
        right = '<M-l>',   -- Option + l
        down = '<M-j>',    -- Option + j
        up = '<M-k>',      -- Option + k

        -- Move current line in Normal mode using Option(⌥) + hjkl on macOS
        line_left = '<M-h>',   -- Option + h
        line_right = '<M-l>',  -- Option + l
        line_down = '<M-j>',   -- Option + j
        line_up = '<M-k>',     -- Option + k
      },

      -- Options which control moving behavior
      options = {
        -- Automatically reindent selection during linewise vertical move
        reindent_linewise = true,
      },
    })
  end,
}

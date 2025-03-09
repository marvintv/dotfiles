return {
  "echasnovski/mini.move",
  version = "*",
  config = function()
    require("mini.move").setup({
      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        -- Move visual selection in Visual mode using Alt/Option + wasd
        left = "<M-a>",  -- Alt + a
        right = "<M-d>", -- Alt + d
        down = "<M-s>",  -- Alt + s
        up = "<M-w>",    -- Alt + w

        -- Move current line in Normal mode using Alt/Option + wasd
        line_left = "<M-a>",  -- Alt + a
        line_right = "<M-d>", -- Alt + d
        line_down = "<M-s>",  -- Alt + s
        line_up = "<M-w>",    -- Alt + w
      },

      -- Options which control moving behavior
      options = {
        -- Automatically reindent selection during linewise vertical move
        reindent_linewise = true,
      },
    })
  end,
}

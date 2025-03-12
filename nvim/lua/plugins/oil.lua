return {
  "stevearc/oil.nvim",
  opts = {
    -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
    default_file_explorer = true,
    -- Show file icons
    columns = {
      "icon",
    },
    -- Restore window options to previous values when leaving an oil buffer
    restore_win_options = true,
    -- Skip the confirmation popup for simple operations
    skip_confirm_for_simple_edits = true,
    -- Keymaps in oil buffer
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-s>"] = { "actions.select", opts = { vertical = true } },
      ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
      ["<C-t>"] = { "actions.select", opts = { tab = true } },
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["<C-l>"] = "actions.refresh",
      -- ["<Space>"] = "actions.toggle_mark",
      -- ["<C-o>"] = "actions.open_marked",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = { "actions.cd", opts = { scope = "tab" } },
      ["g."] = "actions.toggle_hidden",
    },
    -- Set to false to disable all of the above keymaps
    use_default_keymaps = false,
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = false,
    },
  },
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
}

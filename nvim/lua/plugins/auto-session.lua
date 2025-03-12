return {
  "rmagatti/auto-session",
  lazy = false,
  priority = 100,                    -- Lower than telescope
  dependencies = {
    "nvim-telescope/telescope.nvim", -- Ensure telescope loads first
  },
  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    auto_session_use_git_branch = true,
    auto_save_enabled = true,
    auto_restore_enabled = true,
    -- Only restore session if you're in the same directory
    auto_session_enable_last_session = false,
    auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
    -- log_level = 'debug',

    -- Fix Telescope and other commands
    pre_save_cmds = { "silent! Neotree close" },
    post_restore_cmds = {
      function()
        -- Ensure telescope commands are available after session restore
        if package.loaded["telescope"] then
          local builtin = require("telescope.builtin")

          -- Re-register user commands
          vim.api.nvim_create_user_command("TelescopeFindFiles", function()
            builtin.find_files()
          end, {})
          vim.api.nvim_create_user_command("TelescopeLiveGrep", function()
            builtin.live_grep()
          end, {})
          vim.api.nvim_create_user_command("TelescopeBuffers", function()
            builtin.buffers()
          end, {})
          vim.api.nvim_create_user_command("TelescopeHelpTags", function()
            builtin.help_tags()
          end, {})

          -- Re-register keymaps
          vim.keymap.set("n", "<leader>ff", function()
            builtin.find_files()
          end, { desc = "Find Files" })
          vim.keymap.set("n", "<leader>fg", function()
            builtin.live_grep()
          end, { desc = "Live Grep" })
          vim.keymap.set("n", "<leader>fb", function()
            builtin.buffers()
          end, { desc = "Buffers" })
          vim.keymap.set("n", "<leader>fh", function()
            builtin.help_tags()
          end, { desc = "Help Tags" })
          vim.keymap.set("n", "<leader>fr", function()
            builtin.lsp_references()
          end, { desc = "Find References" })
        end
      end,
    },
    session_lens = {
      load_on_setup = false,
    },
  },
  config = function(_, opts)
    local auto_session = require("auto-session")
    auto_session.setup(opts)

    -- Keymapping to reset workspace (close auto-session)
    vim.keymap.set("n", "<leader>rs", function()
      -- Delete the current session
      auto_session.DeleteSession()
      -- Clear all buffers
      vim.cmd("bufdo bwipeout")
      -- You could also reset other elements of your workspace here
    end, { desc = "Reset workspace (close auto-session)" })

    -- We'll use auto-session's post_restore_cmds for this instead
    -- No need for a custom autocmd as already handled in opts.post_restore_cmds
  end,
}

return {
  "rmagatti/auto-session",
  lazy = false,
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
  end,
}

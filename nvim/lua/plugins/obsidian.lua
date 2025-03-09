return {
  "epwalsh/obsidian.nvim",
  version = "*",  -- Use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  dependencies = {
    -- Required
    "nvim-lua/plenary.nvim",
    
    -- Optional, for completion
    "hrsh7th/nvim-cmp",
    
    -- Optional, for search and quick-switch functionality
    "nvim-telescope/telescope.nvim",
    
    -- Optional, for syntax highlighting
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("obsidian").setup({
      workspaces = {
        {
          name = "personal",
          path = "~/notes",
        },
      },
      
      -- Optional, if you keep notes in a specific subdirectory
      notes_subdir = "notes",
      
      -- Optional, customize how notes are named
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,
      
      -- Customize the appearance of markdown links (e.g. "[link](path/to/note.md)")
      preferred_link_style = "markdown",
      
      -- Mappings
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle checkboxes
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
      },
      
      -- Optional, completion of wiki links, local markdown links, and tags
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      
      -- Optional, configure additional syntax highlighting
      ui = {
        enable = true,
        update_debounce = 200,
        checkboxes = {
          [" "] = { char = "☐", hl_group = "ObsidianTodo" },
          ["x"] = { char = "✓", hl_group = "ObsidianDone" },
          [">"] = { char = "▶", hl_group = "ObsidianRightArrow" },
          ["~"] = { char = "≈", hl_group = "ObsidianTilde" },
        },
        bullets = { char = "•", hl_group = "ObsidianBullet" },
        external_link_icon = { char = "↗", hl_group = "ObsidianExtLinkIcon" },
        reference_text = { hl_group = "ObsidianRefText" },
        highlight_text = { hl_group = "ObsidianHighlightText" },
        tags = { hl_group = "ObsidianTag" },
        hl_groups = {
          ObsidianTodo = { bold = true, fg = "#f78c6c" },
          ObsidianDone = { bold = true, fg = "#89ddff" },
          ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
          ObsidianTilde = { bold = true, fg = "#ff5370" },
          ObsidianBullet = { bold = true, fg = "#89ddff" },
          ObsidianRefText = { underline = true, fg = "#c792ea" },
          ObsidianExtLinkIcon = { fg = "#c792ea" },
          ObsidianTag = { italic = true, fg = "#89ddff" },
          ObsidianHighlightText = { bg = "#75662e" },
        },
      },
    })
  end,
  keys = {
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Obsidian Note" },
    { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian App" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search Obsidian Notes" },
    { "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick Switch" },
    { "<leader>of", "<cmd>ObsidianFollowLink<cr>", desc = "Follow Link" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show Backlinks" },
    { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Insert Template" },
    { "<leader>mp", "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian" },
  },
}

return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function() 
    vim.fn["mkdp#util#install"]() 
  end,
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  config = function()
    -- Debug: Show preview URL in messages
    vim.g.mkdp_echo_preview_url = 1
    
    -- Use macOS open command via custom function
    vim.g.mkdp_browserfunc = function(url)
      vim.notify("Markdown preview URL: " .. url)
      vim.fn.system({"open", url})  -- Uses macOS default browser
    end
    
    -- Custom page title
    vim.g.mkdp_page_title = '${name} - Markdown Preview'
    
    -- Port settings (fix for macOS)
    vim.g.mkdp_port = '8090'
    
    -- Refresh on events
    vim.g.mkdp_refresh_slow = 0
    vim.g.mkdp_preview_options = {
      sync_scroll_type = 'middle',
    }
  end,
}

return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "j-hui/fidget.nvim", opts = {} },
    },
    opts = {
      -- Options for nvim-lspconfig
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
      },
      -- LSP Server Settings
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                },
              },
              telemetry = { enable = false },
            },
          },
        },
        vtsls = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
        html = {},
        cssls = {},
        jsonls = {},
        pyright = {},
      },
      setup = {},
    },
    config = function(_, opts)
      -- Setup keymaps when an LSP connects to a buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buffer = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          
          -- Skip attaching to servers that don't support document formatting
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = buffer,
              callback = function()
                vim.lsp.buf.format({ async = false })
              end,
            })
          end
          
          -- LSP-aware keymaps
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
          end
          
          -- Keybindings for LSP functionality
          map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
          map("n", "gr", vim.lsp.buf.references, "Go to References")
          map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
          map("n", "gI", vim.lsp.buf.implementation, "Go to Implementation")
          map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
          map("n", "<leader>D", vim.lsp.buf.type_definition, "Type Definition")
          map("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
          map("n", "<leader>ws", require("telescope.builtin").lsp_workspace_symbols, "Workspace Symbols")
          map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
          map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
          map("n", "<leader>lf", vim.lsp.buf.format, "Format")
        end,
      })
      
      -- Configure diagnostics display
      vim.diagnostic.config(opts.diagnostics)
      
      -- Setup mason to automatically install LSP servers
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
      
      local handlers = {
        function(server_name)
          local server = opts.servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (like formatting)
          -- Setup capabilities with LSP
          local capabilities = vim.lsp.protocol.make_client_capabilities()
          
          -- Use cmp_nvim_lsp capabilities if available
          local status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
          if status then
            capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
          end
          
          server.capabilities = vim.tbl_deep_extend(
            "force",
            {},
            capabilities,
            server.capabilities or {}
          )
          require("lspconfig")[server_name].setup(server)
        end,
      }
      
      -- Add any special per-server setup here
      for server, handler in pairs(opts.setup) do
        if type(handler) == "function" then
          handlers[server] = handler
        end
      end
      
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(opts.servers),
        handlers = handlers,
      })
    end,
  },
  
  -- Mason for managing LSP servers
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    opts = {},
  },
  
  -- Formatters and linters in Mason
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
  },
  
  -- Better UI for LSP
  {
    "j-hui/fidget.nvim",
    opts = {},
  },
}
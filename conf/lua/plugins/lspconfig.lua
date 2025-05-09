{
    "neovim/nvim-lspconfig",
    opts = function()
        ---@class PluginLspOpts
        local ret = {
          -- options for vim.diagnostic.config()
          ---@type vim.diagnostic.Opts
          diagnostics = {
            underline = true,
            update_in_insert = false,
            virtual_text = {
              spacing = 4,
              source = "if_many",
              prefix = "●",
              -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
              -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
              -- prefix = "icons",
            },
            severity_sort = true,
            signs = {
              text = {
                [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
                [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
                [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
                [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
              },
            },
          },
          -- LSP Server Settings
          ---@type lspconfig.options
          servers = {
            pyright = {
                mason = false,
                autostart = false,
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            diagnosticMode = "openFilesOnly",
                            useLibraryCodeForTypes = true,
                            typeCheckingMode = "off",
                        },
                    },
                },
            },
          },
          -- you can do any additional lsp server setup here
          -- return true if you don't want this server to be setup with lspconfig
          ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
          setup = {
            -- example to setup with typescript.nvim
            -- tsserver = function(_, opts)
            --   require("typescript").setup({ server = opts })
            --   return true
            -- end,
            -- Specify * to use this function as a fallback for any server
            -- ["*"] = function(server, opts) end,
          },
        }
        return ret
      end
  }
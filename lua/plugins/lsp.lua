-- ===============================
-- LSP Configuration
-- ===============================

return {
  -- Mason - LSP installer
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim", dependencies = { "williamboman/mason.nvim" } },
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Capabilities from nvim-cmp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      -- Mason + mason-lspconfig with handlers
      require("mason").setup()

      local mlsp = require("mason-lspconfig")

      mlsp.setup({
        ensure_installed = {
          "basedpyright",  -- Python
          "clangd",        -- C/C++
          "lua_ls",        -- Lua
          "ts_ls",         -- TypeScript/JavaScript
          "rust_analyzer", -- Rust
          "html",          -- HTML
          "cssls",         -- CSS
          "jsonls",        -- JSON
          "tailwindcss",   -- Tailwind CSS
        },

        handlers = {
          -- default handler
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
            })
          end,

          -- Lua: custom config
          ["lua_ls"] = function()
            require("lspconfig").lua_ls.setup({
              capabilities = capabilities,
              settings = {
                Lua = {
                  diagnostics = { globals = { "vim" } },
                  workspace   = { checkThirdParty = false },
                },
              },
            })
          end,

          -- BasedPyright: custom config
          ["basedpyright"] = function()
            require("lspconfig").basedpyright.setup({
              capabilities = capabilities,
              settings = {
                basedpyright = {
                  analysis = {
                    typeCheckingMode = "strict",
                    autoImportCompletions = true,
                    diagnosticMode = "workspace",
                  },
                  venvPath = ".",
                  venv = ".venv",
                  exclude = { ".venv" },
                },
              },
            })
          end,

          -- TypeScript/JavaScript: custom config
          ["ts_ls"] = function()
            require("lspconfig").ts_ls.setup({
              capabilities = capabilities,
              settings = {
                typescript = {
                  inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayFunctionParameterTypeHints = true,
                  },
                },
                javascript = {
                  inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayFunctionParameterTypeHints = true,
                  },
                },
              },
            })
          end,

          -- Rust: Disable in favor of rustaceanvim
          ["rust_analyzer"] = function() end,
        },
      })
    end,
  },
}

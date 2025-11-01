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
        ensure_installed = { "basedpyright", "clangd", "lua_ls" },

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
        },
      })
    end,
  },
}

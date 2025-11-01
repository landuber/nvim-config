-- ===============================
-- Rust Development
-- ===============================

return {
  -- Rustaceanvim - Enhanced Rust support
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(client, bufnr)
            -- LSP keymaps are set in autocmds.lua via LspAttach
          end,
          settings = {
            ["rust-analyzer"] = {
              check = {
                command = "clippy", -- Use clippy for better linting
              },
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
              },
              procMacro = {
                enable = true,
              },
              inlayHints = {
                lifetimeElisionHints = {
                  enable = "always",
                },
              },
            },
          },
        },
        tools = {
          hover_actions = {
            auto_focus = true,
          },
        },
        dap = {
          adapter = require("rustaceanvim.config").get_codelldb_adapter(
            vim.fn.stdpath("data") .. "/mason/bin/codelldb",
            vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/lldb/lib/liblldb.so"
          ),
        },
      }
    end,
  },

  -- Crates.nvim - Cargo.toml dependency management
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
      completion = {
        cmp = {
          enabled = true,
        },
      },
    },
    config = function(_, opts)
      require("crates").setup(opts)

      -- Add crates.nvim source to nvim-cmp
      local ok, cmp = pcall(require, "cmp")
      if ok then
        vim.api.nvim_create_autocmd("BufRead", {
          pattern = "Cargo.toml",
          callback = function()
            cmp.setup.buffer({ sources = { { name = "crates" } } })
          end,
        })
      end

      -- Keymaps for Cargo.toml
      vim.keymap.set("n", "<leader>ct", function() require("crates").toggle() end,
        { desc = "Crates: toggle" })
      vim.keymap.set("n", "<leader>cr", function() require("crates").reload() end,
        { desc = "Crates: reload" })
      vim.keymap.set("n", "<leader>cu", function() require("crates").update_crate() end,
        { desc = "Crates: update crate" })
      vim.keymap.set("v", "<leader>cu", function() require("crates").update_crates() end,
        { desc = "Crates: update crates" })
      vim.keymap.set("n", "<leader>ca", function() require("crates").update_all_crates() end,
        { desc = "Crates: update all" })
      vim.keymap.set("n", "<leader>cU", function() require("crates").upgrade_crate() end,
        { desc = "Crates: upgrade crate" })
      vim.keymap.set("v", "<leader>cU", function() require("crates").upgrade_crates() end,
        { desc = "Crates: upgrade crates" })
      vim.keymap.set("n", "<leader>cA", function() require("crates").upgrade_all_crates() end,
        { desc = "Crates: upgrade all" })
    end,
  },
}

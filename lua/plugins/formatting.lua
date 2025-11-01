-- ===============================
-- Formatting with conform.nvim
-- ===============================

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- Python: uvx-powered formatters
        python = { "uvx_ruff_format", "uvx_black" },
        -- C/C++
        cpp    = { "clang-format" },
        c      = { "clang-format" },
        -- Lua
        lua    = { "stylua" },
        -- Rust (rustfmt is handled by rust-analyzer)
        rust   = { "rustfmt" },
        -- JavaScript/TypeScript
        javascript       = { "prettier" },
        javascriptreact  = { "prettier" },
        typescript       = { "prettier" },
        typescriptreact  = { "prettier" },
        -- Web
        html   = { "prettier" },
        css    = { "prettier" },
        scss   = { "prettier" },
        json   = { "prettier" },
        jsonc  = { "prettier" },
        yaml   = { "prettier" },
        markdown = { "prettier" },
      },
      -- Define uvx-backed formatters
      formatters = {
        uvx_black = {
          command = "uvx",
          args = { "black", "-" },
          stdin = true,
        },
        uvx_isort = {
          command = "uvx",
          args = { "isort", "-", "--profile", "black" },
          stdin = true,
        },
        uvx_ruff_format = {
          command = "uvx",
          args = { "ruff", "format", "-" },
          stdin = true,
        },
      },
      format_on_save = { timeout_ms = 1000, lsp_fallback = true },
    },
  },
}

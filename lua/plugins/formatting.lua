-- ===============================
-- Formatting with conform.nvim
-- ===============================

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- Use uvx-powered formatters for Python
        python = { "uvx_ruff_format", "uvx_black" },
        -- System tools for non-Python
        cpp    = { "clang-format" },
        c      = { "clang-format" },
        lua    = { "stylua" },
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

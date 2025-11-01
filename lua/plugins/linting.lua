-- ===============================
-- Linting with nvim-lint
-- ===============================

return {
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require("lint")

      -- Use a uvx-backed Ruff linter
      lint.linters = lint.linters or {}
      lint.linters.uvx_ruff = {
        cmd = "uvx",
        args = { "ruff", "check", "--stdin-filename", "%:p", "-" },
        stdin = true,
        stream = "both",
        ignore_exitcode = true,
      }

      lint.linters_by_ft = {
        python = { "uvx_ruff" },
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        callback = function() require("lint").try_lint() end,
      })
    end,
  },
}

-- ===============================
-- Treesitter
-- ===============================

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          -- Core
          "lua", "vim", "vimdoc", "bash",
          -- Languages
          "python", "rust", "c", "cpp",
          "javascript", "typescript", "tsx", "jsx",
          "html", "css", "scss",
          -- Config/Data
          "json", "jsonc", "yaml", "toml",
          "markdown", "markdown_inline",
          -- Other
          "regex", "comment",
        },
        highlight = { enable = true },
        indent = { enable = true },
        autotag = { enable = true },
      })
    end
  },
}

-- ===============================
-- Treesitter
-- ===============================

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "bash", "python", "cpp", "markdown", "json", "yaml", "toml" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },
}

-- ===============================
-- Web Development
-- ===============================

return {
  -- Auto close and rename HTML/JSX tags
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
      })
    end,
  },

  -- Show npm package versions in package.json
  {
    "vuki656/package-info.nvim",
    ft = { "json" },
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      colors = {
        up_to_date = "#3C4048",
        outdated = "#d19a66",
      },
      icons = {
        enable = true,
        style = {
          up_to_date = "  ",
          outdated = "  ",
        },
      },
      autostart = true,
      hide_up_to_date = false,
      hide_unstable_versions = false,
    },
    config = function(_, opts)
      require("package-info").setup(opts)

      -- Keymaps
      vim.keymap.set("n", "<leader>ns", function() require("package-info").show() end,
        { desc = "NPM: show package info" })
      vim.keymap.set("n", "<leader>nc", function() require("package-info").hide() end,
        { desc = "NPM: hide package info" })
      vim.keymap.set("n", "<leader>nt", function() require("package-info").toggle() end,
        { desc = "NPM: toggle package info" })
      vim.keymap.set("n", "<leader>nu", function() require("package-info").update() end,
        { desc = "NPM: update package" })
      vim.keymap.set("n", "<leader>nd", function() require("package-info").delete() end,
        { desc = "NPM: delete package" })
      vim.keymap.set("n", "<leader>ni", function() require("package-info").install() end,
        { desc = "NPM: install package" })
      vim.keymap.set("n", "<leader>np", function() require("package-info").change_version() end,
        { desc = "NPM: change package version" })
    end,
  },

  -- Emmet support for HTML/CSS
  {
    "mattn/emmet-vim",
    ft = { "html", "css", "javascriptreact", "typescriptreact", "vue", "svelte" },
    init = function()
      vim.g.user_emmet_leader_key = "<C-z>"
      vim.g.user_emmet_settings = {
        javascript = { extends = "jsx" },
        typescript = { extends = "tsx" },
      }
    end,
  },
}

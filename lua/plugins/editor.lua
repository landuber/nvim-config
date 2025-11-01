-- ===============================
-- Editor Enhancement Plugins
-- ===============================

return {
  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local t = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", t.find_files, { desc = "find files" })
      vim.keymap.set("n", "<leader>fg", t.live_grep, { desc = "live grep" })
      vim.keymap.set("n", "<leader>fb", t.buffers, { desc = "buffers" })
      vim.keymap.set("n", "<leader>fh", t.help_tags, { desc = "help" })

      -- Theme picker
      vim.keymap.set("n", "<leader>tc",
        function() require("telescope.builtin").colorscheme({ enable_preview = true }) end,
        { desc = "Theme: choose colorscheme" }
      )
    end
  },

  -- Matchup - better % matching
  {
    "andymass/vim-matchup",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },

  -- Git signs
  { "lewis6991/gitsigns.nvim", opts = {} },

  -- Commenting
  { "numToStr/Comment.nvim", opts = {} },

  -- Indent guides
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
}

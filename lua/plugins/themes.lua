-- ===============================
-- Colorschemes
-- ===============================

local theme_transparent = false -- true = transparent backgrounds

return {
  -- gruvbox (warm/contrasty)
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = { contrast = "hard", transparent_mode = theme_transparent },
  },

  -- catppuccin (pastel, eye-friendly)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = { flavour = "mocha", transparent_background = theme_transparent },
  },

  -- tokyonight (modern blue/purple)
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = { style = "night", transparent = theme_transparent },
  },

  -- kanagawa (elegant, ink-painting vibe)
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    opts = { transparent = theme_transparent },
  },

  -- rose pine (cozy pastels)
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    opts = { disable_background = theme_transparent },
  },
}

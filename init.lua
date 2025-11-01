-- ===============================
-- Neovim 0.11+ Modular Configuration
-- ===============================

-- Load core modules
require("core.options")   -- Core options and settings
require("core.keymaps")   -- Core keymaps
require("core.autocmds")  -- Autocommands (including filetype settings)
require("core.lazy")      -- Plugin manager bootstrap

-- Set default colorscheme
vim.o.background = "dark"
vim.cmd.colorscheme("gruvbox")

-- Theme switcher command
vim.api.nvim_create_user_command("Theme", function(opts)
  local ok, err = pcall(vim.cmd.colorscheme, opts.args)
  if not ok then vim.notify("colorscheme: " .. tostring(err), vim.log.levels.ERROR) end
end, {
  nargs = 1,
  complete = function(lead) return vim.fn.getcompletion(lead, "color") end,
  desc = "Switch colorscheme",
})

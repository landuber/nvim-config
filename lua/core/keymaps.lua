-- ===============================
-- Core Keymaps
-- ===============================

-- Toggle visible whitespace
vim.keymap.set("n", "<leader>lw", function()
  if vim.opt.list:get() then
    vim.opt.list = false
  else
    vim.opt.list = true
    vim.opt.listchars = { tab = "»·", trail = "·", extends = "›", precedes = "‹", nbsp = "␣" }
  end
end, { desc = "Toggle listchars" })

-- Show current indent settings
vim.keymap.set("n", "<leader>is", function()
  vim.cmd("verbose set ts? sw? sts? et?")
end, { desc = "Show indent settings" })

-- File explorer and buffer management
vim.keymap.set("n", "<leader>e", ":Ex<CR>", { desc = "File explorer (netrw)" })
vim.keymap.set("n", "<leader>q", ":bd<CR>", { desc = "Close buffer" })

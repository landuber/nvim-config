-- ===============================
-- Core Neovim Options
-- ===============================

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Prefer project-local Python if available (.venv)
do
  local venv_python = ".venv/bin/python"
  if vim.fn.executable(venv_python) == 1 then
    vim.g.python3_host_prog = vim.fn.fnamemodify(venv_python, ":p")
  end
end

-- Core options
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.termguicolors  = true
vim.opt.cursorline     = true
vim.opt.wrap           = false
vim.opt.signcolumn     = "yes"
vim.opt.scrolloff      = 6
vim.opt.splitbelow     = true
vim.opt.splitright     = true
vim.opt.updatetime     = 200
vim.opt.clipboard      = "unnamedplus" -- wl-clipboard/xclip on ubuntu

-- Tab and space options
-- Global defaults (good for Python, C/C++, etc.)
vim.opt.expandtab      = true -- spaces instead of tabs
vim.opt.tabstop        = 4    -- how tabs render
vim.opt.shiftwidth     = 4    -- >> << and autoindent size
vim.opt.softtabstop    = 4    -- Tab/BS in insert mode feel natural
vim.opt.smartindent    = true
vim.opt.autoindent     = true
vim.opt.copyindent     = true
vim.opt.preserveindent = true

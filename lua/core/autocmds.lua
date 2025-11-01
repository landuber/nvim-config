-- ===============================
-- Autocmds
-- ===============================

-- Helper function for filetype-specific options
local ft = function(patterns, opts)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = patterns,
    callback = function()
      for k, v in pairs(opts) do vim.opt_local[k] = v end
    end,
  })
end

-- Makefile: MUST use hard tabs
ft({ "make", "makefile" }, {
  expandtab = false,
  tabstop = 8,
  shiftwidth = 8,
  softtabstop = 0,
})

-- Go generally prefers hard tabs (gofmt)
ft({ "go" }, {
  expandtab = false,
  tabstop = 8,
  shiftwidth = 8,
  softtabstop = 0,
})

-- 2-space ecosystems
ft({ "lua", "javascript", "javascriptreact", "typescript", "typescriptreact",
  "json", "jsonc", "yaml", "helm", "toml", "html", "css", "scss", "markdown" }, {
  tabstop = 2,
  shiftwidth = 2,
  softtabstop = 2,
  expandtab = true,
})

-- Python: explicit 4-space (PEP 8)
ft({ "python" }, {
  tabstop = 4,
  shiftwidth = 4,
  softtabstop = 4,
  expandtab = true,
})

-- C-family: many teams use 4, tweak to your codebase
ft({ "c", "cpp", "objc", "objcpp", "cuda" }, {
  tabstop = 4,
  shiftwidth = 4,
  softtabstop = 4,
  expandtab = true,
})

-- LSP keymaps on attach
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>fd", function() vim.lsp.buf.format({ async = true }) end, opts)
  end,
})

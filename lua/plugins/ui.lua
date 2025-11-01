-- ===============================
-- UI Plugins
-- ===============================

return {
  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      -- disable netrw (recommended by nvim-tree)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwplugin = 1
    end,
    opts = {
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = { enable = true, update_root = true },
      view = { width = 36, signcolumn = "yes" },
      renderer = {
        group_empty = true,
        highlight_git = true,
        highlight_opened_files = "name",
        indent_markers = { enable = true },
        icons = {
          glyphs = {
            git = { unstaged = "", staged = "", unmerged = "", renamed = "", untracked = "", deleted = "", ignored = "" },
          },
        },
      },
      git = { enable = true, ignore = false },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = { hint = "", info = "", warning = "", error = "" },
      },
      modified = { enable = true },
      filters = { dotfiles = false, custom = { "^.git$" } },
      actions = { open_file = { resize_window = true, quit_on_open = false } },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)
      local api = require("nvim-tree.api")
      vim.keymap.set("n", "<leader>e", api.tree.toggle, { desc = "explorer: toggle" })
      vim.keymap.set("n", "<leader>E", function() api.tree.find_file({ open = true, focus = true }) end,
        { desc = "explorer: reveal current file" })
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      vim.g.have_nerd_font = true

      local icons = {
        lsp = "",
        dap = "",
        venv = "",
        mod = "●",
        ro = "",
      }

      local function venv_component()
        local v = os.getenv("VIRTUAL_ENV")
        if v and #v > 0 then return icons.venv .. " " .. vim.fn.fnamemodify(v, ":t") end
        return ""
      end

      local function lsp_component()
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        if #clients == 0 then return "" end
        local names = {}
        for _, c in ipairs(clients) do table.insert(names, c.name) end
        return icons.lsp .. " " .. table.concat(names, ",")
      end

      local function dap_component()
        local ok, dap = pcall(require, "dap")
        if not ok then return "" end
        local s = dap.status()
        return (s and #s > 0) and (icons.dap .. " " .. s) or ""
      end

      require("lualine").setup({
        options = {
          theme = "auto",
          globalstatus = true,
          icons_enabled = true,
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1, symbols = { modified = icons.mod, readonly = icons.ro } } },
          lualine_x = { dap_component, lsp_component, venv_component, "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- Keybinding hints
  { "folke/which-key.nvim", opts = {} },
}

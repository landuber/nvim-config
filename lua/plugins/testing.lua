-- ===============================
-- Testing with Neotest
-- ===============================

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
    },
    config = function()
      local neotest = require("neotest")

      -- Resolve project-local Python
      local function project_python()
        local venv = vim.fn.getcwd() .. "/.venv/bin/python"
        if vim.fn.executable(venv) == 1 then
          return venv
        end
        return "python3"
      end

      neotest.setup({
        adapters = {
          require("neotest-python")({
            python = project_python,
            runner = "pytest",
            dap = { justMyCode = true },
            pytest_discover_instances = true,
            args = { "-q" },
          }),
        },
        quickfix = { enabled = false, open = false },
        output = { open_on_run = false },
        floating = { border = "rounded" },
        summary = { open = "botright vsplit | vertical resize 40" },
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>tn", function() neotest.run.run() end,
        { desc = "Test: run nearest" })
      vim.keymap.set("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end,
        { desc = "Test: run file" })
      vim.keymap.set("n", "<leader>tr", function() neotest.run.run_last() end,
        { desc = "Test: run last" })
      vim.keymap.set("n", "<leader>tS", function() neotest.run.stop() end,
        { desc = "Test: stop" })
      vim.keymap.set("n", "<leader>ts", function() neotest.summary.toggle() end,
        { desc = "Test: toggle summary" })
      vim.keymap.set("n", "<leader>to",
        function() neotest.output.open({ enter = true, auto_close = true }) end,
        { desc = "Test: open output" })
      vim.keymap.set("n", "<leader>tO", function() neotest.output_panel.toggle() end,
        { desc = "Test: toggle output panel" })
      vim.keymap.set("n", "<leader>td", function() neotest.run.run({ strategy = "dap" }) end,
        { desc = "Test: debug nearest (DAP)" })
    end,
  }
}

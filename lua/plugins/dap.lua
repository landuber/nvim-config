-- ===============================
-- Debugging with DAP
-- ===============================

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
      "mfussenegger/nvim-dap-python",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Signs & highlights
      local icons = { bp = "", cond = "", rej = "", stop = "", log = "" }

      local hl = vim.api.nvim_set_hl
      hl(0, "DapBreakpoint", { default = true, link = "DiagnosticSignError" })
      hl(0, "DapBreakpointCondition", { default = true, link = "DiagnosticSignWarn" })
      hl(0, "DapBreakpointRejected", { default = true, link = "DiagnosticSignHint" })
      hl(0, "DapStopped", { default = true, link = "DiagnosticSignInfo" })
      hl(0, "DapLogPoint", { default = true, link = "DiagnosticSignInfo" })
      hl(0, "DapStoppedLine", { default = true, link = "CursorLine" })

      vim.fn.sign_define("DapBreakpoint",
        { text = icons.bp, texthl = "DapBreakpoint", numhl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointCondition",
        { text = icons.cond, texthl = "DapBreakpointCondition", numhl = "DapBreakpointCondition" })
      vim.fn.sign_define("DapBreakpointRejected",
        { text = icons.rej, texthl = "DapBreakpointRejected", numhl = "DapBreakpointRejected" })
      vim.fn.sign_define("DapStopped",
        {
          text = icons.stop,
          texthl = "DapStopped",
          numhl = "DapStopped",
          linehl = "DapStoppedLine"
        })
      vim.fn.sign_define("DapLogPoint",
        { text = icons.log, texthl = "DapLogPoint", numhl = "DapLogPoint" })

      -- DAP UI layout
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "➤" },
        controls = {
          enabled = true,
          element = "repl",
          icons = { pause = "⏸", play = "▶", step_into = "⤵", step_over = "⤼", step_out = "⤴", step_back = "↶", run_last = "↻", terminate = "■" },
        },
        layouts = {
          {
            position = "left",
            size = 45,
            elements = {
              { id = "scopes",      size = 0.45 },
              { id = "breakpoints", size = 0.20 },
              { id = "stacks",      size = 0.20 },
              { id = "watches",     size = 0.15 },
            },
          },
          {
            position = "bottom",
            size = 12,
            elements = { { id = "repl", size = 0.55 }, { id = "console", size = 0.45 } },
          },
        },
        floating = { border = "rounded" },
        render = { max_type_length = 55, max_value_lines = 200 },
      })

      -- Auto-open/close DAP-UI with sessions
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"]     = function() dapui.close() end

      -- Inline variable values (virtual text)
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        commented = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = true,
        virt_text_pos = "eol",
        all_references = true,
        show_stop_reason = true,
      })

      -- Keymaps
      vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP Continue" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP Step Over" })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP Step Into" })
      vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP Step Out" })
      vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "DAP Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>B", function()
        dap.set_breakpoint(vim.fn.input("Condition: "))
      end, { desc = "DAP Conditional Breakpoint" })
      vim.keymap.set("n", "<leader>dl", function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
      end, { desc = "DAP Logpoint" })

      vim.keymap.set("n", "<leader>du", function() require("dapui").toggle({ reset = true }) end,
        { desc = "DAP-UI Toggle" })
      vim.keymap.set("n", "<leader>de", function() require("dapui").eval() end,
        { desc = "DAP-UI Eval under cursor" })
      vim.keymap.set("v", "<leader>de", function() require("dapui").eval() end,
        { desc = "DAP-UI Eval selection" })
      vim.keymap.set("n", "<leader>dr", function() require("dap").repl.open() end,
        { desc = "DAP REPL" })

      -- Ensure debuggers via Mason
      require("mason-nvim-dap").setup({
        ensure_installed = { "python", "codelldb", "node2" },
        automatic_setup = true,
        handlers = {
          function(config)
            require("mason-nvim-dap").default_setup(config)
          end,
        },
      })
      local venv_python = vim.fn.getcwd() .. "/.venv/bin/python"
      require("dap-python").setup(vim.fn.executable(venv_python) == 1 and venv_python or "python3")

      -- Node.js/TypeScript debugging
      dap.adapters.node2 = {
        type = "executable",
        command = "node",
        args = { vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
      }

      dap.configurations.javascript = {
        {
          type = "node2",
          request = "launch",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
          console = "integratedTerminal",
        },
      }

      dap.configurations.typescript = dap.configurations.javascript

      -- Helper: project python
      local function project_python()
        local p = vim.fn.getcwd() .. "/.venv/bin/python"
        return (vim.fn.executable(p) == 1) and p or "python3"
      end

      -- Shell-like arg splitter
      local function shellwords(str)
        local args, buf, quote = {}, "", nil
        for i = 1, #str do
          local c = str:sub(i, i)
          if quote then
            if c == quote then
              quote = nil
            elseif c == "\\" and i < #str then
              i = i + 1
              buf = buf .. str:sub(i, i)
            else
              buf = buf .. c
            end
          else
            if c == '"' or c == "'" then
              quote = c
            elseif c:match("%s") then
              if #buf > 0 then
                table.insert(args, buf); buf = ""
              end
            elseif c == "\\" and i < #str then
              i = i + 1
              buf = buf .. str:sub(i, i)
            else
              buf = buf .. c
            end
          end
        end
        if #buf > 0 then table.insert(args, buf) end
        return args
      end

      -- :DebugFile command
      vim.api.nvim_create_user_command("DebugFile", function()
        require("dap").run({
          type = "python",
          request = "launch",
          name = "Debug current file",
          program = vim.fn.expand("%:p"),
          cwd = vim.fn.getcwd(),
          console = "integratedTerminal",
          justMyCode = true,
          pythonPath = project_python(),
          args = {},
        })
      end, { desc = "DAP: Debug current file" })

      -- :DebugArgs command
      vim.api.nvim_create_user_command("DebugArgs", function()
        local argstr = vim.fn.input("Args: ")
        local args = shellwords(argstr or "")
        require("dap").run({
          type = "python",
          request = "launch",
          name = "Debug with args",
          program = vim.fn.expand("%:p"),
          cwd = vim.fn.getcwd(),
          console = "integratedTerminal",
          justMyCode = true,
          pythonPath = project_python(),
          args = args,
        })
      end, { desc = "DAP: Debug current file with args" })

      -- Keymaps for commands
      vim.keymap.set("n", "<leader>df", "<cmd>DebugFile<CR>", { desc = "DAP: Debug file" })
      vim.keymap.set("n", "<leader>da", "<cmd>DebugArgs<CR>", { desc = "DAP: Debug with args" })
      vim.keymap.set("n", "<leader>dL", function() require("dap").run_last() end,
        { desc = "DAP: Run last" })
    end,
  },
}

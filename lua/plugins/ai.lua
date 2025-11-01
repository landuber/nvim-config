-- ===============================
-- AI Assistance
-- ===============================

return {
  {
    "greggh/claude-code.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("claude-code").setup({
        model = "claude-3-5-sonnet-latest",
        max_tokens = 4096,
        temperature = 0.2,
        system_prompt = "You are a helpful coding assistant inside Neovim.",
      })

      local map = vim.keymap.set

      -- Claude keymaps
      map("n", "<leader>cc", ":ClaudeChat<CR>", { desc = "Open Claude Chat" })
      map("v", "<leader>ca", ":ClaudeAsk<CR>", { desc = "Ask Claude about code" })
      map("v", "<leader>ce", ":ClaudeEdit<CR>", { desc = "Claude Edit Selection" })
      map("v", "<leader>cx", ":ClaudeExplain<CR>", { desc = "Explain code with Claude" })
    end,
  },
}

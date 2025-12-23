return {
    enabled = os.getenv("CLAUDECODE_ENABLED") == "true",
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
        terminal = { provider = "snacks" },
    },
    keys = {
        { "<leader>a", nil, desc = "AI/Claude Code" },
        { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
        { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
        { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
        { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
        { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
        { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
        { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
        {
            "<leader>as",
            "<cmd>ClaudeCodeTreeAdd<cr>",
            desc = "Add file",
            ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
        },
        -- Diff management
        { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
        { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
    config = function(_, opts)
        require("claudecode").setup(opts)

        -- vim.api.nvim_create_autocmd("TermOpen", {
        --     pattern = { "*" },
        --     callback = function()
        --         local buffer = vim.api.nvim_get_current_buf()
        --         local buf_name = vim.api.nvim_buf_get_name(buffer)
        --         if buf_name:match("claude") then
        --             -- Disable C-w in insert mode for claude code terminals
        --             vim.api.nvim_buf_set_keymap(buffer, "t", "<C-w>", "<Nop>", { desc = "Disable C-w in insert" })
        --         end
        --     end,
        -- })
    end,
}

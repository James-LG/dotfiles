return {
    "olimorris/codecompanion.nvim",
    -- Only one of Claude Code / CodeCompanion loads at a time; Claude wins if both env vars are set.
    enabled = os.getenv("CODECOMPANION_ENABLED") == "true" and os.getenv("CLAUDECODE_ENABLED") ~= "true",
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "zbirenbaum/copilot.lua", -- copilot adapter auth
        "ravitemer/codecompanion-history.nvim", -- save/resume/continue chats
    },
    -- Mirrors the Claude Code <leader>a keymaps (only one plugin is enabled at once).
    keys = {
        { "<leader>a", nil, desc = "AI/CodeCompanion" },
        { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle chat" },
        { "<leader>af", "<cmd>CodeCompanionChat<cr>", desc = "Focus/open chat" },
        { "<leader>ar", "<cmd>CodeCompanionHistory<cr>", desc = "Resume chat (browse history)" },
        {
            "<leader>aC",
            function()
                local history = require("codecompanion").extensions.history
                local latest_id, latest_time = nil, -1
                for save_id, meta in pairs(history.get_chats()) do
                    local updated = meta.updated_at or meta.timestamp or 0
                    if updated > latest_time then
                        latest_time = updated
                        latest_id = meta.save_id or save_id
                    end
                end
                if latest_id then
                    history.load_chat(latest_id)
                else
                    vim.notify("No saved chats to continue", vim.log.levels.INFO)
                end
            end,
            desc = "Continue last chat",
        },
        { "<leader>am", "<cmd>CodeCompanionActions<cr>", desc = "Actions palette" },
        { "<leader>ab", "<cmd>CodeCompanionChat Add<cr>", desc = "Add current buffer" },
        { "<leader>as", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Send to chat" },
    },
    config = function()
        local adapter = os.getenv("CODECOMPANION_ADAPTER") or "copilot"

        require("codecompanion").setup({
            strategies = {
                chat = { adapter = adapter },
                inline = { adapter = adapter },
                cmd = { adapter = adapter },
            },
            adapters = {
                copilot = function()
                    return require("codecompanion.adapters").extend("copilot", {
                        schema = {
                            model = { default = "claude-sonnet-4.5" },
                        },
                    })
                end,
            },
            display = {
                chat = {
                    window = {
                        layout = "vertical",
                        position = "right",
                        width = 0.3,
                    },
                },
            },
            extensions = {
                history = {
                    enabled = true,
                    opts = {
                        auto_save = true,
                        auto_generate_title = true,
                        continue_last_chat = false,
                    },
                },
            },
        })
    end,
}

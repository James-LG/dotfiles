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
        {
            "<leader>af",
            function()
                -- Focus the existing chat if there is one; only create a new
                -- chat when none exists. Plain `:CodeCompanionChat` always spawns
                -- a fresh empty buffer, which hides (and appears to clear) a chat
                -- you just added to via <leader>as.
                local cc = require("codecompanion")
                local chat = cc.last_chat()
                if not chat then
                    return cc.chat()
                end
                if chat.ui:is_visible() then
                    local win = chat.ui.winnr
                    if win and vim.api.nvim_win_is_valid(win) then
                        vim.api.nvim_set_current_win(win)
                    end
                else
                    chat.ui:open()
                end
            end,
            desc = "Focus/open chat",
        },
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
                chat = {
                    adapter = adapter,
                    tools = {
                        opts = {
                            -- Always load these tools in every chat buffer so the
                            -- LLM can read/search the repo without being asked.
                            -- insert_edit_into_file keeps its default post-edit
                            -- confirmation prompt so edits aren't applied blindly.
                            default_tools = {
                                "read_file",
                                "file_search",
                                "grep_search",
                                "insert_edit_into_file",
                                "create_file",
                                "delete_file",
                            },
                        },
                        -- Read-only tools: skip the per-call approval prompt.
                        read_file = { opts = { require_approval_before = false } },
                        grep_search = { opts = { require_approval_before = false } },
                    },
                },
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

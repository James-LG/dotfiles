return {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
        require("copilot").setup({
            panel = {
                enabled = true,
                auto_refresh = true,
            },
            suggestion = {
                auto_trigger = true,
                keymap = {
                    accept = "<C-j>",
                    next = "<C-k>",
                    prev = "<C-h>",
                },
            },
        })
    end,
}

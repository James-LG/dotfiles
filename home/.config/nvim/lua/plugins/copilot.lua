return {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
        require('copilot').setup({
            panel = {
                enabled = true,
                auto_refresh = true,
            },
            suggestion = {
                auto_trigger = true,
                keymap = {
                    accept = "<C-y>",
                    next = "<C-n>",
                    prev = "<C-p>"
                }
            }
        })
    end
}

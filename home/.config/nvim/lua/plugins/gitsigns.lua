return {
    "lewis6991/gitsigns.nvim",
    config = function()
        local gitsigns = require("gitsigns")
        gitsigns.setup({
            current_line_blame = true,
            current_line_blame_opts = {
                delay = 500
            },
            update_debounce = 500,
            on_attach = function(bufnr)
                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- toggles
                map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
                map("n", "<leader>tw", gitsigns.toggle_word_diff)
            end,
        })
    end,
}

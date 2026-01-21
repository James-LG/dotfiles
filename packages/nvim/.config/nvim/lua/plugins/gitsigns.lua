return {
    "lewis6991/gitsigns.nvim",
    config = function()
        local gitsigns = require("gitsigns")
        gitsigns.setup({
            current_line_blame = true,
            current_line_blame_opts = {
                delay = 500,
            },
            update_debounce = 500,
            on_attach = function(bufnr)
                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                map("n", "<leader>gd", gitsigns.diffthis, { desc = "Git diff this" })

                map("n", "<leader>gb", function()
                    gitsigns.blame_line({ full = true })
                end, { desc = "Git blame line" })

                -- toggles
                map("n", "<leader>gtb", gitsigns.toggle_current_line_blame, { desc = "Toggle git blame" })
                map("n", "<leader>gtw", gitsigns.toggle_word_diff, { desc = "Toggle word diff" })
            end,
        })
    end,
}

return {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    config = function()
        require("lint").linters_by_ft = {
            ["javascript"] = { "codespell" },
            ["typescript"] = { "codespell" },
            ["typescriptreact"] = { "codespell" },
            ["text"] = { "codespell" },
            ["markdown"] = { "codespell" },
        }

        vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
            callback = function()
                require("lint").try_lint()
            end,
        })
        vim.keymap.set("n", "<leader>cl", function()
            require("lint").try_lint()
        end)
    end,
}

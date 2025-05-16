return {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    config = function()
        require("lint").linters_by_ft = {
            ["javascript"] = { "eslint_d", "codespell" },
            ["typescript"] = { "eslint_d", "codespell" },
            ["typescriptreact"] = { "eslint_d", "codespell" },
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
    end
}

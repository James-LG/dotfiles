return {
    "danymat/neogen",
    config = function()
        require("neogen").setup({
            enabled = true,
            snippet_engine = "luasnip",
        })
        vim.keymap.set("n", "<leader>ng", function()
            require("neogen").generate()
        end, { noremap = true, silent = true, desc = "Generate docstring with Neogen" })
    end,
}

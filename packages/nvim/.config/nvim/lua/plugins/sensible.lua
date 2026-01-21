return {
    "tpope/vim-sensible",
    config = function()
        -- clear search highlights
        vim.keymap.set(
            "n",
            "<leader>ch",
            ":nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR>",
            { desc = "Clear search highlights" }
        )
    end,
}

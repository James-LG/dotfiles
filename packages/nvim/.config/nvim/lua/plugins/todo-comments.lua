return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("todo-comments").setup({
            -- merge_keywords = false, -- disable default keywords and only use custom ones
            keywords = {
                JAMES = { icon = "J", color = "info" },
            },
            highlight = {
                keyword = "bg",
                pattern = [[.*(KEYWORDS)\(james\)\s*:]], -- vim regex
            },
            search = {
                pattern = [[\b(KEYWORDS)\s*\(james\)\s*:]], -- ripgrep regex
            },
        })
    end,
}

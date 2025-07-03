return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("todo-comments").setup({
            keywords = {
                JAMES = { icon = "J", color = "info" },
            },
            highlight = {
                pattern = [[.*<(KEYWORDS)\(james\):]], -- vim regex
            },
            search = {
                pattern = [[\b(KEYWORDS)\(james\):]], -- ripgrep regex
            },
        })
    end,
}

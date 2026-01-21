return {
    "nvim-mini/mini.nvim",
    version = false,
    config = function()
        require("mini.ai").setup()
        require("mini.operators").setup({
            replace = { prefix = "cr" },
            exchange = { prefix = "cx" },
            multiply = { prefix = "cm" },
            sort = { prefix = "cs" },
            evaluate = { prefix = "c=" },
        })
        require("mini.bracketed").setup({
            spell = { suffix = "" }, -- Disable spell navigation to free up [s and ]s
        })
        require("mini.splitjoin").setup()
        require("mini.surround").setup()
    end,
}

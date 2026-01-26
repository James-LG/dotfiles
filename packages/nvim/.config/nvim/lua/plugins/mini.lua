return {
    "nvim-mini/mini.nvim",
    version = false,
    config = function()
        require("mini.ai").setup()
        require("mini.operators").setup({
            replace = { prefix = "gcr" },
            exchange = { prefix = "gcx" },
            multiply = { prefix = "gcm" },
            sort = { prefix = "gcs" },
            evaluate = { prefix = "gc=" },
        })
        require("mini.bracketed").setup({
            spell = { suffix = "" }, -- Disable spell navigation to free up [s and ]s
        })
        require("mini.splitjoin").setup()
        require("mini.surround").setup()
    end,
}

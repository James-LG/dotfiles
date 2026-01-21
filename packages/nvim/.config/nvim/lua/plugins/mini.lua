return {
    "nvim-mini/mini.nvim",
    version = false,
    config = function()
        require("mini.ai").setup()
        require("mini.operators").setup()
        require("mini.bracketed").setup({
            spell = { suffix = "" }, -- Disable spell navigation to free up [s and ]s
        })
        require("mini.splitjoin").setup()
        require("mini.surround").setup()
    end,
}

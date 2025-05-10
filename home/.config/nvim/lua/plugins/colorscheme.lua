return {
    -- add gruvbox
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false, -- load during startup since it is the main colorscheme
        priority = 1000, -- load before all other start plugins
        config = function()
            require("gruvbox").setup({
                transparent_mode = true
            })
            vim.cmd([[colorscheme gruvbox]])
        end,
    },
}

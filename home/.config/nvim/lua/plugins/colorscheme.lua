return {
    -- add gruvbox
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false, -- load during startup since it is the main colorscheme
        priority = 1000, -- load before all other start plugins
        config = function()
            vim.cmd([[colorscheme gruvbox]])
        end,
    },
}
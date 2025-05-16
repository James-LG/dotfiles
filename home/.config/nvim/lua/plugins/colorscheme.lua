return {
    -- {
    --     "folke/tokyonight.nvim",
    --     lazy = false, -- load during startup since it is the main colorscheme
    --     priority = 1000, -- load before all other start plugins
    --     config = function()
    --         require("tokyonight").setup({
    --             transparent = true
    --         })
    --         vim.cmd([[colorscheme tokyonight]])
    --     end,
    -- },
    -- {
    --     "ellisonleao/gruvbox.nvim",
    --     lazy = false, -- load during startup since it is the main colorscheme
    --     priority = 1000, -- load before all other start plugins
    --     config = function()
    --         require("gruvbox").setup({
    --             transparent_mode = true
    --         })
    --         vim.cmd([[colorscheme gruvbox]])
    --     end,
    -- },
    {
        "sainnhe/gruvbox-material",
        lazy = false, -- load during startup since it is the main colorscheme
        priority = 1000, -- load before all other start plugins
        config = function()
            vim.g.gruvbox_material_transparent_background = 1
            vim.cmd([[colorscheme gruvbox-material]])
        end,
    },
}

return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = "make",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua", -- for providers='copilot'
        "MeanderingProgrammer/render-markdown.nvim", -- markdown rendering
        "HakonHarnes/img-clip.nvim", -- image pasting
    },
    keys = {
        {
            "<leader>a+",
            function()
                local tree_ext = require("avante.extensions.nvim_tree")
                tree_ext.add_file()
            end,
            desc = "Select file in NvimTree",
            ft = "NvimTree",
        },
        {
            "<leader>a-",
            function()
                local tree_ext = require("avante.extensions.nvim_tree")
                tree_ext.remove_file()
            end,
            desc = "Deselect file in NvimTree",
            ft = "NvimTree",
        },
    },
    config = function()
        local ai_provider = os.getenv("AVANTE_AI_PROVIDER") or "copilot"

        require("avante").setup({
            debug = false,
            provider = ai_provider,
            providers = {
                gemini = {
                    model = "gemini-2.5-flash",
                },
                copilot = {
                    model = "gpt-4o",
                },
            },
            web_search_engine = {
                provider = "google",
            },
        })
    end,
}

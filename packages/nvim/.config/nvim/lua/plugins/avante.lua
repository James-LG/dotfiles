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
    config = function()
        local ai_provider = os.getenv("AVANTE_AI_PROVIDER") or "copilot"

        require("avante").setup({
            provider = ai_provider,
            -- other shared avante settings
        })
    end,
}

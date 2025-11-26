return {
    -- Make sure to set this up properly if you have lazy=true
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
        file_types = { "markdown", "Avante" },
        code = {
            style = "full",
            border = "thin",
        },
        heading = {
            icons = {},
        },
    },
    ft = { "markdown", "Avante" },
}

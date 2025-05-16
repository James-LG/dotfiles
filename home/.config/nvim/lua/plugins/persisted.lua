return {
    "olimorris/persisted.nvim",
    lazy = false,
    enabled = false,
    config = function()
        require("persisted").setup({
            autoload = true
        })
        require("telescope").load_extension("persisted")
    end,
}

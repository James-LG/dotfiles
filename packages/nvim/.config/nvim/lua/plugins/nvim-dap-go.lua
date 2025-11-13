return {
    "leoluz/nvim-dap-go",
    enabled = false,
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
        require("dap-go").setup({
            -- delve = {
            --     output_mode = "remote", -- Could be "local" or "remote"
            -- },
        })
    end,
}

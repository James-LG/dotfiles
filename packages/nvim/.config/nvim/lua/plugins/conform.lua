return {
    enabled = true,
    "stevearc/conform.nvim",
    opts = {
        default_format_opts = {
            lsp_format = "fallback",
        },
        formatters_by_ft = {
            lua = { "stylua" },
            typescript = { "prettierd" },
            typescriptreact = { "prettierd" },
        },
    },
    config = function(_, opts)
        local conform = require("conform")
        conform.setup(opts)

        vim.keymap.set("n", "<leader>cf", function()
            conform.format()
        end)

        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*",
            callback = function(args)
                require("conform").format({ bufnr = args.buf })
            end,
        })
    end,
}

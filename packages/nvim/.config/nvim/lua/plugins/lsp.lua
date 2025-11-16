return {
    enabled = true,
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "stevearc/conform.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        require("conform").setup({
            formatters_by_ft = {},
        })
        local cmp = require("cmp")

        require("fidget").setup({
            notification = {
                window = {
                    avoid = { "NvimTree" },
                },
            },
        })

        -- BEGIN remove mason on nixos
        require("mason").setup()
        require("mason-lspconfig").setup({
            automatic_enable = {
                exclude = {
                    "ts_ls",
                },
            },
            ensure_installed = {
                "gopls",
                "ts_ls",
                "lua_ls",
                "eslint",
            },
        })
        require("mason-tool-installer").setup({
            ensure_installed = {
                "prettierd",
                "stylua",
                "codespell",
            },
        })
        -- END remove mason on nixos

        -- lsps
        -- require('lspconfig').pyright.setup({})
        -- require('lspconfig').lua_ls.setup({})
        -- require('lspconfig').rust_analyzer.setup({})
        -- require('lspconfig').ts_ls.setup({})
        -- require('lspconfig').nil_ls.setup({})
        -- require('lspconfig').elixirls.setup({})
        vim.lsp.config("ts_ls", {
            settings = {
                typescript = {
                    format = {
                        indentSize = 2,
                        tabSize = 2,
                        preferEditorConfig = true,
                    },
                },
                javascript = {
                    format = {
                        indentSize = 2,
                        tabSize = 2,
                        preferEditorConfig = true,
                    },
                },
            },
        })
        vim.lsp.enable("ts_ls")

        -- extra keybinds
        vim.keymap.set("n", "grt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
        vim.keymap.set("n", "grd", vim.lsp.buf.definition, { desc = "Go to definition" })
        vim.keymap.set("n", "grD", vim.lsp.buf.declaration, { desc = "Go to declaration" })

        -- completions
        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" }, -- For luasnip users.
            }, {
                { name = "buffer" },
            }),
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })

        -- find all references with telescope
        vim.keymap.set("n", "<leader>gr", function()
            require("telescope.builtin").lsp_references()
        end, {})
    end,
}

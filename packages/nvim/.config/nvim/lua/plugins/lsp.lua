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
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })

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
                header = "",
                prefix = "",
            },
        })

        -- find all references with telescope
        vim.keymap.set("n", "<leader>gr", function()
            require("telescope.builtin").lsp_references()
        end, {})

        -- LSP reference highlighting
        local highlight_ns = vim.api.nvim_create_namespace("lsp_references")

        -- Set custom highlight for references with bold and underline
        vim.api.nvim_set_hl(0, "LspReferenceText", { bold = true, underline = true })

        local function highlight_references()
            -- Clear existing highlights first
            vim.api.nvim_buf_clear_namespace(0, highlight_ns, 0, -1)

            local params = vim.lsp.util.make_position_params(0, "utf-16")
            vim.lsp.buf_request(0, "textDocument/references", params, function(err, result)
                if err then
                    vim.notify("Error getting references: " .. vim.inspect(err), vim.log.levels.ERROR)
                    return
                end

                if not result or vim.tbl_isempty(result) then
                    vim.notify("No references found", vim.log.levels.INFO)
                    return
                end

                local bufnr = vim.api.nvim_get_current_buf()
                local count = 0

                for _, ref in ipairs(result) do
                    if ref.range then
                        local ref_bufnr = vim.uri_to_bufnr(ref.uri)
                        -- Only highlight references in the current buffer
                        if ref_bufnr == bufnr then
                            local start_line = ref.range.start.line
                            local start_col = ref.range.start.character
                            local end_line = ref.range["end"].line
                            local end_col = ref.range["end"].character

                            vim.api.nvim_buf_set_extmark(bufnr, highlight_ns, start_line, start_col, {
                                end_line = end_line,
                                end_col = end_col,
                                hl_group = "LspReferenceText",
                            })
                            count = count + 1
                        end
                    end
                end

                vim.notify(string.format("Highlighted %d references", count), vim.log.levels.INFO)
            end)
        end

        local function clear_reference_highlights()
            vim.api.nvim_buf_clear_namespace(0, highlight_ns, 0, -1)
            vim.notify("Cleared reference highlights", vim.log.levels.INFO)
        end

        vim.keymap.set("n", "<leader>*", highlight_references, { desc = "Highlight LSP references" })
        vim.keymap.set("n", "<leader>c*", clear_reference_highlights, { desc = "Clear reference highlights" })
    end,
}

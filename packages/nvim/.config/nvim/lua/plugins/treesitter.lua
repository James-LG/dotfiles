return {
    {
        enabled = true,
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        lazy = false,
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter-textobjects",
                branch = "main",
                config = function()
                    -- You can use the capture groups defined in `textobjects.scm`
                    --
                    -- Select
                    vim.keymap.set({ "x", "o" }, "am", function()
                        require("nvim-treesitter-textobjects.select").select_textobject(
                            "@function.outer",
                            "textobjects"
                        )
                    end, { desc = "Select outer function" })
                    vim.keymap.set({ "x", "o" }, "im", function()
                        require("nvim-treesitter-textobjects.select").select_textobject(
                            "@function.inner",
                            "textobjects"
                        )
                    end, { desc = "Select inner function" })
                    vim.keymap.set({ "x", "o" }, "ac", function()
                        require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
                    end, { desc = "Select outer class" })
                    vim.keymap.set({ "x", "o" }, "ic", function()
                        require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
                    end, { desc = "Select inner class" })
                    -- You can also use captures from other query groups like `locals.scm`
                    vim.keymap.set({ "x", "o" }, "as", function()
                        require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
                    end, { desc = "Select local scope" })
                    -- Swap
                    vim.keymap.set("n", "<leader>s", function()
                        require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
                    end, { desc = "Swap next parameter" })

                    vim.keymap.set("n", "<leader>S", function()
                        require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
                    end, { desc = "Swap previous parameter" })

                    -- Move
                    vim.keymap.set({ "n", "x", "o" }, "]m", function()
                        require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
                    end, { desc = "Next function start" })
                    vim.keymap.set({ "n", "x", "o" }, "]]", function()
                        require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
                    end, { desc = "Next class start" })
                    -- You can also pass a list to group multiple queries.
                    vim.keymap.set({ "n", "x", "o" }, "]o", function()
                        require("nvim-treesitter-textobjects.move").goto_next_start(
                            { "@loop.inner", "@loop.outer" },
                            "textobjects"
                        )
                    end, { desc = "Next loop start" })
                    -- You can also use captures from other query groups like `locals.scm` or `folds.scm`
                    vim.keymap.set({ "n", "x", "o" }, "]s", function()
                        require("nvim-treesitter-textobjects.move").goto_next_start("@local.scope", "locals")
                    end, { desc = "Next scope start" })
                    vim.keymap.set({ "n", "x", "o" }, "]z", function()
                        require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
                    end, { desc = "Next fold start" })

                    vim.keymap.set({ "n", "x", "o" }, "]M", function()
                        require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
                    end, { desc = "Next function end" })
                    vim.keymap.set({ "n", "x", "o" }, "][", function()
                        require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
                    end, { desc = "Next class end" })

                    vim.keymap.set({ "n", "x", "o" }, "[m", function()
                        require("nvim-treesitter-textobjects.move").goto_previous_start(
                            "@function.outer",
                            "textobjects"
                        )
                    end, { desc = "Previous function start" })
                    vim.keymap.set({ "n", "x", "o" }, "[o", function()
                        require("nvim-treesitter-textobjects.move").goto_previous_start(
                            { "@loop.inner", "@loop.outer" },
                            "textobjects"
                        )
                    end, { desc = "Previous loop start" })
                    vim.keymap.set({ "n", "x", "o" }, "[s", function()
                        require("nvim-treesitter-textobjects.move").goto_previous_start("@local.scope", "locals")
                    end, { desc = "Previous scope start" })
                    vim.keymap.set({ "n", "x", "o" }, "[z", function()
                        require("nvim-treesitter-textobjects.move").goto_previous_start("@fold", "folds")
                    end, { desc = "Previous fold start" })
                    vim.keymap.set({ "n", "x", "o" }, "[[", function()
                        require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
                    end, { desc = "Previous class start" })

                    vim.keymap.set({ "n", "x", "o" }, "[M", function()
                        require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
                    end, { desc = "Previous function end" })
                    vim.keymap.set({ "n", "x", "o" }, "[]", function()
                        require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
                    end, { desc = "Previous class end" })
                end,
            },
        },
        config = function()
            local treesitter = require("nvim-treesitter")
            treesitter.install({
                "bash",
                "c",
                "diff",
                "html",
                "javascript",
                "json",
                "lua",
                "luadoc",
                "markdown",
                "markdown_inline",
                "python",
                "regex",
                "toml",
                "typescript",
                "tsx",
                "vim",
                "xml",
                "yaml",
                "rust",
                "nix",
                "go",
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "go", "typescript", "typescriptreact", "javascript", "tsx" },
                callback = function()
                    vim.treesitter.start()
                    vim.bo.indentexpr = "v:lua:require'nvim-treesitter'.indentexpr()"
                    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                end,
            })
        end,
    },
}

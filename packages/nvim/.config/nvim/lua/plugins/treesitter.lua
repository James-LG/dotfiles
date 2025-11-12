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
                    vim.keymap.set("n", "<leader>s", function()
                        require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
                    end, { desc = "Swap next parameter" })

                    vim.keymap.set("n", "<leader>S", function()
                        require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
                    end, { desc = "Swap next parameter" })
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

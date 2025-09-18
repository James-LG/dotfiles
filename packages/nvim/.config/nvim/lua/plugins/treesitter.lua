return {
    {
        enabled = true,
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        opts = {
            highlight = { enable = true },
            indent = {
                enable = true, -- Keep Treesitter indentation generally enabled
                disable = {
                    "typescript", -- Disable Treesitter indent for TypeScript
                    "typescriptreact", -- Disable Treesitter indent for TSX
                    -- Add other filetypes where you want .editorconfig/formatters to rule
                },
            },
            ensure_installed = {
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
            },
            textobjects = {
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>s"] = { query = "@parameter.inner", desc = "Swap next parameter" },
                    },
                    swap_previous = {
                        ["<leader>S"] = { query = "@parameter.inner", desc = "Swap previous parameter" },
                    },
                },
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
}

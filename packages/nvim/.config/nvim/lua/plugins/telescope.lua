return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-live-grep-args.nvim",
    },
    config = function()
        local telescope = require("telescope")
        local lga_actions = require("telescope-live-grep-args.actions")
        telescope.setup({
            defaults = {
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--hidden",
                    "--glob",
                    "!**/.git/*",
                },
            },
            extensions = {
                live_grep_args = {
                    auto_quoting = true, -- enable/disable auto-quoting
                    mappings = {
                        i = {
                            ["<C-g>"] = lga_actions.quote_prompt({ postfix = " --glob " }),
                            ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --ignore-case " }),
                        },
                    },
                },
            },
        })
        telescope.load_extension("live_grep_args")

        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>pf", function()
            builtin.find_files({ find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" } })
        end, { desc = "Find files" })
        vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Find git files" })
        vim.keymap.set("n", "<leader>pws", function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end, { desc = "Search word under cursor" })
        vim.keymap.set("n", "<leader>pWs", function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end, { desc = "Search WORD under cursor" })
        vim.keymap.set("n", "<leader>ps", builtin.live_grep, { desc = "Search with live grep" })
        vim.keymap.set("n", "<leader>pS", function()
            telescope.extensions.live_grep_args.live_grep_args({
                prompt_title = "Live Grep Args",
            })
        end, { desc = "Search with live grep args" })
        vim.keymap.set("n", "<leader>ph", builtin.help_tags, { desc = "Search help tags" })
        vim.keymap.set("n", "<leader>pb", builtin.buffers, { desc = "Search buffers" })
    end,
}

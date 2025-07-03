return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },

    opts = {
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
    },

    config = function(_, opts)
        require("telescope").setup(opts)

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
        vim.keymap.set("n", "<leader>ph", builtin.help_tags, { desc = "Search help tags" })
        vim.keymap.set("n", "<leader>pb", builtin.buffers, { desc = "Search buffers" })
    end,
}

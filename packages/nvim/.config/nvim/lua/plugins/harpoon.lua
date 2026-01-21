return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },

    config = function()
        local harpoon = require("harpoon")

        harpoon:setup()

        vim.keymap.set("n", "<leader>H", function()
            harpoon:list():prepend()
        end, { desc = "Harpoon: Prepend file to list" })
        vim.keymap.set("n", "<leader>h", function()
            harpoon:list():add()
        end, { desc = "Harpoon: Add file to list" })
        vim.keymap.set("n", "<C-e>", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Harpoon: Toggle quick menu" })

        vim.keymap.set("n", "<C-h>", function()
            harpoon:list():select(1)
        end, { desc = "Harpoon: Select file 1" })
        vim.keymap.set("n", "<C-j>", function()
            harpoon:list():select(2)
        end, { desc = "Harpoon: Select file 2" })
        vim.keymap.set("n", "<C-k>", function()
            harpoon:list():select(3)
        end, { desc = "Harpoon: Select file 3" })
        vim.keymap.set("n", "<C-l>", function()
            harpoon:list():select(4)
        end, { desc = "Harpoon: Select file 4" })
        vim.keymap.set("n", "<leader><C-h>", function()
            harpoon:list():replace_at(1)
        end, { desc = "Harpoon: Replace at position 1" })
        vim.keymap.set("n", "<leader><C-j>", function()
            harpoon:list():replace_at(2)
        end, { desc = "Harpoon: Replace at position 2" })
        vim.keymap.set("n", "<leader><C-k>", function()
            harpoon:list():replace_at(3)
        end, { desc = "Harpoon: Replace at position 3" })
        vim.keymap.set("n", "<leader><C-l>", function()
            harpoon:list():replace_at(4)
        end, { desc = "Harpoon: Replace at position 4" })
    end,
}

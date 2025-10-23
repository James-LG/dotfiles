vim.g.mapleader = " "
-- commented out while using nvim-tree
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
--

-- Move selected line / block of text in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Open focusaable diagnostics window
vim.keymap.set("n", "<C-w>d", function()
    vim.diagnostic.open_float({ focusable = true })
end, { desc = "Open Diagnostics Float" })

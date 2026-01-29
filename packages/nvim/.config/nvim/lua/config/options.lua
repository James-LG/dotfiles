vim.o.clipboard = "unnamedplus"

vim.o.number = true
vim.o.relativenumber = true

vim.o.signcolumn = "yes"

vim.o.updatetime = 300

vim.o.termguicolors = true

vim.o.mouse = "a"

vim.opt.smartindent = true

vim.opt.scrolloff = 8 -- Keep lines below and above the cursor

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.wrap = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.list = true -- show whitespace
local space = "·"
vim.opt.listchars:append({
    tab = "│─",
    multispace = space,
    lead = space,
    trail = space,
    nbsp = space,
})

vim.opt.cursorline = true
vim.opt.hlsearch = true -- higlight search matches as you type

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"

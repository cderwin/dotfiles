vim.cmd.colorscheme "tokyonight"

-- display settings
vim.opt.number = true
vim.opt.wrap = false
vim.opt.termguicolors = true

-- tab/indent settings
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smarttab = true

-- set terminal high to prevent extra prompt
vim.opt.cmdheight = 2

-- search settings
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- lsp settings
vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true }, })

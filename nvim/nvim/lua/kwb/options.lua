-- Basic UI tweaks
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.wrap = false

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = false

-- Window splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- No tabs, all spaces
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- Timeouts
vim.opt.timeoutlen = 250
--vim.opt.updatetime = 250

-- Misc files
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.writebackup = false

-- Completions
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.pumheight = 8

-- Misc
vim.opt.clipboard = "unnamedplus"
vim.opt.iskeyword:append("-")
vim.opt.whichwrap:append "<,>,[,],h,l"

-- Don't use ruby or perl
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- TODO: Needed?
-- vim.opt.rtp:append "/opt/homebrew/opt/fzf"

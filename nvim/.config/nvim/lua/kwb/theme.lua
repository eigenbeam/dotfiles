-- Colorscheme and statusline (mirrors emacs/lisp/theme.el).
-- Zenwritten (zenbones family). lush.nvim is optional upstream, but the
-- lush-free "compat" file lacks tree-sitter, LSP semantic token, Telescope,
-- blink.cmp and mini.icons groups; the lush spec has all of them.
require("kwb.pack")({
    "rktjmp/lush.nvim",
    "zenbones-theme/zenbones.nvim",
    "nvim-tree/nvim-web-devicons",
    "echasnovski/mini.nvim",
})

vim.g.zenwritten = { darken_comments = 45 } -- default 38; a bit more contrast
vim.o.background = "light" -- read by zenbones at colorscheme time: the light/dark switch
vim.cmd.colorscheme("zenwritten")

local statusline = require("mini.statusline")
statusline.setup({ use_icons = true })
statusline.section_location = function()
    return "%2l:%-2v"
end

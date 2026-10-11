-- Colorscheme and statusline (mirrors emacs/lisp/theme.el).
require("kwb.pack")({
    "ellisonleao/gruvbox.nvim",
    "nvim-tree/nvim-web-devicons",
    "echasnovski/mini.nvim",
})

require("gruvbox").setup({
    contrast = "soft",
})
vim.o.background = "dark"
vim.cmd.colorscheme("gruvbox")

local statusline = require("mini.statusline")
statusline.setup({ use_icons = true })
statusline.section_location = function()
    return "%2l:%-2v"
end

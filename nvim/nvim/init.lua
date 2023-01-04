if vim.g.vscode then
  -- VSCode extension is running, do not customize
else
  require("kwb.options")
  require("kwb.bootstrap")
  require("kwb.plugins")
  require("kwb.keymaps")

  require("kwb.autocmds")
  require("kwb.cmp")

  require("kwb.toggleterm")
  require("kwb.telescope")
  require("kwb.treesitter")

  require("kwb.lsp")

  vim.cmd 'colorscheme modus-operandi'
end

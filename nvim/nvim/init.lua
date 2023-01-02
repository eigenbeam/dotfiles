if vim.g.vscode then
  -- VSCode extension is running, do not customize
else
  require("kwb.options")
  require("kwb.bootstrap")
  require("kwb.plugins")
  require("kwb.keymaps")
  require("kwb.mason")
  require("kwb.lspcfg")

  vim.cmd 'colorscheme modus-operandi'
end

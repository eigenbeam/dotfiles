if vim.g.vscode then
  -- VSCode extension is running, do not use plugins
  require("kwb.options")
else
  require("kwb.options")
  require("kwb.bootstrap")
  require("kwb.plugins")
  require("kwb.config")
end

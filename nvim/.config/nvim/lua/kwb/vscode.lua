-- Running inside VS Code (vscode-neovim). basics.lua already set the shared
-- options and keymaps; these route editor actions to VS Code commands.
local vscode = require("vscode")
local function action(name)
    return function()
        vscode.action(name)
    end
end
local keymap = vim.keymap.set

keymap("n", "<leader>w", action("workbench.action.files.save"), { desc = "Save file" })
keymap("n", "<leader>q", action("workbench.action.closeActiveEditor"), { desc = "Close editor" })
keymap("n", "<leader>e", action("workbench.view.explorer"), { desc = "Toggle explorer" })
keymap("n", "<leader>f", action("workbench.action.quickOpen"), { desc = "Quick open file" })
keymap("n", "<leader>b", action("workbench.action.showAllEditors"), { desc = "Show all editors" })
keymap("n", "<leader>g", action("workbench.action.findInFiles"), { desc = "Find in files" })
keymap("n", "<leader>sv", action("workbench.action.splitEditorRight"), { desc = "Split right" })
keymap("n", "<leader>sh", action("workbench.action.splitEditorDown"), { desc = "Split down" })
keymap("n", "gd", action("editor.action.revealDefinition"), { desc = "Go to definition" })
keymap("n", "gr", action("editor.action.goToReferences"), { desc = "Go to references" })
keymap("n", "K", action("editor.action.showHover"), { desc = "Show hover" })
keymap("n", "<leader>rn", action("editor.action.rename"), { desc = "Rename" })
keymap("n", "<leader>ca", action("editor.action.quickFix"), { desc = "Code action" })

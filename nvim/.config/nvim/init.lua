-- ============================================================================
-- Neovim Configuration
-- ============================================================================
-- Neovim 0.12+. Plugins are managed by the built-in vim.pack (lockfile:
-- nvim-pack-lock.json). The config lives in lua/kwb/, mirroring the Emacs
-- lisp/ layout: basics, theme, packages, dev. See README.md.
-- ============================================================================

vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable unused providers (silences checkhealth warnings)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

require("kwb.basics")

if vim.g.vscode then
    require("kwb.vscode")
    return
end

-- Build steps for plugins that need them. Registered before the first
-- vim.pack.add() so it also fires for installs from the lockfile.
vim.api.nvim_create_autocmd("PackChanged", {
    group = vim.api.nvim_create_augroup("kwb-pack-hooks", { clear = true }),
    callback = function(ev)
        local name, kind, path = ev.data.spec.name, ev.data.kind, ev.data.path
        if kind == "delete" then
            return
        end
        if name == "telescope-fzf-native.nvim" then
            vim.system({ "make" }, { cwd = path }):wait()
        elseif name == "nvim-treesitter" and kind == "update" then
            if not ev.data.active then
                vim.cmd.packadd("nvim-treesitter")
            end
            require("nvim-treesitter").update():wait(300000)
        end
    end,
})

require("kwb.theme")
require("kwb.packages")
require("kwb.dev")

-------------------------------------------------------------------------------
-- Options
-------------------------------------------------------------------------------
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.laststatus = 3
vim.opt.cmdheight = 0
vim.opt.numberwidth = 4
vim.opt.signcolumn = "yes"

-------------------------------------------------------------------------------
-- Keymap
-------------------------------------------------------------------------------
-- Tab/Shift+tab to indent/dedent
vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("n", "<Tab>", "v><C-\\><C-N>")
vim.keymap.set("v", "<S-Tab>", "<gv")
vim.keymap.set("n", "<S-Tab>", "v<<C-\\><C-N>")
vim.keymap.set("i", "<S-Tab>", "<C-\\><C-N>v<<C-\\><C-N>^i")

-------------------------------------------------------------------------------
-- Bootstrap Package Manager
-------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------
require("lazy").setup {
    { "sainnhe/everforest",
        config = function()
            vim.opt.termguicolors = true
            vim.g.everforest_background = "hard"
            vim.g.everforest_disable_italic_comment = true
            vim.cmd.colorscheme("everforest")
        end },
    { "nvim-lualine/lualine.nvim",
        dependencies = "kyazdani42/nvim-web-devicons",
        config = true },
    { "nvim-neo-tree/neo-tree.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons",
            "MunifTanjim/nui.nvim"
        },
        keys = {
            { "<C-b>", "<CMD>NeoTreeFocusToggle<CR>", mode = { "n", "i", "v" } }
        },
        config = true },
    { "ethanholz/nvim-lastplace", config = true },
    { "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = "nvim-lua/plenary.nvim",
        keys = {
            { "<C-t>", "<CMD>Telescope<CR>", mode = { "n", "i", "v" } },
            { "<C-p>", "<CMD>Telescope find_files<CR>", mode = { "n", "i", "v" } },
            { "<C-l>", "<CMD>Telescope live_grep<CR>", mode = { "n", "i", "v" } },
            { "<C-c>", "<CMD>Telescope commands<CR>", mode = { "n", "i", "v" } },
            { "<C-k>", "<CMD>Telescope keymaps<CR>", mode = { "n", "i", "v" } },
            { "<C-s>", "<CMD>Telescope grep_string<CR>", mode = { "n", "i", "v" } },
        },
        config = true },
    { "VonHeikemen/lsp-zero.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",
            { "lukas-reineke/lsp-format.nvim", config = true },
        },
        config = function()
            local lsp = require("lsp-zero")
            lsp.preset("recommended")
            lsp.on_attach(function(client, bufnr)
                require("lsp-format").on_attach(client, bufnr)
            end)
            lsp.nvim_workspace()
            lsp.setup()
            vim.diagnostic.config { virtual_text = true }
        end },
    { "nvim-treesitter/nvim-treesitter",
        commit = "4cccb6f494eb255b32a290d37c35ca12584c74d0", -- HEAD is often broken
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = { "c", "lua", "rust" },
                highlight = { enable = true, }
            }
        end },
    { "terrortylor/nvim-comment",
        keys = {
            { "<C-_>", "<CMD>CommentToggle<CR>j", mode = { "n" } },
            { "<C-_>", "<C-\\><C-N><CMD>CommentToggle<CR>ji", mode = { "i" } },
            { "<C-_>", ":'<,'>CommentToggle<CR>gv<esc>j", mode = { "v" } },
        },
        config = function()
            require("nvim_comment").setup()
        end },
    { "fedepujol/move.nvim",
        keys = {
            { "<A-Down>", ":MoveLine(1)<CR>", mode = { "n" } },
            { "<A-Up>", ":MoveLine(-1)<CR>", mode = { "n" } },
            { "<A-Down>", ":MoveBlock(1)<CR>", mode = { "v" } },
            { "<A-Up>", ":MoveBlock(-1)<CR>", mode = { "v" } },
            { "<A-Down>", "<C-\\><C-N>:MoveLine(1)<CR>i", mode = { "i" } },
            { "<A-Up>", "<C-\\><C-N>:MoveLine(-1)<CR>i", mode = { "i" } },
        } },
    { "sindrets/diffview.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "TimUntersberger/neogit", config = { disable_commit_confirmation = true } },
        },
        commit = "9359f7b1dd3cb9fb1e020f57a91f8547be3558c6", -- HEAD requires git 2.31
        keys = {
            { "<C-g>", "<CMD>DiffviewOpen<CR>", mode = { "n", "i", "v" } }
        },
        config = {
            keymaps = {
                view = {
                    ["<C-g>"] = "<CMD>DiffviewClose<CR>",
                    ["c"] = "<CMD>DiffviewClose|Neogit commit<CR>",
                },
                file_panel = {
                    ["<C-g>"] = "<CMD>DiffviewClose<CR>",
                    ["c"] = "<CMD>DiffviewClose|Neogit commit<CR>",
                },
            },
        } },
    { "akinsho/toggleterm.nvim",
        config = { open_mapping = [[<c-\>]], direction = "tab" } },
}
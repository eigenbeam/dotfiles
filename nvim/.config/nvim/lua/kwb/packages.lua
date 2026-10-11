-- Editing, navigation, git, and UI plugins (mirrors emacs/lisp/packages.el).
-- mini.nvim is added in theme.lua.
require("kwb.pack")({
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-fzf-native.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope.nvim",
    { src = "nvim-treesitter/nvim-treesitter", version = "main" },
    "nvim-treesitter/nvim-treesitter-context",
    "lewis6991/gitsigns.nvim",
    "kdheepak/lazygit.nvim",
    "mrjones2014/smart-splits.nvim",
    "folke/which-key.nvim",
    "folke/todo-comments.nvim",
    "folke/zen-mode.nvim",
    "NMAC427/guess-indent.nvim",
})

local keymap = vim.keymap.set

-- ── Fuzzy Finder (telescope) ─────────────────────────────────────────────
require("telescope").setup({
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
        },
    },
})
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")

local builtin = require("telescope.builtin")
keymap("n", "<leader>s?", builtin.help_tags, { desc = "Search help" })
keymap("n", "<leader>sk", builtin.keymaps, { desc = "Search keymaps" })
keymap("n", "<leader>sf", builtin.find_files, { desc = "Search files" })
keymap("n", "<leader>sw", builtin.grep_string, { desc = "Search current word" })
keymap("n", "<leader>sg", builtin.live_grep, { desc = "Search by grep" })
keymap("n", "<leader>sd", builtin.diagnostics, { desc = "Search diagnostics" })
keymap("n", "<leader>sr", builtin.resume, { desc = "Search resume" })
keymap("n", "<leader>s.", builtin.oldfiles, { desc = "Search recent files" })
keymap("n", "<leader>sb", builtin.buffers, { desc = "Search buffers" })
keymap("n", "<leader>sn", function()
    builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Search neovim config" })

-- Notes
keymap("n", "<leader>sN", function()
    builtin.live_grep({ cwd = vim.fn.expand("~/notes") })
end, { desc = "Search notes" })
keymap("n", "<leader>sO", function()
    builtin.find_files({ cwd = vim.fn.expand("~/notes") })
end, { desc = "Browse notes" })

-- Git pickers
keymap("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
keymap("n", "<leader>gf", builtin.git_bcommits, { desc = "Git file history" })
keymap("n", "<leader>gs", builtin.git_status, { desc = "Git status" })

keymap("n", "<leader>/", function()
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
    }))
end, { desc = "Fuzzy find in buffer" })

-- ── Treesitter ───────────────────────────────────────────────────────────
local filetypes = {
    "bash",
    "c",
    "cpp",
    "css",
    "diff",
    "dockerfile",
    "hcl",
    "html",
    "java",
    "javascript",
    "json",
    "julia",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "sql",
    "terraform",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
}
require("nvim-treesitter").install(filetypes)
vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    callback = function()
        vim.treesitter.start()
    end,
})

-- Sticky function/class headers
require("treesitter-context").setup({ max_lines = 3 })

-- ── Zen Mode (distraction-free editing) ──────────────────────────────────
require("zen-mode").setup({ window = { width = 90 } })
keymap("n", "<leader>tz", "<cmd>ZenMode<cr>", { desc = "Toggle zen mode" })

-- ── Mini.nvim (textobjects, surround) ────────────────────────────────────
require("mini.ai").setup({ n_lines = 500 })
require("mini.surround").setup()

-- ── Git Signs ────────────────────────────────────────────────────────────
require("gitsigns").setup({
    signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
    },
    on_attach = function(bufnr)
        local gitsigns = require("gitsigns")
        local map = function(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end
        map("n", "]h", gitsigns.next_hunk, { desc = "Next git hunk" })
        map("n", "[h", gitsigns.prev_hunk, { desc = "Previous git hunk" })
        map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
        map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })
        map("n", "<leader>hb", gitsigns.blame_line, { desc = "Blame line" })
        map("n", "<leader>hd", function()
            gitsigns.diffthis()
        end, { desc = "Diff against index" })
        map("n", "<leader>hD", function()
            gitsigns.diffthis("~")
        end, { desc = "Diff against last commit" })
    end,
})

-- ── Git (lazygit) ────────────────────────────────────────────────────────
keymap("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })

-- ── Navigation (nvim/tmux seamless) ──────────────────────────────────────
local splits = require("smart-splits")
splits.setup({})
keymap("n", "<C-h>", splits.move_cursor_left, { desc = "Move to left split/pane" })
keymap("n", "<C-j>", splits.move_cursor_down, { desc = "Move to below split/pane" })
keymap("n", "<C-k>", splits.move_cursor_up, { desc = "Move to above split/pane" })
keymap("n", "<C-l>", splits.move_cursor_right, { desc = "Move to right split/pane" })
keymap("n", "<A-h>", splits.resize_left, { desc = "Resize left" })
keymap("n", "<A-j>", splits.resize_down, { desc = "Resize down" })
keymap("n", "<A-k>", splits.resize_up, { desc = "Resize up" })
keymap("n", "<A-l>", splits.resize_right, { desc = "Resize right" })

-- ── Which Key ────────────────────────────────────────────────────────────
require("which-key").setup({
    delay = 0,
    icons = { mappings = true },
    spec = {
        { "<leader>b", group = "Buffer" },
        { "<leader>c", group = "Code" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "Git hunk", mode = { "n", "v" } },
        { "<leader>r", group = "Rename" },
        { "<leader>l", group = "Lint" },
        { "<leader>s", group = "Search", mode = { "n", "v" } },
        { "<leader>t", group = "Toggle" },
        { "<leader>D", group = "Debug" },
    },
})

-- ── Misc ─────────────────────────────────────────────────────────────────
require("todo-comments").setup({ signs = false })
require("guess-indent").setup({})

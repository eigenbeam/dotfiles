-- Options, filetypes, keymaps, and quality-of-life autocmds that need no
-- plugins (mirrors emacs/lisp/basics.el). Loaded in VS Code too. Options
-- that already match Neovim's defaults are not restated here.

-- ============================================================================
-- Core Settings
-- ============================================================================

-- UI & Appearance
vim.opt.number = true -- Line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.signcolumn = "yes" -- Always show sign column (prevents shift)
vim.opt.cursorline = true -- Highlight current line
vim.opt.scrolloff = 8 -- Keep 8 lines above/below cursor
vim.opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor
vim.opt.wrap = false -- No line wrapping (good for code/logs)
vim.opt.showmode = false -- Don't show mode (already in statusline)
vim.opt.termguicolors = true -- Autodetected from $COLORTERM, but zenbones has no cterm fallback
vim.opt.updatetime = 250 -- Faster CursorHold and swap writes
vim.opt.timeoutlen = 300 -- Faster key sequence timeout
vim.opt.foldlevelstart = 99 -- Folds exist (tree-sitter) but start open

-- Editor Behavior
vim.opt.mouse = "a" -- Mouse in all modes (default leaves out command-line)
vim.opt.mousefocus = true -- Focus window on mouse hover
vim.opt.clipboard = "unnamedplus" -- System clipboard integration
vim.opt.undofile = true -- Persistent undo
vim.opt.swapfile = false -- No swap files
vim.opt.splitright = true -- Vertical splits open to right
vim.opt.splitbelow = true -- Horizontal splits open below
vim.opt.confirm = true -- Confirm before quit without save

-- Search
vim.opt.ignorecase = true -- Case-insensitive search
vim.opt.smartcase = true -- Unless search has uppercase

-- Indentation
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 4 -- Indent by 4 spaces
vim.opt.tabstop = 4 -- Tab = 4 spaces
vim.opt.softtabstop = 4 -- Backspace removes 4 spaces
vim.opt.smartindent = true -- Smart auto-indenting

-- Completion
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.wildmode = { "longest:full", "full" }
vim.opt.wildignore = { "*.o", "*.obj", "*.pyc", "*.swp", "*~", ".git/*", "node_modules/*" }

-- Better search with ripgrep if available
if vim.fn.executable("rg") == 1 then
    vim.opt.grepprg = "rg --vimgrep --smart-case --hidden"
    vim.opt.grepformat = "%f:%l:%c:%m"
end

-- ============================================================================
-- File Types
-- ============================================================================

-- Language-specific indentation
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "yaml", "ruby" },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "make", "go" },
    callback = function()
        vim.opt_local.expandtab = false -- Use real tabs
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.opt_local.textwidth = 88 -- ruff/black line length
    end,
})

-- Prose files: wrap at word boundaries
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "quarto", "text", "tex" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
    end,
})

-- File types Neovim does not detect on its own. Terraform is listed because
-- the built-in .tf detection needs file content to tell it from TinyFugue,
-- so a new empty file would get no LSP; .tfvars maps to "terraform" rather
-- than the built-in "terraform-vars" so the conform table applies.
vim.filetype.add({
    extension = {
        conf = "conf",
        config = "conf",
        service = "systemd",
        timer = "systemd",
        socket = "systemd",
        mount = "systemd",
        automount = "systemd",
        tf = "terraform",
        tfvars = "terraform",
        wls = "mma",
    },
    filename = {
        ["authorized_keys"] = "conf",
        ["known_hosts"] = "conf",
    },
})

-- ============================================================================
-- Keybindings
-- ============================================================================

local keymap = vim.keymap.set

-- Better navigation
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
keymap("n", "n", "nzzzv", { desc = "Next search result (centered)" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Window navigation & resizing handled by smart-splits.nvim (crosses tmux panes)

-- Buffer navigation
keymap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
keymap("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Better indenting (stay in visual mode)
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- Move lines up/down
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Clear search highlighting
keymap("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Better paste (don't yank replaced text)
keymap("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })

-- Quick save/quit
keymap("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })
keymap("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
keymap("n", "<leader>Q", "<cmd>qall!<cr>", { desc = "Quit all (force)" })

-- File explorer (built-in netrw)
keymap("n", "<leader>e", "<cmd>Explore<cr>", { desc = "File explorer" })
keymap("n", "<leader>E", "<cmd>Vexplore<cr>", { desc = "File explorer (split)" })

-- Split windows (<C-w>= and <C-w>q stay native)
keymap("n", "<leader>|", "<C-w>v", { desc = "Split vertical" })
keymap("n", "<leader>-", "<C-w>s", { desc = "Split horizontal" })

-- Terminal. A double Esc leaves terminal mode; a single Esc still reaches
-- TUIs running inside (lazygit, Claude Code).
keymap("n", "<leader>tt", "<cmd>terminal<cr>", { desc = "Open terminal" })
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ============================================================================
-- File Explorer (Netrw) Configuration
-- ============================================================================

vim.g.netrw_banner = 0 -- Hide banner
vim.g.netrw_liststyle = 3 -- Tree view
vim.g.netrw_browse_split = 0 -- Open in current window
vim.g.netrw_winsize = 25 -- 25% width
vim.g.netrw_altv = 1 -- Open splits to the right

-- ============================================================================
-- Quality of Life
-- ============================================================================

-- Check clipboard provider on startup (diagnostic)
vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        if vim.fn.has("clipboard") == 0 then
            vim.notify(
                "Warning: Clipboard provider not available. Install xclip/xsel (Linux) or check pbcopy/pbpaste (macOS)",
                vim.log.levels.WARN
            )
        end
    end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.hl.on_yank({ timeout = 200 })
    end,
})

-- Remember cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local line_count = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})

-- Auto-cd to project root (makes Telescope, :grep, :terminal use project scope)
vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("auto-root", { clear = true }),
    callback = function(args)
        if vim.bo[args.buf].buftype ~= "" then
            return
        end
        local root = vim.fs.root(args.buf, {
            ".git",
            "Makefile",
            "pyproject.toml",
            "package.json",
            "Cargo.toml",
            "go.mod",
        })
        if root and root ~= vim.fn.getcwd() then
            vim.fn.chdir(root)
        end
    end,
})

-- Auto-create parent directories when saving
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function(args)
        local dir = vim.fn.fnamemodify(args.file, ":h")
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
        end
    end,
})

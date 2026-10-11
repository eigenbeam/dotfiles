-- Options, filetypes, keymaps, and quality-of-life autocmds that need no
-- plugins (mirrors emacs/lisp/basics.el). Loaded in VS Code too.

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
vim.opt.termguicolors = true -- True color support
vim.opt.showmode = false -- Don't show mode (already in statusline)
vim.opt.showcmd = true -- Show partial commands
vim.opt.laststatus = 2 -- Always show statusline
vim.opt.cmdheight = 1 -- Command line height
vim.opt.updatetime = 250 -- Faster updates
vim.opt.timeoutlen = 300 -- Faster key sequence timeout

-- Editor Behavior
vim.opt.mouse = "a" -- Enable mouse support
vim.opt.mousefocus = true -- Focus window on mouse hover
vim.opt.clipboard = "unnamedplus" -- System clipboard integration
vim.opt.undofile = true -- Persistent undo
vim.opt.backup = false -- No backup files
vim.opt.writebackup = false -- No backup before overwrite
vim.opt.swapfile = false -- No swap files
vim.opt.hidden = true -- Allow hidden buffers
vim.opt.autoread = true -- Auto reload changed files
vim.opt.splitright = true -- Vertical splits open to right
vim.opt.splitbelow = true -- Horizontal splits open below
vim.opt.confirm = true -- Confirm before quit without save

-- Search
vim.opt.ignorecase = true -- Case-insensitive search
vim.opt.smartcase = true -- Unless search has uppercase
vim.opt.incsearch = true -- Incremental search
vim.opt.hlsearch = true -- Highlight search matches
vim.opt.wrapscan = true -- Wrap search at end of file

-- Indentation
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 4 -- Indent by 4 spaces
vim.opt.tabstop = 4 -- Tab = 4 spaces
vim.opt.softtabstop = 4 -- Backspace removes 4 spaces
vim.opt.smartindent = true -- Smart auto-indenting
vim.opt.autoindent = true -- Copy indent from current line

-- Completion
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.wildmode = { "longest:full", "full" }
vim.opt.wildmenu = true
vim.opt.wildignore = { "*.o", "*.obj", "*.pyc", "*.swp", "*~", ".git/*", "node_modules/*" }

-- ============================================================================
-- File Type & Syntax
-- ============================================================================

vim.cmd("filetype plugin indent on")

-- Language-specific indentation
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "yaml", "yml", "ruby" },
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

-- Python specific
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.opt_local.textwidth = 88 -- Black formatter standard
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

-- Recognize additional file types (sysadmin stuff)
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
        hcl = "hcl",
        jl = "julia",
        wl = "mma",
        wls = "mma",
        qmd = "quarto",
        toml = "toml",
        typ = "typst",
    },
    filename = {
        ["Dockerfile"] = "dockerfile",
        ["docker-compose.yml"] = "yaml",
        ["docker-compose.yaml"] = "yaml",
        [".env"] = "sh",
        ["crontab"] = "crontab",
        ["authorized_keys"] = "conf",
        ["known_hosts"] = "conf",
    },
    pattern = {
        [".*/%.ssh/config"] = "sshconfig",
        [".*/nginx/.*%.conf"] = "nginx",
        [".*/apache2?/.*%.conf"] = "apache",
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
keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- Better indenting (stay in visual mode)
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- Move lines up/down
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Clear search highlighting
keymap("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- Better paste (don't yank replaced text)
keymap("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })

-- Quick save/quit
keymap("n", "<leader>w", ":write<CR>", { desc = "Save file" })
keymap("n", "<leader>q", ":quit<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", ":qall!<CR>", { desc = "Quit all (force)" })

-- File explorer (built-in netrw)
keymap("n", "<leader>e", ":Explore<CR>", { desc = "File explorer" })
keymap("n", "<leader>E", ":Vexplore<CR>", { desc = "File explorer (split)" })

-- Split windows
keymap("n", "<leader>sv", "<C-w>v", { desc = "Split vertical" })
keymap("n", "<leader>sh", "<C-w>s", { desc = "Split horizontal" })
keymap("n", "<leader>se", "<C-w>=", { desc = "Equal splits" })
keymap("n", "<leader>sx", ":close<CR>", { desc = "Close split" })

-- Terminal
keymap("n", "<leader>tt", ":terminal<CR>", { desc = "Open terminal" })
keymap("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ============================================================================
-- File Explorer (Netrw) Configuration
-- ============================================================================

vim.g.netrw_banner = 0 -- Hide banner
vim.g.netrw_liststyle = 3 -- Tree view
vim.g.netrw_browse_split = 0 -- Open in current window
vim.g.netrw_winsize = 25 -- 25% width
vim.g.netrw_altv = 1 -- Open splits to the right

-- ============================================================================
-- Clipboard & Mouse Configuration
-- ============================================================================

-- Check clipboard provider on startup (diagnostic)
vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        local clipboard_ok = vim.fn.has("clipboard")
        if clipboard_ok == 0 then
            vim.notify(
                "Warning: Clipboard provider not available. Install xclip/xsel (Linux) or check pbcopy/pbpaste (macOS)",
                vim.log.levels.WARN
            )
        end
    end,
})

-- ============================================================================
-- Quality of Life Improvements
-- ============================================================================

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

-- Remove trailing whitespace on save (skip markdown/quarto where trailing spaces are meaningful)
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        local ft = vim.bo.filetype
        if ft == "markdown" or ft == "quarto" then
            return
        end
        local save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
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

-- Better search with ripgrep if available
if vim.fn.executable("rg") == 1 then
    vim.opt.grepprg = "rg --vimgrep --smart-case --hidden"
    vim.opt.grepformat = "%f:%l:%c:%m"
end

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

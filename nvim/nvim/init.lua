-- ============================================================================
-- Minimal Neovim Configuration
-- ============================================================================
-- Zero dependencies, maximum portability
-- Perfect for: SSH sessions, remote systems, quick edits
-- Target: Sysadmin/NetAdmin work with bash, C, Python, config files
-- Requirements: Neovim 0.8+ only
-- ============================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- Core Settings
-- ============================================================================

-- UI & Appearance
vim.opt.number = true                    -- Line numbers
vim.opt.relativenumber = true            -- Relative line numbers
vim.opt.signcolumn = "yes"              -- Always show sign column (prevents shift)
vim.opt.cursorline = true               -- Highlight current line
vim.opt.scrolloff = 8                   -- Keep 8 lines above/below cursor
vim.opt.sidescrolloff = 8               -- Keep 8 columns left/right of cursor
vim.opt.wrap = false                    -- No line wrapping (good for code/logs)
vim.opt.termguicolors = true            -- True color support
vim.opt.showmode = false                -- Don't show mode (already in statusline)
vim.opt.showcmd = true                  -- Show partial commands
vim.opt.laststatus = 2                  -- Always show statusline
vim.opt.cmdheight = 1                   -- Command line height
vim.opt.updatetime = 250                -- Faster updates
vim.opt.timeoutlen = 300               -- Faster key sequence timeout

-- Editor Behavior
vim.opt.mouse = "a"                     -- Enable mouse support
vim.opt.clipboard = "unnamedplus"       -- System clipboard integration
vim.opt.undofile = true                 -- Persistent undo
vim.opt.backup = false                  -- No backup files
vim.opt.writebackup = false             -- No backup before overwrite
vim.opt.swapfile = false                -- No swap files
vim.opt.hidden = true                   -- Allow hidden buffers
vim.opt.autoread = true                 -- Auto reload changed files
vim.opt.splitright = true               -- Vertical splits open to right
vim.opt.splitbelow = true               -- Horizontal splits open below
vim.opt.confirm = true                  -- Confirm before quit without save

-- Search
vim.opt.ignorecase = true               -- Case-insensitive search
vim.opt.smartcase = true                -- Unless search has uppercase
vim.opt.incsearch = true                -- Incremental search
vim.opt.hlsearch = true                 -- Highlight search matches
vim.opt.wrapscan = true                 -- Wrap search at end of file

-- Indentation
vim.opt.expandtab = true                -- Use spaces instead of tabs
vim.opt.shiftwidth = 4                  -- Indent by 4 spaces
vim.opt.tabstop = 4                     -- Tab = 4 spaces
vim.opt.softtabstop = 4                 -- Backspace removes 4 spaces
vim.opt.smartindent = true              -- Smart auto-indenting
vim.opt.autoindent = true               -- Copy indent from current line

-- Completion
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.wildmode = { "longest:full", "full" }
vim.opt.wildmenu = true
vim.opt.wildignore = { "*.o", "*.obj", "*.pyc", "*.swp", "*~", ".git/*", "node_modules/*" }

-- Performance
vim.opt.lazyredraw = true               -- Don't redraw during macros
vim.opt.synmaxcol = 300                 -- Only syntax highlight first 300 cols

-- ============================================================================
-- File Type & Syntax
-- ============================================================================

vim.cmd("syntax on")
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
    vim.opt_local.expandtab = false  -- Use real tabs
  end,
})

-- Python specific
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.textwidth = 88  -- Black formatter standard
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

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Window resizing
keymap("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

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

-- Fuzzy file finding (built-in)
keymap("n", "<leader>f", ":find ", { desc = "Find file" })
keymap("n", "<leader>b", ":buffer ", { desc = "Switch buffer" })

-- Grep (built-in)
keymap("n", "<leader>g", ":grep ", { desc = "Grep" })

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

vim.g.netrw_banner = 0          -- Hide banner
vim.g.netrw_liststyle = 3       -- Tree view
vim.g.netrw_browse_split = 0    -- Open in current window
vim.g.netrw_winsize = 25        -- 25% width
vim.g.netrw_altv = 1            -- Open splits to the right

-- ============================================================================
-- Statusline (Simple but Informative)
-- ============================================================================

function _G.statusline()
  local mode_map = {
    n = "NORMAL",
    i = "INSERT",
    v = "VISUAL",
    V = "V-LINE",
    [""] = "V-BLOCK",
    c = "COMMAND",
    s = "SELECT",
    S = "S-LINE",
    [""] = "S-BLOCK",
    R = "REPLACE",
    r = "PROMPT",
    ["!"] = "SHELL",
    t = "TERMINAL",
  }

  local mode = mode_map[vim.fn.mode()] or "UNKNOWN"
  local filename = vim.fn.expand("%:t")
  local filetype = vim.bo.filetype
  local modified = vim.bo.modified and "[+]" or ""
  local readonly = vim.bo.readonly and "[RO]" or ""
  local line = vim.fn.line(".")
  local col = vim.fn.col(".")
  local total = vim.fn.line("$")
  local percent = math.floor((line / total) * 100)

  return string.format(
    " %s | %s%s%s | %s | %d:%d | %d%% ",
    mode,
    filename ~= "" and filename or "[No Name]",
    modified,
    readonly,
    filetype ~= "" and filetype or "none",
    line,
    col,
    percent
  )
end

vim.opt.statusline = "%!v:lua.statusline()"

-- ============================================================================
-- Optional: LSP Support (if available)
-- ============================================================================
-- This section gracefully degrades if LSP servers aren't installed
-- No errors if missing - just works without LSP

local lsp_ok, lspconfig = pcall(require, "lspconfig")
if lsp_ok then
  -- LSP keybindings (only set when LSP is attached)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local opts = { buffer = args.buf }
      keymap("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
      keymap("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
      keymap("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Show references" }))
      keymap("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
      keymap("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
      keymap("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
      keymap("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
      keymap("n", "<leader>d", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show diagnostics" }))
      keymap("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
      keymap("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
    end,
  })

  -- Auto-start LSP servers if they exist
  -- bash-language-server, clangd, pyright are common for sysadmin work
  local servers = { "bashls", "clangd", "pyright" }

  for _, server in ipairs(servers) do
    if vim.fn.executable(server) == 1 or vim.fn.executable(server:gsub("ls$", "-language-server")) == 1 then
      lspconfig[server].setup({})
    end
  end
end

-- ============================================================================
-- Quality of Life Improvements
-- ============================================================================

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
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

-- Auto-create parent directories when saving
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    local dir = vim.fn.fnamemodify(args.file, ":h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- ============================================================================
-- Color Scheme
-- ============================================================================
-- Use a simple, portable color scheme that works in all terminals

vim.cmd("colorscheme default")

-- Enhance default colors slightly
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2d2d2d" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#5f5f5f" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#d7d700", bold = true })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "#3a3a3a", fg = "#d0d0d0" })

-- ============================================================================
-- Usage Tips (View with :help local-additions)
-- ============================================================================
--
-- File Navigation:
--   <leader>e       - File explorer (netrw)
--   <leader>f       - Find file (use wildcards: **/filename)
--   <leader>b       - Switch buffer by name/number
--   <leader>g       - Grep for text
--
-- Window Management:
--   <C-h/j/k/l>     - Navigate windows
--   <leader>sv/sh   - Split vertical/horizontal
--   <leader>sx      - Close split
--
-- Editing:
--   <leader>w       - Save file
--   <leader>q       - Quit
--   Visual+J/K      - Move selected lines up/down
--   Visual+</>/     - Indent left/right
--
-- LSP (if available):
--   gd              - Go to definition
--   K               - Hover documentation
--   <leader>rn      - Rename
--   <leader>ca      - Code action
--   [d / ]d         - Navigate diagnostics
--
-- ============================================================================

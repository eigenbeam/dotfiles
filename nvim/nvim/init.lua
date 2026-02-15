-- ============================================================================
-- Neovim Configuration
-- ============================================================================
-- Kickstart-inspired single-file config with lazy.nvim plugin management
-- Features: Telescope, LSP (Mason), Treesitter, blink.cmp, gitsigns
-- Theme: Base2Tone EveningDark (DuoTone)
-- VSCode Neovim extension supported (auto-detected)
-- Requirements: Neovim 0.8+, git
-- ============================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Detect Nerd Font availability (set to true if your terminal uses a Nerd Font)
vim.g.have_nerd_font = false

-- ============================================================================
-- Plugin Manager (lazy.nvim) - Auto-installs on first run
-- ============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- ── Colorscheme ──────────────────────────────────────────────────────
  {
    "atelierbram/Base2Tone-nvim",
    priority = 1000,
    config = function()
      vim.cmd("colorscheme base2tone_evening_dark")
    end,
  },

  -- ── Fuzzy Finder ─────────────────────────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
    config = function()
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
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Search help" })
      vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Search keymaps" })
      vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Search files" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Search current word" })
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Search by grep" })
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Search diagnostics" })
      vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "Search resume" })
      vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "Search recent files" })
      vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Search buffers" })
      vim.keymap.set("n", "<leader>sn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "Search neovim config" })
      vim.keymap.set("n", "<leader>/", function()
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "Fuzzy find in buffer" })
    end,
  },

  -- ── LSP ──────────────────────────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      "saghen/blink.cmp",
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
          end
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gr", vim.lsp.buf.references, "Show references")
          map("gi", vim.lsp.buf.implementation, "Go to implementation")
          map("K", vim.lsp.buf.hover, "Hover documentation")
          map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "x" })
          map("<leader>d", vim.diagnostic.open_float, "Show diagnostics")

          if vim.fn.has("nvim-0.11") == 1 then
            map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Previous diagnostic")
            map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
          else
            map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
            map("]d", vim.diagnostic.goto_next, "Next diagnostic")
          end

          -- Toggle inlay hints if supported
          if vim.lsp.inlay_hint then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "Toggle inlay hints")
          end

          -- Highlight references on cursor hold
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
              end,
            })
          end
        end,
      })

      vim.lsp.config('*', {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
      })

      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
          },
        },
      })

      require("mason-tool-installer").setup({
        ensure_installed = { "bash-language-server", "clangd", "pyright", "lua-language-server", "stylua" },
      })

      vim.lsp.enable({ 'bashls', 'clangd', 'pyright', 'lua_ls' })
    end,
  },

  -- ── Completion ───────────────────────────────────────────────────────
  {
    "saghen/blink.cmp",
    event = "VimEnter",
    version = "1.*",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        build = (function()
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
      },
    },
    opts = {
      keymap = { preset = "default" },
      appearance = { nerd_font_variant = "mono" },
      completion = { documentation = { auto_show = false, auto_show_delay_ms = 500 } },
      sources = { default = { "lsp", "path", "snippets" } },
      snippets = { preset = "luasnip" },
      fuzzy = { implementation = "lua" },
      signature = { enabled = true },
    },
  },

  -- ── Formatting ───────────────────────────────────────────────────────
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },

  -- ── Treesitter ───────────────────────────────────────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local filetypes = {
        "bash", "c", "cpp", "diff", "html", "lua", "luadoc",
        "markdown", "markdown_inline", "python", "query",
        "vim", "vimdoc", "yaml",
      }
      require("nvim-treesitter").install(filetypes)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = filetypes,
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },

  -- ── Mini.nvim (textobjects, surround, statusline) ───────────────────
  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.ai").setup({ n_lines = 500 })
      require("mini.surround").setup()
      local statusline = require("mini.statusline")
      statusline.setup({ use_icons = vim.g.have_nerd_font })
      statusline.section_location = function()
        return "%2l:%-2v"
      end
    end,
  },

  -- ── Git Signs ────────────────────────────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    opts = {
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
      end,
    },
  },

  -- ── Which Key ────────────────────────────────────────────────────────
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      spec = {
        { "<leader>s", group = "Search", mode = { "n", "v" } },
        { "<leader>t", group = "Toggle" },
        { "<leader>h", group = "Git hunk", mode = { "n", "v" } },
      },
    },
  },

  -- ── Misc ─────────────────────────────────────────────────────────────
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

  { "NMAC427/guess-indent.nvim", opts = {} },
})

-- ============================================================================
-- VSCode Neovim Extension Support
-- ============================================================================

if vim.g.vscode then
  -- Running inside VSCode - minimal config focused on keybindings

  -- Editor Behavior (VSCode-compatible)
  vim.opt.clipboard = "unnamedplus"       -- System clipboard integration
  vim.opt.ignorecase = true               -- Case-insensitive search
  vim.opt.smartcase = true                -- Unless search has uppercase
  vim.opt.hlsearch = true                 -- Highlight search matches
  vim.opt.incsearch = true                -- Incremental search

  local keymap = vim.keymap.set

  -- Navigation
  keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
  keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
  keymap("n", "n", "nzzzv", { desc = "Next search result (centered)" })
  keymap("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

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

  -- Explicit clipboard operations (force y, Y, p, P to use system clipboard)
  keymap({ "n", "v" }, "y", '"+y', { desc = "Yank to clipboard" })
  keymap("n", "Y", '"+Y', { desc = "Yank line to clipboard" })
  keymap({ "n", "v" }, "p", '"+p', { desc = "Paste from clipboard" })
  keymap({ "n", "v" }, "P", '"+P', { desc = "Paste before from clipboard" })

  -- VSCode commands (call VSCode's native functionality)
  keymap("n", "<leader>w", "<Cmd>call VSCodeNotify('workbench.action.files.save')<CR>", { desc = "Save file" })
  keymap("n", "<leader>q", "<Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>", { desc = "Close editor" })
  keymap("n", "<leader>e", "<Cmd>call VSCodeNotify('workbench.view.explorer')<CR>", { desc = "Toggle explorer" })
  keymap("n", "<leader>f", "<Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>", { desc = "Quick open file" })
  keymap("n", "<leader>b", "<Cmd>call VSCodeNotify('workbench.action.showAllEditors')<CR>", { desc = "Show all editors" })
  keymap("n", "<leader>g", "<Cmd>call VSCodeNotify('workbench.action.findInFiles')<CR>", { desc = "Find in files" })
  keymap("n", "<leader>sv", "<Cmd>call VSCodeNotify('workbench.action.splitEditorRight')<CR>", { desc = "Split right" })
  keymap("n", "<leader>sh", "<Cmd>call VSCodeNotify('workbench.action.splitEditorDown')<CR>", { desc = "Split down" })
  keymap("n", "gd", "<Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>", { desc = "Go to definition" })
  keymap("n", "gr", "<Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>", { desc = "Go to references" })
  keymap("n", "K", "<Cmd>call VSCodeNotify('editor.action.showHover')<CR>", { desc = "Show hover" })
  keymap("n", "<leader>rn", "<Cmd>call VSCodeNotify('editor.action.rename')<CR>", { desc = "Rename" })
  keymap("n", "<leader>ca", "<Cmd>call VSCodeNotify('editor.action.quickFix')<CR>", { desc = "Code action" })

  -- Highlight on yank
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      vim.highlight.on_yank({ timeout = 200 })
    end,
  })

else
  -- Running in regular Neovim - full configuration

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
vim.opt.mousefocus = true               -- Focus window on mouse hover
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

-- Explicit clipboard operations (force y, Y, p, P to use system clipboard)
-- This ensures clipboard works even if provider isn't properly configured
keymap({ "n", "v" }, "y", '"+y', { desc = "Yank to clipboard" })
keymap("n", "Y", '"+Y', { desc = "Yank line to clipboard" })
keymap({ "n", "v" }, "p", '"+p', { desc = "Paste from clipboard" })
keymap({ "n", "v" }, "P", '"+P', { desc = "Paste before from clipboard" })

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

vim.g.netrw_banner = 0          -- Hide banner
vim.g.netrw_liststyle = 3       -- Tree view
vim.g.netrw_browse_split = 0    -- Open in current window
vim.g.netrw_winsize = 25        -- 25% width
vim.g.netrw_altv = 1            -- Open splits to the right

-- ============================================================================
-- Clipboard & Mouse Configuration
-- ============================================================================

-- Check clipboard provider on startup (diagnostic)
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local clipboard_ok = vim.fn.has("clipboard")
    if clipboard_ok == 0 then
      vim.notify("Warning: Clipboard provider not available. Install xclip/xsel (Linux) or check pbcopy/pbpaste (macOS)", vim.log.levels.WARN)
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

end -- End of non-VSCode configuration

-- ============================================================================
-- Usage Tips
-- ============================================================================
--
-- Clipboard:
--   All yank (y, Y) and paste (p, P) operations use the system clipboard
--   If clipboard doesn't work, check :checkhealth provider
--   macOS: Requires pbcopy/pbpaste (built-in)
--   Linux: Requires xclip or xsel
--
-- Mouse Selection:
--   Use mouse to select text in neovim (won't include line numbers)
--   For terminal selection (includes line numbers), hold Shift while selecting
--   Or use Option/Alt on some terminal emulators
--
-- VSCode Mode:
--   Automatically detected when using VSCode Neovim extension
--   Uses VSCode's native UI and LSP
--   Keeps Vim keybindings and motions
--
-- Regular Neovim Mode:
--
-- Search (Telescope):
--   <leader>sf      - Find files
--   <leader>sg      - Live grep
--   <leader>sb      - Switch buffer
--   <leader>sh      - Help tags
--   <leader>sk      - Keymaps
--   <leader>sd      - Diagnostics
--   <leader>sr      - Resume last search
--   <leader>s.      - Recent files
--   <leader>/       - Fuzzy find in current buffer
--
-- File Navigation:
--   <leader>e       - File explorer (netrw)
--   <leader>f       - Format buffer
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
-- Git:
--   ]h / [h         - Next/previous hunk
--   <leader>hs      - Stage hunk
--   <leader>hr      - Reset hunk
--   <leader>hb      - Blame line
--
-- LSP:
--   gd              - Go to definition
--   K               - Hover documentation
--   <leader>rn      - Rename
--   <leader>ca      - Code action
--   <leader>d       - Show diagnostics
--   [d / ]d         - Navigate diagnostics
--   <leader>th      - Toggle inlay hints
--
-- ============================================================================

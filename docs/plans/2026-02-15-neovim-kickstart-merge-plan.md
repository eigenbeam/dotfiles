# Neovim Kickstart Merge Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Merge kickstart.nvim features (lazy.nvim, Telescope, blink.cmp, Treesitter, Mason LSP, gitsigns, which-key, mini.nvim, conform, Base2Tone EveningDark) into the existing single-file neovim config.

**Architecture:** Additive merge into `nvim/nvim/init.lua`. lazy.nvim bootstraps at the top, plugin specs declared in `lazy.setup()`, then existing config follows with targeted removals (old LSP block, custom statusline, default colorscheme, `syntax on`). All existing keybindings preserved except 3 remapped to Telescope.

**Tech Stack:** Neovim 0.8+, lazy.nvim, Lua

**Design doc:** `docs/plans/2026-02-15-neovim-kickstart-merge-design.md`

---

### Task 1: Add lazy.nvim Bootstrap and Nerd Font Detection

**Files:**
- Modify: `nvim/nvim/init.lua:10-11` (insert after leader key setup)

**Step 1: Insert lazy.nvim bootstrap after leader key lines**

After line 11 (`vim.g.maplocalleader = " "`), insert:

```lua
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
```

**Step 2: Verify the edit**

Read the file and confirm the bootstrap code is between leader key setup and the VSCode block.

**Step 3: Commit**

```bash
git add nvim/nvim/init.lua
git commit -m "feat(nvim): add lazy.nvim bootstrap"
```

---

### Task 2: Add Plugin Specs via lazy.setup()

**Files:**
- Modify: `nvim/nvim/init.lua` (insert after lazy.nvim bootstrap, before VSCode block)

**Step 1: Insert lazy.setup() call with all 16 plugin specs**

After the `vim.opt.rtp:prepend(lazypath)` line, insert the full `lazy.setup` block. This is the largest single insertion:

```lua
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

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local servers = {
        bashls = {},
        clangd = {},
        pyright = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = "Replace" },
            },
          },
        },
      }

      require("mason-tool-installer").setup({
        ensure_installed = vim.tbl_keys(servers),
      })

      require("mason-tool-installer").setup({
        ensure_installed = vim.list_extend(vim.tbl_keys(servers), { "stylua" }),
      })

      for server_name, server_config in pairs(servers) do
        server_config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server_config.capabilities or {})
        require("lspconfig")[server_name].setup(server_config)
      end
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
```

**Step 2: Verify the edit**

Read the file and confirm lazy.setup is between bootstrap and VSCode block. Check for Lua syntax: balanced parentheses, no stray commas.

**Step 3: Commit**

```bash
git add nvim/nvim/init.lua
git commit -m "feat(nvim): add all plugin specs via lazy.setup"
```

---

### Task 3: Remove Replaced Code

**Files:**
- Modify: `nvim/nvim/init.lua`

These removals happen in the existing config body (the `else` branch of the VSCode conditional).

**Step 1: Remove `syntax on` line**

Remove:
```lua
vim.cmd("syntax on")
```

Keep `vim.cmd("filetype plugin indent on")` — Treesitter doesn't replace filetype detection.

**Step 2: Remove `synmaxcol` line**

Remove:
```lua
vim.opt.synmaxcol = 300                 -- Only syntax highlight first 300 cols
```

And remove the `-- Performance` comment above it if it's the only item in that section.

**Step 3: Remove old keymaps that conflict with Telescope**

Remove these three lines:
```lua
keymap("n", "<leader>f", ":find ", { desc = "Find file" })
keymap("n", "<leader>b", ":buffer ", { desc = "Switch buffer" })
keymap("n", "<leader>g", ":grep ", { desc = "Grep" })
```

**Step 4: Remove custom statusline**

Remove the entire statusline section (the `function _G.statusline()` through `vim.opt.statusline = "%!v:lua.statusline()"`):

```lua
function _G.statusline()
  -- ... all of it ...
end

vim.opt.statusline = "%!v:lua.statusline()"
```

Also remove `vim.opt.showmode = false` comment if it references "already in statusline" — mini.statusline handles this.

**Step 5: Remove old colorscheme section**

Remove:
```lua
vim.cmd("colorscheme default")

-- Enhance default colors slightly
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2d2d2d" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#5f5f5f" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#d7d700", bold = true })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "#3a3a3a", fg = "#d0d0d0" })
```

And the section header comment above it.

**Step 6: Remove old LSP block**

Remove the entire section from `local lsp_ok, lspconfig = pcall(require, "lspconfig")` through the closing `end` of `if lsp_ok then`. This is lines 335-368 in the original file. Mason and the lspconfig plugin spec now handle this.

**Step 7: Verify the edit**

Read the full file. Confirm:
- No `syntax on`
- No `synmaxcol`
- No `<leader>f/g/b` mapped to built-in commands
- No `_G.statusline` function
- No `colorscheme default`
- No `pcall(require, "lspconfig")` block
- `filetype plugin indent on` still present

**Step 8: Commit**

```bash
git add nvim/nvim/init.lua
git commit -m "refactor(nvim): remove code replaced by plugins"
```

---

### Task 4: Update File Header Comments

**Files:**
- Modify: `nvim/nvim/init.lua:1-8`

**Step 1: Update the header to reflect the new config**

Replace:
```lua
-- ============================================================================
-- Minimal Neovim Configuration
-- ============================================================================
-- Zero dependencies, maximum portability
-- Perfect for: SSH sessions, remote systems, quick edits, VSCode Neovim
-- Target: Sysadmin/NetAdmin work with bash, C, Python, config files
-- Requirements: Neovim 0.8+ only
-- ============================================================================
```

With:
```lua
-- ============================================================================
-- Neovim Configuration
-- ============================================================================
-- Kickstart-inspired single-file config with lazy.nvim plugin management
-- Features: Telescope, LSP (Mason), Treesitter, blink.cmp, gitsigns
-- Theme: Base2Tone EveningDark (DuoTone)
-- VSCode Neovim extension supported (auto-detected)
-- Requirements: Neovim 0.8+, git
-- ============================================================================
```

**Step 2: Commit**

```bash
git add nvim/nvim/init.lua
git commit -m "docs(nvim): update header comments for merged config"
```

---

### Task 5: Smoke Test

**Files:** None (verification only)

**Step 1: Check Lua syntax**

Run:
```bash
luac -p nvim/nvim/init.lua 2>&1 || lua -e "loadfile('nvim/nvim/init.lua')" 2>&1
```

Expected: No errors. If `luac` isn't available, the `lua -e` fallback works.

**Step 2: Dry-run Neovim to check for startup errors**

Run:
```bash
NVIM_APPNAME=test-nvim nvim --headless -c 'qa' 2>&1
```

Note: This won't load the config since `NVIM_APPNAME=test-nvim` looks in `~/.config/test-nvim/`. To test the actual config:

```bash
nvim --headless "+lua print('config loaded ok')" +qa 2>&1
```

Expected: Prints "config loaded ok" and exits. First run will auto-clone lazy.nvim and install plugins (may take 30-60 seconds).

**Step 3: Interactive verification**

Launch `nvim` and verify:
- `:Lazy` opens the plugin manager UI (all plugins installed, no errors)
- `:Telescope find_files` opens fuzzy file finder
- `:Mason` opens Mason UI (bashls, clangd, pyright, lua_ls listed)
- Colorscheme is EveningDark (purple/gold duotone on dark background)
- Statusline shows mode, file, git branch, diagnostics
- `<leader>` then wait — which-key popup appears

**Step 4: If all passes, final commit**

```bash
git add nvim/nvim/init.lua
git commit -m "feat(nvim): complete kickstart merge with Base2Tone EveningDark"
```

Only commit if there were any fixes needed from steps 1-3. If no changes were needed, skip this commit.

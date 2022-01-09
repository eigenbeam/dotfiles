local function bootstrap()
  -- Automatically install packer
  -- https://github.com/wbthomason/packer.nvim
  local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  end

  -- Reload neovim whenever this file saved
  vim.cmd [[
    augroup packer_user_config
      autocmd!
      autocmd BufWritePost init.lua source <afile> | PackerSync
    augroup end
  ]]
end

local function load_plugins()
  local status_ok, packer = pcall(require, "packer")
  if not status_ok then return end

  packer.startup({function(use)
    use "wbthomason/packer.nvim"

    use {
      'navarasu/onedark.nvim',
      config = function()
        require('onedark').setup {
          code_style = { comments = "none" }
        }
        require('onedark').load()
      end
    }

    use {
      "numToStr/Comment.nvim",
      config = function()
        require('Comment').setup()
      end
    }

    use "JuliaEditorSupport/julia-vim"

    -- Automatically set up your configuration after cloning packer.nvim
    if packer_bootstrap then
      require("packer").sync()
    end
  end,
  config = {
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end
    }
  }})
end

local function set_basics()
  vim.g.mapleader = " "

  local options = {
    backup = false,                          -- creates a backup file
    clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
    cmdheight = 2,                           -- more space in the neovim command line for displaying messages
    completeopt = { "menuone", "noselect" }, -- mostly just for cmp
    conceallevel = 0,                        -- so that `` is visible in markdown files
    fileencoding = "utf-8",                  -- the encoding written to a file
    hlsearch = false,                        -- highlight all matches on previous search pattern
    ignorecase = true,                       -- ignore case in search patterns
    mouse = "a",                             -- allow the mouse to be used in neovim
    pumheight = 10,                          -- pop up menu height
    showmode = false,                        -- we don't need to see things like -- INSERT -- anymore
    showtabline = 2,                         -- always show tabs
    smartcase = true,                        -- smart case
    smartindent = true,                      -- make indenting smarter again
    splitbelow = true,                       -- force all horizontal splits to go below current window
    splitright = true,                       -- force all vertical splits to go to the right of current window
    swapfile = false,                        -- creates a swapfile
    termguicolors = true,                    -- set term gui colors (most terminals support this)
    timeoutlen = 100,                        -- time to wait for a mapped sequence to complete (in milliseconds)
    undofile = true,                         -- enable persistent undo
    updatetime = 300,                        -- faster completion (4000ms default)
    writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
    expandtab = true,                        -- convert tabs to spaces
    shiftwidth = 2,                          -- the number of spaces inserted for each indentation
    tabstop = 2,                             -- insert 2 spaces for a tab
    cursorline = false,                      -- highlight the current line
    number = true,                           -- set numbered lines
    relativenumber = false,                  -- set relative numbered lines
    numberwidth = 4,                         -- set number column width to 2 {default 4}
    signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
    wrap = false,                            -- display lines as one long line
    scrolloff = 8,                           -- is one of my fav
    sidescrolloff = 8,
    guifont = "monospace:h17",               -- the font used in graphical neovim applications
  }

  for k, v in pairs(options) do
    vim.opt[k] = v
  end

  vim.opt.shortmess:append "c"
  vim.g["netrw_banner"] = 0
  vim.g["netrw_liststyle"] = 3
  vim.g["netrw_winsize"] = 25

  vim.cmd "set whichwrap+=<,>,[,],h,l"
  vim.cmd [[set iskeyword+=-]]
  vim.cmd [[set formatoptions-=cro]] -- TODO: this doesn't seem to work
end

local function add_keymaps()
  local opts = { noremap = true, silent = true }

  local term_opts = { silent = true }

  -- Shorten function name
  local keymap = vim.api.nvim_set_keymap

  --Remap space as leader key
  keymap("", "<Space>", "<Nop>", opts)
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "

  -- Modes
  --   normal_mode = "n",
  --   insert_mode = "i",
  --   visual_mode = "v",
  --   visual_block_mode = "x",
  --   term_mode = "t",
  --   command_mode = "c",

  -- Normal --
  -- Better window navigation
  keymap("n", "<C-h>", "<C-w>h", opts)
  keymap("n", "<C-j>", "<C-w>j", opts)
  keymap("n", "<C-k>", "<C-w>k", opts)
  keymap("n", "<C-l>", "<C-w>l", opts)

  -- Resize with arrows
  keymap("n", "<C-Up>", ":resize -2<CR>", opts)
  keymap("n", "<C-Down>", ":resize +2<CR>", opts)
  keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
  keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

  -- Navigate buffers
  keymap("n", "<S-l>", ":bnext<CR>", opts)
  keymap("n", "<S-h>", ":bprevious<CR>", opts)

  -- Move text up and down
  keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
  keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

  -- Visual --
  -- Stay in indent mode
  keymap("v", "<", "<gv", opts)
  keymap("v", ">", ">gv", opts)

  -- Move text up and down
  keymap("v", "<A-j>", ":m .+1<CR>==", opts)
  keymap("v", "<A-k>", ":m .-2<CR>==", opts)
  -- yanking & pasting keeps yank
  -- keymap("v", "p", '"_dP', opts)

  -- Visual Block --
  -- Move text up and down
  keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
  keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
  keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
  keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

  -- Terminal --
  -- Better terminal navigation
  -- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
  -- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
  -- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
  -- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
end

local function setup_lualine()
  local status_ok, lualine = pcall(require, "lualine")
  if not status_ok then
  	return
  end
  
  local hide_in_width = function()
  	return vim.fn.winwidth(0) > 80
  end
  
  local diagnostics = {
  	"diagnostics",
  	sources = { "nvim_diagnostic" },
  	sections = { "error", "warn" },
  	symbols = { error = " ", warn = " " },
  	colored = false,
  	update_in_insert = false,
  	always_visible = true,
  }
  
  local diff = {
  	"diff",
  	colored = false,
  	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
    cond = hide_in_width
  }
  
  local mode = {
  	"mode",
  	fmt = function(str)
  		return "-- " .. str .. " --"
  	end,
  }
  
  local filetype = {
  	"filetype",
  	icons_enabled = false,
  	icon = nil,
  }
  
  local branch = {
  	"branch",
  	icons_enabled = false,
  	icon = nil,
  }
  
  local location = {
  	"location",
  	padding = 0,
  }
  
  -- cool function for progress
  local progress = function()
  	local current_line = vim.fn.line(".")
  	local total_lines = vim.fn.line("$")
  	local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
  	local line_ratio = current_line / total_lines
  	local index = math.ceil(line_ratio * #chars)
  	return chars[index]
  end
  
  local spaces = function()
  	return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
  end
  
  lualine.setup({
  	options = {
  		icons_enabled = false,
  		theme = "onedark",
  		component_separators = { left = "", right = "" },
  		section_separators = { left = "", right = "" },
  		disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
  		always_divide_middle = true,
  	},
  	sections = {
  		lualine_a = { branch, diagnostics },
  		lualine_b = { mode },
  		lualine_c = {},
  		-- lualine_x = { "encoding", "fileformat", "filetype" },
  		lualine_x = { diff, spaces, "encoding", filetype },
  		lualine_y = { location },
  		lualine_z = { progress },
  	},
  	inactive_sections = {
  		lualine_a = {},
  		lualine_b = {},
  		lualine_c = { "filename" },
  		lualine_x = { "location" },
  		lualine_y = {},
  		lualine_z = {},
  	},
  	tabline = {},
  	extensions = {},
  })
end

bootstrap()
load_plugins()
set_basics()
add_keymaps()
setup_lualine()

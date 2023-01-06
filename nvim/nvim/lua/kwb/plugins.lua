-- Install plugins
require('packer').startup(function(use)
  use "wbthomason/packer.nvim"

  use "nvim-lua/plenary.nvim"

  use 'ishan9299/modus-theme-vim'
  use 'christoomey/vim-tmux-navigator'
  use 'numToStr/Comment.nvim'
  use 'nvim-tree/nvim-tree.lua'
  use 'nvim-lualine/lualine.nvim'
  use 'windwp/nvim-autopairs'
  use 'tpope/vim-sleuth'

  -- Maybe
  -- use 'akinsho/toggleterm.nvim'
  -- use 'tpope/vim-surround'
  -- use 'szw/vim-maximizer'
  -- use 'ahmedkhalf/project.nvim'
  -- use 'goolord/alpha-nvim'

  -- Completions
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lsp'

  -- Telescope
  -- use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'nvim-telescope/telescope.nvim'

  -- Treesitter
  use 'nvim-treesitter/nvim-treesitter'

  -- LSP: servers, linters & formatters
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'
  use 'jose-elias-alvarez/null-ls.nvim'

  -- DAP
  use 'mfussenegger/nvim-dap'
  use 'rcarriga/nvim-dap-ui'
  use 'ravenxrz/DAPInstall.nvim'
end)

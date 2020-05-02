" ordinary neovim
set number
set nobackup
set expandtab
set softtabstop=2
set shiftwidth=2
set shiftround

" Sync with clipboard
set clipboard^=unnamed

call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'chriskempson/base16-vim'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-fugitive'
Plug 'jpalardy/vim-slime'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'MaxMEllon/vim-jsx-pretty'
call plug#end()

" vim-slime
let g:slime_target = "tmux"

" vim-javascript settings
let g:javascript_conceal_function       = "ƒ"
let g:javascript_conceal_null           = "ø"
let g:javascript_conceal_arrow_function = "⇒"
set conceallevel=1

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

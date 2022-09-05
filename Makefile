all:
	stow --dotfiles -t $(HOME) git
	stow --dotfiles -t $(HOME) nvim
	stow --dotfiles -t $(HOME) tmux
	stow --dotfiles -t $(HOME) zsh

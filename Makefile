all:
	stow --dotfiles -t $(HOME) git
	stow --dotfiles -t $(HOME)/.config nvim
	stow --dotfiles -t $(HOME) tmux
	stow --dotfiles -t $(HOME) zsh

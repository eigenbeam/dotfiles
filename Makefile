all:
	stow --dotfiles -t $(HOME) bash
	stow --dotfiles -t $(HOME) emacs
	stow --dotfiles -t $(HOME) git
	stow --dotfiles -t $(HOME) tmux
	stow --dotfiles -t $(HOME) vim

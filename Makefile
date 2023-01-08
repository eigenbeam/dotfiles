.PHONY: homebrew brewfile

all:
	stow --dotfiles -t $(HOME) emacs
	stow --dotfiles -t $(HOME) git
	stow --dotfiles -t $(HOME)/.config kitty
	stow --dotfiles -t $(HOME)/.config nvim
	stow --dotfiles -t $(HOME) tmux
	stow --dotfiles -t $(HOME) zsh

homebrew:
	brew bundle install --file=homebrew/Brewfile

brewfile:
	brew bundle dump --file=homebrew/Brewfile

.PHONY: homebrew-kwb brewfile-kwb homebrew-nsidc brewfile-nsidc

all:
	stow --dotfiles -t $(HOME) emacs
	stow --dotfiles -t $(HOME) git
	stow --dotfiles -t $(HOME)/.config kitty
	stow --dotfiles -t $(HOME)/.config nvim
	stow --dotfiles -t $(HOME) tmux
	stow --dotfiles -t $(HOME) zsh

homebrew-kwb:
	brew bundle install --file=homebrew-kwb/Brewfile

brewfile-kwb:
	brew bundle dump --file=homebrew-kwb/Brewfile

homebrew-nsidc:
	brew bundle install --file=homebrew-nsidc/Brewfile

brewfile-nsidc:
	brew bundle dump --file=homebrew-nsidc/Brewfile

.PHONY: all check homebrew brewfile

check:
	@command -v stow >/dev/null 2>&1 || (echo "Error: GNU Stow not found. Please install it first." && exit 1)
	@command -v brew >/dev/null 2>&1 || (echo "Error: Homebrew not found. Please install it first." && exit 1)
	@echo "✓ All dependencies found"

all: check
	@mkdir -p $(HOME)/.cache/zsh
	@mkdir -p $(HOME)/.config
	stow --dotfiles -t $(HOME) emacs
	stow --dotfiles -t $(HOME) git
	stow --dotfiles -t $(HOME)/.config nvim
	stow --dotfiles -t $(HOME) tmux
	stow --dotfiles -t $(HOME) zsh
	@echo "✓ Dotfiles installed successfully"

homebrew:
	brew bundle install --file=homebrew/Brewfile

brewfile:
	brew bundle dump --force --file=homebrew/Brewfile

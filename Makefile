.PHONY: all check bootstrap homebrew homebrew-extras brewfile brewfile-extras uninstall lint mac

check:
	@command -v stow >/dev/null 2>&1 || (echo "Error: GNU Stow not found. Please install it first." && exit 1)
	@command -v brew >/dev/null 2>&1 || echo "Warning: Homebrew not found. Stow will still work, but run 'make homebrew' later."
	@echo "✓ Dependencies checked"

all: check
	@mkdir -p $(HOME)/.cache/zsh
	@mkdir -p $(HOME)/.config
	@touch $(HOME)/.gitconfig-local
	stow --dotfiles -t $(HOME) bash
	stow --dotfiles -t $(HOME) ghostty
	stow --dotfiles -t $(HOME) keyboard
	stow --dotfiles -t $(HOME) git
	stow --dotfiles -t $(HOME) nvim
	stow --dotfiles -t $(HOME) starship
	stow --dotfiles -t $(HOME) tmux
	stow --dotfiles -t $(HOME) zsh
	@echo "✓ Dotfiles installed successfully"

uninstall:
	stow --dotfiles -D -t $(HOME) bash ghostty keyboard git nvim starship tmux zsh
	@echo "✓ Dotfiles uninstalled"

bootstrap:
	@command -v brew >/dev/null 2>&1 || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	@command -v stow >/dev/null 2>&1 || brew install stow
	@$(MAKE) all
	@$(MAKE) homebrew
	@echo "✓ Bootstrap complete"

homebrew:
	brew bundle install --file=homebrew/Brewfile

homebrew-extras:
	brew bundle install --file=homebrew/Brewfile.extras

brewfile:
	brew bundle dump --force --file=homebrew/Brewfile

brewfile-extras:
	brew bundle dump --force --file=homebrew/Brewfile.extras

lint:
	shellcheck bash/dot-bashrc bash/dot-bash_profile bash/dot-profile

mac:
	defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

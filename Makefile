.PHONY: all check bootstrap homebrew homebrew-extras brewfile brewfile-extras uninstall lint iterm mac

check:
	@command -v stow >/dev/null 2>&1 || (echo "Error: GNU Stow not found. Please install it first." && exit 1)
	@command -v brew >/dev/null 2>&1 || echo "Warning: Homebrew not found. Stow will still work, but run 'make homebrew' later."
	@echo "✓ Dependencies checked"

all: check
	@mkdir -p $(HOME)/.cache/zsh
	@mkdir -p $(HOME)/.config
	@mkdir -p $(HOME)/.emacs.d/lisp
	@touch $(HOME)/.gitconfig-local
	stow --dotfiles -t $(HOME) bash
	stow --dotfiles --no-folding -t $(HOME) emacs
	stow --dotfiles -t $(HOME) git
	stow --dotfiles -t $(HOME)/.config nvim
	stow --dotfiles -t $(HOME) starship
	stow --dotfiles -t $(HOME) tmux
	stow --dotfiles -t $(HOME) zsh
	@echo "✓ Dotfiles installed successfully"

uninstall:
	stow --dotfiles -D -t $(HOME) bash emacs git starship tmux zsh
	stow --dotfiles -D -t $(HOME)/.config nvim
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
	shellcheck bash/dot-bashrc bash/dot-bash_profile bash/dot-profile aws/aws.sh

iterm:
	@mkdir -p "$(HOME)/Library/Application Support/iTerm2/DynamicProfiles"
	cp iterm2/KWB.json "$(HOME)/Library/Application Support/iTerm2/DynamicProfiles/"
	@echo "✓ iTerm2 profile installed (restart iTerm2 to load)"

mac:
	defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

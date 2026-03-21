.PHONY: all check bootstrap homebrew homebrew-extras brewfile brewfile-extras uninstall lint mac cards tools ssh sync fonts linux-packages

UNAME := $(shell uname)

check:
	@command -v stow >/dev/null 2>&1 || (echo "Error: GNU Stow not found. Please install it first." && exit 1)
	@echo "✓ Dependencies checked ($(UNAME))"

all: check
	@mkdir -p $(HOME)/.cache/zsh
	@mkdir -p $(HOME)/.config
	@if [ ! -f $(HOME)/.gitconfig-local ]; then \
		if [ "$$(uname)" = "Darwin" ]; then \
			git config --file $(HOME)/.gitconfig-local credential.helper osxkeychain; \
		else \
			git config --file $(HOME)/.gitconfig-local credential.helper cache; \
		fi; \
		echo "✓ Created ~/.gitconfig-local with credential helper"; \
	fi
	stow --dotfiles --no-folding -t $(HOME) bash
	stow --dotfiles --no-folding -t $(HOME) ghostty
	stow --dotfiles --no-folding -t $(HOME) git
	stow --dotfiles --no-folding -t $(HOME) lazygit
	stow --dotfiles --no-folding -t $(HOME) nvim
	stow --dotfiles --no-folding -t $(HOME) starship
	stow --dotfiles --no-folding -t $(HOME) tmux
	stow --dotfiles --no-folding -t $(HOME) yazi
	stow --dotfiles --no-folding -t $(HOME) zsh
ifeq ($(UNAME),Darwin)
	stow --dotfiles --no-folding -t $(HOME) keyboard
endif
	@echo "✓ Dotfiles installed successfully"

uninstall:
	stow --dotfiles --no-folding -D -t $(HOME) bash ghostty git lazygit nvim starship tmux yazi zsh
ifeq ($(UNAME),Darwin)
	stow --dotfiles --no-folding -D -t $(HOME) keyboard
endif
	@echo "✓ Dotfiles uninstalled"

bootstrap:
	@command -v brew >/dev/null 2>&1 || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	@command -v stow >/dev/null 2>&1 || brew install stow
	@$(MAKE) all
	@$(MAKE) homebrew
	@$(MAKE) tools
ifneq ($(UNAME),Darwin)
	@$(MAKE) fonts
	@echo "Run 'sudo make linux-packages' to install desktop apps (Ghostty, Bitwarden, etc.)"
endif
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
	cd bash && shellcheck -x -e SC1091 dot-bashrc dot-bash_profile dot-profile dot-shell-common

cards:
	pdflatex -interaction=nonstopmode -output-directory=reference-cards reference-cards/reference-cards.tex
	@rm -f reference-cards/reference-cards.aux reference-cards/reference-cards.log
	@echo "✓ reference-cards/reference-cards.pdf built"

tools:
	@command -v node >/dev/null 2>&1 || (echo "Error: node not found. Run 'nvm install --lts' first." && exit 1)
	npm install -g typescript typescript-language-server dockerfile-language-server-nodejs prettier
	uv tool install ipython
	uv tool install marimo
	@echo "✓ Tools installed"

ssh:
	@mkdir -p $(HOME)/.ssh/sockets
	@if [ ! -f $(HOME)/.ssh/config-local ]; then \
		touch $(HOME)/.ssh/config-local; \
		chmod 600 $(HOME)/.ssh/config-local; \
		echo "✓ Created empty ~/.ssh/config-local"; \
	fi
	stow --dotfiles --no-folding -t $(HOME) ssh
	@chmod 600 ssh/.ssh/config
	@echo "✓ SSH config installed"

sync:
	git pull
	brew bundle install --file=homebrew/Brewfile
	@$(MAKE) all
	@echo "✓ Synced"

linux-packages:
	linux/packages.sh


fonts:
ifeq ($(UNAME),Darwin)
	@echo "On macOS, install via: brew install --cask font-commit-mono-nerd-font"
else
	@mkdir -p $(HOME)/.local/share/fonts
	curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CommitMono.tar.xz \
		| tar -xJ -C $(HOME)/.local/share/fonts
	fc-cache -f
	@echo "✓ CommitMono Nerd Font installed"
endif

mac:
ifeq ($(UNAME),Darwin)
	defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
else
	@echo "Skipped: macOS-only target"
endif

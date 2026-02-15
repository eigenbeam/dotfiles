.PHONY: all check bootstrap homebrew homebrew-extras brewfile brewfile-extras uninstall lint mac cards tools ssh

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
	stow --dotfiles -t $(HOME) ssh
	@chmod 600 ssh/dot-ssh/config
	@echo "✓ SSH config installed"

mac:
	defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

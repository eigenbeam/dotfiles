.PHONY: all check bootstrap homebrew brewfile uninstall lint mac cards tools ssh sync fonts linux-packages ssm-plugin doctor

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

brewfile:
	brew bundle dump --force --file=homebrew/Brewfile

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

doctor:
	@pass=0; fail=0; warn=0; \
	ok()  { pass=$$((pass + 1)); printf '  \033[32m✓\033[0m %s\n' "$$1"; }; \
	nok() { fail=$$((fail + 1)); printf '  \033[31m✗\033[0m %s\n' "$$1"; }; \
	wrn() { warn=$$((warn + 1)); printf '  \033[33m!\033[0m %s\n' "$$1"; }; \
	has() { command -v "$$1" >/dev/null 2>&1; }; \
	link_ok() { [ -L "$$1" ] && [ -e "$$1" ]; }; \
	echo "Dotfiles Doctor"; \
	echo "================"; \
	echo ""; \
	echo "Symlinks:"; \
	link_ok "$(HOME)/.profile"                    && ok ".profile"             || nok ".profile"; \
	link_ok "$(HOME)/.bashrc"                     && ok ".bashrc"              || nok ".bashrc"; \
	link_ok "$(HOME)/.bash_profile"               && ok ".bash_profile"        || nok ".bash_profile"; \
	link_ok "$(HOME)/.shell-common"               && ok ".shell-common"        || nok ".shell-common"; \
	link_ok "$(HOME)/.zshrc"                      && ok ".zshrc"               || nok ".zshrc"; \
	link_ok "$(HOME)/.zprofile"                   && ok ".zprofile"            || nok ".zprofile"; \
	link_ok "$(HOME)/.zshenv"                     && ok ".zshenv"              || nok ".zshenv"; \
	link_ok "$(HOME)/.tmux.conf"                  && ok ".tmux.conf"           || nok ".tmux.conf"; \
	link_ok "$(HOME)/.config/ghostty/config"      && ok "ghostty/config"       || nok "ghostty/config"; \
	link_ok "$(HOME)/.config/git/config"          && ok "git/config"           || nok "git/config"; \
	link_ok "$(HOME)/.config/git/ignore"          && ok "git/ignore"           || nok "git/ignore"; \
	link_ok "$(HOME)/.config/lazygit/config.yml"  && ok "lazygit/config.yml"   || nok "lazygit/config.yml"; \
	link_ok "$(HOME)/.config/nvim/init.lua"       && ok "nvim/init.lua"        || nok "nvim/init.lua"; \
	link_ok "$(HOME)/.config/starship.toml"       && ok "starship.toml"        || nok "starship.toml"; \
	link_ok "$(HOME)/.config/yazi/yazi.toml"      && ok "yazi/yazi.toml"       || nok "yazi/yazi.toml"; \
	link_ok "$(HOME)/.local/bin/tmux-sessionizer" && ok "tmux-sessionizer"     || nok "tmux-sessionizer"; \
	if [ "$$(uname)" = "Darwin" ]; then \
		link_ok "$(HOME)/Library/LaunchAgents/com.local.KeyRemapping.plist" \
			&& ok "keyboard remap plist" || nok "keyboard remap plist"; \
	fi; \
	echo ""; \
	echo "Configs:"; \
	[ -f "$(HOME)/.gitconfig-local" ] \
		&& ok "~/.gitconfig-local exists" || nok "~/.gitconfig-local missing (run make all)"; \
	git config --file "$(HOME)/.gitconfig-local" user.email >/dev/null 2>&1 \
		&& ok "git user.email set" || nok "git user.email not set in ~/.gitconfig-local"; \
	[ -d "$(HOME)/.cache/zsh" ] \
		&& ok "~/.cache/zsh exists" || nok "~/.cache/zsh missing (run make all)"; \
	echo ""; \
	echo "Shell:"; \
	if [ "$$(uname)" = "Darwin" ]; then \
		cur_shell=$$(dscl . -read "/Users/$$(whoami)" UserShell 2>/dev/null | awk '{print $$2}'); \
	else \
		cur_shell=$$(getent passwd "$$(whoami)" | cut -d: -f7); \
	fi; \
	case "$$cur_shell" in */zsh) ok "default shell is zsh";; *) wrn "default shell is not zsh ($$cur_shell)";; esac; \
	echo ""; \
	echo "Core tools:"; \
	for cmd in brew stow git nvim tmux starship fzf rg fd bat delta; do \
		has "$$cmd" && ok "$$cmd" || nok "$$cmd not found"; \
	done; \
	echo ""; \
	echo "CLI tools:"; \
	for cmd in lazygit zoxide direnv eza yazi glow xh; do \
		has "$$cmd" && ok "$$cmd" || wrn "$$cmd not found"; \
	done; \
	echo ""; \
	echo "Dev tools:"; \
	for cmd in node npm uv python3 aws terraform; do \
		has "$$cmd" && ok "$$cmd" || wrn "$$cmd not found"; \
	done; \
	has typescript-language-server && ok "typescript-language-server" || wrn "typescript-language-server (run make tools)"; \
	has prettier                  && ok "prettier"                   || wrn "prettier (run make tools)"; \
	has ipython                   && ok "ipython"                    || wrn "ipython (run make tools)"; \
	has marimo                    && ok "marimo"                     || wrn "marimo (run make tools)"; \
	has session-manager-plugin    && ok "session-manager-plugin"     || wrn "session-manager-plugin (run make ssm-plugin)"; \
	has claude                    && ok "claude"                      || wrn "claude (curl -fsSL https://claude.ai/install.sh | bash)"; \
	has gemini                    && ok "gemini"                      || wrn "gemini"; \
	echo ""; \
	echo "Homebrew:"; \
	brew bundle check --file=homebrew/Brewfile >/dev/null 2>&1 \
		&& ok "Brewfile packages installed" || wrn "some Brewfile packages missing (run make homebrew)"; \
	echo ""; \
	echo "================"; \
	printf 'Summary: \033[32m%d passed\033[0m' "$$pass"; \
	[ "$$warn" -gt 0 ] && printf ', \033[33m%d warnings\033[0m' "$$warn"; \
	[ "$$fail" -gt 0 ] && printf ', \033[31m%d failed\033[0m' "$$fail"; \
	echo ""; \
	[ "$$fail" -eq 0 ]

ssm-plugin:
	@echo "Installing AWS Session Manager Plugin..."
ifeq ($(UNAME),Darwin)
	@if [ "$$(uname -m)" = "arm64" ]; then \
		curl -fsSL "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac_arm64/session-manager-plugin.pkg" -o /tmp/session-manager-plugin.pkg; \
	else \
		curl -fsSL "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/session-manager-plugin.pkg" -o /tmp/session-manager-plugin.pkg; \
	fi
	sudo installer -pkg /tmp/session-manager-plugin.pkg -target /
	sudo ln -sf /usr/local/sessionmanagerplugin/bin/session-manager-plugin /usr/local/bin/session-manager-plugin
	@rm -f /tmp/session-manager-plugin.pkg
else
	@if [ "$$(uname -m)" = "aarch64" ]; then \
		curl -fsSL "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_arm64/session-manager-plugin.deb" -o /tmp/session-manager-plugin.deb; \
	else \
		curl -fsSL "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o /tmp/session-manager-plugin.deb; \
	fi
	sudo dpkg -i /tmp/session-manager-plugin.deb
	@rm -f /tmp/session-manager-plugin.deb
endif
	@echo "✓ AWS Session Manager Plugin installed"

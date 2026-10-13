.PHONY: all check bootstrap homebrew brew-sync brewfile uninstall lint tex keyboard cards tools debug-adapters ssh sync fonts linux-packages ssm-plugin doctor

# `check` is defined first below; without this, bare `make` would run only
# `check` instead of stowing anything.
.DEFAULT_GOAL := all

UNAME := $(shell uname)

# Debug adapters shared by Emacs dape and nvim-dap (make debug-adapters).
# java-debug's newest tag is not published to Maven Central; bump when it is.
JAVA_DEBUG_VERSION := 0.53.1
DEBUG_ADAPTERS := $(HOME)/.local/share/debug-adapters

# Where stow links land besides $(HOME) itself: the packages' top-level
# directories. make doctor scans them for links into this repo that no
# longer resolve.
LINK_ROOTS := .claude .config .emacs.d .local .ssh Library/LaunchAgents
REPO_REL := $(patsubst $(HOME)/%,%,$(CURDIR))

check:
	@command -v stow >/dev/null 2>&1 || (echo "Error: GNU Stow not found. Please install it first." && exit 1)
	@echo "✓ Dependencies checked ($(UNAME))"

# stow -R (restow) drops links to files deleted from a package. Links under a
# deleted directory survive it; make doctor reports those.
all: check
	@mkdir -p $(HOME)/.cache/zsh
	@mkdir -p $(HOME)/.config
	@find . -name .DS_Store -not -path './.git/*' -delete 2>/dev/null || true
	@if [ ! -f $(HOME)/.gitconfig-local ]; then \
		if [ "$$(uname)" = "Darwin" ]; then \
			git config --file $(HOME)/.gitconfig-local credential.helper osxkeychain; \
		else \
			git config --file $(HOME)/.gitconfig-local credential.helper cache; \
		fi; \
		echo "✓ Created ~/.gitconfig-local with credential helper"; \
	fi
	stow --dotfiles --no-folding -R -t $(HOME) ai
	stow --dotfiles --no-folding -R -t $(HOME) bash
	stow --dotfiles --no-folding -R -t $(HOME) emacs
	stow --dotfiles --no-folding -R -t $(HOME) ghostty
	stow --dotfiles --no-folding -R -t $(HOME) git
	stow --dotfiles --no-folding -R -t $(HOME) lazygit
	stow --dotfiles --no-folding -R -t $(HOME) nvim
	stow --dotfiles --no-folding -R -t $(HOME) starship
	stow --dotfiles --no-folding -R -t $(HOME) tmux
	stow --dotfiles --no-folding -R -t $(HOME) yazi
	stow --dotfiles --no-folding -R -t $(HOME) zsh
	@$(MAKE) keyboard
	@echo "✓ Dotfiles installed successfully"

uninstall:
	stow --dotfiles --no-folding -D -t $(HOME) ai bash emacs ghostty git lazygit nvim starship tmux yazi zsh
ifeq ($(UNAME),Darwin)
	@launchctl bootout gui/$$(id -u)/com.local.KeyRemapping 2>/dev/null || true
	@hidutil property --set '{"UserKeyMapping":[]}' >/dev/null 2>&1 || true
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

# Make Homebrew match the Brewfile: remove what it no longer lists (brew
# asks first), then install and upgrade the rest. Cleanup must run first: a
# package that moved from formula to cask (emacs-plus) keeps its formula's
# links until cleanup, and a cask installed alongside them skips its own.
brew-sync:
	brew bundle cleanup --file=homebrew/Brewfile
	brew bundle install --file=homebrew/Brewfile

brewfile:
	brew bundle dump --force --file=homebrew/Brewfile

lint:
	cd bash && shellcheck -x -e SC1091 dot-bashrc dot-bash_profile dot-profile dot-shell-common
	stylua --check nvim/.config/nvim
	nvim --headless --clean -l nvim/.config/nvim/lint.lua
	emacs -Q --batch --eval '(dolist (f (append (file-expand-wildcards "emacs/dot-emacs.d/*.el") (file-expand-wildcards "emacs/dot-emacs.d/lisp/*.el"))) (with-temp-buffer (insert-file-contents f) (emacs-lisp-mode) (condition-case err (check-parens) (error (message "%s: %s" f err) (kill-emacs 1)))))'

# A5 duplex PDFs for a binder: the deck (reference-cards.tex) plus one topic
# card per *-card.tex. cards.sty is the shared preamble; fancyhdr and the rest
# come from `make tex`.
cards:
	@for f in reference-cards/reference-cards.tex reference-cards/*-card.tex; do \
		TEXINPUTS=reference-cards: pdflatex -interaction=nonstopmode -halt-on-error -output-directory=reference-cards "$$f" >/dev/null || { echo "pdflatex failed on $$f"; exit 1; }; \
	done
	@rm -f reference-cards/*.aux reference-cards/*.log
	@echo "✓ Reference cards built (A5, duplex)"

# Use Homebrew's npm so globals land in $(brew --prefix)/bin, which is always on
# PATH. nvm's bin dir is only on PATH after nvm lazy-loads, so globals installed
# there are invisible to nvim (LSPs, prettier) and to `make doctor`.
tools:
	@test -x "$$(brew --prefix)/bin/npm" || (echo "Error: Homebrew node not found. Run 'make homebrew' first." && exit 1)
	"$$(brew --prefix)/bin/npm" install -g typescript typescript-language-server dockerfile-language-server-nodejs prettier
	uv tool install ipython
	@echo "✓ Tools installed"

debug-adapters:
	@command -v jq >/dev/null 2>&1 || (echo "Error: jq not found. Run 'make homebrew' first." && exit 1)
	mkdir -p "$(DEBUG_ADAPTERS)/java-debug"
	curl -fsSL -o "$(DEBUG_ADAPTERS)/java-debug/com.microsoft.java.debug.plugin-$(JAVA_DEBUG_VERSION).jar" \
		"https://repo1.maven.org/maven2/com/microsoft/java/com.microsoft.java.debug.plugin/$(JAVA_DEBUG_VERSION)/com.microsoft.java.debug.plugin-$(JAVA_DEBUG_VERSION).jar"
	v=$$(curl -fsSL https://api.github.com/repos/microsoft/vscode-js-debug/releases/latest | jq -r .tag_name); \
		rm -rf "$(DEBUG_ADAPTERS)/js-debug"; \
		curl -fsSL "https://github.com/microsoft/vscode-js-debug/releases/download/$$v/js-debug-dap-$$v.tar.gz" | tar xz -C "$(DEBUG_ADAPTERS)"
	@echo "✓ Debug adapters installed in $(DEBUG_ADAPTERS) (java-debug $(JAVA_DEBUG_VERSION), js-debug)"

ssh:
	@mkdir -p $(HOME)/.ssh/sockets
	@if [ ! -f $(HOME)/.ssh/config-local ]; then \
		touch $(HOME)/.ssh/config-local; \
		chmod 600 $(HOME)/.ssh/config-local; \
		echo "✓ Created empty ~/.ssh/config-local"; \
	fi
	stow --dotfiles --no-folding -R -t $(HOME) ssh
	@chmod 600 ssh/.ssh/config
	@echo "✓ SSH config installed"

sync:
	git pull
	@$(MAKE) brew-sync
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

tex:
ifeq ($(UNAME),Darwin)
	@command -v tlmgr >/dev/null 2>&1 || (echo "Error: tlmgr not found. Run 'brew install --cask basictex' first (needs sudo)." && exit 1)
	sudo tlmgr update --self
	sudo tlmgr install bera extsizes fancyhdr geometry helvetic microtype needspace psnfss tools
	@echo "✓ TeX packages for reference-cards installed"
else
	@echo "Skipped: on Linux, 'sudo make linux-packages' installs TeX Live via apt"
endif

keyboard:
ifeq ($(UNAME),Darwin)
	stow --dotfiles --no-folding -R -t $(HOME) keyboard
	@launchctl bootout gui/$$(id -u)/com.local.KeyRemapping 2>/dev/null || true
	@launchctl bootstrap gui/$$(id -u) $(HOME)/Library/LaunchAgents/com.local.KeyRemapping.plist
	@echo "✓ Keyboard remapping agent loaded (right-option → right-control)"
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
	link_ok "$(HOME)/.emacs.d/init.el"            && ok "emacs/init.el"        || nok "emacs/init.el"; \
	link_ok "$(HOME)/.config/git/config"          && ok "git/config"           || nok "git/config"; \
	link_ok "$(HOME)/.config/git/ignore"          && ok "git/ignore"           || nok "git/ignore"; \
	link_ok "$(HOME)/.config/lazygit/config.yml"  && ok "lazygit/config.yml"   || nok "lazygit/config.yml"; \
	link_ok "$(HOME)/.config/nvim/init.lua"       && ok "nvim/init.lua"        || nok "nvim/init.lua"; \
	link_ok "$(HOME)/.config/nvim/nvim-pack-lock.json" && ok "nvim/nvim-pack-lock.json" || nok "nvim/nvim-pack-lock.json"; \
	link_ok "$(HOME)/.config/starship.toml"       && ok "starship.toml"        || nok "starship.toml"; \
	link_ok "$(HOME)/.config/yazi/yazi.toml"      && ok "yazi/yazi.toml"       || nok "yazi/yazi.toml"; \
	link_ok "$(HOME)/.claude/CLAUDE.md"            && ok "claude/CLAUDE.md"     || nok "claude/CLAUDE.md"; \
	link_ok "$(HOME)/.local/bin/tmux-sessionizer" && ok "tmux-sessionizer"     || nok "tmux-sessionizer"; \
	if [ "$$(uname)" = "Darwin" ]; then \
		link_ok "$(HOME)/Library/LaunchAgents/com.local.KeyRemapping.plist" \
			&& ok "keyboard remap plist" || nok "keyboard remap plist"; \
		launchctl print "gui/$$(id -u)/com.local.KeyRemapping" >/dev/null 2>&1 \
			&& ok "keyboard remap agent loaded" || nok "keyboard remap agent not loaded (run make keyboard)"; \
		hidutil property --get UserKeyMapping 2>/dev/null | grep -q 30064771300 \
			&& ok "right-option → right-control active" || nok "right-option remap inactive (run make keyboard)"; \
	fi; \
	broken=$$( { find "$(HOME)" -maxdepth 1 -type l -lname '*$(REPO_REL)/*'; \
		find $(addprefix "$(HOME)"/,$(LINK_ROOTS)) -type l -lname '*$(REPO_REL)/*'; } 2>/dev/null \
		| while IFS= read -r l; do [ -e "$$l" ] || echo "$$l"; done ); \
	if [ -z "$$broken" ]; then \
		ok "no broken links into the repo"; \
	else \
		nok "$$(printf '%s\n' "$$broken" | wc -l | tr -d ' ') broken links into the repo (stale stow links; delete them):"; \
		printf '%s\n' "$$broken" | sed 's|^$(HOME)/|      ~/|'; \
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
	has prettier                  && ok "prettier"                   || wrn "prettier (run make tools)"; \
	has ipython                   && ok "ipython"                    || wrn "ipython (run make tools)"; \
	has session-manager-plugin    && ok "session-manager-plugin"     || wrn "session-manager-plugin (run make ssm-plugin)"; \
	has claude                    && ok "claude"                      || wrn "claude (curl -fsSL https://claude.ai/install.sh | bash)"; \
	echo ""; \
	echo "Language servers (Emacs eglot and Neovim):"; \
	for cmd in clangd pyright-langserver ruff jdtls bash-language-server yaml-language-server lua-language-server taplo terraform-ls julia; do \
		has "$$cmd" && ok "$$cmd" || wrn "$$cmd not found"; \
	done; \
	has typescript-language-server && ok "typescript-language-server" || wrn "typescript-language-server (run make tools)"; \
	has docker-langserver          && ok "docker-langserver"          || wrn "docker-langserver (run make tools)"; \
	echo ""; \
	echo "Debug adapters (Emacs dape and nvim-dap):"; \
	ls "$(DEBUG_ADAPTERS)"/java-debug/com.microsoft.java.debug.plugin-*.jar >/dev/null 2>&1 \
		&& ok "java-debug adapter" || wrn "java-debug adapter (run make debug-adapters)"; \
	[ -f "$(DEBUG_ADAPTERS)/js-debug/src/dapDebugServer.js" ] \
		&& ok "js-debug adapter" || wrn "js-debug adapter (run make debug-adapters)"; \
	if [ "$(UNAME)" = Darwin ]; then \
		xcrun -f lldb-dap >/dev/null 2>&1 && ok "lldb-dap (Xcode CLT)" || wrn "lldb-dap (xcode-select --install)"; \
	else \
		has lldb-dap && ok "lldb-dap" || wrn "lldb-dap (install the lldb package)"; \
	fi; \
	ok "debugpy is per project: uv add --dev debugpy"; \
	echo ""; \
	echo "Emacs:"; \
	has emacs && ok "emacs $$(emacs --version | head -1 | awk '{print $$3}')" || wrn "emacs not found"; \
	has cmake && [ -d "$$(brew --prefix 2>/dev/null)/opt/libvterm" ] \
		&& ok "cmake + libvterm (vterm build deps)" || wrn "cmake/libvterm missing (run make homebrew)"; \
	ls "$(HOME)"/.emacs.d/elpa/vterm-*/vterm-module.so >/dev/null 2>&1 \
		&& ok "vterm module compiled" || wrn "vterm module not compiled yet (first C-c t in Emacs)"; \
	echo ""; \
	echo "Neovim:"; \
	has nvim && ok "nvim $$(nvim --version | head -1 | awk '{print $$2}')" || wrn "nvim not found"; \
	has stylua && ok "stylua" || wrn "stylua (run make homebrew; make lint needs it)"; \
	has tree-sitter && ok "tree-sitter CLI" || wrn "tree-sitter CLI (run make homebrew; parsers will not compile)"; \
	ls "$(HOME)"/.local/share/nvim/site/parser/*.so >/dev/null 2>&1 \
		&& ok "tree-sitter parsers compiled" || wrn "no tree-sitter parsers yet (start nvim once with the CLI installed)"; \
	[ -f "$(HOME)/.local/share/nvim/site/queries/python/highlights.scm" ] \
		&& ok "tree-sitter queries linked" || wrn "tree-sitter query links missing (:TSInstall! all; see nvim README troubleshooting)"; \
	ls "$(HOME)"/.local/share/nvim/site/pack/core/opt/*/ >/dev/null 2>&1 \
		&& ok "vim.pack plugins installed" || wrn "no vim.pack plugins yet (start nvim once)"; \
	for d in lazy mason site/pack/packer; do \
		[ -e "$(HOME)/.local/share/nvim/$$d" ] && wrn "stale ~/.local/share/nvim/$$d (rm -rf it; see nvim/.config/nvim/README.md)"; \
	done; \
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

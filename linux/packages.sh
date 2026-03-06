#!/usr/bin/env bash
# Install Linux equivalents of macOS Homebrew casks.
# Targets Debian/Ubuntu/Mint (apt-based). Run with sudo or as root.
set -euo pipefail

if [[ "$(uname)" != "Linux" ]]; then
    echo "This script is for Linux only."
    exit 1
fi

if [[ $EUID -ne 0 ]]; then
    echo "Error: This script requires root. Run: sudo make linux-packages"
    exit 1
fi

ARCH="$(dpkg --print-architecture)"

# -- Ghostty (must be built from source — see https://ghostty.org/docs/install/build) --
if ! command -v ghostty &>/dev/null; then
    echo "Note: Ghostty not installed. It must be built from source on Linux."
    echo "  See: https://ghostty.org/docs/install/build"
fi

# -- Bitwarden (snap) -------------------------------------------------------
if ! command -v bitwarden &>/dev/null && command -v snap &>/dev/null; then
    echo "Installing Bitwarden..."
    snap install bitwarden
fi

# -- TeX Live ----------------------------------------------------------------
if ! command -v pdflatex &>/dev/null; then
    echo "Installing TeX Live..."
    apt-get install -y texlive-base texlive-latex-recommended texlive-fonts-recommended
fi

# -- Quarto (.deb from GitHub) -----------------------------------------------
if ! command -v quarto &>/dev/null; then
    echo "Installing Quarto..."
    QUARTO_URL=$(curl -fsSL https://api.github.com/repos/quarto-dev/quarto-cli/releases/latest \
        | grep "browser_download_url.*linux-${ARCH}.deb" | head -1 | cut -d '"' -f 4)
    curl -fsSL -o /tmp/quarto.deb "$QUARTO_URL"
    apt-get install -y /tmp/quarto.deb
    rm -f /tmp/quarto.deb
fi

# -- AWS Session Manager Plugin (.deb) --------------------------------------
if ! command -v session-manager-plugin &>/dev/null; then
    echo "Installing AWS Session Manager Plugin..."
    curl -fsSL -o /tmp/session-manager-plugin.deb \
        "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb"
    apt-get install -y /tmp/session-manager-plugin.deb
    rm -f /tmp/session-manager-plugin.deb
fi

# -- Adoptium Temurin JDK 21 ------------------------------------------------
if ! dpkg -s temurin-21-jdk &>/dev/null 2>&1; then
    echo "Installing Temurin JDK 21..."
    apt-get install -y wget apt-transport-https gpg
    wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public \
        | gpg --dearmor -o /usr/share/keyrings/adoptium.gpg 2>/dev/null || true
    echo "deb [signed-by=/usr/share/keyrings/adoptium.gpg] https://packages.adoptium.net/artifactory/deb $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") main" \
        | tee /etc/apt/sources.list.d/adoptium.list
    apt-get update
    apt-get install -y temurin-21-jdk
fi

# -- Zotero (.deb from zotero.org) -------------------------------------------
if ! command -v zotero &>/dev/null; then
    echo "Installing Zotero..."
    curl -fsSL https://raw.githubusercontent.com/retorquere/zotero-deb/master/install.sh | bash
    apt-get update
    apt-get install -y zotero
fi

# -- Docker (official apt repo) ----------------------------------------------
if ! command -v docker &>/dev/null; then
    echo "Installing Docker..."
    apt-get install -y ca-certificates curl
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" \
      | tee /etc/apt/sources.list.d/docker.list
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    usermod -aG docker "${SUDO_USER:-$USER}"
    echo "Note: Log out and back in for docker group membership to take effect."
fi

echo "✓ Linux packages installed"

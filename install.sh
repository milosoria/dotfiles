#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    log_error "This script is designed for macOS only"
    exit 1
fi

log_info "Starting macOS development environment setup..."

# Install Xcode Command Line Tools
if ! command -v git &> /dev/null; then
    log_info "Installing Xcode Command Line Tools..."
    xcode-select --install
    log_success "Xcode Command Line Tools installation initiated"
else
    log_success "Xcode Command Line Tools already installed"
fi

# Install Homebrew
if ! command -v brew &> /dev/null; then
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    log_success "Homebrew installed"
else
    log_success "Homebrew already installed"
fi

# Update Homebrew
log_info "Updating Homebrew..."
brew update

# Install essential CLI tools
log_info "Installing essential CLI tools..."

# Core tools
CORE_TOOLS=(
    "git"
    "zsh"
    "tmux"
    "neovim"
    "fzf"
    "ripgrep"
    "fd"
    "bat"
    "eza"
    "zoxide"
    "starship"
    "gh"
)

for tool in "${CORE_TOOLS[@]}"; do
    if brew list "$tool" &> /dev/null; then
        log_success "$tool already installed"
    else
        log_info "Installing $tool..."
        brew install "$tool"
        log_success "$tool installed"
    fi
done

# Install development tools
log_info "Installing development tools..."

DEV_TOOLS=(
    "node"
    "pnpm"
    "python@3.11"
    "pyenv"
    "go"
    "rustup"
)

for tool in "${DEV_TOOLS[@]}"; do
    if brew list "$tool" &> /dev/null; then
        log_success "$tool already installed"
    else
        log_info "Installing $tool..."
        brew install "$tool"
        log_success "$tool installed"
    fi
done

# Install GUI applications via Homebrew Cask
log_info "Installing GUI applications..."

CASK_APPS=(
    "kitty"
    "visual-studio-code"
    "cursor"
    "raycast"
    "iterm2"
    "zathura"
)

for app in "${CASK_APPS[@]}"; do
    if brew list --cask "$app" &> /dev/null; then
        log_success "$app already installed"
    else
        log_info "Installing $app..."
        brew install --cask "$app"
        log_success "$app installed"
    fi
done

# Setup Rust
if command -v rustup &> /dev/null; then
    log_info "Setting up Rust..."
    rustup default stable
    log_success "Rust setup complete"
fi

# Setup Python
if command -v pyenv &> /dev/null; then
    log_info "Setting up Python with pyenv..."
    pyenv install 3.11.0 || log_warning "Python 3.11.0 already installed"
    pyenv global 3.11.0
    log_success "Python setup complete"
fi

# Setup Node.js
if command -v pnpm &> /dev/null; then
    log_info "Setting up pnpm..."
    pnpm setup
    log_success "pnpm setup complete"
fi

# Install Java (Zulu OpenJDK 17)
if ! brew list --cask zulu17 &> /dev/null; then
    log_info "Installing Java (Zulu OpenJDK 17)..."
    brew install --cask zulu17
    log_success "Java installed"
else
    log_success "Java already installed"
fi

# Setup FZF key bindings
if command -v fzf &> /dev/null; then
    log_info "Setting up FZF key bindings..."
    $(brew --prefix)/opt/fzf/install --all
    log_success "FZF setup complete"
fi

log_success "Installation complete! Please run the bootstrap script next."
log_info "You may need to restart your terminal for some changes to take effect."
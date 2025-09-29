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

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
DOTFILES_DIR="$SCRIPT_DIR"

log_info "Bootstrapping dotfiles from $DOTFILES_DIR..."

# Function to create symlinks
create_symlink() {
    local source="$1"
    local target="$2"

    if [[ -L "$target" ]]; then
        log_warning "Symlink already exists: $target"
        return
    fi

    if [[ -e "$target" ]]; then
        log_warning "File exists, creating backup: $target -> $target.backup"
        mv "$target" "$target.backup"
    fi

    mkdir -p "$(dirname "$target")"
    ln -s "$source" "$target"
    log_success "Created symlink: $target -> $source"
}

# Create .config directory if it doesn't exist
mkdir -p "$HOME/.config"

# Symlink configuration directories
CONFIG_DIRS=(
    "nvim"
    "kitty"
    "tmux"
    "zsh"
    "git"
    "gh"
    "raycast"
    "cursor"
    "zathura"
    "custom_commands"
)

for dir in "${CONFIG_DIRS[@]}"; do
    if [[ -d "$DOTFILES_DIR/$dir" ]]; then
        create_symlink "$DOTFILES_DIR/$dir" "$HOME/.config/$dir"
    else
        log_warning "Directory not found: $DOTFILES_DIR/$dir"
    fi
done

# Special handling for Cursor configuration files
CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"
if [[ -d "$CURSOR_USER_DIR" ]]; then
    log_info "Setting up Cursor configuration..."

    # Create symlinks for Cursor config files
    if [[ -f "$DOTFILES_DIR/cursor/settings.json" ]]; then
        create_symlink "$DOTFILES_DIR/cursor/settings.json" "$CURSOR_USER_DIR/settings.json"
    fi

    if [[ -f "$DOTFILES_DIR/cursor/keybindings.json" ]]; then
        create_symlink "$DOTFILES_DIR/cursor/keybindings.json" "$CURSOR_USER_DIR/keybindings.json"
    fi

    log_success "Cursor configuration completed"
else
    log_warning "Cursor not found. Configuration files are available in cursor/ directory."
    log_info "Install Cursor and run this script again to set up configuration."
fi

# Special handling for zsh - link .zshrc to home directory
if [[ -f "$DOTFILES_DIR/zsh/.zshrc" ]]; then
    create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
fi

# Create .zprofile if it doesn't exist (for Homebrew PATH)
if [[ ! -f "$HOME/.zprofile" ]]; then
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' > "$HOME/.zprofile"
    else
        echo 'eval "$(/usr/local/bin/brew shellenv)"' > "$HOME/.zprofile"
    fi
    log_success "Created .zprofile"
fi

# Setup Git configuration (if git config exists)
if [[ -f "$DOTFILES_DIR/git/config" ]]; then
    log_info "Git configuration found. You may need to update user.name and user.email"
    log_info "Run: git config --global user.name 'Your Name'"
    log_info "Run: git config --global user.email 'your.email@example.com'"
fi

# Make custom commands executable
if [[ -d "$DOTFILES_DIR/custom_commands" ]]; then
    log_info "Making custom commands executable..."
    find "$DOTFILES_DIR/custom_commands" -type f -exec chmod +x {} \;
    log_success "Custom commands made executable"
fi

# Change default shell to zsh
if [[ "$SHELL" != "/bin/zsh" ]] && [[ "$SHELL" != "/usr/local/bin/zsh" ]]; then
    log_info "Changing default shell to zsh..."
    sudo chsh -s "$(which zsh)" "$USER"
    log_success "Default shell changed to zsh"
else
    log_success "Default shell is already zsh"
fi

# Install nvim plugins (if nvim is available)
if command -v nvim &> /dev/null; then
    log_info "Installing Neovim plugins..."
    nvim --headless +q 2>/dev/null || true
    log_success "Neovim plugins installation initiated"
fi

# Setup tmux plugin manager
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    log_info "Installing tmux plugin manager..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    log_success "TPM installed"
    log_info "Run 'tmux' and press 'prefix + I' to install tmux plugins"
fi

log_success "Bootstrap complete!"
log_info "Please restart your terminal or run 'source ~/.zshrc' to apply changes"
log_info "You may need to:"
log_info "  1. Update Git user config: git config --global user.name/email"
log_info "  2. Install tmux plugins: prefix + I in tmux"
log_info "  3. Setup any API keys or secrets in ~/.config/zsh/.zshsecrets"
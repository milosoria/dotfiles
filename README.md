# Dotfiles Configuration

A comprehensive macOS development environment configuration repository designed for easy portability and quick setup on new machines.

## Quick Setup

1. **Clone the repository:**
   ```bash
   git clone <your-repo-url> ~/.config
   cd ~/.config
   ```

2. **Run the installation script:**
   ```bash
   ./install.sh
   ```

3. **Bootstrap the dotfiles:**
   ```bash
   ./bootstrap.sh
   ```

4. **Restart your terminal or source the configuration:**
   ```bash
   source ~/.zshrc
   ```

## What's Included

### Core Configuration
- **nvim/**: Neovim configuration with LazyVim, plugins, and custom settings
- **zsh/**: Zsh configuration with aliases, functions, and environment variables
- **kitty/**: Kitty terminal emulator configuration
- **tmux/**: Tmux configuration and plugin setup
- **git/**: Git configuration and aliases

### Development Tools
- **cursor/**: Cursor IDE configuration
- **raycast/**: Raycast app launcher settings
- **gh/**: GitHub CLI configuration
- **zathura/**: PDF viewer configuration

### Hardware
- **ergodox/**: Ergodox keyboard layout and Wally software configuration
- **custom_commands/**: Custom shell commands and scripts

## Scripts

### install.sh
Installs all necessary software and tools including:
- Homebrew and essential CLI tools (git, zsh, tmux, neovim, fzf, ripgrep, etc.)
- Development tools (Node.js, Python, Go, Rust)
- GUI applications (Kitty, VSCode, Cursor, Raycast)
- Package managers (pnpm, pyenv)

### bootstrap.sh
Sets up the dotfiles by:
- Creating symbolic links for all configuration directories
- Setting up shell configuration
- Installing Neovim plugins
- Installing tmux plugin manager
- Making custom commands executable

## Manual Setup Steps

After running the scripts, you may need to:

1. **Configure Git:**
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

2. **Install tmux plugins:**
   - Start tmux: `tmux`
   - Press `prefix + I` to install plugins

3. **Setup secrets:**
   - Create `~/.config/zsh/.zshsecrets` for API keys and sensitive environment variables

4. **Configure applications:**
   - Import Raycast settings if needed
   - Configure Cursor/VSCode extensions and settings

## Customization

- Modify configurations in their respective directories
- Add custom shell functions to `zsh/`
- Add custom commands to `custom_commands/`
- Update plugin lists in `nvim/` configurations

## Supported Platforms

- macOS (Intel and Apple Silicon)

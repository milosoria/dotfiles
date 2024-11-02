# 💤 LazyVim Neovim Configuration

This repository contains my personal Neovim configuration using [LazyVim](https://github.com/LazyVim/LazyVim). LazyVim is a modern and minimalistic Neovim configuration framework that helps you get started quickly.

## Prerequisites

- Neovim v0.10.0 or later
- Git
- A terminal emulator

## Installation

1. Clone this repository to your local machine:

   ```bash
   
    git clone --depth 1 --filter=blob:none --sparse https://github.com/milosoria/dotfiles.git ~/.config/nvim
    cd ~/.config/nvim
    git sparse-checkout set nvim
    ```

   ```

2. Once opened LazyVim will do the rest 

## Configuration

You can customize the configuration by editing the files in the `~/.config/nvim` directory. For examples of how to customize plugins, refer to the `plugins/example.lua` file. Additionally, you can refer to the [LazyVim documentation](https://lazyvim.github.io/installation) for more details on how to configure LazyVim.

## Usage

- Open Neovim by running `nvim` in your terminal.
- Use the provided keybindings and commands to enhance your coding experience.

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests to improve this configuration.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

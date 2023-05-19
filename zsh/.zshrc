# Path to your oh-my-zsh installation.
ZSH_THEME=021011
DISABLE_AUTO_TITLE=true
# Add wisely, as too many plugins slow down shell startup.
zvm_after_init_commands+=('[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh')
plugins=(zsh-vi-mode git dircycle nvm  zsh-autosuggestions zsh-syntax-highlighting zsh-z)

export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
zstyle ':omz:update' mode auto # update automatically without asking

# User configuration
export ZDOTDIR=$HOME/.config/zsh
export GIT_EDITOR="nvim"
export VISUAL="nvim"
export EDITOR="nvim"
export editor="nvim"
export PATH=$PATH:~/.cargo/bin
export PATH=$PATH:~/Library/Python/3.9/bin
## Android Studio shit
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
## pnpm
export PNPM_HOME="/Users/milosoria/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

## Hombrew api key
export HOMEBREW_GITHUB_API_TOKEN=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
## Dont use docker desktop tools
export DOCKER_BUILDKIT=0
export COMPOSE_DOCKER_CLI_BUILD=0
## NVM: loads nvm and sources nvm completion
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Source customs
source ~/.config/custom_commands/custom_commands.sh
source ~/.config/zsh/zsh-aliases

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

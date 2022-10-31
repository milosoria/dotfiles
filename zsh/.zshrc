# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
# Path to your oh-my-zsh installation.
ZSH_THEME="awesomepanda"
# Add wisely, as too many plugins slow down shell startup.
zvm_after_init_commands+=('[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh')
plugins=(zsh-vi-mode git  dircycle nvm  zsh-autosuggestions zsh-syntax-highlighting zsh-z)


export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
zstyle ':omz:update' mode auto      # update automatically without asking


# User configuration
export ZDOTDIR=$HOME/.config/zsh
export GIT_EDITOR="nvim"
export VISUAL="nvim"
export EDITOR="nvim"
export editor="nvim"
export PATH=$PATH:~/.cargo/bin

# NVM: loads nvm and sources nvm completion
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Source customs
source ~/.config/custom_commands/custom_commands.sh
source ~/.config/zsh/zsh-aliases

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# FIX THIS: zsh-vi-mode uses ^J as escape newline, find a way to make it work
# zsh-autosuggestions accept suggestion with c-j
bindkey '^J' autosuggest-accept

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"

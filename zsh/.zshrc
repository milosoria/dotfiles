# zmodload zsh/zprof

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export SHELL=/bin/zsh

ZSH_THEME="robbyrussell"
# Case sensitive search
CASE_SENSITIVE="true"

# Plugins with oh my zsh
plugins=(
    zshfl
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-nvm
)

source $ZSH/oh-my-zsh.sh

# Node lazy loading for faster shell startup 
lazynvm() {
    unset -f nvm node npm
    export NVM_DIR=~/.nvm
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
}

# NVM unset and then set when called
nvm() {
    lazynvm 
    nvm $@
}

# NODE unset and then set when called
node() {
    lazynvm
    node $@
}

# NPM unset and then set when called
npm() {
    lazynvm
    npm $@
}

# ALIASES 
#general
alias nv='nvim'
alias home='cd ~'
alias mine='cd ~/projects'
alias dotfiles='cd ~/.config'
alias ex='exit'
alias open='xdg-open'
alias vimrc='"$EDITOR" ~/.config/nvim/init.vim'
alias dotfiles='cd ~/.config'
alias kittyconf='"$EDITOR" ~/.config/kitty/kitty.conf'
alias ll='ls -lah'
alias nn='nnn -de'
alias cat='bat'

# git
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gs='git status'
alias qpll='git pull'

# apt
alias update='sudo apt-get update -y'
alias upgrade='sudo apt-get upgrade -y'
alias install='sudo apt-get install'

# cheat sheet
alias cheat='cht.sh'

# custom commands
alias create='project'
alias qpsh='qpsh'

# Path exports
export PATH=$PATH/neovim/build/bin
export VISUAL=nvim
export EDITOR=$VISUAL
export PATH=/snap/bin:$PATH
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/.rvm/bin
export PATH=$PATH:/.yarn/bin

#source Custom commands
source ~/custom_commands/custom_commands.sh

# fzf for shell 
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# zprof

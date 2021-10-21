#!bin/sh

# Path to your oh-my-zsh installation.
export SHELL=/bin/zsh
# zsh config dir
export ZDOTDIR=$HOME/.config/zsh

# useful options
setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments
zle_highlight=('paste:none')
unsetopt BEEP


# Case sensitive search
CASE_SENSITIVE="true"
# useful functions to add plugins and source files, make ur profile readable
source "$ZDOTDIR/zsh-functions"

# Normal files to source
zsh_add_file "zsh-exports"
zsh_add_file "zsh-vim-mode"
zsh_add_file "zsh-aliases"
zsh_add_file "zsh-prompt"
# Source customs
source ~/custom_commands/custom_commands.sh

#Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-nvm"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"

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

# fzf for shell 
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

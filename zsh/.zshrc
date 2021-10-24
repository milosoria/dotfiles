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
zsh_add_file "zsh-aliases"
zsh_add_file "zsh-prompt"
zsh_add_file "zsh-vim-mode"

# Source customs
source ~/custom_commands/custom_commands.sh

#Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-nvm"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"

# fzf for shell 
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# compinit fix for slow startup
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C
# Path to your oh-my-zsh installation.
export ZSH="/home/camilo/.oh-my-zsh"
# Path to startship
 export STARSHIP_CONFIG=~/.config/starship/starship.toml
# Node stuff
export NVM_LAZY_LOAD=true
export NVM_DIR=~/.nvm
NODE_GLOBALS=(`find ~/.nvm/versions/node -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq`)
NODE_GLOBALS+=(node nvm yarn)

_load_nvm() {
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}

for cmd in "${NODE_GLOBALS[@]}"; do
    eval "function ${cmd}(){ unset -f ${NODE_GLOBALS[*]}; _load_nvm; unset -f _load_nvm; ${cmd} \$@; }"
done
unset cmd NODE_GLOBALS

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
# Plugins with oh my zsh
plugins=(
	zshfl
	git
        zsh-syntax-highlighting
	zsh-autosuggestions
        zsh-nvm
)

source $ZSH/oh-my-zsh.sh

#Custom commands
source ~/custom_commands/custom_commands.sh

# Custom Aliases

alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias qpll='git pull'
alias update='sudo apt-get update -y'
alias upgrade='sudo apt-get upgrade -y'
alias install='sudo apt-get install'
alias home='cd ~'
alias ex='exit'
# Custom command
alias create='project'
alias open='xdg-open'
alias qpsh='qpsh'
alias vim='nvim'
alias vimrc='cd ~/.config/nvim && vim init.vim'
alias kittyconf='cd ~/.config/kitty && vim kitty.conf'
alias ll='ls -la'

# Path exports
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="/snap/bin:$PATH"
export PATH="$PATH/neovim/build/bin"
export PATH="$PATH:/.yarn/bin"
# 
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Startship prompt
eval "$(starship init zsh)"

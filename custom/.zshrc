# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Setup history
HISTFILE=/vagrant/custom/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Visual things
ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#808080"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-completions fzf docker)

# Reload completions for zsh-completions
autoload -U compinit && compinit

# Source the files for the enhancd
source ~/.oh-my-zsh/plugins/enhancd/init.sh

# Source oh-my-zsh
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# User configuration
# Include my aliases
source /vagrant/custom/.zsh_aliases

# Freeze
freeze_history () {
    fc -A
    fc -p $HISTFILE
    unset HISTFILE
}
unfreeze_history () {
    fc -P
}

# Configuration for pet
function prev() {
  PREV=$(fc -lrn | head -n 1)
  sh -c "pet new `printf %q "$PREV"`"
}
function pet-select() {
  BUFFER=$(pet search --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N pet-select
bindkey '^s' pet-select

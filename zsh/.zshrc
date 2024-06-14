# == Environment ==

export ZSH=$HOME/.zsh
export HISTFILE=~/.histfile
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
unsetopt beep
bindkey -e

export EDITOR=nvim

# == Plugins ==

## zsh-completions
fpath+=$ZSH/plugins/zsh-completions/zsh-completions.plugin.zsh
fpath+=$ZSH/completions/_poetry


## zsh-autosuggestions
source $ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^ ' autosuggest-accept

## zsh-syntax-highlighting
source $ZSH/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

## auto-activate python virtual environments
source $ZSH/plugins/custom/venv-activate.sh

## fetch gitignore.io via gi
source $ZSH/plugins/custom/gitignore.io.sh

# == Remapts ==

alias vim=nvim
alias grep=rg

# == Scripts ==

CUSTOM_SCRIPTS=$HOME/scripts
alias note=$CUSTOM_SCRIPTS/edit_daily_note.sh
alias kk=$CUSTOM_SCRIPTS/kube.sh
alias kkw="$CUSTOM_SCRIPTS/kube.sh -w"
alias goodnight="$CUSTOM_SCRIPTS/goodnight.sh"
alias mkuid="python -c \"from uuid import uuid4; print(uuid4(), end='')\" | xclip -i -selection c"

# == P.S ==

## Clever history scroll
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

## Menu completion
zstyle ':completion:*' menu select

## Ctrl-arrow
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# == Plugin init ==

eval "$(starship init zsh)"
eval "$(mcfly init zsh)"

# The following lines were added by compinstall
zstyle :compinstall filename $ZSH
autoload -Uz compinit
compinit

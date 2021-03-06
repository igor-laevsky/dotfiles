[[ $- != *i* ]] && return

# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' ignore-parents parent pwd .. directory
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/igor/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000000
setopt inc_append_history autocd
unsetopt beep extendedglob nomatch notify share_history
bindkey -e
# End of lines configured by zsh-newuser-install

# Keep timestamps in the history file
setopt EXTENDED_HISTORY
# Remove duplicates
setopt HIST_IGNORE_ALL_DUPS
# Ask for typo correction
setopt CORRECT
# Powerfull prompt
setopt PROMPT_SUBST
# Consider slashes and dots as word separators
export WORDCHARS=''

autoload -Uz promptinit
promptinit

autoload -U colors
colors

setopt autopushd
unsetopt correct_all

bindkey '^[h' backward-kill-word


function _git_branch_name() {    
  git branch 2>/dev/null | awk '/^\*/ { print $2 }'
}
function _git_is_dirty() { 
  git diff --quiet 2> /dev/null || echo '*'
}

function _git_prompt {
  git status &> /dev/null
  if [[ "$?" == 0 ]]; then
    echo "%B(%F{blue}$(_git_branch_name)$(_git_is_dirty)%f)%b"
  fi
}
     
RPROMPT='$(_git_prompt)'
PS1='[%n:%B%F{red}%~%f%b]\$ '

function ec {
  local has_frame=$(emacsclient -n -e "(if (> (length (frame-list)) 1) 't)" 2>&1)
  if [ "${has_frame}" = "t" ]; then
    emacsclient -a "" -n "$@" &> /dev/null
  else
    emacsclient -a "" -c -n "$@" &> /dev/null
  fi

  i3-msg "[class=\"Emacs\"] focus" &> /dev/null
}

alias emacs=ec
alias ll='LC_COLLATE=C ls --color=auto -alGh --group-directories-first'
alias grep="grep --color"

export EDITOR=ec
export BURGAUR_FILE_MANAGER=emacs

# Posix time output
TIMEFMT=$'\nreal\t%*E\nuser\t%*U\nsys\t%*S'

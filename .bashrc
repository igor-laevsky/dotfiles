# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

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
alias ls='ls --color=auto -alGh --group-directories-first'
alias grep="grep --color"

export EDITOR=ec
export BURGAUR_FILE_MANAGER=emacs

export P4CONFIG=.p4config
export TERM="xterm-256color"
export P4EDITOR=ec

shopt -s histappend
export HISTCONTROL=ignoredups:erasedups
export PROMPT_COMMAND='history -a; echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
export HISTSIZE=10000
export HISTFILESIZE=999999999

export PS1="[\H:\[$(tput bold)\]\w\[$(tput sgr0)\]]$ "

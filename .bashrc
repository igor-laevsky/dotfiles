#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u:\w]\$ '

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

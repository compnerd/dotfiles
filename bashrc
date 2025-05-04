# .bashrc
# Saleem Abdulrasool <compnerd@compnerd.org>
# vim: set fmr={{{,}}} fdm=marker :

# {{{ ensure interactive mode
if [[ $- != *i* ]] ; then
  return
fi
# }}}

# {{{ shell options
shopt -s extglob
shopt -s cmdhist
shopt -s histappend
# }}}

# {{{ locale
eval unset ${!LC_*} LANG
export LANG=en_US.UTF-8
export LC_COLATE=C
# }}}

# {{{ core
ulimit -c 0
# }}}

# {{{ colours
case $(uname -s) in
Darwin|FreeBSD)
  export CLICOLOR=yes
  export LSCOLORS=Exfxcxdxbxegedabagacad
;;
esac

if type -p dircolors >/dev/null ; then
  eval $(dircolors -b $([[ -f /etc/DIR_COLORS ]] && echo "/etc/DIR_COLORS"))
fi
# }}}

# {{{ terminal
case "${TERM}" in
xterm*)
  ( infocmp xterm-256color &> /dev/null ) && export TERM=xterm-256color
;;
esac
# }}}

# {{{ alias
case $(uname -s) in
Darwin|FreeBSD)
  alias df='df -h'
  alias du='du -h'
  alias ls='ls -G'
;;
Linux)
  alias df='df --human-readable'
  alias du='du --human-readable'
  alias ls='ls --human-readable --color=auto'

  if type -p xclip >/dev/null ; then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
  fi
;;
OpenBSD)
  alias df='df -h'
  alias du='du -h'
  alias ls='ls -h'
;;
esac

alias grep="grep --directories=skip --color=auto --exclude-dir='.git' --exclude='.*.svn' --exclude='.*.sw?'"

alias ping='ping -c4'

alias info='info --vi-keys'

if type -p hilite >/dev/null ; then
  alias make='hilite make'
  alias scons='hilite scons'
fi
# }}}

# {{{ keybindings
set -o vi

bind Space:magic-space
bind C-p:reverse-search-history
bind C-n:forward-search-history

stty werase undef
bind C-w:unix-filename-rubout

# remap Caps Lock (0x3A) to Escape
if [[ ${TERM} == linux ]] ; then
  ( echo -e $(dumpkeys | grep -i keymaps ; echo \\nkeycode 58 = Escape) | loadkeys - ) > /dev/null 2>&1
fi

# disable control echo (e.g. ^C)
stty -ctlecho
# }}}

# {{{ prompt
_ps_retval_colour_f()
{
  if [[ ${1} -eq 0 ]] ; then
    echo -e "\033[01;34m"
  else
    echo -e "\033[01;31m"
  fi

  return ${1}
}

export PS1='\[\033[01;32m\]\u@\h \[\033[01;34m\]\w \[$(_ps_retval_colour_f $?)\]$ \[\033[00;00m\]'
# }}}

# {{{ history
export HISTCONTROL=ignoreboth:erasedups
export HISTFILE="${HOME}/.bash/.${HOSTNAME}-history"
export HISTIGNORE='bg:fg:history'
export HISTTIMEFORMAT='%F %T '
# }}}

# {{{ pager
export MANPAGER="vim +MANPAGER --not-a-term -"
# }}}

# {{{ per host configuration
if [[ -d "${HOME}/.bash" ]] ; then
  for file in "${HOME}/.bash"/* ; do
    if [[ -x "${file}" ]] ; then
      source "${file}"
    fi
  done
fi
# }}}


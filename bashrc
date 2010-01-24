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
export LANG=en_US.utf8
export LC_COLATE=C
# }}}

# {{{ core
ulimit -c 0
# }}}

# {{{ colours
eval $(dircolors -b $([[ -f /etc/DIR_COLORS ]] && echo "/etc/DIR_COLORS"))
# }}}

# {{{ terminal
case "${TERM}" in
   xterm*)
      ( infocmp xterm-256color &> /dev/null ) && export TERM=xterm-256color
   ;;
esac
# }}}

# {{{ alias
alias cd..='cd ..'

alias ls='ls -h --color=auto'
alias grep='grep -d skip --color=auto'

alias df='df -h'
alias du='du -h'

alias ping='ping -c4'

alias info='info --vi-keys'

if type -p hilite &> /dev/null ; then
   alias make='hilite make'
   alias scons='hilite scons'
fi
# }}}

# {{{ keybindings
set -o vi

bind Space:magic-space
bind C-p:reverse-search-history

# remap Caps Lock (0x3A) to Escape
if [[ ${TERM} == linux ]] ; then
   ( echo -e $(dumpkeys | grep -i keymaps ; echo \\nkeycode 58 = Escape) | loadkeys - ) > /dev/null 2>&1
fi
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
export HISTTIMEFORMAT='%F %T '
export HISTCONTROL=erasedups
export HISTFILE="${HOME}/.bash/.history"
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


# config.fish
# Copyright © 2014 Saleem Abdulrasool <compnerd@compnerd.org>
# vim: set et fdm=marker fmr={{{,}}} ft=fish sw=2 sts=2 ts=8 :

# {{{ fish shell specific
set fish_greeting ""
# }}}

# {{{ locale
set -x LANG en_US.utf-8
set -x LC_COLATE C
# }}}

# {{{ colours
switch (uname -s)
case Darwin
  set -x CLICOLOR yes
  set -x LSCOLORS Exfxcxdxbxegedabagacad

  alias df='df -h'
  alias du='du -h'
  alias ls='ls -G'
case '*'
  alias df='df --human-readable'
  alias du='du --human-readable'
  alias ls='ls --human-readable --color=auto'
end
# }}}

# {{{ GNU environment options
set -x GREP_OPTIONS "--directories=skip --color=auto --exclude='.*.sw*' --exclude-dir='.git' --exclude-dir='.svn'"
# }}}

# {{{ alises
alias cd..='cd ..'
alias info='invo --vi-keys'
# }}}

# {{{ prompt
function fish_prompt
  set -l ec $status

  if not set -q __fish_prompt_hostname
    set -g __fish_prompt_hostname ( hostname )
  end

  echo -n -s (set_color --bold green) $USER@$__fish_prompt_hostname (set_color normal)
  echo -n " "
  echo -n -s (set_color --bold blue) (basename $PWD) (set_color normal)
  echo -n " "
  if test $ec -ne 0
    echo -n -s (set_color --bold red) \$ (set_color normal)
  else
    echo -n -s (set_color --bold blue) \$ (set_color normal)
  end
  echo -n " "
end
# }}}


# .zshrc
# Saleem Abdulrasool <compnerd@compnerd.org>
# vim: set fmr={{{,}}} fdm=marker nowrap :

# {{{ interactive mode configuration only
# }}}

# {{{ shell options
setopt ALWAYS_TO_END            # goto end of word on completion
setopt AUTO_CD                  # directoy command does cd
setopt AUTO_PARAM_SLASH         # append trailing slash on directory completions
setopt AUTO_PUSHD               # cd uses directory stack
setopt BASH_AUTO_LIST           # list completions on second tab
setopt CDABLE_VARS              # cd var works if $var is a directory
setopt CHASE_DOTS               # resolve .. in cd
setopt CHASE_LINKS              # resolve symbolic links in cd
setopt COMPLETE_IN_WORD         # completion works inside words
setopt CORRECT                  # correct spelling of commands
setopt EXTENDED_GLOB            # use zsh globbing extensions
setopt FLOW_CONTROL             # disable job control sequences in the editor
setopt INTERACTIVE_COMMENTS     # allow comments in interactive shells
setopt LIST_ROWS_FIRST          # list completions across
setopt MAGIC_EQUAL_SUBST        # special expansion after all =
setopt PATH_DIRS                # path search commands even with slashes
setopt PUSHD_SILENT             # make pushd quiet
setopt PUSHD_IGNORE_DUPS        # make directory stack unique
setopt PROMPT_SUBST             # allow substitutions in the prompt
setopt SH_WORD_SPLIT            # split non-array variables

unsetopt CASE_GLOB              # case-insensitive globbing
unsetopt NO_MATCH               # dont error on no glob matches
# }}}

# {{{ extensions
if [[ ${ZSH_VERSION//.} -gt 420 ]] ; then
  autoload -Uz url-quote-magic
  zle -N self-insert url-quote-magic
fi

# TODO(compnerd) figure out which version first included edit-command-line
autoload -Uz edit-command-line
zle -N edit-command-line
# }}}

# {{{ locale
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

# {{{ aliases
alias cd..='cd ..'

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

alias grep="grep --directories=skip --color=auto --exclude-dir='.git' --exclude-dir='.svn' --exclude='.*.sw?'"

alias ping='ping -c4'

alias info='info --vi-keys'

if type -p hilite >/dev/null ; then
  alias make='hilite make'
  alias scons='hilite scons'
fi

[[ -n "$(type -p time)" ]] && alias time='command time'

alias cp='nocorrect cp'
alias mv='nocorrect mv'
alias rm='nocorrect rm -ir'
alias mkdir='nocorrect mkdir'
# }}}

# {{{ keybindings
bindkey -v

bindkey ' ' magic-space

bindkey -M vicmd '' redo
bindkey -M vicmd 'u' undo
bindkey -M vicmd 'v' edit-command-line
bindkey -M vicmd 'ga' what-cursor-position

bindkey -M viins '' history-incremental-search-backward
bindkey -M viins '' history-incremental-search-forward

# remap Caps Lock (0x3A) to Escape
if [[ ${TERM} == linux ]] ; then
  ( echo -e $(dumpkeys | grep -i keymaps ; echo \\nkeycode 58 = Escape) | loadkeys - ) > /dev/null 2>&1
fi
# }}}

# {{{ prompt
PROMPT='%B%F{green}%n@%m %F{blue}%1~ %(?..%F{red})%(!.#.$) %f%b'
# }}}

# {{{ history
export HISTSIZE=1000
export SAVEHIST=1000
export HISTFILE="${HOME}/.zsh/.${HOST}-history"

setopt HIST_FCNTL_LOCK          # use fcntl to perform file locking
setopt HIST_IGNORE_ALL_DUPS     # ignore all duplicates in history
setopt HIST_IGNORE_SPACE        # elide space prefixed commands from history
setopt HIST_REDUCE_BLANKS       # remove superfluous blanks in the commands
setopt INC_APPEND_HISTORY       # incremental appending to history
setopt SHARE_HISTORY            # merge saved history and command history

unsetopt HIST_BEEP
unsetopt EXTENDED_HISTORY
# }}}

# {{{ completion
autoload -Uz compinit
compinit -d "${HOME}/.zsh/.${HOST}-zcompdump"

# {{{ caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${HOME}/.zsh/.${HOST}-zcompcache"
# }}}

# {{{ colourise output
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# }}}

# {{{ completion suggestion order
zstyle ':completion:*' completer _expand _complete _prefix _correct _match _approximate
# }}}

# {{{ message formatting
zstyle ':completion:*:descriptions' format '%B%F{yellow} -- %d -- %f%b'
zstyle ':completion:*:messages' format '%B%F{blue} -- %d -- %f%b'
zstyle ':completion:*:warnings' format '%B%F{red} -- No Matches Found -- %f%b'
# }}}

# {{{ grouping
zstyle ':completion:*' group-name ''
zstyle ':completion:*:matches' group 'yes'
# }}}

# {{{ ignored completion
# commands that are not present
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# prevent parameter resuggestion
zstyle ':completion:*:ls:*' ignore-line yes
zstyle ':completion:*:rm:*' ignore-line yes
zstyle ':completion:*:scp:*' ignore-line yes
zstyle ':completion:*:diff:*' ignore-line yes
# }}}

# {{{ jobs
zstyle ':completion:*:jobs' numbers true
# }}}

# {{{ man pages
zstyle ':completion:*:manuals:*' insert-sections true
zstyle ':completion:*:manuals:*' separate-sections true
# }}}

# {{{ matching
# case insensitive, partial matching, substitution
zstyle ':completion:*' matcher-list 'm:{A-Z}={a-z}' 'm:{a-z}={A-Z}' 'r:|[-._]=* r:|=*' 'l:|=* r:|=*' '+l:|=*'
# }}}

# {{{ menu
zstyle ':completion:*' menu select
# }}}

# {{{ completion options
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-descriptions 'yes'
# }}}

# {{{ process management
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*:processes' command 'ps -U '${USERNAME}' -o pid,cmd | sed "/ps -U '${USERNAME}' -o pid,cmd/d"'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=31;31'

zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:*:killall:*:processes-names' command 'ps -U '${USERNAME}' -o cmd'

zstyle ':completion:*:processes-names' command 'ps axho command'
# }}}

# {{{ user completion
zstyle -e ':completion:*' users "reply=( root '${USERNAME}' )"
# }}}

# {{{ git completion
__git_files() { _wanted files expl 'local files' _files ; }
# }}}
# }}}

# {{{ watch
watch=( all )
export LOGCHECK=30
export WATCHFMT=$'\e[01;36m'" -- %n@%m %a %l from %M --"$'\e[00;00m'
# }}}

# {{{ directory hashes
if [[ -d "${HOME}/SourceCache" ]] ; then
  hash -d SourceCache="${HOME}/SourceCache"

  for dir in "${HOME}"/SourceCache/*(N-/) ; do
    hash -d $(basename "${dir}")="${dir}"
  done
fi
# }}}

# {{{ per host configuration
if [[ -d "${HOME}/.zsh" ]] ; then
  for file in "${HOME}"/.zsh/*(N.x:t) ; do
    source "${HOME}/.zsh/${file}"
  done
fi
# }}}


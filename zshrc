# .zshrc
# Saleem Abdulrasool <compnerd@compnerd.org>
# vim: set fmr={{{,}}} fdm=marker nowrap :

# {{{ interactive mode configuration only
# }}}

# {{{ shell options
setopt ALWAYS_TO_END          # goto end of word on completion
setopt AUTO_CD                # directoy command does cd
setopt AUTO_PUSHD             # cd uses directory stack
setopt BASH_AUTO_LIST         # list completions on second tab
setopt CDABLE_VARS            # cd var works if $var is a directory
setopt CHASE_DOTS             # resolve .. in cd
setopt CHASE_LINKS            # resolve symbolic links in cd
setopt COMPLETE_IN_WORD       # completion works inside words
setopt CORRECT                # correct spelling of commands
setopt EXTENDED_GLOB          # use zsh globbing extensions
setopt INTERACTIVE_COMMENTS   # allow comments in interactive shells
setopt LIST_ROWS_FIRST        # list completions across
setopt MAGIC_EQUAL_SUBST      # special expansion after all =
setopt PUSHD_SILENT           # make pushd quiet
setopt PROMPT_SUBST           # allow substitutions in the prompt
setopt SH_WORD_SPLIT          # split non-array variables

unsetopt NO_MATCH             # dont error on no glob matches
# }}}

# {{{ extensions
if [[ ${ZSH_VERSION//.} -gt 420 ]] ; then
   autoload -Uz url-quote-magic
   zle -N self-insert url-quote-magic
fi
# }}}

# {{{ locale
# }}}

# {{{ core
ulimit -c 0
# }}}

# {{{ colours
if $(type dircolors >/dev/null) ; then
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

# {{{ GNU environment options
export GREP_OPTIONS="--directories=skip --color=auto --exclude='.*.sw*'"
# }}}

# {{{ aliases
alias cd..='cd ..'

case $(uname -s) in
Darwin)
    alias ls='ls -G'
    ;;
*)
    alias ls='ls --human-readable --color=auto'
    ;;
esac

alias df='df --human-readable'
alias du='du --human-readable'

alias ping='ping -c4'

alias info='info --vi-keys'

if type -p hilite &> /dev/null ; then
   alias make='hilite make'
   alias scons='hilite scons'
fi

( type -p time &> /dev/null ) && alias time='command time'

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
PROMPT=$'%{\e[01;32m%}%n@%m %{\e[01;34m%}%1~ %(?..%{\e[01;31m%})%(!.#.$) %{\e[00;00m%}'
# }}}

# {{{ history
export HISTSIZE=1000
export SAVEHIST=1000
export HISTFILE="${HOME}/.zsh/.${HOST}-history"

setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS

unsetopt HIST_BEEP
unsetopt EXTENDED_HISTORY
# }}}

# {{{ completion
autoload -Uz compinit ; compinit -d "${HOME}/.zsh/.${HOST}-zcompdump"

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

# {{{ descriptions
zstyle ':completion:*:messages' format $'\e[01;35m -- %d -- \e[00;00m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found -- \e[00;00m'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d -- \e[00;00m'
# }}}

# {{{ grouping
zstyle ':completion:*' group-name ''
zstyle ':completion:*:matches' group 'yes'
# }}}

# {{{ ignored completion
# commands that are not present
zstyle ':completion:*:functions' ignored-patterns '_*'

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
zstyle ':completion:*' menu select=1
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
export WATCHFMT=$'\e[01;36m'" -- %n@%m has %(a.Logged In.Logged out) --"$'\e[00;00m'
# }}}

# {{{ directory hashes
if [[ -d "${HOME}/sandbox" ]] ; then
   hash -d sandbox="${HOME}/sandbox"
fi

if [[ -d "${HOME}/work" ]] ; then
   hash -d work="${HOME}/work"

   for dir in "${HOME}"/work/*(N-/) ; do
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


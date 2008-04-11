# .zshrc
# Saleem Abdulrasool <compnerd@compnerd.org>
# vim:set nowrap:

autoload -Uz compinit; compinit -d "${HOME}/.zsh/.zcompdump"

autoload -Uz age
autoload -Uz zmv

if [[ ${ZSH_VERSION//.} -gt 420 ]] ; then
   autoload -Uz url-quote-magic
   zle -N self-insert url-quote-magic
fi

# disable core dumps
limit coredumpsize 0

# clear on exit
trap clear 0

# shell options
setopt AUTO_CD             # directoy command does cd
setopt CORRECT             # correct spelling of commands
setopt AUTO_PUSHD          # cd uses directory stack
setopt CHASE_DOTS          # resolve .. in cd
setopt CHASE_LINKS         # resolve symbolic links in cd
setopt CDABLE_VARS         # cd var works if $var is a directory
setopt PUSHD_SILENT        # make pushd quiet
setopt ALWAYS_TO_END       # goto end of word on completion
setopt EXTENDED_GLOB       # use zsh globbing extensions
setopt SH_WORD_SPLIT       # split non-array variables
setopt BASH_AUTO_LIST      # list completions on second tab
setopt LIST_ROWS_FIRST     # list completions across
setopt COMPLETE_IN_WORD    # completion works inside words
setopt MAGIC_EQUAL_SUBST   # special expansion after all =

unsetopt BEEP              # stop beeping!
unsetopt LIST_BEEP         # seriously, stop beeping!

# history
export HISTSIZE=1000
export SAVEHIST=1000
export HISTFILE="${HOME}/.zsh/.history"

setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS

unsetopt HIST_BEEP
unsetopt EXTENDED_HISTORY

# colors
[[ -f /etc/DIR_COLORS ]] && eval $(dircolors -b /etc/DIR_COLORS)
export ZLSCOLORS="${LS_COLORS}"

# aliases
alias cd..='cd ..'

alias ls='ls -h --color=auto'
alias grep='grep -d skip --color=auto'

alias df='df -h'
alias du='du -h'

alias ping='ping -c4'

alias cp='nocorrect cp'
alias mv='nocorrect mv'
alias rm='nocorrect rm -ir'
alias mkdir='nocorrect mkdir'

alias :q='exit'
alias :wq='exit'

# Prefer sys-process/time over the builtin
[[ -x =time ]] && alias time='command time'

# keybindings
set -o vi

bindkey ' ' magic-space

bindkey -M vicmd '' redo
bindkey -M vicmd 'u' undo
bindkey -M vicmd 'ga' what-cursor-position

bindkey -M viins '' history-incremental-search-backward
bindkey -M viins '' history-incremental-search-forward

# prompt
if [[ -z ${SSH_TTY} ]] ; then
   PS1=$'%{\e[01;32m%}%n@%m %{\e[01;34m%}%1~ %(?..%{\e[01;31m%})%(!.#.$) %{\e[00;00m%}'
else
   PS1=$'%{\e[01;36m%}%n %(?..%{\e[01;31m%})%(!.#.$) %{\e[00;00m%}'
   RPROMPT=$'%{\e[01;33m%}%m %{\e[01;32m%}%1~%{\e[00;00m%}'
fi

# terminal titles
case ${TERM} in
   screen*)
      precmd() { print -Pn "\ek%n@%m ${1%% *}\e\\" }
      preexec() { print -Pn "\ek%n@%m ${1%% *}\e\\" }
   ;;
   GNOME|*xterm*|rxvt*|(dt|k|E|a)term)
      precmd() { print -Pn "\e]2;%n@%m ${1%% *}\a" }
      preexec() { print -Pn "\e]2;%n@%m ${1%% *}\a" }
   ;;
esac

# completion menu
zstyle ':completion:*' menu select=1

# group matches
zstyle ':completion:*' group-name ''
zstyle ':completion:*:matches' group 'yes'

# colors on completions
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# users are all useless, ignore them always
zstyle -e ':completion:*' users "reply=( root '${USERNAME}' )"

# caching good
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${HOME}/.zsh/.${HOST}-cache"

# descriptions
zstyle ':completion:*:messages' format $'\e[01;35m -- %d -- \e[00;00m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found -- \e[00;00m'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d -- \e[00;00m'

# kill/killall menu and general process listing
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*:processes' command 'ps -U $USERNAME -o pid,cmd | sed "/ps -U '${USERNAME}' -o pid,cmd/d"'

zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:*:killall:*:processes-names' command 'ps -U '${USERNAME}' -o cmd'

zstyle ':completion:*:processes-names' command 'ps axho command'

# case insensitivity, partial matching, substitution
zstyle ':completion:*' matcher-list 'm:{A-Z}={a-z}' 'm:{a-z}={A-Z}' 'r:|[-._]=* r:|=*' 'l:|=* r:|=*' '+l:|=*'

# compctl should die
zstyle ':completion:*' use-compctl false

# dont suggest the first parameter again
zstyle ':completion:*:ls:*' ignore-line yes
zstyle ':completion:*:rm:*' ignore-line yes
zstyle ':completion:*:scp:*' ignore-line yes
zstyle ':completion:*:diff:*' ignore-line yes

# directory hashes
if [[ -d "${HOME}/sandbox" ]] ; then
   hash -d sandbox="${HOME}/sandbox"
fi

if [[ -d "${HOME}/work" ]] ; then
   hash -d work="$HOME/work"

   for dir in $(ls -d "${HOME}"/work/*(/D)) ; do
      hash -d $(basename "${dir}")="${dir}"
   done
fi

# extras
if [[ -d "${HOME}/.zsh" ]] ; then
   for file in "${HOME}"/.zsh/*(N.x:t) ; do
      source "${HOME}/.zsh/${file}"
   done
fi

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# disable stupid C-s / C-q stuff
stty -ixon

if [[ -r ~/.private/env.sh ]] ; then
  source ~/.private/env.sh
fi

export LC_LANG=$LANG
# custom scripts and tools
export PATH=$HOME/.DotFiles/bins:$PATH
export PATH=/usr/lib/go/bin:$PATH
export PATH=~/Dropbox/Scripts:$PATH

# go setup
export GOPATH=~/proj/:$GOPATH
export PATH=$GOPATH/bin:$PATH

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export LESS="-RSM~gIsw"
export LSCOLORS="Gxfxcxdxbxegedabagacad"

# append to the history file, don't overwrite it
HISTCONTROL=ignoreboth
export WORDCHARS=''
shopt -s histappend

# sync history between different sessions, a bit hacky, wish it worked like
# in ZSH
HISTSIZE=90000000
HISTFILESIZE=$HISTSIZE
HISTCONTROL=ignorespace:ignoredups

function history() {
  _bash_history_sync
  builtin history "$@"
}

# "callback" for use after running a command
function _bash_history_sync() {
  builtin history -a
  HISTFILESIZE=$HISTSIZE
  builtin history -c
  builtin history -r
}

# nice things
shopt -s checkwinsize
shopt -s globstar
shopt -s autocd # type 'dir' instead 'cd dir'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls --color -alF'
alias la='ls --color -A'
alias l='ls --color -CF'
alias ls-l=ll
alias b=bundle
alias be='bundle exec '
alias r='rails' # sigh
alias s='bundle exec rspec -f n'
alias rs='bundle exec rspec spec -f n -c'
alias ffs='bundle exec rspec -f n 2>/dev/null'
alias rightsplit='tmux splitw -h -p 33  '

export EDITOR=vim

# make vim a pager
function vless() {
  local less_path=`find $(vim --version | awk ' /fall-back/ { gsub(/\"/,"",$NF); print $NF }'  )/ -name less.sh`
  if [[ -z $less_path ]]; then
    echo 'less.sh not found'
    exit 1
  fi
  $less_path $*
}
alias vl=vless
alias v=vim


# edit modified files in vim
# use vim as man viewer
function viman() {
env PAGER="/bin/sh -c \"unset PAGER;col -b -x | \
  vim -R -c 'set ft=man nomod nolist nonumber' -c 'map q :q<CR>' \
  -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
  -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\"" man $*
}


function Mutt() {
  TERM=screen-256color mutt -e "source ~/.private/mutt_$1"
}


# useful as guard replacement (ish)
# Usage:
#    Loop grunt test:all
# or
#    DELAY=10 Loop grunt test:browser
function Loop() {
  if [[ -z "$DELAY" ]] ; then
    DELAY=7
  fi

  echo "Loop time $DELAY sec"

  while true
  do
    $*
    sleep $DELAY
  done
}

# print given color, need reset after that!
function Color() {
  echo "\[$(tput setaf $1)\]"
}
function ResetColor() {
  echo "\[$(tput sgr0)\]"
}

function thePrompt() {
  local last_status=$?
  local reset=$(ResetColor)

  if [[ "$last_status" != "0" ]]; then
    last_status="$(Color 5)✘$reset"
  else
    last_status="$(Color 2)✔$reset"
  fi


  local currentDir="$(Color 6)\w$reset"
  local currentBranch="$(Color 4)$(git cb)$reset"
  # local sigil="$(Color 1)➜$reset"
  local sigil="$(Color 1):$reset"
  echo "$last_status $currentDir $currentBranch $sigil "
}

# prompt command gets called before any other command
# so this refreshes the git branch and other dynamic stuff
PROMPT_COMMAND='PS1="$(thePrompt)"'

# plug-in the history hack
PROMPT_COMMAND="$PROMPT_COMMAND ; _bash_history_sync "
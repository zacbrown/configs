export LC_CTYPE="utf-8"

# Custom bash prompt via kirsle.net/wizards/ps1.html
export PS1="\[$(tput bold)\]\[$(tput setaf 5)\]\t \[$(tput setaf 2)\]\u@\h: \[$(tput setaf 4)\]\w\[$(tput setaf 7)\] > \[$(tput sgr0)\]"
export PATH=/usr/local/bin:$PATH:$HOME/bin

export PATH=$PATH:/Applications/Epsilon.app/Contents/bin

export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/Code/bin

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

alias ssh-rufius='ssh rufius.xen.prgmr.com'
alias ssh-prgmr='ssh rufius@rufius.console.xen.prgmr.com'
#alias ec='/Applications/Emacs.app/Contents/MacOS/bin/emacsclient --no-wait -c'
#alias et='/Applications/Emacs.app/Contents/MacOS/bin/emacsclient --no-wait -t'
alias te=terminal-epsilon
alias e=epsilon
alias ea='epsilon -add'

alias hibernate='sudo pmset -a hibernatemode 25'
alias sleepsafe='sudo pmset -a destroyfvkeyonstandby 1 hibernatemode 25'
alias sleepfast='sudo pmset -a hibernatemode 0'
alias sleepdefault='sudo pmset -a hibernatemode 3'

#alias ghci='stack ghci'
#alias ghc='stack ghc'

source $HOME/.profile

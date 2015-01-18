
#/usr/local/bin/emacs --daemon

alias ls='colorls -G'

alias enw='emacsclient -nw'
alias e='emacsclient -n -a emacs'
#alias nano='emacs -nw'
alias ssh-rufius='ssh rufius.xen.prgmr.com'

PS1='\[\e[1;35m\]\t\[\e[1;32m\] \u@\h: \[\e[1;34m\]\w \[\e[1;37m\]>\[\e[1;37m\] '
TERM=wsvt25

export PS1 TERM

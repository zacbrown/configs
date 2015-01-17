# $OpenBSD: dot.profile,v 1.4 2005/02/16 06:56:57 matthieu Exp $
#
# sh/ksh initialization

bind '^[[3'=prefix-2
bind '^[[3~'=delete-char-forward

PS1='\[\e[1;35m\]\t\[\e[1;32m\] \u@\h: \[\e[1;34m\]\w \[\e[1;37m\]>\[\e[1;37m\] '
TERM=wsvt25

#/usr/local/bin/emacs --daemon

alias ls='colorls -G'
alias enw='emacsclient -nw -t'
alias e='emacsclient -t -c'
#alias nano='emacs -nw'

PKG_PATH=http://ftp.usa.openbsd.org/pub/OpenBSD/$(uname -r)/packages/$(uname -m)/
PATH=$HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games:.
export PATH HOME TERM PKG_PATH PS1 TERM

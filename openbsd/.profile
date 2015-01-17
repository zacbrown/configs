# $OpenBSD: dot.profile,v 1.4 2005/02/16 06:56:57 matthieu Exp $
#
# sh/ksh initialization

bind '^[[3'=prefix-2
bind '^[[3~'=delete-char-forward

ENV=${HOME}/.kshrc

PKG_PATH=http://ftp.usa.openbsd.org/pub/OpenBSD/$(uname -r)/packages/$(uname -m)/
PATH=$HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games:.
export PATH HOME TERM PKG_PATH ENV

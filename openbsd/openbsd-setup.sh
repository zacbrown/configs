#!/bin/ksh

echo 'Package Installation'
pkg_add -i emacs
pkg_add -i xfce
pkg_add -i xfce-extras
pkg_add -i bash
pkg_add -i toad
pkg_add -i firefox
pkg_add -i nano
pkg_add -i llvm
pkg_add -i git
pkg_add -i git-x11
pkg_add -i evince
pkg_add -i colorls

curl -o openup.sh https://stable.mtier.org/openup
chmod +x openup.sh
./openup.sh -K

chsh -s /usr/local/bin/bash zbrown

# vim : set ft=make noet sw=8 sts=8 ts=8 :
# Copyright © 2011 Saleem Abdulrasool <compnerd@compnerd.org>

DOTFILES    := bashrc bash_profile gitconfig gitignore gvimrc tmux.conf vimrc zshrc

GITHUB_USER ?= compnerd
GITHUB_REPO ?= dotfiles

GITHUB      := https://github.com/$(GITHUB_USER)/$(GITHUB_REPO)/raw/master/$(strip $(1))

SYSTEM      := $(shell uname -s)

all : $(DOTFILES) ;

$(HOME)/.% : %
ifeq ($(SYSTEM),$(filter $(SYSTEM),OpenBSD FreeBSD NetBSD DragonFlyBSD))
	install -C -b -B~ -m 0644 $? $@
else
	install --preserve-timestamps --backup --mode 0644 $? $@
endif

install-% : $(HOME)/.% ;

install : $(foreach dotfile, $(DOTFILES), install-$(dotfile)) ;

.PRECIOUS : $(HOME)/.%

.DELETE_ON_ERROR :

.DEFAULT :
	wget --no-check-certificate --quiet --continue $(call GITHUB, $@) --output-document $@


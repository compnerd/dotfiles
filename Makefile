# vim : set ft=make noet sw=8 sts=8 ts=8 :
# Copyright © 2011 Saleem Abdulrasool <compnerd@compnerd.org>

DOTFILES    := bashrc bash_profile gitconfig gvimrc tmux.conf vimrc zshrc

GITHUB_USER ?= compnerd
GITHUB_REPO ?= dotfiles

GITHUB      := https://github.com/$(GITHUB_USER)/$(GITHUB_REPO)/raw/master/$(strip $(1))

all : $(DOTFILES) ;

$(HOME)/.% : %
	install --preserve-timestamps --backup --mode 0644 $? $@

install-% : $(HOME)/.% ;

install : $(foreach dotfile, $(DOTFILES), install-$(dotfile)) ;

.PRECIOUS : $(HOME)/.%

.DELETE_ON_ERROR :

.DEFAULT :
	wget --no-check-certificate --quiet --continue $(call GITHUB, $@) --output-document $@


# https://stackoverflow.com/a/2547973/2411520
# https://stackoverflow.com/a/73450593/2411520
# dotfiles is relative to HOME
dotfiles := $(patsubst %/,%,$(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
dotfiles := $(subst $(HOME)/,,$(dotfiles))

homedir = ackrc \
	  bash_aliases \
	  bash_completion \
	  bash_completion.d \
	  cvsignore \
	  cvsrc \
	  inputrc \
	  lessfilter \
	  minttyrc \
	  tidyrc

linux_homedir = dpkg.cfg \
	        tmux.conf \
	        Xmodmap

dot_config = gdb \
	     git

linux_dot_config = gtk-3.0

unison = am.prf \
	 default.inc \
	 portable.prf

# ~/snap/firefox/common/
firefox = mime.types

profiles = bashrc \
	   profile

# --------------------------- Windows --------------------------------------------

ifeq ($(OS),Windows_NT)
   symlink_dir  = cmd //c "mklink /d $(2) $(1)"
   symlink_file = cmd //c "mklink    $(2) $(1)"
else
   homedir := $(homedir) $(linux_homedir)
   dot_config := $(dot_config) $(linux_dot_config)
   symlink_dir  = ln -s $(1) $(2)
   symlink_file = ln -s $(1) $(2)
endif

.PHONY: all
all: $(homedir) \
     $(dot_config) \
     $(unison) \
     $(firefox) \
     $(profiles)

.PHONY: $(homedir)
$(homedir):
	@rm -f $(HOME)/.$@
	@$(call symlink_file, $(dotfiles)/$@, $(HOME)/.$@)
	@ls -l --color $(HOME)/.$@

.PHONY: $(dot_config)
$(dot_config):
	@mkdir -p $(HOME)/.config
	@rm -f $(HOME)/.config/$@
	@$(call symlink_dir, ../$(dotfiles)/$@, $(HOME)/.config/$@)
	@ls -ld --color $(HOME)/.config/$@

.PHONY: $(unison)
$(unison):
	@mkdir -p $(HOME)/.unison
	@rm -f $(HOME)/.unison/$@
	@$(call symlink_file, ../$(dotfiles)/unison/$@, $(HOME)/.unison/$@)
	@ls -ld --color $(HOME)/.unison/$@

.PHONY: $(firefox)
$(firefox):
	@if [ -d $(HOME)/snap/firefox/common ]; then \
	    rm -f $(HOME)/snap/firefox/common/$@; \
	    $(call symlink_file, $(HOME)/$(dotfiles)/firefox/$@, $(HOME)/snap/firefox/common/$@); \
	    ls -ld --color $(HOME)/snap/firefox/common/$@; \
	 fi

.PHONY: $(profiles)
$(profiles):
	@touch $(HOME)/.$@
	@if ! grep -q "$(dotfiles)/$@" $(HOME)/.$@; then \
	    printf ". $(dotfiles)/$@ || true\n\n" >> $(HOME)/.$@; \
	 fi
	@grep -H "$(dotfiles)/$@" $(HOME)/.$@


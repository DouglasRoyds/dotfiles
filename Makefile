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
	  dpkg.cfg \
	  inputrc \
	  lessfilter \
	  minttyrc \
	  tidyrc \
	  tmux.conf \
	  Xmodmap

dot_config = gdb \
	     git \
	     gtk-3.0

unison = am.prf \
	 default.inc \
	 portable.prf

# ~/snap/firefox/common/
firefox = mime.types

profiles = bashrc \
	   profile

ifeq ($(OS),Windows_NT)
   $(info Manually symlink a subset of:)
   $(info home dir: $(homedir))
   $(info .config/: $(dot_config))
   $(info .unison/: $(unison))
   $(info Source these files from .bashrc and .profile:)
   $(info $(profiles))
   $(error Windows installation using this Makefile not supported)
endif

.PHONY: all
all: $(homedir) \
     $(dot_config) \
     $(unison) \
     $(firefox) \
     $(profiles)

.PHONY: $(homedir)
$(homedir):
	@ln -snf $(dotfiles)/$@ $(HOME)/.$@
	@ls -l --color $(HOME)/.$@

.PHONY: $(dot_config)
$(dot_config):
	@mkdir -p $(HOME)/.config
	@ln -snf ../$(dotfiles)/$@ $(HOME)/.config/$@
	@ls -ld --color $(HOME)/.config/$@

.PHONY: $(unison)
$(unison):
	@mkdir -p $(HOME)/.unison
	@ln -snf ../$(dotfiles)/unison/$@ $(HOME)/.unison/$@
	@ls -ld --color $(HOME)/.unison/$@

.PHONY: $(firefox)
$(firefox):
	@if [ -d $(HOME)/snap/firefox/common ]; then \
	    ln -snf $(HOME)/$(dotfiles)/firefox/$@ $(HOME)/snap/firefox/common/$@; \
	    ls -ld --color $(HOME)/snap/firefox/common/$@; \
	 fi

.PHONY: $(profiles)
$(profiles):
	@if ! grep -q "$(dotfiles)/$@" $(HOME)/.$@; then \
	    printf ". $(dotfiles)/$@ || true\n\n" >> $(HOME)/.$@; \
	 fi
	@grep -H "$(dotfiles)/$@" $(HOME)/.$@


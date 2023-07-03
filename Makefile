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

ifeq ($(OS),Windows_NT)
   $(info Manually symlink a subset of:)
   $(info home dir: $(homedir))
   $(info .config/: $(dot_config))
   $(info .unison/: $(unison))
   $(info Source these files from .bashrc and .profile:)
   $(info $(profiles))
   $(error Windows installation using this Makefile not supported)
else
   homedir := $(homedir) $(linux_homedir)
   dot_config := $(dot_config) $(linux_dot_config)
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
	@ln -s $(dotfiles)/$@ $(HOME)/.$@
	@ls -l --color $(HOME)/.$@

.PHONY: $(dot_config)
$(dot_config):
	@mkdir -p $(HOME)/.config
	@rm -f $(HOME)/.config/$@
	@ln -s ../$(dotfiles)/$@ $(HOME)/.config/$@
	@ls -ld --color $(HOME)/.config/$@

.PHONY: $(unison)
$(unison):
	@mkdir -p $(HOME)/.unison
	@rm -f $(HOME)/.unison/$@
	@ln -s ../$(dotfiles)/unison/$@ $(HOME)/.unison/$@
	@ls -ld --color $(HOME)/.unison/$@

.PHONY: $(firefox)
$(firefox):
	@if [ -d $(HOME)/snap/firefox/common ]; then \
	    rm -f $(HOME)/snap/firefox/common/$@; \
	    ln -s $(HOME)/$(dotfiles)/firefox/$@ $(HOME)/snap/firefox/common/$@; \
	    ls -ld --color $(HOME)/snap/firefox/common/$@; \
	 fi

.PHONY: $(profiles)
$(profiles):
	@touch $(HOME)/.$@
	@if ! grep -q "$(dotfiles)/$@" $(HOME)/.$@; then \
	    printf ". $(dotfiles)/$@ || true\n\n" >> $(HOME)/.$@; \
	 fi
	@grep -H "$(dotfiles)/$@" $(HOME)/.$@


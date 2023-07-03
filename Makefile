# https://stackoverflow.com/a/2547973/2411520
# https://stackoverflow.com/a/73450593/2411520
# dotfiles is relative to HOME
dotfiles := $(patsubst %/,%,$(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
dotfiles := $(subst $(HOME)/,,$(dotfiles))

homedir = ackrc \
	  bash_aliases \
	  bash_completion \
	  cvsignore \
	  cvsrc \
	  inputrc \
	  lessfilter \
	  minttyrc \
	  tidyrc

linux_homedir = bash_completion.d \
                dpkg.cfg \
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
   HOME := $(subst $() ,/,$(wordlist 1,3,$(subst /, ,$(dotfiles))))
   dotfiles := $(subst $(HOME)/,,$(dotfiles))
   target = $(subst /,\,$(1))
   link   = $(subst /,\,$(2))
   symlink_dir  = cmd //c "mklink /d $(link) $(target)"
   symlink_file = cmd //c "mklink    $(link) $(target)"
else
   homedir := $(homedir) $(linux_homedir)
   dot_config := $(dot_config) $(linux_dot_config)
   symlink_dir  = ln -s $(1) $(2)
   symlink_file = ln -s $(1) $(2)
endif

# --------------------------- usage ----------------------------------------------

define newline


endef

define usage
Symlinks dotfiles into the HOME directory:

 $(foreach file,$(homedir),  $$HOME/.$(file) -> workspace/dotfiles/$(file)$(newline))
 $(foreach dir,$(dot_config),  $$HOME/.config/$(dir) -> ../workspace/dotfiles/$(dir)/$(newline))
 $(foreach file,$(unison),  $$HOME/.unison/$(file) -> ../workspace/dotfiles/unison/$(file)$(newline))
 $(foreach file,$(firefox),  $$HOME/snap/firefox/common/$(file) -> ~/workspace/dotfiles/firefox/$(file)$(newline))

Sources bashrc and profile from .bashrc and .profile respectively:
   
   . workspace/dotfiles/profile || true
   . workspace/dotfiles/bashrc || true

Install:

   $$ make install	# The lot
   $$ make ackrc		# Just the one (note the absence of the leading dot)
			# Use tab-completion to choose individual files

On Windows:

 - Install make using chocolatey.
 - Run this Makefile in a git-bash shell with admin rights (required for symlinks).
endef
export usage

.PHONY: usage
usage:
	@echo "$$usage"

# --------------------------- install --------------------------------------------

.PHONY: install
install: $(homedir) \
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
	@grep -H "dotfiles" $(HOME)/.$@


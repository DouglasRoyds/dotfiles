# https://stackoverflow.com/a/2547973/2411520
# https://stackoverflow.com/a/73450593/2411520
# dotfiles is relative to HOME
dotfiles := $(patsubst %/,%,$(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
dotfiles := $(subst $(HOME)/,,$(dotfiles))

homedir = $(HOME)/.ackrc \
	  $(HOME)/.bash_aliases \
	  $(HOME)/.bash_completion \
	  $(HOME)/.cvsignore \
	  $(HOME)/.cvsrc \
	  $(HOME)/.inputrc \
	  $(HOME)/.lessfilter \
	  $(HOME)/.minttyrc \
	  $(HOME)/.tidyrc

linux_homedir = $(HOME)/.bash_completion.d \
                $(HOME)/.dpkg.cfg \
	        $(HOME)/.tmux.conf \
	        $(HOME)/.Xmodmap

dot_config = $(HOME)/.config/gdb \
	     $(HOME)/.config/git

linux_dot_config = $(HOME)/.config/gtk-3.0

unison = $(HOME)/.unison/am.prf \
	 $(HOME)/.unison/default.inc \
	 $(HOME)/.unison/portable.prf

firefox = $(HOME)/snap/firefox/common/mime.types

profiles = bashrc \
	   profile

# --------------------------- usage ----------------------------------------------

define newline


endef

define usage
Symlinks dotfiles into the HOME directory:

 $(foreach file,$(homedir),  $(file) -> workspace/dotfiles/$(notdir $(file))$(newline))
 $(foreach dir,$(dot_config),  $(dir) -> ../workspace/dotfiles/$(notdir $(dir))/$(newline))
 $(foreach file,$(unison),  $(file) -> ../workspace/dotfiles/unison/$(notdir $(file))$(newline))
 $(foreach file,$(firefox),  $(file) -> ~/workspace/dotfiles/firefox/$(notdir $(file))$(newline))

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

# --------------------------- Windows, Linux -------------------------------------

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

# --------------------------- install --------------------------------------------

.PHONY: install
install: $(homedir) \
         $(dot_config) \
         $(unison) \
         $(firefox) \
         $(profiles)

$(HOME)/.%: %
	@$(call symlink_file, $(dotfiles)/$<, $@)
	@ls -l --color $@

$(HOME)/.config/%: %
	@mkdir -p $(dir $@)
	@$(call symlink_dir, ../$(dotfiles)/$<, $@)
	@ls -ld --color $@

$(HOME)/.unison/%: unison/%
	@mkdir -p $(dir $@)
	@$(call symlink_file, ../$(dotfiles)/$<, $@)
	@ls -ld --color $@

$(HOME)/snap/firefox/common/%: firefox/%
	@if [ -d $(dir $@) ]; then \
	    $(call symlink_file, $(HOME)/$(dotfiles)/$<, $@); \
	    ls -ld --color $@; \
	 fi

.PHONY: $(profiles)
$(profiles):
	@touch $(HOME)/.$@
	@if ! grep -q "$(dotfiles)/$@" $(HOME)/.$@; then \
	    printf ". $(dotfiles)/$@ || true\n\n" >> $(HOME)/.$@; \
	    grep -H "dotfiles" $(HOME)/.$@; \
	 fi


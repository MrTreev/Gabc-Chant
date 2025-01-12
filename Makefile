SHELL		:= zsh
.ONESHELL:
.SHELLFLAGS	:= -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS	+= --warn-undefined-variables
MAKEFLAGS	+= --no-builtin-rules
LATEX		?=	lualatex

PDF_FILES	:=	$(patsubst %.gabc,%.pdf,$(shell find -type f -name '*.gabc'))

default: all

all: ${PDF_FILES}

%.gtex: %.gabc
	cd $(dir $@)
	gregorio --verbose $(notdir $<) --output-file $(notdir $@)
	cd -

%.tex: %.gabc
	sed "s/TEMPLATESTRING/$(basename $(notdir $@))/" make/template.tex > $@

%.pdf: %.tex | %.gtex
	cd $(dir $@)
	${LATEX} --shell-escape $(notdir $<)
	cd -

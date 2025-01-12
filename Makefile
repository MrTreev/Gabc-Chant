SHELL		:= zsh
.ONESHELL:
.SHELLFLAGS	:= -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS	+= --warn-undefined-variables
MAKEFLAGS	+= --no-builtin-rules
LATEX		?=	lualatex

GABC_FILES	:=	$(shell find -type f -name '*.gabc')
PDF_FILES	:=	$(patsubst %.gabc,%.pdf,${GABC_FILES})
GTEX_FILES	:=	$(patsubst %.gabc,%.gtex,${GABC_FILES})

default: all

.PHONY: all
all: pdfs

.PHONY: gtex
gtex: ${GTEX_FILES}

.PHONY: pdfs
pdfs: ${PDF_FILES}

%.gtex: %.gabc
	cd $(dir $@)
	gregorio --verbose $(notdir $<) --output-file $(notdir $@)
	cd -

%.tex: make/textemplate
	sed "s/TEMPLATESTRING/$(basename $(notdir $@))/" $< > $@

%.pdf: %.tex
	cd $(dir $@)
	${LATEX} --shell-escape $(notdir $<)
	cd -

.PHONY: clean
clean:
	find -type f \
		-and \( \
			-name '*.aux' -or \
			-name '*.gaux' -or \
			-name '*.glog' -or \
			-name '*.gtex' -or \
			-name '*.log' -or \
			-name '*.pdf' \
		\) -delete


.PHONY: clear
clear:
	find -type f \
		-and \( \
			-name '*.aux' -or \
			-name '*.gaux' -or \
			-name '*.glog' -or \
			-name '*.gtex' -or \
			-name '*.log' \
		\) -delete

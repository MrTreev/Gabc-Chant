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

# %.gtex: %.gabc
# 	cd $(dir $@)
# 	gregorio --verbose $(notdir $<) --output-file $(notdir $@)
# 	cd -

%.tex: make/textemplate
	sed "s/TEMPLATESTRING/$(basename $(notdir $@))/" $< > $@

%.pdf: %.tex
	cd $(dir $@)
	${LATEX} --shell-escape $(notdir $<)
	cd -

.PHONY: clean
clean:
	rm $(shell \
		find -type f \
		-and \( \
			-name '*.glog' -or \
			-name '*.gtex' -or \
			-name '*.aux' -or \
			-name '*.gaux' -or \
			-name '*.log' -or \
			-name '*.pdf' \
		\) \
	)

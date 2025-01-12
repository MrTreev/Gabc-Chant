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
	$(shell find -type f \
		-name '*.glog' \
		-name '*.gtex' \
		-name '*.aux' \
		-name '*.gaux' \
		-name '*.log' \
		-name '*.pdf' \
	)

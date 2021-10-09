Q := @
SHELL := /bin/bash
.SHELLFLAGS := -e -o pipefail -c
COLOR := y
DIRECTORIES :=

ROOT.dir := $(abspath $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))/..)
export ROOT_DIR := $(ROOT.dir)
MAKETOOLS.dir := $(ROOT.dir)/maketools
BUILD.dir := $(ROOT.dir)/build
DIRECTORIES += $(BUILD.dir)

-include .env

MAKETOOLS.files := $(shell find "$(MAKETOOLS.dir)" -type f -name '*.mk' -not -path '*/init.mk')
include $(MAKETOOLS.files)

check: static test

clean cleanup:
	$(Q)echo $(@) is not implemented yet

# Create directories
# after inclusion of other files, so that newly added directories are included
$(DIRECTORIES):
	$(Q)mkdir -p '$@'


# Explicit rules for Makefile, *.mk to prevent implicit rule invokation.
Makefile: ;
%.mk: ;

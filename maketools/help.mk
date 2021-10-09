
.DEFAULT_GOAL := help

.PHONY: help
help:
	$(Q)cat $(MAKETOOLS.dir)/help.txt


.PHONY: make-help
make-help:
	$(Q)cat $(MAKETOOLS.dir)/make-help.txt


.PHONY: readme
readme:
	$(Q)cat $(ROOT.dir)/README.md

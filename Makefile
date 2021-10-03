IMAGE := nginx-proxy-index
CONTAINER := $(IMAGE)
Q=@

image:
	$(Q)docker build . -t ${IMAGE}:test

check: static test

static test clean cleanup:
	$(Q)echo $(@) is not implemented yet

help:
	@cat help.txt

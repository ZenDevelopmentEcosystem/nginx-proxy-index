IMAGE := perbohlin/nginx-proxy-index
CONTAINER := $(IMAGE)
Q=@

image:
	$(Q)docker build . -t ${IMAGE}:test

tag:
	$(Q)docker tag ${IMAGE}:test ${IMAGE}:latest

publish: tag
	$(Q)docker push ${IMAGE}:latest

check: static test

static test clean cleanup:
	$(Q)echo $(@) is not implemented yet

help:
	@cat help.txt

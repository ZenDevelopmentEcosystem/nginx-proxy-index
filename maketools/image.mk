IMAGE := perbohlin/nginx-proxy-index
TAG := test
DOCKER_ARGS ?=

INDEX_WEB.src ?= https://github.com/ZenDevelopmentEcosystem/index-web.git
INDEX_WEB.type ?= git

image:
	$(Q)docker build . $(DOCKER_ARGS)\
		-t $(IMAGE):$(TAG) \
		--build-arg "INDEX_WEB_SRC=$(INDEX_WEB.src)" \
		--build-arg "INDEX_WEB_TYPE=$(INDEX_WEB.type)"

tag:
	$(Q)docker tag $(IMAGE):$(TAG) $(IMAGE):latest

publish: tag
	$(Q)docker push $(IMAGE):latest

up:
	$(Q)$(ROOT.dir)/bin/docker-compose.sh up -d

down:
	$(Q)$(ROOT.dir)/bin/docker-compose.sh down

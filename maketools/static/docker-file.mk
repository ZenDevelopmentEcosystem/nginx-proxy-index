HADOLINT.bin := $(ROOT.dir)/bin/hadolint.sh
HADOLINT.args :=
HADOLINT.cmd := $(HADOLINT.bin) $(HADOLINT.args)

static: static-docker-file

static-docker-file:
	$(Q)cd "$(ROOT.dir)" \
		&& find "$(ROOT.dir)" \
		-type f \
		-name 'Dockerfile'| xargs --no-run-if-empty -L1 $(HADOLINT.cmd)

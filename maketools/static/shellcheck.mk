SHELLCHECK.bin := shellcheck
SHELLCHECK.args := -x --source-path=SCRIPTDIR
SHELLCHECK.cmd := $(SHELLCHECK.bin) $(SHELLCHECK.args)


.PHONY static: static-shellcheck
static-shellcheck:
	$(Q)cd "$(ROOT_DIR)" \
		&& find "$(ROOT_DIR)" \
			-type f \
			-name '*.sh'| xargs --no-run-if-empty -L1 $(SHELLCHECK.cmd)

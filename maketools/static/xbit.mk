XBIT.bin := $(ROOT.dir)/bin/xbit.sh
XBIT.args :=
XBIT.cmd := $(XBIT.bin) $(XBIT.args)

.PHONY static: static-xbit
static-xbit:
	$(Q)cd "$(ROOT.dir)" \
		&& find "$(ROOT.dir)" \
			-type f \
			-name '*.sh'| xargs --no-run-if-empty -L1 $(XBIT.cmd)

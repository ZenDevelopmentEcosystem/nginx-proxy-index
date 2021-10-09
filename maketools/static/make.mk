.PHONY static: static-make
static-make:
	$(Q)output=$$($(MAKE) -f $(firstword $(MAKEFILE_LIST)) \
		--no-print-directory \
		--warn-undefined-variables \
		help 2>&1 >/dev/null ); \
		[ -z "$${output}" ] || { echo "$${output}" && exit 1; }

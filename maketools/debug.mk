
# $1 variable
define VARIABLE_INFO
$(origin $(1))$$($(MAKE) --print-data-base \
| egrep -e '^'$$(sed 's/[][\.]/\\&/g' <<< '$(1)')' ' -B 1 \
| grep -v "\# make file (from " \
| gawk 'match($$0, /'\''(.*)'\'', line (.*)\)/, a) {print " " a[1] ":" a[2] }')
endef


# $1 variable
define DEFINE_INFO
$(origin $(1))$$($(MAKE) --print-data-base \
| egrep -e '^define '$$(sed 's/[][\.]/\\&/g' <<< '$(1)')'$$' -B 1 \
| grep -v "\# make file (from " \
| gawk 'match($$0, /'\''(.*)'\'', line (.*)\)/, a) {print " " a[1] ":" a[2] }')
endef


.PHONY: print-var-%
print-var-%:
	@echo "$*=$($*)"


.PHONY: print-val-%
print-val-%:
	@echo "$($*)"


.PHONY: print-info-%
print-info-%:
	@echo "$*=$($*) [$(call VARIABLE_INFO,$*)]"


.PHONY: list-targets
list-targets:
	$(Q)$(MAKE) --print-data-base --no-print-directory \
	 | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' \
	 | sort -u | egrep -v -e '^[^[:alnum:]]' -e'Makefile' -e'maketools/.*\.mk'


.PHONY: list-variables
list-variables:
	@$(foreach __v,$(filter-out $(shell $(MAKE) --no-print-directory list-defines),$(sort $(filter-out __%,$(.VARIABLES)))),$(if $(filter-out environment% default automatic,$(origin $(__v))),echo "$(__v)";))


.PHONY: list-defines
list-defines:
	$(Q)$(MAKE) --print-data-base | grep -o -P '^define \K\w+' | sort -u


.PHONY: print-var-all-variables
print-var-all-variables:
	@$(foreach __v,$(shell $(MAKE) --no-print-directory list-variables),echo "$(__v)=$($(__v))";)

.PHONY: print-info-all-variables
print-info-all-variables:
	@$(foreach __v,$(shell $(MAKE) --no-print-directory list-variables),echo "$(__v)=$($(__v)) [$(call VARIABLE_INFO,$(__v))]";)

.PHONY: print-info-all-defines
print-info-all-defines:
	@$(foreach __d,$(shell $(MAKE) --no-print-directory list-defines),echo "$(__d) [$(call DEFINE_INFO,$(__d))]";)

.PHONY: env
env:
	$(Q)env

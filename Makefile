DB=enceladus
BUILD=${CURDIR}/build.sql
SCRIPTS=${CURDIR}/scripts
CSV=${CURDIR}/data/master_plan.csv
MASTER=$(SCRIPTS)/import.sql
NORMALIZE=$(SCRIPTS)/normalize.sql
VIEWS=$(SCRIPTS)/views.sql

all: views
	psql $(DB) -f ${BUILD}

master:
	@cat $(MASTER) >> $(BUILD)

import: master
	@echo "COPY import.master_plan FROM '$(CSV)' WITH DELIMITER ',' HEADER CSV;" >> $(BUILD)

# rebuilds full build.sql, starting from scratch so we don't add multiple instances of the same code if we run make multiple times
normalize: import
	@cat $(NORMALIZE) >> $(BUILD)

# views: clean normalize
views: clean normalize
	@cat $(VIEWS) >> $(BUILD)

clean:
	@rm -rf $(BUILD)
DB=enceladus
BUILD=${CURDIR}/build.sql
SCRIPTS=${CURDIR}/scripts
CSV_MP=${CURDIR}/data/master_plan.csv
CSV_INMS=${CURDIR}/data/inms/inms.csv
MASTER=$(SCRIPTS)/import.sql
NORMALIZE=$(SCRIPTS)/normalize.sql
VIEWS=$(SCRIPTS)/views.sql

all: views
	psql $(DB) -f ${BUILD}

master:
	@cat $(MASTER) >> $(BUILD)

import: master
	@echo "COPY import.master_plan FROM '$(CSV_MP)' WITH DELIMITER ',' HEADER CSV;" >> $(BUILD)

# rebuilds full build.sql, starting from scratch so we don't add multiple instances of the same code if we run make multiple times
normalize: import
	@cat $(NORMALIZE) >> $(BUILD)

# views: clean normalize
views: clean normalize
	@cat $(VIEWS) >> $(BUILD)

clean:
	@rm -rf $(BUILD)
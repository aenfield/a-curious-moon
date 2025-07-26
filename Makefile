DB=enceladus
BUILD=${CURDIR}/build.sql
SCRIPTS=${CURDIR}/scripts
CSV_MP=${CURDIR}/data/master_plan.csv
CSV_INMS=${CURDIR}/data/INMS/inms.csv
CSV_CDA=${CURDIR}/data/CDA/cda.csv
CSV_JPL=${CURDIR}/data/jpl_flybys.csv
MASTER=$(SCRIPTS)/import.sql
FLYBYS=$(SCRIPTS)/flybys.sql
CDA=$(SCRIPTS)/cda.sql
NORMALIZE=$(SCRIPTS)/normalize.sql
FUNCTIONS=$(SCRIPTS)/functions.sql
VIEWS=$(SCRIPTS)/views.sql

# built up using stuff in the book - the result feels spaghettified and isn't maintainable

all: flybys
	psql $(DB) -f ${BUILD}

master:
	@cat $(MASTER) >> $(BUILD)

import: master
	@echo "COPY import.master_plan FROM '$(CSV_MP)' WITH DELIMITER ',' HEADER CSV;" >> $(BUILD)
	@echo "COPY import.inms FROM '$(CSV_INMS)' WITH DELIMITER ',' HEADER CSV;" >> $(BUILD)
	@echo "-- delete empty rows (null) and header rows (field name is same as value)" >> $(BUILD)
	@echo "DELETE FROM import.inms WHERE sclk IS NULL OR sclk = 'sclk'; " >> $(BUILD)
	@echo "COPY import.cda FROM '$(CSV_CDA)' WITH DELIMITER ',' HEADER CSV;" >> $(BUILD)

normalize: import
	@cat $(NORMALIZE) >> $(BUILD)

views: normalize
	@cat $(VIEWS) >> $(BUILD)

functions: views
	@cat $(FUNCTIONS) >> $(BUILD)

cda: functions
	@cat $(CDA) >> $(BUILD)

# order after functions are created, since this uses a function
flybys: clean cda
	@cat $(FLYBYS) >> $(BUILD)
	@echo "COPY flybys FROM '$(CSV_JPL)' WITH DELIMITER ',' HEADER CSV;" >> $(BUILD)

clean:
	@rm -rf $(BUILD)
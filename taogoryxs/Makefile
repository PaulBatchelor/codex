include $(MONOLITH_HOME)/aliases.mk

IDENTITY=jatash

default: test

#IDENTITY_AUX=$(IDENTITY).db

include ../hearth.mk

.PHONY: test
test:
	$(JANET) $(IDENTITY).janet

$(IDENTITY).db: $(IDENTITY).sql
	sqlite3 $@ < $<

clean:
	$(RM) $(IDENTITY_FILES)
	$(RM) $(IDENTITY).db

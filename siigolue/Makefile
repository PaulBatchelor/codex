include $(MONOLITH_HOME)/aliases.mk

IDENTITY=pyda

default: $(IDENTITY).mp4

IDENTITY_AUX=$(IDENTITY).db

include ../hearth.mk

.PHONY: test
test:
	$(JANET) pyda.janet

$(IDENTITY).db: $(IDENTITY).sql
	sqlite3 $@ < $<

clean:
	$(RM) $(IDENTITY_FILES)
	$(RM) $(IDENTITY).db

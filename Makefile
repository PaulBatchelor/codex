PORT?=8080
WIKI_PATH=codex

CFLAGS+=-I/usr/local/include/mnolth
LIBS=-lmnolth -lx264 -lm -lsqlite3 -lz

default: update

sync:
	weewiki sync

update:
	$(MAKE) db
	$(MAKE) sync
	$(MAKE) dump

export: db
	$(RM) -r _site/$(WIKI_PATH)
	mkdir -p _site/$(WIKI_PATH)
	weewiki sync
	weewiki export
	mv mkdb.janet mkdb.janet.old
	weewiki dump mkdb.janet

db:
	@sh update_db.sh

dump:
	weewiki dump mkdb.janet

transfer:
	$(RM) -r _live/$(WIKI_PATH)
	mkdir -p _live/$(WIKI_PATH)
	rsync -rvt _site/$(WIKI_PATH)/* _live/$(WIKI_PATH)

codex: codex.c
	$(CC) $(CFLAGS) $< -o $@ $(LIBS)

server:
	weewiki server - $(PORT)

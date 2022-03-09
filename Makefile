LUA         = 5.2
LUA_CFLAGS  = $(shell pkg-config --cflags lua$(LUA))
LUA_LIBS    = $(shell pkg-config --libs lua$(LUA))
 
CFLAGS      = -O3 -Wall -fPIC $(LUA_CFLAGS)
LIBS        = -lsqlite3 $(LUA_LIBS)

PREFIX      = /usr/local
LIBDIR      = $(PREFIX)/lib/lua/$(LUA)

all: sqlite.so

sqlite.so: luasqlite.o
	$(CC) $(CFLAGS) -shared -o $@ luasqlite.o $(LIBS)

clean:
	rm -f *.o *.so

install:
	install -d $(DESTDIR)$(LIBDIR)
	install -m 755 sqlite.so $(DESTDIR)$(LIBDIR)/sqlite.so

uninstall:
	rm -f $(DESTDIR)$(LIBDIR)/sqlite.so

.PHONY: sqlite.so

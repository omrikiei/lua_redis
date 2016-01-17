INST_PREFIX = /usr
INST_BINDIR = $(INST_PREFIX)/bin
INST_LIBDIR = $(INST_PREFIX)/lib64/lua/5.1
INST_LUADIR = $(INST_PREFIX)/share/lua/5.1
INST_CONFDIR = $(INST_PREFIX)/etc
SHARED_OBJ = "./src/redislib"
STATIC_EXTERNAL = $(LIBHIREDIS_DIR)/libhiredis.a

all:	$(SHARED_OBJ).so
	@echo --- build
	@echo CFLAGS: $(CFLAGS)
	@echo LIBFLAG: $(LIBFLAG)
	@echo LUA_LIBDIR: $(LUA_LIBDIR)
	@echo LUA_BINDIR: $(LUA_BINDIR)
	@echo LUA_INCDIR: $(LUA_INCDIR)
	@echo HIREDIS: $(LIBHIREDIS_DIR)
$(SHARED_OBJ).so: $(SHARED_OBJ).o
	$(CC) --shared $(LIBFLAGS) -o $@ $< -I$(LUA_INCDIR) -I$(LIBHIREDIS_INCDIR) -L$(LUA_LIBDIR) -llua $(STATIC_EXTERNAL)

$(SHARED_OBJ).o: ./src/lua_redis.c
	$(CC) -c $(CFLAGS) -I$(LUA_INCDIR) -I$(LIBHIREDIS_INCDIR) $< -o $@

install:
	@echo --- install
	@echo INST_PREFIX: $(INST_PREFIX)
	@echo INST_BINDIR: $(INST_BINDIR)
	@echo INST_LIBDIR: $(INST_LIBDIR)
	@echo INST_LUADIR: $(INST_LUADIR)
	@echo INST_CONFDIR: $(INST_CONFDIR)


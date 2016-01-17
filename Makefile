INST_PREFIX = /usr
INST_BINDIR = $(INST_PREFIX)/bin
INST_LIBDIR = $(INST_PREFIX)/lib64/lua/5.1
INST_LUADIR = $(INST_PREFIX)/share/lua/5.1
INST_CONFDIR = $(INST_PREFIX)/etc
SHARED_OBJ = "./src/redislib"
STATIC_EXTERNAL = $(LIBHIREDIS_DIR)/libhiredis.a

all:	$(SHARED_OBJ).so
	@echo --- building redislib module ---
$(SHARED_OBJ).so: $(SHARED_OBJ).o
	$(CC) --shared $(LIBFLAGS) -o $@ $< -I$(LUA_INCDIR) -I$(LIBHIREDIS_INCDIR) -L$(LUA_LIBDIR) -llua $(STATIC_EXTERNAL)

$(SHARED_OBJ).o: ./src/lua_redis.c
	$(CC) -c $(CFLAGS) -I$(LUA_INCDIR) -I$(LIBHIREDIS_INCDIR) $< -o $@

install:
	@echo --- installing lua_redis ---


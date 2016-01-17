#include <lua.h>
#include <lauxlib.h>
#include "lua_redis.h"

typedef enum { false, true } bool;
#define NO_INDEXES 1

// Global connection variable

static int pushConnection(lua_State *L, redisContext *con) {
  if (con != NULL && con->err) {
    luaL_error(L, "Error: %s\n", con->errstr);
    lua_pushnil(L);
    lua_pushstring(L, con->errstr);
    redisFree(con);
    return 2;
  }
  lua_pushlightuserdata(L, con);
  return 1;
};

static int luaredis_connect (lua_State *L) {
  const char *ip = luaL_checkstring(L, 1);
  int port = luaL_optint(L, 2, 6379);
  int timeout = luaL_optint(L, 3, -1);
  int nonblock = lua_toboolean(L, 4);
  if (timeout == -1) {
    if (nonblock == 1) {
      redisContext *con = redisConnectNonBlock(ip, port);
      return pushConnection(L, con);
    } else {
      redisContext *con = redisConnect(ip, port);
      return pushConnection(L, con);
    }
  } else {
    struct timeval to;
    to.tv_sec = timeout;
    to.tv_usec = 0;
    redisContext *con = redisConnectWithTimeout(ip, port, to);
    return pushConnection(L, con);
  }
};

static int lua_connect_unix (lua_State *L) {
  const char *path = luaL_checkstring(L, 1);
  int timeout = luaL_optint(L, 3, -1);
  int nonblock = lua_toboolean(L, 4);
  if (timeout == -1) {
    if (nonblock == 1) {
      redisContext *con = redisConnectUnixNonBlock(path);
      return pushConnection(L, con);
    } else {
      redisContext *con = redisConnectUnix(path);
      return pushConnection(L, con);
    }
  } else {
    struct timeval to;
    to.tv_sec = timeout;
    to.tv_usec = 0;
    redisContext *con = redisConnectUnixWithTimeout(path, to);
    return pushConnection(L, con);
  }
};

static int luaredis_disconnect (lua_State *L) {
  redisContext *con = lua_touserdata(L, 1);
  if (con == NULL) {
    luaL_error(L, "Error: expected connection instance");
    return 0;
  }
  redisFree(con);
  return 1;
};

void pushRedisArrayAsTable (lua_State *L, redisReply *reply, int mode) {
  size_t i;
  if (reply->element != NULL) {
    lua_newtable(L);
    for (i=0; i < reply->elements; i++) {
      if (reply->element[i] != NULL){
        if (mode == NO_INDEXES) {
          lua_pushstring(L, reply->element[i]->str);
          i++;
        } else {
          lua_pushinteger(L, i+1);
        }
        redisReply *subReply = reply->element[i];
        switch(subReply->type) {
          case REDIS_REPLY_INTEGER:
            lua_pushinteger(L, subReply->integer);
            break;
          case REDIS_REPLY_ARRAY:
            pushRedisArrayAsTable(L, subReply, mode);
            break;
          case REDIS_REPLY_ERROR:
            luaL_error(L, "Error: %s\n", subReply->str);
            return;    
          case REDIS_REPLY_STATUS:
          case REDIS_REPLY_STRING:
            lua_pushstring(L, subReply->str);
            break;
          case REDIS_REPLY_NIL:
            lua_pushnil(L);
            break;
        }
      }
      lua_settable(L, -3); 
    }
  }
}

static int luaredis_command (lua_State *L) {
  redisContext *con = lua_touserdata(L, 1);
  const char *cmd = luaL_checkstring(L, 2);
  int mode = luaL_optint(L, 3, 0);  
  redisReply *reply = redisCommand(con, cmd);
  switch (reply->type) {
    case REDIS_REPLY_INTEGER:
      lua_pushinteger(L, reply->integer);
      break;
    case REDIS_REPLY_ARRAY:
      pushRedisArrayAsTable(L, reply, mode);
      break;
    case REDIS_REPLY_ERROR:
      luaL_error(L, "Error: %s\n", reply->str);
      return 0;    
    case REDIS_REPLY_STATUS:
    case REDIS_REPLY_STRING:
      lua_pushstring(L, reply->str);
      break;
    case REDIS_REPLY_NIL:
      lua_pushnil(L);
      break;
  }
  freeReplyObject(reply);
  return 1;
};

static const luaL_Reg lua_redis[] = {
{"connect", luaredis_connect},
{"connect_unix", lua_connect_unix},
{"disconnect", luaredis_disconnect},
{"command", luaredis_command},

{NULL, NULL}
};

LUALIB_API int luaopen_redislib (lua_State *L) {
  lua_pushvalue(L, -1);
  lua_setglobal(L, "redis");
//  luaL_setfuncs(L, lua_redis, 0); /* 5.1 */
  luaL_register(L, "LUA_REDIS", lua_redis);
  return 1;
}

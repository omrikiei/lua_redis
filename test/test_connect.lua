require "lunit"

module( "my_testcase", lunit.testcase, package.seeall )

redis = require "lua_redis"

function test_connect()
  instance = redis.connect("test", {["ip"] = "127.0.0.1"})
  assert_true(instance.__connected, "could not connect to 127.0.0.1")
  redis.disconnect("test")
  instance = redis.connect("test", {["ip"] = "127.0.0.1"})
  assert_false(pcall( function() return redis.connect("badtest", {["ip"] = "126.0.0.1", ["timeout"] = 1}) end ), "blabla")
--  assert_false(bad.__connected, "Expected connection failure on wrong IP terms")
end

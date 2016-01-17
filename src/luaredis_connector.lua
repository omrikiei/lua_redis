local M = {}
M.__index = M

function M:init(redislib)
  M.__redis = redislib
  return M
end

function verify_type(param, class, name)
  if type(param) ~= class then
    error("Error: "..name.." argument should be of type "..class)
  end
end

function M.connect_tcp(ip,port,timeout,nonblock)
  local ok, invocation
  verify_type(ip, "string", "ip") 
  verify_type(port, "number", "port")
  if timeout then
    verify_type(timeout, "number", "timeout")
  end
  if nonblock then
    verify_type(nonblock, "boolean", "nonblock")
  end
  return M.__redis.connect(ip,port,timeout,nonblock)
end

function M.connect_unix(path,timeout,nonblock)
  local ok, invocation
  verify_type(path, "string", "path")
  if timeout then
    verify_type(timeout, "number", "timeout")
  end
  if nonblock then
    verify_type(nonblock, "boolean", "nonblock")
  end
  return M.__redis.connect_unix(path,timeout)
end

return M

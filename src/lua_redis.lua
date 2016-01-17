local Connection = require "luaredis_connection"
local M = {}
M.__index = M
M.instances = {}
M.__mem_allocs = {} -- userdata memory allocations table

M.connect = function(name, params)
  --TODO: define connection prototypes
  M.instances[name] = Connection:init({ ["ip"] = params.ip,
                                        ["port"] = params.port,
                                        ["mode"] = params.mode,
                                        ["path"] = params.path,
                                        ["timeout"] = params.timeout,
                                        ["nonblock"] = params.nonblock })
  local mem_alloc = tostring(M.instances[name].__context):match("%w+$")
  if M.__mem_allocs[mem_alloc] then
    error("Error: Failed to connect")
  end
  M.__mem_allocs[mem_alloc] = true
  return M.instances[name]
end

M.disconnect = function(name)
  M.instances[name]:close()
  local mem_alloc = tostring(M.instances[name].__context):match("%w+$")
  M.__mem_allocs[mem_alloc] = nil
end

return M

local commands = require "luaredis_commands"
local M = {}
M.__index = M
M.__context = nil
M.__connected = false
M.__Redis = require "redislib"
M.__Connector = require("luaredis_connector"):init(M.__Redis)
local metacommands = {}

metacommands.__index = function(table, key)
  if not commands[key] then
    local cmd = function(...)
      local cmd_text = key
      for _,v in ipairs(arg) do
        cmd_text = cmd_text .. " " .. v
      end
      if M.__connected and M.__context then
        return M.__Redis.command(M.__context, cmd_text)
      end
      error("Redis instance is not connected")
    end
    return cmd
  end
  return commands[key]
end

function M:init(params)
  if (type(params) ~= "table") then
    error("Wrong argument type: expected table but instead got "..type(params))
  end
  setmetatable(M, metacommands)
  if params.mode == "unix" then
    M.__context = M.__Connector.connectUnix(params.path, params.timeout, params.nonblock)
  else
    M.__context = M.__Connector.connect_tcp(params.ip, params.port or 6379, params.timeout, params.nonblock)
  end
  commands:init(M.__Redis,M.__context)
  if M.__context then
    M.__connected = true
  else
    error("Failed to connect")
  end
  return M
end

function M:close()
  if M.__context then
    M.__Redis.disconnect(M.__context)
    M.__connected = false
  else
    error("No connection to terminate")
  end
end

return M

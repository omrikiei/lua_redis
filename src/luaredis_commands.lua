local M = {}
M.__index = M

function M:init(redis, context)
  M.__context = context
  M.redis = redis
  return M
end

M.hgetall = function(str)
  local cmd_text = "hgetall "..str
  local no_indexes = 1
  if M.__context then
    return M.redis.command(M.__context, cmd_text, no_indexes)
  end
  return nil
end

return M

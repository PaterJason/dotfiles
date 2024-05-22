local M = {}

---@param obj any
---@return string?
function M.encode(obj)
  local obj_type = type(obj)
  if obj_type == "number" and obj % 1 == 0 then
    return "i" .. obj .. "e"
  elseif obj_type == "string" then
    return string.len(obj) .. ":" .. obj
  elseif vim.islist(obj) then
    local s = "l"
    for _, value in ipairs(obj) do
      local v_str = M.encode(value)
      if v_str == nil then return end
      s = s .. v_str
    end
    return s .. "e"
  elseif obj_type == "table" then
    local s = "d"
    for key, value in pairs(obj) do
      local k_str, v_str = M.encode(key), M.encode(value)
      if k_str == nil or v_str == nil then return end
      s = s .. k_str .. v_str
    end
    return s .. "e"
  end
  vim.notify("Failed to encode bencode", vim.log.levels.ERROR)
end

---@param s string
---@param index integer?
---@return any, integer
function M.decode(s, index)
  index = index or 1
  local head = string.sub(s, index, index)

  if head == "" then
    return nil, index
  elseif head == "e" then
    return nil, index + 1
  elseif head == "i" then
    local start, _end = string.find(s, "^i%-?%d+e", index)
    if start == nil or _end == nil then
      vim.notify("Failed to decode number", vim.log.levels.ERROR)
      return nil, index
    end
    return tonumber(string.sub(s, start + 1, _end - 1)), _end + 1
  elseif string.find(head, "%d") then
    local start, _end = string.find(s, "^%d+:", index)
    if start == nil or _end == nil then
      vim.notify("Failed to decode string", vim.log.levels.ERROR)
      return nil, index
    end
    local len = tonumber(string.sub(s, start, _end - 1))
    return string.sub(s, _end + 1, _end + len), _end + len + 1
  elseif head == "l" then
    local list = {}
    index = index + 1
    while true do
      local decoded_s, i = M.decode(s, index)
      index = i
      if decoded_s == nil then break end
      list[#list + 1] = decoded_s
    end
    return list, index
  elseif head == "d" then
    local dict = {}
    index = index + 1
    while true do
      local key, i = M.decode(s, index)
      if key == nil then return dict, i end

      local value, j = M.decode(s, i)
      index = j
      dict[key] = value
    end
    return dict, index
  end

  vim.notify("Failed to decode bencode", vim.log.levels.ERROR)
  return nil, index
end

return M

function clone(rootElement)
  local elementType = type(rootElement)
  local copy

  if elementType == 'table' then
    copy = {}
    for elementKey, elementValue in next, rootElement, nil do
      copy[clone(elementKey)] = clone(elementValue)
    end
    setmetatable(copy, clone(getmetatable(rootElement)))
  else
    copy = rootElement
  end

  return copy
end

local function assignOne(destination, source)
  assert(type(source) == "table", "Assign must be called with a table or nil as a successive argument. Type was " .. type(source))

  for key, value in pairs(source) do
    destination[key] = clone(value)
  end 

  return destination
end

local function assign(destination, ...)
  assert(type(destination) == "table", "Assign must be called with a table as the first argument. Type was " .. type(destination))

  for index, source in ipairs({...}) do
    assignOne(destination, source)
  end

  return destination
end

return assign
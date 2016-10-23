lust = require('tests.libs.lust')
local files = require('tests.suite')

for _, fn in pairs({'describe', 'it', 'test', 'expect', 'spy', 'before', 'after'}) do
  _G[fn] = lust[fn]
end

for i, path in ipairs(files) do
  dofile(path)
  if next(files, i) then
    print()
  end
end

local red = string.char(27) .. '[31m'
local green = string.char(27) .. '[32m'
local normal = string.char(27) .. '[0m'

if lust.errors > 0 then
  io.write(red .. lust.errors .. normal .. ' failed, ')
end

print(green .. lust.passes .. normal .. ' passed')

if lust.errors > 0 then os.exit(1) end
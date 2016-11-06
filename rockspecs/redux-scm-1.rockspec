package = "redux"
version = "scm-1"
source = {
  url = "https://github.com/talldan/lua-redux.git"
}
description = {
  summary = "Implementation of the JavaScript redux library in Lua",
  detailed = [[
    Implementation of the JavaScript redux library in Lua.
  ]],
  homepage = "https://github.com/talldan/lua-redux",
  license = "MIT"
}
dependencies = {
  "lua >= 5.1"
}
build = {
  type = "builtin",
  modules = {
    ["redux.init"] = "src/init.lua",
    ["redux.connect"] = "src/connect.lua",
    ["redux.createStore"] = "src/createStore.lua"
  }
}
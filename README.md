[![Build Status](https://travis-ci.org/talldan/lua-redux.svg?branch=master)](https://travis-ci.org/talldan/lua-redux)

# lua-redux
Implementation of the JavaScript redux library in Lua
(see here for the original: https://github.com/reactjs/redux)

## Installation

lua-redux is currently in early stages of development, and doesn't contain the same featureset as JavaScript redux.

lua-redux is installable using LuaRocks (https://luarocks.org/modules/talldan/redux):

```
luarocks install redux
```

Alternatively, it should be possible to use other approaches, like a git submodule.

## Usage

There are currently two main parts to the library:

### createStore

```
local createStore = require('redux.createStore')
```

createStore is a function that returns a new store instance. For arguments, it 
takes a reducing function and and optional initial store state:

```
local initialState = {
  counter = 0
}

local store = createStore(function(state, action)
  local newState = {}

  if action.actionType == 'INCREMENT' then
    newState.counter = state.counter + action.value
  elseif action.actionType == 'DECREMENT' then
    newState.counter = state.counter - action.value
  end

  return newState
end, initialState)
```

Above, a new store is created from a reducing function and some initial state. 
The store is created with the state set as the initialState variable. The 
reducing function is used to update the state of the store and receives the
current state of the store, and an action that encapsulates a particular change.
It is good practice not to mutate the store.


Use store.dispatch to dispatch actions:

```
store.dispatch({
  actionType = 'INCREMENT',
  value = 2
})
```

When dispatch is called the reducing function passed to createStore is 
triggered. In this case it has the result of updating the store state's 
counter property to 2.


Use store.listen to listen to changes in the store:

```
local unlisten = store.listen(function(updatedState)
  print(updatedState.counter)
end)
```

Here, the callback passed to listen will be called with the new store state
whenever a dispatch causes the store state to change.


Use the unlisten function to stop listening:

```
unlisten()
```


store.getState returns the state of the store:

```
local storeState = store.getState()
print(storeState.counter)  -- prints 2
```

### connect

Use connect to connect some kind of component (tbc) to the store. Connect
receives a couple of mapping functions for store state and store actions and
returns a higher order function used to wrap another function.

```
local connect = require('redux.connect')

local function mapStateToProps(state) {
  return {
    value = state.counter
  }
}

local function mapDispatchToProps(dispatch) {
  return {
    incrementByOne = function()
      dispatch({
        actionType = 'INCREMENT',
        value = 1
      })
    end,
    decrementByOne = function()
      dispatch({
        actionType = 'DECREMENT',
        value = 1  
      })
    end
  }
}

local connector = connect(mapStateToProps, mapDispatchToProps)

local connected = connector(function(props)
  return component({
    onClickUpButton = props.incrementByOne,
    onClickDownButton = props.decrementByOne,
    value = props.value
  })
end)

connected({ store = store })
```

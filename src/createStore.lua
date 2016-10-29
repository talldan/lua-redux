function listen(listener, listeners)
  assert(type(listener) == 'function', 'Listener passed to listen must be of type function')
  assert(type(listeners) == 'table', 'Listeners passed to listen must be of type table')

  listeners[#listeners + 1] = listener

  function unlisten()
    local position;
    for index, listenerToCheck in ipairs(listeners) do
      if listener == listenerToCheck then
        position = index
        break
      end
    end

    table.remove(listeners, position)
  end

  return unsubscribe
end

function triggerListeners(listeners, storeState)
  for index, listener in ipairs(listeners) do
    listener(storeState)
  end
end

function createStore(reducer, intialState) 
  assert(type(reducer) == 'function', 'reducer passed to #createStore must be of type function')

  local store = {}
  
  local isDispatching = false
  local listeners = {}
  local storeState = intialState or {}

  function store.dispatch(action)
    assert(type(action) == 'table', 'Action passed to dispatch must be of type table')
    assert(type(action.actionType) == 'string', 'Action must have a type of string')
    assert(not isDispatching, 'Reducers must not call dispatch')

    isDispatching = true
    storeState = reducer(storeState, action)
    isDispatching = false

    triggerListeners(listeners, storeState)
  end

  function store.listen(listener)
    return listen(listener, listeners)
  end

  function store.getState()
    return storeState
  end

  return store
end

return createStore
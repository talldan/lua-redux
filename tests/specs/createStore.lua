local createStore = require('src.createStore')
local noop = function() end

describe('createStore', function()
  describe('error states', function()
    it('causes an error if a function is not passed as the first argument', function()
      expect(function()
        createStore()
      end).to.fail()
    end)
  end)

  describe('behaviour', function()
    it('returns a table when passed a function as the first argument', function()
      local store = createStore(noop)

      expect(type(store))
        .to.be('table')
    end)

    it('returns a table when passed a function as the first argument and a table as the second argument', function()
      local store = createStore(noop, {})

      expect(type(store))
        .to.be('table')
    end)

    it('sets the store state to be the initial state when specified through the second argument', function()
      local initialState = {
        a = '1'
      }
      local store = createStore(noop, initialState)
      local storeState = store.getState()

      expect(storeState)
        .to.be(initialState)

      expect(storeState.a)
        .to.be(initialState.a)
    end)
  end)
end)

describe('store', function()
  describe('properties', function()
    it('has a dispatch property, which is a function', function()
      local store = createStore(noop, {})

      expect(type(store.dispatch))
        .to.be('function')
    end)

    it('has a listen property, which is a function', function()
      local store = createStore(noop, {})

      expect(type(store.listen))
        .to.be('function')
    end)

    it('has a getState property, which is a function', function()
      local store = createStore(noop, {})

      expect(type(store.getState))
        .to.be('function')
    end)
  end)
end)

describe('store#dispatch', function()
  describe('error states', function()
    it('causes an error if dispatch is not passed a table as a first argument', function()
      local store = createStore(noop)

      expect(function()
        store.dispatch()
      end).to.fail()
    end)

    it('causes an error if the first argument table does not have an actionType property', function()
      local store = createStore(noop)

      expect(function()
        store.dispatch({})
      end).to.fail()
    end)

    it('causes an error if the first argument table has an actionType property that is not a string', function()
      local store = createStore(noop)

      expect(function()
        store.dispatch({
          actionType = 12
        })
      end).to.fail()

      expect(function()
        store.dispatch({
          actionType = {}
        })
      end).to.fail()

      expect(function()
        store.dispatch({
          actionType = false  
        })
      end).to.fail()
    end)

    it('causes an error if a reducer tries to call dispatch', function()
      local store = createStore(function()
        store.dispatch({
          actionType = 'test'
        })
      end)

      expect(function()
        store.dispatch({
          actionType = 'test'
        })
      end).to.fail()
    end)
  end)

  describe('behaviour', function()
    it('calls the reducing function declared in createStore', function()
      local calls = 0
      local store = createStore(function()
        calls = calls + 1
      end)

      store.dispatch({ actionType = 'test' })

      expect(calls)
        .to.be(1)
    end)

    it('calls the reducing function with the store state as the first argument, and the action as the second argument', function()
      local initialState = {
        testValue = 'this is a test'
      }

      local action = { 
        actionType = 'test' 
      }

      local stateArg = nil
      local actionArg = nil

      local store = createStore(function(state, action)
        stateArg = state
        actionArg = action
      end, initialState)

      store.dispatch(action)

      expect(stateArg)
        .to.be(initialState)

      expect(actionArg)
        .to.be(action)
    end)

    it('causes the store state to be updated to the value returned by the reducer', function()
      local initialState = {
        testValue = 'this is the initial state'
      }

      local store = createStore(function()
        return {
          testValue = 'this is the new state'
        }
      end, initialState)

      store.dispatch({
        actionType = 'update'  
      })

      expect(store.getState())
        .to_not.be(initialState)

      expect(store.getState().testValue)
        .to.be('this is the new state')
    end)
  end)
end)

describe('store#getState', function()
  describe('behaviour', function()
    it('returns the current store state', function()
      local initialState = {
        testValue = 'this is the initial state'
      }

      local store = createStore(noop, initialState)

      expect(store.getState())
        .to.be(initialState)
    end)
  end)
end)

describe('store#listen', function()
  describe('error states', function()
    it('causes an error if a function is not passed as the first argument', function()
      local store = createStore(noop)

      expect(function()
        store.listen()
      end).to.fail()

      expect(function()
        store.listen(false)
      end).to.fail()

      expect(function()
        store.listen('hi')
      end).to.fail()

      expect(function()
        store.listen(12)
      end).to.fail()
    end)
  end)

  describe('behaviour', function()
    it('registers a function as a listener, which is triggered when the store is updated, and receives the new store state as an argument', function()
      local listenerCalls = 0
      local listenerStateArg = nil
      local anotherListenerCalls = 0
      local anotherListenerStateArg = nil

      local initialState = {
        updated = false
      }

      function listener(newState)
        listenerCalls = listenerCalls + 1
        listenerStateArg = newState
      end

      function anotherListener(newState)
        anotherListenerCalls = anotherListenerCalls + 1
        anotherListenerStateArg = newState
      end

      function reducer()
        return {
          updated = true
        }
      end

      local store = createStore(reducer, initialState)
      store.listen(listener)
      store.listen(anotherListener)

      store.dispatch({ actionType = 'update' })

      expect(listenerCalls)
        .to.be(1)

      expect(listenerStateArg.updated)
        .to.be(true)

      expect(anotherListenerCalls)
        .to.be(1)

      expect(anotherListenerStateArg.updated)
        .to.be(true)
    end) 

    it('returns an unlisten function, which is used to unregister the listener', function()
      local listenerCalls = 0
      local listenerStateArg = nil

      local initialState = {
        updated = false
      }

      function listener(newState)
        listenerCalls = listenerCalls + 1
        listenerStateArg = newState
      end

      function reducer()
        return {
          updated = true
        }
      end

      local store = createStore(reducer, initialState)
      local unlisten = store.listen(listener)

      expect(type(unlisten))
        .to.be('function')

      store.dispatch({ actionType = 'update' })
      store.dispatch({ actionType = 'update' })

      expect(listenerCalls)
        .to.be(2)

      expect(listenerStateArg.updated)
        .to.be(true)

      unlisten()
      store.dispatch({ actionType = 'update' })
      store.dispatch({ actionType = 'update' })

      expect(listenerCalls)
        .to.be(2)
    end)
  end)
end)
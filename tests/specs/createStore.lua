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
  end)
end)
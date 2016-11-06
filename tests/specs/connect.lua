local connect = require('src.connect')

local function createStoreMock(storeState)
  local storeMock = {
    getState = function()
      return storeState
    end,
    dispatch = function()
    end    
  }

  return storeMock
end

describe('connect', function()
  describe('error states', function()
    it('causes an error if the inner function is not passed a function as the first argument', function()
      expect(function()
        connect()()
      end).to.fail()
    end)

    it('causes an error if the function returned by the curried function is not called with a table with a store property that is a table', function()
      expect(function()
        local wrapped = connect()(function() end)
        wrapped()
      end).to.fail()

      expect(function()
        local wrapped = connect()(function() end)
        wrapped({})
      end).to.fail()

      expect(function()
        local wrapped = connect()(function() end)
        wrapped({
          store = 'a string'
        })
      end).to.fail()
    end)
  end)

  describe('behaviour', function()
    it('returns a function when called', function()
      expect(type(connect()))
        .to.be('function')
    end)

    it('returns a function which also returns a function when called with a function', function()
      expect(type(connect()(function() end)))
        .to.be('function')
    end)

    it('receives a mapping function for the first argument which is used to augment the props of the wrapped component', function()
      local mockStore = createStoreMock({
        test = 'test of connect'  
      })

      function mapProps(storeState)
        return {
          test = 'this is a ' .. storeState.test
        }
      end

      function testComponent(props)
        return props.test
      end

      local connectedComponent = connect(mapProps)(testComponent)

      expect(connectedComponent({ store = mockStore }))
        .to.be('this is a test of connect')
    end)

    it('receives a mapping function for the second argument which is used to configure action dispatches to the store', function()
      local mockStore = createStoreMock({
        test = 'test of connect'  
      })

      local calls = 0

      mockStore.dispatch = function()
        calls = calls + 1
      end

      function mapDispatches(dispatch)
        return {
          test = function()
            dispatch()
          end
        }
      end

      function testComponent(props)
        props.test()
      end

      local connectedComponent = connect(nil, mapDispatches)(testComponent)
      connectedComponent({ store = mockStore })

      expect(calls)
        .to.be(1)
    end)
  end)
end)
local connect = require('src.connect')

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
    it('curries a function when called', function()
      expect(type(connect()))
        .to.be('function')
    end)

    it('curries a function that returns a function when called with a function', function()
      expect(type(connect()(function() end)))
        .to.be('function')
    end)
  end)
end)
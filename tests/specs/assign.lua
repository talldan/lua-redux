local assign = require('src.assign')

describe('assign', function()
  describe('error states', function()
    it('causes an error if passed no arguments', function()
      expect(function()
        assign()
      end).to.fail()
    end)

    it('causes an error if passed a non table for the first argument', function()
      expect(function() 
        assign('test', {})
      end).to.fail()
    end)

    it('causes an error if passed a non table for any argument after the first', function()
      expect(function() 
        assign({}, 'test')
      end).to.fail()

      expect(function() 
        assign({}, {}, 'test')
      end).to.fail()

      expect(function() 
        assign({}, 12, {})
      end).to.fail()
    end)
  end)

  describe('behaviour', function()
    it('returns the same table as originally passed for the first argument', function()
      local tbl = {}
      expect(assign(tbl))
        .to.be(tbl)
    end)

    it('assigns all properties from the second argument table to the first argument table', function()
      local destination = {}
      local source = {
        a = '1',
        b = '2',
        c = '3'
      }

      assign(destination, source)

      expect(destination['a'])
        .to.exist()
      expect(destination['a'])
        .to.be('1')

      expect(destination['b'])
        .to.exist()
      expect(destination['b'])
        .to.be('2')

      expect(destination['c'])
        .to.exist()
      expect(destination['c'])
        .to.be('3')
    end)

    it('assigns all properties from the second argument table to the first argument table and returns the first table as the result', function()
      local destination = {}
      local source = {
        a = '1',
        b = '2',
        c = '3'
      }

      local result = assign(destination, source)

      expect(result['a'])
        .to.exist()
      expect(result['a'])
        .to.be('1')

      expect(result['b'])
        .to.exist()
      expect(result['b'])
        .to.be('2')

      expect(result['c'])
        .to.exist()
      expect(result['c'])
        .to.be('3')

      expect(result)
        .to.be(destination)
    end)

    it('also assigns resulting arguments to the destination', function()
      local destination = {}
      local sourceA = {
        a = '1'
      }
      local sourceB = {
        b = '2'
      }

      assign(destination, sourceA, sourceB)

      expect(destination['a'])
        .to.exist()
      expect(destination['a'])
        .to.be('1')

      expect(destination['b'])
        .to.exist()
      expect(destination['b'])
        .to.be('2')
    end)

    it('makes the assignment of multiple sources from left to right', function()
      local destination = {}
      local sourceA = {
        a = '1'
      }
      local sourceB = {
        a = '2'
      }

      assign(destination, sourceA, sourceB)

      expect(destination['a'])
        .to.exist()
      expect(destination['a'])
        .to.be('2')
    end)

    it('clones properties from source tables when assigning them to the destination', function()
      local destination = {}

      local source = {
        test = {
          value = 0
        }
      }

      assign(destination, source)

      source.test.value = 1

      expect(destination.test.value)
        .to.be(0)
    end)
  end)
end)
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
  
end)
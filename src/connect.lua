local assign = require('src.assign')

function connect(mapStateToProps, mapDispatchToProps)
  return function(componentToWrap)
    assert(type(componentToWrap) == 'function', 
      'connect expects its inner function to receive a function as an argument')

    function render(props, children, key)
      assert(type(props.store) == 'table',
        'Store should be passed as a prop to connect component')

      local store = props.store
      local storeState = store.getState()
      local dispatch = store.dispatch

      local newProps = {}
      if type(mapStateToProps) == 'function' then
        local stateProps = mapStateToProps(storeState) or {}
        assign(newProps, stateProps, props)
      end

      if type(mapDispatchToProps) == 'function' then
        local dispatchProps = mapDispatchToProps(dispatch) or {}
        assign(newProps, dispatchProps, props)
      end

      return componentToWrap(newProps, children, key)
    end

    return render
  end
end

return connect
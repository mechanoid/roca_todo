namespace 'todoMVC.conditionalObserve', (exports) ->
  config = exports.config =
    target: "conditional-observe"
    action: "conditional-observe-action"
    conterAction: "conditional-observe-conter-action"
    condition: "conditional-observe-condition"

  conditions = {
      empty: ->
        this.length < 1

      notEmpty: ->
        not conditions.empty.call(this)
  }

  approve = (obj, condition) ->
    condition_func = conditions[condition]
    condition_func.call(obj) if condition_func and obj

  sanitizeParam = (param) ->
    return false if /^false$/.test(param)
    return true if /^true$/.test(param)
    param

  sanitizeAction = (action) ->
    result_action = params = undefined
    if action?
      [result_action, params] = action.split(':')
      if params?
        params = params.split(',')
        params = (sanitizeParam(param) for param in params)
    [result_action, params]

  exports.install = (root) ->
    $root = $(root or document)
    observer = $root.find("[data-#{config.target}]")
    observed = $root.find(observer.data(config.target))

    condition = observer.data(config.condition)
    action = observer.data(config.action)
    conterAction = observer.data(config.conterAction)

    [action, params] = sanitizeAction(action)
    [conterAction, conterParams] = sanitizeAction(conterAction)

    if approve(observed, condition)
      observer[action](params...)
    else if conterAction?
      console.log "calling install"
      observer[conterAction](conterParams...)
    else
      console.log "huhu"


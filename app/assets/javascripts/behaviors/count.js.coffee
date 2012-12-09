namespace 'todoMVC.count', (exports) ->
  config = exports.config =
    mainSelector: 'count'

  valueMethod = (obj, params...) ->
    return obj.attr('value', params...) if obj.attr('value')
    obj.html(params...)

  exports.install = (root) ->
    $root = $(root or document)
    for thingWithCounter in $root.find("[data-#{config.mainSelector}]")
      thingWithCounter = $(thingWithCounter)
      thingToCount = $(thingWithCounter.data(config.mainSelector))

      text = valueMethod(thingWithCounter)
      valueMethod(thingWithCounter, text.replace(/\d+/, thingToCount.length))
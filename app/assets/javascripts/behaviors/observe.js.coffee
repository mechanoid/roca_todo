namespace 'todoMVC.observe', (exports) ->
  config = exports.config =
    mainSelector: 'observe'
    observeAction: 'observe-action'
    allowedActions: ['detach', 'show', 'hide']

  exports.install = (root) ->
    $root = $(root or document)
    observer = $root.find("[data-#{config.mainSelector}]")
    target = observer.data(config.mainSelector)
    action = observer.data(config.observeAction)
    targets = $root.find(target)
    targets[action]() if action in config.allowedActions
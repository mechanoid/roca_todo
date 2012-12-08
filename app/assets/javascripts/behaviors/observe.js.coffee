namespace 'todoMVC.observe', (exports) ->
  config = exports.config =
    observeSelector: 'observe'
    observeAction: 'observe-action'
    allowedActions: ['detach', 'show', 'hide']

  exports.install = (root) ->
    $root = $(root or document)
    observer = $root.find("[data-#{config.observeSelector}]")
    target = observer.data(config.observeSelector)
    action = observer.data(config.observeAction)
    targets = $root.find(target)
    targets[action]() if action in config.allowedActions
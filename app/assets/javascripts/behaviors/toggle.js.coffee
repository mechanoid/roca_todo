namespace 'todoMVC.toggle', (exports) ->
  config = exports.config =
    mainSelector: 'toggle'

  exports.install = (root) ->
    $root = $(root or document)

    # enable form submit on check
    $root.on 'click', "[data-#{config.mainSelector}]", (event) ->
      checkbox = $(this)
      checkbox.parent().submit()

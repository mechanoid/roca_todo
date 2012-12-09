namespace 'todoMVC.toggle', (exports) ->
  config = exports.config =
    mainSelector: 'toggle'

  exports.install = (root) ->
    $root = $(root or document)

    # clean up former click events on the toggle selector,
    # to avoid multiple action calls.
    $root.find("[data-#{config.mainSelector}]").off 'click'

    # enable form submit on check
    $root.find("[data-#{config.mainSelector}]").on 'click', (event) ->
      checkbox = $(this)
      checkbox.parent().submit()

namespace 'todoMVC.toggle', (exports) ->

  config = exports.config =
    toggleDataSelector: 'toggle'


  exports.install = (root) ->
    $root = $(root or document)

    # enable form submit on check
    $root.find("[data-#{config.toggleDataSelector}]").on 'click', (event) ->
      checkbox = $(this)
      checkbox.parent().submit()


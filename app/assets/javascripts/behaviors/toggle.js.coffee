namespace 'todoMVC.toggle', (exports) ->

  config = exports.config =
    toggleDataSelector: 'toggle'


  exports.install = (root) ->
    $root = $(root or document)

    # clean up former click events on the toggle selector,
    # to avoid multiple action calls.
    $root.find("[data-#{config.toggleDataSelector}]").off 'click'

    # enable form submit on check
    $root.find("[data-#{config.toggleDataSelector}]").on 'click', (event) ->
      console.log "huh"
      checkbox = $(this)
      checkbox.parent().submit()


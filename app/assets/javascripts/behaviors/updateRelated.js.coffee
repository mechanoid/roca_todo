namespace 'todoMVC.updateRelated', (exports) ->
  config = exports.config =
    relatedDataSelector: 'related'
    clearSwitch: 'related-clear'
    updateAction: 'related-action'
    allowedActions: ['after', 'before', 'insertBefore', 'insertAfter', 'prepend', 'append', 'detach', 'hide', 'show']

  handleData = (element, action, data) ->
    if not action
        element.replaceWith(data)
    else if action is 'detach'
      element.detach()
    else
      element[action](data) if action in config.allowedActions

  clearForm = (form) ->
    form.find('input').not(':submit').val ''


  exports.install = (root) ->
    $root = $(root or document)
    # cleaning former event bindings, in case the form has not be rerendered
    $root.off 'ajax:success', "[data-#{config.relatedDataSelector}]"

    # re-bind event in case the form has rerendered
    $root.on 'ajax:success', "[data-#{config.relatedDataSelector}]", (event, data) ->
      elem = $(event.currentTarget)
      related = $(elem.data(config.relatedDataSelector))
      action = elem.data(config.updateAction)

      handleData(related, action, data)
      clearForm(elem) if elem.data(config.clearSwitch)

      $root.trigger('dom:changed')

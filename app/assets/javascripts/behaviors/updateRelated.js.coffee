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
    $root.off 'ajax:success', "form[data-#{config.relatedDataSelector}]"

    # re-bind event in case the form has rerendered
    $root.on 'ajax:success', "form[data-#{config.relatedDataSelector}]", (event, data) ->
      form = $(event.currentTarget)
      related = $(form.data(config.relatedDataSelector))
      action = form.data(config.updateAction)

      handleData(related, action, data)
      clearForm(form) if form.data(config.clearSwitch)

      $root.trigger('dom:changed')

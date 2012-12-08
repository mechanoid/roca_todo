namespace 'todoMVC.updateRelated', (exports) ->
  config = exports.config =
    relatedDataSelector: 'related'
    clearSwitch: 'related-clear'
    updateAction: 'related-action'
    allowedActions: ['after', 'before', 'insertBefore', 'insertAfter', 'prepend', 'append']

  insertData = (element, action, data) ->
    unless action
        element.replaceWith(data)
      else
        element[action](data) if action in config.allowedActions

  clearForm = (form) ->
    form.find('input').not(':submit').val ''


  exports.install = (root) ->
    $root = $(root or document)
    $root.on 'ajax:success', "form[data-#{config.relatedDataSelector}]", (event, data) ->
      form = $(event.currentTarget)
      related = $(form.data(config.relatedDataSelector))
      action = form.data(config.updateAction)

      insertData(related, action, data)
      clearForm(form) if form.data(config.clearSwitch)

      $root.trigger('dom:changed')

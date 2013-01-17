namespace 'eventr', (exports) ->
  # Eventr is an abstract base class, which gives us
  # a sense of which classes are made as Eventr Root Classes.
  class Eventr
  # helper to provide access to the class level attributes
  # and functions in a more dynamic behavior.
    eigenClass: => this.__proto__.constructor

    # data-* attribute for eventr class data-binding.
    # e.g. data-eventr on class level.
    @dataBinder: 'eventr'

    dataBinder: => @eigenClass().dataBinder


  # Promotr is the bread and butter stuff of this library.
  # It supports the idea of promoting data on events,
  # which can be named dynamically at data-tag structur level.
  class Promotr extends Eventr
    constructor: (@promotr, @root) ->

      # promoting the given event data to the specified event,
      # in the data-attribute specified in the dataBinder.
    promote: (data) ->
      console.log 'promoting', @promotr.data('promote')
#      @root.trigger(@promotr.data('promote'), [data, @promotr.data('promotr-id')])
      eventName = @promotr.data('promote')
#      @promotr.trigger(eventName, [data, @promotr.data('promotr-id')])
      @root.find("[data-prepend-on], [data-replace-on]").trigger(eventName, [data, @promotr.data('promotr-id')] )
      console.log @root.find("[data-prepend-on]")

    # dataBinder for the Promotr class
    @dataBinder: 'promote'

    # initializer for all promotor entities on the page.
    # This function should be called once, and every time the
    # given elements are reloaded in a dom change.
    @initialize: (root) ->
      # giving a possibility to chain the event initialization
      # not always on the document level.
      $root = $(root or document)

      # removing pre-defined event listeners for re-initialization.
      #      $root.off 'ajax:success', "[data-#{@dataBinder}]"

      # setting listeners for each element specified by the
      # dataBinder attribute which promote the evented data.
      $root.on 'ajax:success', "[data-#{@dataBinder}]", (event, data) ->
        new Promotr($(event.currentTarget), $root).promote(data)

  # Consumr is also more of an abstract class, which serves
  # as base class for other consumers with concrete behavior.
  # The behavior of a class is implemented in the consume instance
  # function, which is the hook provided by the promotions lookup.
  class Consumr extends Eventr
    constructor: (@consumr, @root) ->

    handlePromotion: (event, data, promotrId) =>
      handler = event.handleObj
      eventNamespaceId = '' + handler.namespace.split('.')[0]
      if promotrId isnt undefined
        promotrId  = '' + promotrId
        @consume(data, promotrId, event) if eventNamespaceId is promotrId
      else
        @consume(data, event)

    # Method which sets listeners for the events specified in the
    # dataBinder attribute, which call a hook to the consume method
    # where the data handling can be specified.
    lookForPromotions: (selector) =>
      @root.on @eventName(), selector, (event, data, promotr) =>
        @handlePromotion(event, data, promotr)
        event.stopPropagation()
        console.log @consumr
        false

    eventName: => @consumr.data(@dataBinder())

    # Abstract Method: Is used as hook for consumers
    consume: (data) =>

    @initialize: (root) ->
      $root = $(root or document)
      consumerSelector = "[data-#{@dataBinder}]"
      new this($(consumer), $root).lookForPromotions(consumerSelector) for consumer in $root.find(consumerSelector)

  ### ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ++ CONSUMER DESCENDANTS ++++++++++++++++++++++++++++++++++++++
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ ###

  class Prependr extends Consumr
    @dataBinder: 'prepend-on'
    consume: (data) => @consumr.prepend(data)

  class Appendr extends Consumr
    @dataBinder: 'append-on'
    consume: (data) => @consumr.append(data)

  class Replacr extends Consumr
    @dataBinder: 'replace-on'
    consume: (data) => @consumr.html(data)

  class Countr extends Consumr
  # value is a more generic getter and setter for values
  # working for elements with an value attribute, which should
  # be updated.
    value: (params...) ->
      # value method for elements, sporting a value attribute
      return @consumr.attr('value', params...) if @consumr.attr('value')
      # value attribute for container elements
      @consumr.html(params...)

    countSelector: => @consumr.data('count-what')
    elementCount: => $(@countSelector()).length
    replaceNumber: (text, count) => text.replace(/\d+/, count)
    updateCounter: =>
      currentValue = @value()
      newCount = @elementCount()
      @value(@replaceNumber(currentValue, newCount))

    @dataBinder: 'count-on'

    consume: => @updateCounter()

  class Cleanr extends Consumr
    @dataBinder: 'clean-on'
    consume: => @consumr.find('input').not(':submit, :hidden').val ''


  exports.setup = (root) ->
    $root = (root or document)
    type.initialize($root) for type in [Promotr, Prependr, Replacr, Appendr, Cleanr, Countr]



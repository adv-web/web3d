class Component

  constructor: ->
    @gameObject = null
    @name = "component" # subclass should override it

  receive: (args...) =>

module.exports = Component
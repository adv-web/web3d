# The component of a game object.
#
# A component has its lifecycle, you can alternatively implement these methods as you need:
#
# - afterAdded():    Called when the component added to a game object.
#
# - update():        Called when the game update every frame.
#
# - beforeRemoved(): Called when the component ready to detach from its game object.
class Component
  module.exports = this

  # @property [String] the name of the component, every subclass should overwrite it with unique value
  name: "Component"

  # @property [GameObject] the game object of the component
  gameObject: null

  # Construct a new component.
  # @param name [String] the name of the component
  constructor: (@name) ->
    @gameObject = null

  # Receive a message from its game object.
  #
  # Automatically called when GameObject#broadcast is invoked.
  # @param args [Array<Object>] the message received
  receive: (args...) =>

# The basic object in scene, can contain many components.
class GameObject
  module.exports = this

  # @property [THREE.Mesh] the mesh of the game object
  mesh: null

  # @property [Object] the key-value pair of components and theirs name. e.g. {name1: component1, name2: component2}
  components: {}

  # Construct a new game object.
  # @param mesh [THREE.Mesh | Physijs.Mesh] the mesh of the game object
  constructor: (@mesh) ->

  # Add a component to the game object.
  # @param component [Component] the component to be added
  addComponent: (comp) =>
    comp.gameObject = this
    @components[comp.name] = comp
    comp.afterAdded?()

  # Get the component of the given name.
  # @param name [String] the name of the component
  # @return [Component] the component of the given name
  getComponent: (name) =>
    @components[name]

  # Remove the component of the given name.
  # @param name [String] the name of the component
  removeComponent: (name) =>
    comp = @components[name]
    return if not comp?
    comp.beforeRemoved?()
    comp.gameObject = null
    @components[name] = null

  # Broadcast messages to all of its components
  # @param args [Array<Object>] the message to be broadcast
  broadcast: (args...) =>
    comp.receive(args...) for name, comp of @components

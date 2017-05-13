Game = require("./Game")
# The basic object in scene, can contain many components.
class GameObject
  module.exports = this

  # @property [boolean] to identify whether it is a game object, you should not change it
  isGameObject: true

  # @property [THREE.Mesh | Physijs.Mesh] the mesh of the game object, especially, you can call mesh.gameObject to get the game object of mesh
  mesh: null

  # @property [Object] the key-value pair of components and theirs name. e.g. {name1: component1, name2: component2}
  components: {}

  @property 'mesh',
    get: -> @_mesh
    set: (mesh) ->
      if @_mesh?
        @_mesh.gameObject = null
        Game.scene?._scene.remove(@_mesh) # scene.remove 会 remove gameObject， 而这里只是切换 mesh
      @_mesh = mesh # 切换 mesh
      if mesh?
        mesh.gameObject = this
        Game.scene?._scene.add(mesh)

  # Construct a new game object.
  # @param mesh [THREE.Mesh | Physijs.Mesh] the mesh of the game object
  constructor: (@mesh,@name) ->
    @components = {}
    @isGameObject = true

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

  # Be called when this object is to be removed from the seen
  # usually do some destroying work here.
  beforeRemoved: () =>
    for key, comp of @components
      comp.beforeRemoved?()

  # Broadcast messages to all of its components
  # @param args [Array<Object>] the message to be broadcast
  broadcast: (args...) =>
    comp.receive(args...) for name, comp of @components

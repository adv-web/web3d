# The scene in game to contain game objects and other essential objects.
#
# To render the scene, it will auto detect cameras and save it to an array when add a game object to the scene.
# But if there are multiply cameras in a scene, only the first one will be used to render.
class Scene
  module.exports = this

  # Construct a scene use an initializer.
  # @param initializer [Function] the user-defined initialize function to add objects in the scene
  constructor: (initializer) ->
    @_scene = new Physijs.Scene()
    @_cameras = []
    @_objects = []
    initializer(this)

  # This is a generic Scene add method.
  #
  # @overload add(gameObject)
  #   Add a game object to the scene.
  #   @param [GameObject] gameObject the game object to be added
  #
  # @overload add(object)
  #   Add a light/skybox or any not GameObject to the scene.
  #   @param [Object] object the object to be added
  add: (object) =>
    if object.isGameObject
      @_objects.push(object)
      @_scene.add(object.mesh)
      @_cameras.push(object.getComponent("Camera")._camera) if object.getComponent("Camera")?
    else
      @_scene.add(object)

  # This is a generic Scene remove method.
  #
  # @overload remove(gameObject)
  #   Remove a game object to the scene.
  #   @param [GameObject] gameObject the game object to be removed
  #
  # @overload remove(mesh)
  #   Remove a game object of this mesh to the scene. It's equal to use remove(mesh.gameObject).
  #   @param [THREE.Mesh | Physijs.Mesh] mesh the mesh of the game object to be removed
  #
  # @overload remove(object)
  #   Remove a light/skybox or any not GameObject or Mesh to the scene.
  #   @param [Object] object the object to be removed
  remove: (object) =>
    return @_removeGameObject(object) if object.isGameObject
    return @_removeGameObject(object.gameObject) if object.isMesh
    @_scene.remove(object)  # not game object or mesh

  # @private
  _removeGameObject: (object) =>
    return if not object?
    @_cameras.remove(object.getComponent("Camera")._camera) if object.getComponent("Camera")?
    @_scene.remove(object.mesh) if object.mesh?
    @_objects.remove(object)

  # @nodoc
  update: (deltaTime) =>
    comp.update?(deltaTime) for name, comp of object?.components for object in @_objects
    @_scene.simulate()  # for physical simulation


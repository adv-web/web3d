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
  #   Add a game object to the scene
  #   @param [GameObject] gameObject the game object to be added
  #
  # @overload add(object)
  #   Add a light/skybox or any not GameObject to the scene
  #   @param [Object] object the object to be added
  add: (object) =>
    if object.isGameObject
      @_objects.push(object)
      @_scene.add(object.mesh)
      @_cameras.push(object.getComponent("Camera")._camera) if object.getComponent("Camera")?
    else
      @_scene.add(object)

  # Remove a game object.
  # @param object [GameObject] the game object to be removed
  removeObject: (object) =>
    @_scene.remove(object.mesh)
    # TODO

  # Remove a game object by its mesh.
  # @param mesh [THREE.Mesh | Physijs.Mesh] the mesh of game object to be removed
  removeObjectByMesh: (mesh) =>
    @_scene.remove(mesh)
    # TODO 根据 uuid 判断删除

  # @nodoc
  update: (deltaTime) =>
    comp.update?(deltaTime) for name, comp of object.components for object in @_objects
    @_scene.simulate()  # for physical simulation


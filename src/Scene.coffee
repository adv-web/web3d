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

  # Add a game object to the scene
  # @param object [GameObject] the game object to be added
  addObject: (object) =>
    @_objects.push(object)
    @_scene.add(object.mesh)
    @_cameras.push(object.getComponent("camera")._camera) if object.getComponent("camera")?

  # Add a light to the scene
  # @param light [THREE.Light] the light to be added
  addLight: (light) =>
    @_scene.add(light)

  # @nodoc
  update: () =>
    comp.update?() for name, comp of object.components for object in @_objects
    @_scene.simulate()  # for physical simulation



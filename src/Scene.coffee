# The scene in game to contain game objects and other essential objects.
class Scene
  module.exports = this

  # Construct a scene use an initializer.
  # @param initializer [Function] the user-defined initialize function to add objects in the scene
  constructor: (initializer) ->
    @_scene = new Physijs.Scene()
    @camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 10000)
    @camera.position.set(0, -0.5, 1);
    @objects = []
    initializer(this)

  # Add a game object to the scene
  # @param object [GameObject] the game object to be added
  addObject: (object) =>
    @objects.push(object)
    @_scene.add(object.mesh)

  # Add a light to the scene
  # @param light [THREE.Light] the light to be added
  addLight: (light) =>
    @_scene.add(light)

  # @nodoc
  update: () =>
    comp.update?() for name, comp of object.components for object in @objects
    @_scene.simulate()  # for physical simulation



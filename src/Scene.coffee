module.exports = class #Scene

  constructor: (initializer) ->
    @_scene = new Physijs.Scene()
    @camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 10000)
    @camera.position.set(0, -0.5, 1);
    @objects = []
    initializer(this)

  addObject: (object) =>
    @objects.push(object)
    @_scene.add(object.mesh)

  addLight: (light) =>
    @_scene.add(light)

  update: () =>
    comp.update?() for name, comp of object.components for object in @objects
    @_scene.simulate()  # for physical simulation

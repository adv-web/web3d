module.exports = class #Scene

  constructor: (initializer) ->
    @pscene = new Physijs.Scene()
    @camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 10000)
    @camera.position.set(0, -0.5, 1);
    @objects = []
    initializer(this)

  addObject: (object) =>
    @objects.push(object)
    @pscene.add(object.mesh)

  addLight: (light) =>
    @pscene.add(light)

  update: () =>
    comp.update?() for name, comp of object.components for object in @objects
    @pscene.simulate()  # for physical simulation



Component = require("../Component")

class TreeCollider extends Component
  module.exports = this

  constructor: (@_scene) ->
    super("TreeCollider")

  afterAdded: =>
    @gameObject.mesh.addEventListener('collision', @_onCollision);

  beforeRemoved: =>
    @gameObject.mesh.removeEventListener('collision', @_onCollision)

  _onCollision: (other_mesh, linear_velocity, angular_velocity) =>
    if other_mesh.name == "bullet"
      @_scene.removeObject(@gameObject)
      @_scene.removeObjectByMesh(other_mesh)
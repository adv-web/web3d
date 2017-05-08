Component = require("../Component")
# The tree collider. It uses on tree and deal with its collision events.
#
# name = "TreeCollider"
class TreeCollider extends Component
  module.exports = this

  # Construct a tree collider.
  # @param scene [Scene] the scene its game object in
  constructor: (@_scene) ->
    super("TreeCollider")
    window.PlayerInfo = window.PlayerInfo || {} # not good behavior
    PlayerInfo.hitCount = 0 if not PlayerInfo.hitCount?

  # @nodoc
  afterAdded: =>
    @gameObject.mesh.addEventListener('collision', @_onCollision)

  # @nodoc
  beforeRemoved: =>
    @gameObject.mesh.removeEventListener('collision', @_onCollision)

  # @private
  _onCollision: (other_mesh, linear_velocity, angular_velocity) =>
    if other_mesh.name == "bullet"
      @_scene.removeObject(@gameObject)
      @_scene.removeObjectByMesh(other_mesh)
      PlayerInfo.hitCount += 1
Component = require("../Component")
NetWorkManager = require('../NetWorkManager')
# The tree collider. It uses on tree and deal with its collision events.
#
# name = "TreeCollision"
class TreeCollision extends Component
  module.exports = this

  # Construct a tree collider.
  # @param scene [Scene] the scene its game object in
  constructor: ->
    super("TreeCollision")
    window.PlayerInfo = window.PlayerInfo || {} # not good behavior
    PlayerInfo.hitCount = 0 if not PlayerInfo.hitCount?

  # @private
  onCollision: (other_mesh, linear_velocity, angular_velocity) =>
    if other_mesh.name == "bullet"
      PlayerInfo.hitCount += 1 # client predict
      NetWorkManager.remove(@gameObject,(result) =>
        if not result
          PlayerInfo.hitCount -= 1 # predict error and roll back
      )

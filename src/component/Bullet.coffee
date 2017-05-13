Component = require("../Component")
ExplodeAnimation = require("./ExplodeAnimation")
Game = require("../Game")
# The bullet component. It will call an explode animation when collision and destroy itself.
#
# name = "Bullet"
class Bullet extends Component
  module.exports = this

  # Constructor a bullet.
  constructor: () ->
    super("Bullet")

  # @nodoc
  afterAdded: =>
    @gameObject.mesh.addEventListener('collision', @_onCollision)

  # @nodoc
  beforeRemoved: =>
    @gameObject.mesh?.removeEventListener('collision', @_onCollision)

  # @private
  _onCollision: (other_mesh, linear_velocity, angular_velocity) =>
    @gameObject.addComponent(new ExplodeAnimation(@_onExplodeFinish))
    @gameObject.mesh.removeEventListener('collision', @_onCollision)
    @gameObject.mesh = null

  # @private
  _onExplodeFinish: =>
    Game.scene.remove(@gameObject)
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
    @_explode = false

  # @private
  onCollision: (other_mesh, linear_velocity, angular_velocity) =>
    if not @_explode  # 保证只触发一次
      @gameObject.addComponent(new ExplodeAnimation(@_onExplodeFinish))
      @_explode = true
      @gameObject.mesh = null

  # @private
  _onExplodeFinish: =>
    Game.scene.remove(@gameObject)

  _launch: (mass, velocity) =>
    @gameObject.mesh.mass = mass
    @gameObject.mesh.setLinearVelocity(velocity)

  receive: (args...) =>
    data = args[0]
    return if data.method != "launch"
    @_launch(0.0006, new THREE.Vector3(data.x, data.y, data.z))

Component = require("../Component")
ExplodeAnimation = require("./ExplodeAnimation")
Game = require("../Game")
AudioSource = require('./AudioSource')
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
      @_explode = true # 已触发
      # 爆炸效果
      @gameObject.addComponent(new ExplodeAnimation(@_onExplodeFinish))
      @gameObject.mesh = null

  # @private
  _onExplodeFinish: =>
    Game.scene.remove(@gameObject)

  # @private
  _launch: (mass, velocity) =>
    AudioSource.play('/client/audio/fire.mp3', 1) # source, volume
    @gameObject.mesh?.mass = mass
    @gameObject.mesh?.setLinearVelocity(velocity)

  # @nodoc
  receive: (args...) =>
    data = args[0]
    return if data.method != "launch"
    console.log data
    @gameObject.mesh?.userData = data
    @_launch(0.0006, new THREE.Vector3(data.x, data.y, data.z))

NetWorkComponent = require("./NetWorkComponent")
GameObject = require("../GameObject")
Game = require("../Game")
Bullet = require("./Bullet")
# The first-person shooter, give you the ability that,
# when you click mouse, a small ball will be generated and fly to your first-person direction.
# The ball has it collider, you can detect it by assert other_mesh.name = 'bullet'.
#
# name = "FirstPersonShooter"
class FirstPersonShooter extends NetWorkComponent
  module.exports = this

  # @property [number] the cool down time (ms), initially 1000
  cooldown: 1000

  # @property [number] the initial speed of bullet, initially 10
  bullet_speed: 10

  # @property [number] the radius of bullet, initially 0.05
  bullet_size: 0.05

  # @property [number] the color of bullet, initially 0xffff00 (yellow)
  bullet_color: 0xffff00

  # Constructor a first-person shooter.
  # @param controller [FirstPersonController] the first-person controller it relates to
  # @param options [Object] the optional parameters
  # @option options [number] cooldown the cool down time (ms)
  # @option options [number] bullet_speed the initial speed of bullet
  # @option options [number] bullet_size the radius of bullet
  # @option options [number] bullet_color the color of bullet
  constructor: (@_controller, options = {}) ->
    super("FirstPersonShooter")
    @_lastFireTime = 0
    @cooldown = if options.cooldown? then options.cooldown else 1000
    @bullet_speed = if options.bullet_speed? then options.bullet_speed else 10
    @bullet_size = if options.bullet_size? then options.bullet_size else 0.05
    @bullet_color = if options.bullet_color? then options.bullet_color else 0xffff00

  # @nodoc
  afterAdded: =>
    document.body.onclick = @_onFire

  # @nodoc
  beforeRemoved: =>
    document.body.onclick = null

  # @private
  _onFire: =>
    # return if not @isLocal
    # 确认冷却时间
    currentTime = new Date()
    return if currentTime - @_lastFireTime < @cooldown
    @_lastFireTime = currentTime
    # 创造子弹
    Game.scene.add(bullet = @_makeBullet())
    rot_y = @_controller._yaw.rotation.y
    rot_x = @_controller._pitch.rotation.x
    # 这里的设置速度是世界坐标系。好不容易调出来的方向
    bullet.mesh.setLinearVelocity(new THREE.Vector3(-Math.sin(rot_y) * Math.cos(rot_x) * @bullet_speed, Math.sin(rot_x) * @bullet_speed, -Math.cos(rot_y) * Math.cos(rot_x) * @bullet_speed))

  # @private
  _makeBullet: =>
    geometry = new THREE.SphereGeometry(@bullet_size)
    material = new THREE.MeshBasicMaterial({color: @bullet_color})
    mesh = new Physijs.SphereMesh(geometry, material)
    worldPosition = @gameObject.mesh.position
    mesh.position.set(worldPosition.x, worldPosition.y + 0.5, worldPosition.z)
    mesh.name = "bullet"
    obj = new GameObject(mesh)
    obj.addComponent(new Bullet())
    return obj
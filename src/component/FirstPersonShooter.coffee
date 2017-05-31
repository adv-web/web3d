NetWorkComponent = require("./NetWorkComponent")
Input = require("../Input")
NetWorkManager = require("../NetWorkManager")
Data = require("../Data")
# The first-person shooter, give you the ability that,
# when you click mouse, a small ball will be generated and fly to your first-person direction.
# The ball has it collider, you can detect it by assert other_mesh.name = 'bullet'.
#
# name = "FirstPersonShooter"
class FirstPersonShooter extends NetWorkComponent
  module.exports = this

  # @property [boolean] tell whether the controller is enabled, initially true
  enabled: true

  # @property [number] the cool down time (ms), initially 1000
  cooldown: 1000

  # @property [number] the initial speed of bullet, initially 10
  bullet_speed: 10

  # Constructor a first-person shooter.
  # @param options [Object] the optional parameters
  # @option options [number] cooldown the cool down time (ms)
  # @option options [number] bullet_speed the initial speed of bullet
  constructor: (options = {}) ->
    super("FirstPersonShooter")
    @enabled = false
    @_lastFireTime = 0
    @cooldown = if options.cooldown? then options.cooldown else 1000
    @bullet_speed = if options.bullet_speed? then options.bullet_speed else 10
    @bullet_size = if options.bullet_size? then options.bullet_size else 0.05
    @bullet_color = if options.bullet_color? then options.bullet_color else 0xffff00

  # @nodoc
  afterAdded: =>
    @_controller = @gameObject.getComponent("FirstPersonController")
    Input.registerClickResponse(@_onFire)
    @enabled = true

  # @nodoc
  beforeRemoved: =>
    Input.removeClickResponse(@_onFire)

  # @private
  _onFire: =>
    return if not @enabled
    return if not @isLocal
    # 确认冷却时间
    currentTime = Date.now()
    return if currentTime - @_lastFireTime < @cooldown
    @_lastFireTime = currentTime
    # 创造子弹
    worldPosition = @gameObject.mesh.position
    pos = new THREE.Vector3(worldPosition.x, worldPosition.y + 0.5, worldPosition.z)
    rot_y = @_controller._yaw.rotation.y
    rot_x = @_controller._pitch.rotation.x
    # 计算速度分量
    vx = -Math.sin(rot_y) * Math.cos(rot_x) * @bullet_speed
    vy = Math.sin(rot_x) * @bullet_speed
    vz = -Math.cos(rot_y) * Math.cos(rot_x) * @bullet_speed
    NetWorkManager.spawn Data.prefab.bullet, {position: pos}, (obj) =>
      NetWorkManager.update(obj.id, {method: "launch", x: vx, y: vy, z: vz}) # 通知其他玩家发射子弹
      # 本地发射子弹（NetWorkManager 不发给自机）
      obj.mesh.mass = 0.0006
      obj.mesh.setLinearVelocity(new THREE.Vector3(vx, vy, vz)) # 这里的设置速度是世界坐标系

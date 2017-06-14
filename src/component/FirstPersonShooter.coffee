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
  cooldown: 5000

  # @property [number] the initial speed of bullet, initially 30
  bullet_speed: 30

  # Constructor a first-person shooter.
  # @param options [Object] the optional parameters
  # @option options [number] cooldown the cool down time (ms)
  # @option options [number] bullet_speed the initial speed of bullet
  constructor: (options = {}) ->
    super("FirstPersonShooter")
    @enabled = false
    @_lastFireTime = 0
    @cooldown = if options.cooldown? then options.cooldown else 5000
    @bullet_speed = if options.bullet_speed? then options.bullet_speed else 30
    @bullet_size = if options.bullet_size? then options.bullet_size else 0.05
    @bullet_color = if options.bullet_color? then options.bullet_color else 0xffff00

  # @nodoc
  afterAdded: =>
    @_tank = @gameObject.getComponent("Tank") # 伤害根据 tank 类型来定，因此有耦合，prefab 中应该在 tank 后
    Input.registerClickResponse(@_onFire)
    @enabled = true

  # @nodoc
  beforeRemoved: =>
    Input.removeClickResponse(@_onFire)

  # @nodoc
  update: =>  # 更新冷却时间计时器（setInterval 不准确）
    timeleft = @cooldown - (Date.now() - @_lastFireTime)
    return if timeleft < -100
    if timeleft < 0
      $("#coldtime").hide()
      $("#aim").show()
    else
      $("#coldtime-sec").text(Math.ceil(timeleft / 1000))
      $("#aim").hide()
      $("#coldtime").show()

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
    direction = @gameObject.mesh.getWorldDirection()
    # 计算子弹发射位置
    px = worldPosition.x - direction.x * 0.9
    py = worldPosition.y + 0.3 - direction.y * 0.9
    pz = worldPosition.z - direction.z * 0.9
    pos = new THREE.Vector3(px, py, pz)
    # 计算速度分量
    vx = -direction.x * @bullet_speed
    vy = -direction.y * @bullet_speed
    vz = -direction.z * @bullet_speed
    NetWorkManager.spawn Data.prefab.bullet, {position: pos}, (obj) =>
      NetWorkManager.update(obj, {method: "launch", x: vx, y: vy, z: vz, type: @_tank.type}) # 通知其他玩家发射子弹
      # 本地发射子弹（NetWorkManager 不发给自己）
      obj.mesh.mass = 0.0006
      obj.mesh.setLinearVelocity(new THREE.Vector3(vx, vy, vz)) # 这里的设置速度是世界坐标系
    # 显示计时器
    $("#coldtime-sec").text(Math.ceil(@cooldown / 1000))
    $("#aim").hide()
    $("#coldtime").show()



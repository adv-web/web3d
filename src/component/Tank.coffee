NetWorkComponent = require("./NetWorkComponent")
NetWorkManager = require("../NetWorkManager")
Data = require("../Data")
Input = require("../Input")
$ = require("jquery")
# The tank component is important to deal with game logic.
# It provides damage detecting and calculating, and update users' states
#
# name = "Tank"
class Tank extends NetWorkComponent
  module.exports = this

  @DAMAGE = {"MT": 300, "SPG": 1800, "LT": 280, "HT": 350, "TD": 400}
  @HP = {"MT": 1400, "SPG": 350, "LT": 1100, "HT": 1600, "TD": 1100}
  @NAME = {"MT": "中坦", "SPG": "火炮", "LT": "轻坦", "HT": "重坦", "TD": "坦歼"}
  @LEVEL = [null, "MT", "HT", "TD", "LT", "SPG"]

  @GOD_TIME = 5000 # 重生无敌时间

  # Construct a tank.
  constructor: () ->
    super("Tank")
    @userInfo = document.userInfo
    @_respawnTime = 0

  # @private
  onCollision: (other_mesh, linear_velocity, angular_velocity) =>
    return if not @isLocal
    return if other_mesh.name != "bullet"
    return if Date.now() - @_respawnTime < Tank.GOD_TIME  # 无敌时间内不扣血
    # 计算伤害和血量
    console.log("be hit")
    @_beHitEffect()
    damage = Tank.DAMAGE[other_mesh.userData.type]
    damage += damage * (Math.random() * 10 - 5) / 100
    realHP = Tank.HP[@userInfo.type] * @userInfo.hp - damage
    console.log realHP
    @userInfo.hp = if realHP < 0 then 0 else realHP / Tank.HP[@userInfo.type]
    NetWorkManager.update(other_mesh.gameObject.reqPlayerId, {method: "deal_damage", damage: damage, killed: @userInfo.hp == 0})
    @_respawn() if @userInfo.hp == 0 # 打死了则复活
    NetWorkManager.updateUserInfo(@userInfo)
    document.setUserInfo(@userInfo)

  # @nodoc
  receive: (args...) =>
    data = args[0]  # 表示自己对他人造成了伤害
    if data.method == "deal_damage" # 计算奖励经验和分数
      profit = data.damage + (if data.killed then 100 else 0)
      @getExp(profit)
      @userInfo.score += Math.floor(profit)
      NetWorkManager.updateUserInfo(@userInfo)
      document.setUserInfo(@userInfo)
    else if data.method == "change_mesh" and not @isLocal # 更改别人的坦克模型
      @_changeMesh(data.level)
      #document.setUserInfo(@userInfo)

  # @nodoc
  update: =>
    return if not @isLocal
    # 检测本地玩家是否翻车或掉下悬崖
    @_respawn() if @gameObject.mesh.position.y < -10
    @_respawn() if Input.isPressed('R') and Date.now() - @_respawnTime > Tank.GOD_TIME  # 按 R 复活，5s cd
    # 检测是否在房子周围回血
    distanceToHouse = @gameObject.mesh.position.distanceTo(new THREE.Vector3(0, 0, 0))
    if distanceToHouse < 3 and @userInfo.hp < 1
      console.log "recovering"
      @userInfo.hp += 0.0005
      $(".HP-data").width(107 * @userInfo.hp); # 107 is hacking
      #document.setUserInfo(@userInfo)

  # Get exp. User may level up by this.
  # @param exp [number] the absolute exp user get, usually a positive number
  getExp: (exp) =>
    return if not @isLocal
    realEXP = Tank.HP[@userInfo.type] * @userInfo.exp + exp
    # 是否升级
    if realEXP >= Tank.HP[@userInfo.type] && @userInfo.level < 5
      realEXP -= Tank.HP[@userInfo.type]
      @userInfo.level += 1
      @_updateInfoByLevel()
      console.log "lv" + @userInfo.level
      @_changeMesh(@userInfo.level)
      NetWorkManager.update(@gameObject, {method: "change_mesh", level: @userInfo.level})
    @userInfo.exp = realEXP / Tank.HP[@userInfo.type]
    @userInfo.exp = 1 if @userInfo.exp > 1
    document.setUserInfo(@userInfo)

  # @private
  _changeMesh: (level) =>
    meshName = "tank_" + Tank.LEVEL[level].toLowerCase()
    @gameObject.mesh.geometry = Data.vox[meshName].geometry
    @gameObject.mesh.material = Data.vox[meshName].material

  # @private
  _respawn: =>
    pz = if Math.random() > 0.5 then 18 else -18
    @gameObject.mesh.position.set(0, 1, pz)
    @gameObject.mesh.__dirtyPosition = true
    @gameObject.mesh.rotation.set(0, 0, 0)
    @gameObject.mesh.__dirtyRotation = true
    @userInfo.score -= Math.floor(Tank.HP[@userInfo.type] / 10) # 分数惩罚
    @userInfo.exp = 0 # 经验惩罚
    @userInfo.level -= 1;
    @userInfo.level = 1 if @userInfo.level < 1
    @_updateInfoByLevel()
    @_changeMesh(@userInfo.level)
    NetWorkManager.update(@gameObject, {method: "change_mesh", level: @userInfo.level}) # 降级通知换 mesh
    @_respawnTime = Date.now()
    @userInfo.hp = 1
    document.setUserInfo(@userInfo)

  # @private
  _updateInfoByLevel: =>
    type = @userInfo.type = Tank.LEVEL[@userInfo.level]
    @userInfo.power = Tank.DAMAGE[type]
    @userInfo.equipment = Tank.NAME[type]

  # @private
  _beHitEffect: =>
    $("#twinkle").fadeTo(100, 0.3, () => $("#twinkle").fadeOut(100))
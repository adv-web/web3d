NetWorkComponent = require("./NetWorkComponent")
NetWorkManager = require("../NetWorkManager")
class Tank extends NetWorkComponent
  module.exports = this

  @DAMAGE = {"MT": 300, "SPG": 1800, "LT": 280, "HT": 350, "TD": 400}
  @HP = {"MT": 1400, "SPG": 350, "LT": 1100, "HT": 1600, "TD": 1100}
  @NAME = {"MT": "中坦", "SPG": "火炮", "LT": "轻坦", "HT": "重坦", "TD": "坦歼"}
  @LEVEL = [null, "MT", "HT", "TD", "LT", "SPG"]

  @GOD_TIME = 5000 # 重生无敌时间

  #type: "MT"

  constructor: () ->
    super("Tank")
    @userInfo = document.userInfo
    @_respawnTime = 0
    #@type = "MT"

  # @private
  onCollision: (other_mesh, linear_velocity, angular_velocity) =>
    return if not @isLocal
    return if other_mesh.name != "bullet"
    return if Date.now() - @_respawnTime < Tank.GOD_TIME  # 无敌时间内不扣血
    # 计算伤害和血量
    damage = Tank.DAMAGE[other_mesh.userData.type]
    damage += damage * (Math.random() * 10 - 5) / 100
    realHP = Tank.HP[@userInfo.type] * @userInfo.hp - damage
    @userInfo.hp = if realHP < 0 then 0 else realHP / Tank.HP[@userInfo.type]
    NetWorkManager.update(other_mesh.gameObject.reqPlayerId, {damage: damage, killed: @userInfo.hp == 0})
    @_respawn() if @userInfo.hp == 0 # 打死了则复活
    NetWorkManager.updateUserInfo(@userInfo)
    document.setUserInfo(@userInfo)

  receive: (args...) =>
    data = args[0]  # 表示自己对他人造成了伤害
    # 计算奖励经验和分数
    profit = data.damage + (if data.killed then 100 else 0)
    realEXP = Tank.HP[@userInfo.type] * @userInfo.exp + profit
    @userInfo.score += profit
    # 是否升级
    if realEXP >= Tank.HP[@userInfo.type] && @userInfo.level < 5
      realEXP -= Tank.HP[@userInfo.type]
      @userInfo.level += 1
      @_updateInfoByLevel()
    @userInfo.exp = realEXP / Tank.HP[@userInfo.type]
    @userInfo.exp = 1 if @userInfo.exp > 1
    NetWorkManager.updateUserInfo(@userInfo)
    document.setUserInfo(@userInfo)

  _respawn: =>
    pz = if Math.random() > 0.5 then 18 else -18
    @gameObject.mesh.position.set(0, 1, pz)
    @userInfo.score -= Math.floor(Tank.HP[@userInfo.type] / 10) # 分数惩罚
    @userInfo.exp = 0 # 经验惩罚
    @userInfo.level -= 1;
    @userInfo.level = 1 if @userInfo.level < 1
    @_updateInfoByLevel()
    @_respawnTime = Date.now()

  _updateInfoByLevel: () =>
    type = @userInfo.type = Tank.LEVEL[@userInfo.level]
    @userInfo.power = Tank.DAMAGE[type]
    @userInfo.equipment = Tank.NAME[type]

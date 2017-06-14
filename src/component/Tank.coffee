NetWorkComponent = require("./NetWorkComponent")
class Tank extends NetWorkComponent
  module.exports = this

  @DAMAGE = {"MT": 300, "SPG": 1800, "LT": 280, "HT": 350, "TD": 400}
  @HP = {"MT": 1400, "SPG": 350, "LT": 1100, "HT": 1600, "TD": 1100}

  #type: "MT"

  constructor: () ->
    super("Tank")
    @userInfo = document.userInfo
    @type = "MT"

  # @private
  onCollision: (other_mesh, linear_velocity, angular_velocity) =>
    return if not @isLocal
    console.log other_mesh
    return if other_mesh.name != "bullet"
    damage = Tank.DAMAGE[other_mesh.userData.type]
    damage += damage * (Math.random() * 10 - 5) / 100
    console.log "damage" + damage
    realHP = Tank.HP[@userInfo.type] * @userInfo.hp - damage
    console.log "realHP" + realHP
    console.log "maxHP" + Tank.HP[@userInfo.type]
    @userInfo.hp = if realHP < 0 then 0 else realHP / Tank.HP[@userInfo.type]

    document.setUserInfo(@userInfo)



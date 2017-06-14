Component = require("../Component")
ExplodeAnimation = require("./ExplodeAnimation")
Game = require("../Game")

class Pumpkin extends Component
  module.exports = this

  constructor: () ->
    super("Pumpkin")
    @_explode = false

  # @private
  onCollision: (other_mesh, linear_velocity, angular_velocity) =>
    return if other_mesh.name != "player"
    if not @_explode  # 保证只触发一次
      @_explode = true # 已触发
      # 爆炸效果
      @gameObject.addComponent(new ExplodeAnimation(@_onExplodeFinish))
      @gameObject.mesh = null
      other_mesh.gameObject.getComponent("Tank").getExp(500)

  # @private
  _onExplodeFinish: =>
    Game.scene.remove(@gameObject)

Component = require("../Component")
# The HUD component. Generate HTML elements to show game info on screen.
#
# name = "HUD"
class HUD extends Component
  module.exports = this

  # Construct HUD.
  constructor: ->
    super("HUD")

  # @nodoc
  afterAdded: =>
    @_hud = document.createElement('div')
    @_hud.innerHTML = '当前玩家：CZP<br>击中数：0'
    @_hud.style.height = '100px'
    @_hud.style.width = '200px'
    @_hud.style.position = 'fixed'
    @_hud.style.backgroundColor = 'lightskyblue'
    document.body.appendChild(@_hud)

  # @nodoc
  update: =>
    @_hud.innerHTML = '当前玩家：CZP<br>击中数：' + PlayerInfo.hitCount if PlayerInfo?
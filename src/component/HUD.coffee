Component = require("../Component")

class HUD extends Component
  module.exports = this

  # @nodoc
  afterAdded: =>
    @_hud = document.createElement('div')
    @_hud.innerHTML = '<p>当前玩家：CZP，等级：99</p>'
    @_hud.style.height = '100px'
    @_hud.style.width = '200px'
    @_hud.style.position = 'fixed'
    @_hud.style.backgroundColor = 'lightskyblue'
    document.body.appendChild(@_hud)
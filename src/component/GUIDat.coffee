# Created by duocai on 2017/5/11.
NetWorkComponent = require('./NetWorkComponent')

# This component display some parameters such as velocity, jump power of the player.
#
# Notice: This component should be only added to the player Prefab
class GUIDat extends NetWorkComponent
  module.exports = @

  constructor: () ->
    super "GUIDat"

  # override the onStartLocalPlayer function and
  # add gui display
  onStartLocalPlayer: () =>
    @gui = new dat.GUI()
    fpc = @gameObject.getComponent('FirstPersonController')
    # dat
    @gui.add(fpc, 'sensitivity').min(0).step(0.5)
    @gui.add(fpc, 'move_velocity').min(0).step(0.5)
    @gui.add(fpc, 'jump_velocity').min(0).step(0.5)
    # gui.add(fpc, 'activateMoveRate').min(1).max(20).step(1)

    nwtm = @gameObject.getComponent("NetWorkTransform")
    @gui.add(nwtm, 'networkSendRate').min(1).max(50).step(1)

    bc = @gameObject.getComponent("BoxCollider")
    @gui.add(bc, 'activateMoveTime').min(1).max(100).step(1)
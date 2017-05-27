# Created by duocai on 2017/5/11.
NetWorkComponent = require('./NetWorkComponent')

class GUIDatComponent extends NetWorkComponent
  module.exports = @

  constructor: () ->
    super "GUIDatComponent"


  onStartLocalPlayer: () =>
    gui = new dat.GUI()
    fpc = @gameObject.getComponent('FirstPersonController')
    # dat
    gui.add(fpc, 'sensitivity').min(0).step(0.5);
    gui.add(fpc, 'move_velocity').min(0).step(0.5);
    gui.add(fpc, 'jump_velocity').min(0).step(0.5);

    nwtm = @gameObject.getComponent("NetWorkTransformComponent")
    gui.add(nwtm, 'networkSendRate').min(10).max(100).step(5)

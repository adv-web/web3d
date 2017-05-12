# Created by duocai on 2017/5/11.

NetWorkComponent = require('./NetWorkComponent')
NetWorkManager = require('../NetWorkManager')

class NetWorkTransformComponent extends NetWorkComponent
  module.exports = @

  constructor: () ->
    super "NetWorkTransformComponent"
    @networkSendRate = 200

  onStartLocalPlayer: () =>
    if @networkSendRate <= 0
      return

    @event = "nwtc."+ @gameObject.name
    socket = NetWorkManager.socket
    socket.on(@event, (data) =>
      player = NetWorkManager.players.others[data.id]
      if player
        player.mesh.position.set(data.pos[0],data.pos[1],data.pos[2])
        player.mesh.rotation.set(data.rot[0],data.rot[1],data.rot[2])
        player.mesh.__dirtyRotation = true
        player.mesh.__dirtyPosition = true
    )

    setInterval(@networkSend,@networkSendRate)

  networkSend: () =>
    socket = NetWorkManager.socket
    mesh = @gameObject.mesh
    pos1 = mesh.position
    rot1 = mesh.rotation
    data =
      event: @event
      id: NetWorkManager.players.self.id,
      pos: [pos1.x,pos1.y,pos1.z],
      rot: [rot1.x,rot1.y,rot1.z]
#    console.log(pos1)
    socket.emit("nwtc",data)

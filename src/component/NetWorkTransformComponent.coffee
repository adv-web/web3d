# Created by duocai on 2017/5/11.

NetWorkComponent = require('./NetWorkComponent')
NetWorkManager = require('../NetWorkManager')

class NetWorkTransformComponent extends NetWorkComponent
  module.exports = @

  constructor: () ->
    super "NetWorkTransformComponent"
    @networkSendRate = 100

  onStartServerPlayer: (player) =>
    event = "nwtc."+ @gameObject.name
    player.on(event, (data) =>
      players = NetWorkManager.players.others
      host = NetWorkManager.players.self
      players[host.id] = host
      console.log(data)
      for id, p of players
        p.emit(event, data) if player.id  != id
    )

  onStartLocalPlayer: () =>
    event = "nwtc."+ @gameObject.name
    socket = NetWorkManager.socket
    setInterval(@networkSend,@networkSendRate)
    socket.on(event, (data) =>
      console.log(data)
      console.log(NetWorkManager.players.others)
      player = NetWorkManager.players.others[data.id]
      player.mesh.position.set(data.pos)
      player.mesh.rotation.set(data.rot)
    )

  networkSend: () =>
    event = "nwtc."+ @gameObject.name
    socket = NetWorkManager.socket
    mesh = @gameObject.mesh
    socket.emit(event,{id: NetWorkManager.players.self.id, pos:mesh.position, rot: mesh.rotation})

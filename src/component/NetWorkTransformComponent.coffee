# Created by duocai on 2017/5/11.

NetWorkComponent = require('./NetWorkComponent')
NetWorkManager = require('../NetWorkManager')

class NetWorkTransformComponent extends NetWorkComponent
  module.exports = @

  constructor: () ->
    super "NetWorkTransformComponent"
    @networkSendRate = 1000

  onStartServerPlayer: (player) =>
    event = "nwtc."+ @gameObject.name
    player.on(event, (data) =>
      players = NetWorkManager.players.others
      host = NetWorkManager.players.self
      players[host.id] = host
      console.log(player.id+"'s sign")
      for id, p of players
        p.emit(event, data) if player.id  != id
    )

  onStartLocalPlayer: () =>
    Game = require('../Game')
    event = "nwtc."+ @gameObject.name
    socket = NetWorkManager.socket
    setInterval(@networkSend,@networkSendRate)
    socket.on(event, (data) =>
      console.log(data)
      player = NetWorkManager.players.others[data.id]
      player.mesh.position.set(10,3,4)
      Game.scene.remove(player)
      player.mesh.rotation.set(data.rot[0],data.rot[1],data.rot[2])
    )

  networkSend: () =>
    event = "nwtc."+ @gameObject.name
    socket = NetWorkManager.socket
    mesh = @gameObject.mesh
    pos1 = mesh.position
    rot1 = mesh.rotation
    data =
      id: NetWorkManager.players.self.id,
      pos: [pos1.x,pos1.y,pos1.z],
      rot: [rot1.x,rot1.y,rot1.z]
    socket.emit(event,data)

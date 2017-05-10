# Created by duocai on 2017/5/2.

Game = require('Game')

class NetWorkManager
  module.exports = this
  @server = false
  @prefabs = {}
  @gameObjects = {}
  @init: (server,@playerPrefab,@pos) =>
    @server = server
    if !server
      @_client_connect_to_server()
      @_initLocalPlayer()
    return @

  @update: () =>

  @_initLocalPlayer: () =>
    player = @playerPrefab()
    player.mesh.position.set(@pos) if @pos
    for key, comp of player.components
      comp.setIsLocal?(true)
      comp.onStartLocalPlayer?()
    Game.scene.add(player)

  @_client_connect_to_server: () =>

    # Store a local reference to our connection to the server
    @socket = io.connect()

    # When we connect, we are not 'connected' until we have a server id
    # and are placed in a game by the server. The server sends us a message for that.
    @socket.on('connect', () =>
      @status = "connecting"
      console.log @status
    )

    # Sent when we are disconnected (network, server down, etc)
    @socket.on('disconnect', @_client_ondisconnect)
    # Sent each tick of the server simulation. This is our authoritive update
    @socket.on('onserverupdate', @_client_onserverupdate_recieved)
    # Handle when we connect to the server, showing state and storing id's.
    @socket.on('onconnected', @_client_onconnected)
    # On error we just show that we are not connected for now. Can print the data.
    @socket.on('error', @_client_ondisconnect)
    # On message from the server, we parse the commands and send it to the handlers
    @socket.on('message', @_client_onnetmessage)

  @_client_onconnected: (data) =>

  @_client_onnetmessage: (mess) =>
    commands = data.split('.');
    command = commands[0];
    subcommand = commands[1] || null;
    commanddata = commands[2] || null;

    switch(command) {
      case 's': //server message

        switch(subcommand) {

          case 'h' : //host a game requested
            this.client_onhostgame(commanddata); break;

    case 'j' : //join a game requested
      this.client_onjoingame(commanddata); break;

    case 'r' : //ready a game requested
      this.client_onreadygame(commanddata); break;

    case 'e' : //end game requested
      this.client_ondisconnect(commanddata); break;

    case 'p' : //server ping
      this.client_onping(commanddata); break;

    case 'c' : //other player changed colors
      this.client_on_otherclientcolorchange(commanddata); break;

    } //subcommand

    break; //'s'


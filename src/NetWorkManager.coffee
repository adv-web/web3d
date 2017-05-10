# Created by duocai on 2017/5/2.

class NetWorkManager
  module.exports = this
  @server = false
  @prefabs = {}
  @gameObjects = {}
  @players =
    self: null
    others: {}
  @net_latency = 0
  @init: (server, @scene, @playerPrefab) =>
    @server = server
    console.log("isServer":server)
    if !server
      @_client_connect_to_server()
      @_initLocalPlayer()
    return @

  @server_update: () =>

  @client_update: () =>

  @_initLocalPlayer: () =>
    player = @playerPrefab()
    for key, comp of player.components
      comp.setIsLocal?(true)
      comp.onStartLocalPlayer?()
    @scene.add(player)
    @players.self = player

  @_client_connect_to_server: () =>
    # Store a local reference to our connection to the server
    @socket = io('/')

    # When we connect, we are not 'connected' until we have a server id
    # and are placed in a game by the server. The server sends us a message for that.
    @socket.on('connect', () =>
      @players.self.state = "connecting"
      console.log "self.status:" + @players.self.state
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
    #The server responded that we are now in a game,
    #this lets us store the information about ourselves and set the colors
    #to show we are now ready to be playing.
    @players.self.id = data.id;
    @players.self.state = 'connected'
    @players.self.online = true

  @_client_onserverupdate_recieved: (data) =>


  @_client_onnetmessage: (data) =>
    commands = data.split('.');
    command = commands[0];
    subcommand = commands[1] || null;
    commanddata = commands[2] || null;

    switch command
      when 's' #server message
        switch subcommand 
          when 'h'# host a game requested
            @_client_onhostgame(commanddata)

          when 'j' #join a game requested
            @_client_onjoingame(commanddata)

          when 'oj' # other player join the game
            @_client_onotherjoingame(commanddata)

          when 'r' #ready a game requested
            @_client_onreadygame(commanddata)
      
          when 'e' #end game requested
            @_client_ondisconnect(commanddata)
      
          when 'p' #server ping
            @_client_onping(commanddata)

          when 'c' #other player changed colors
            @_client_on_otherclientcolorchange(commanddata)
      # maybe some message else later

  @_client_onotherjoingame: (id) =>
    player = @playerPrefab()
    @scene.add(player)
    player.id = id
    @players.others[data.id] = player
    console.log(id+" joined game")

  @_client_onhostgame: (data) =>
    # so the value will be really small anyway (15 or 16ms)
    server_time = parseFloat(data.replace('-','.'))

    # Get an estimate of the current time on the server
    @local_time = server_time + @net_latency

    # Set the flag that we are hosting, this helps us position respawns correctly
    @players.self.host = true;

  @_client_onjoingame: (data) =>
    # i am not host
    @players.self.host = false


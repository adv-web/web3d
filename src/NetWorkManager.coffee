# Created by duocai on 2017/5/2.

# Network Manager is unique in the client. It will do many works that
# are simply classified as follows:
# 1. It will connect to the server. Besides, it will receive and handle
#   message about that other players join and leave the game, and send message
#   to server if we leave the game. Mostly important, it will store and maintain
#   the socket. and other class can use this socket to register event or emit message
# 2. It will store and maintain the prefabs of game objects. Recall GameManager on the
#   server, this class will receive the spawn or destroy message from GameManager. And
#   then it will do the work of spawn objects to the scene. And then it will store theses
#   objects in order to destroy them later
class NetWorkManager
  module.exports = this

  # this function must be called before you use Network Manager
  # must set scene
  # must set player prefab
  #   @param [Scene] scene the scene that you will display on the window
  #   @param [Function] the function that will return player GameObject
  @init: (@scene, @playerPrefab) =>
    @local_time = new Date().getTime()
    @objectUpdateEvent = "object.update"
    @prefabs = {}
    @gameObjects = {}
    @players =
      self: {}
      others: {}
    @net_latency = 0
    return @

  # initialize the client and connect to the server
  @client_start: () =>
    # connect to the server
    @_client_connect_to_server()

  # add prefab to NetworkManager's pool of prefabs
  #   @param [Function] prefab a function that receives parameter
  #     (mess) and returns a GameObject
  @addPrefab: (prefab) =>
    @prefabs[prefab.key] = prefab

  # add GameObject to the scene and inform other clients
  #   @param [String] key the key of the prefab that you have set
  #   @param [Object] messages side message of this object and this message
  #       will be send to the prefab decided by the parameter key. So, the
  #     server don't care the format of the message. you definite it and you
  #   should use it properly.
  @add: (key, messages) =>
    prefab = @prefabs[key]
    if prefab == undefined
      console.error("No such key of prefab: ", key)

    # can not use client predict add it to the scene directly
    # for the UUID of the object is produced by server
    data =
      action: 's'
      prefabId: key
      mess: messages
    # send message to server
    @socket.emit(@objectUpdateEvent, data)

  # remove object from the scene
  #   @param [GameObject] object the object function
  #   @param [Function] callbackFunction callback to show whether this operation is successful
  @remove: (object, callbackFunction) =>
    # remove directly for Smooth in client
    # for in this game, it will must be removed by this action or action of
    # others before this one
    @scene.remove(@gameObjects[object.id])
    delete @gameObjects[object.id]

    # set callback event
    event = "_destroy_callback_"+object.id
    @socket.on(event, callbackFunction)
    data =
      action: 'd'
      callback: event
      objectId: object.id
    # send message to server
    @socket.emit(@objectUpdateEvent, data)

  @_client_connect_to_server: () =>
    # Store a local reference to our connection to the server
    # @socket = io('http://120.76.125.35:5000/game')
    @socket = io('http://localhost:5000/game')

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

    # receive the message about update game object
    @socket.on(@objectUpdateEvent, (data) =>
      switch data.action
        when 's' then @_spawn(data.prefabId, data.objectId, data.mess)
        when 'd' then @_destroy(data.objectId)
        when 'u' then @_update(data.objectId, data)
    )

  @_spawn: (key, id, mess) =>
    object = @prefabs[key](mess)
    if object
      object.id = id
      @gameObjects[id] = object
      @scene.add(object)

  @_destroy: (id) =>
    if @gameObjects[id] isnt undefined
      @scene.remove(@gameObjects[id])
      delete @gameObjects[id]

  @_update: (id, data) =>

  @_client_onconnected: (data) =>
    #The server responded that we are now connected to the server
    #this lets us store the information about ourselves
    #to show we are now ready to be playing.
    @players.self.id = data.id;
    @players.self.state = 'connected'
    @players.self.online = true

  @_client_ondisconnect: (data) =>
    @scene.remove(@players.self)

  @_client_onserverupdate_recieved: (data) =>

  @_client_onnetmessage: (data) =>
    # data is a string, and it has at most three parts
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

          when 'ol' # other player left the game
            @_client_onotherleftgame(commanddata)

          when 'r' #ready a game requested
            @_client_onreadygame(commanddata)
          when 's' # start game
            @_client_onstartgame(commanddata)
          when 'e' #end game requested
            @_client_ondisconnect(commanddata)
      
          when 'p' #server ping
            @_client_onping(commanddata)
      # maybe some message else later

  @_client_onotherjoingame: (id) =>
    player = @playerPrefab()
    @scene.add(player)
    player.id = id
    @players.others[id] = player
    console.log(id+" joined game")

  @_client_onotherleftgame: (id) =>
    @scene.remove(@players.others[id])
    delete  @players.others[id]
    console.log(id+" left game")

  @_client_onhostgame: (@game_id) =>
    # Set the flag that we are hosting, this helps us position respawns correctly
    @players.self.host = true;
    # initialize local player
    @_client_initLocalPlayer()

  @_client_onjoingame: (@game_id) =>
    # i am not host
    @players.self.host = false
    # initialize local player
    @_client_initLocalPlayer()

  @_client_initLocalPlayer: () =>
    player = @playerPrefab()
    for key, comp of player.components
      comp.setIsLocal?(true)
      comp.onStartLocalPlayer?()
    @scene.add(player)
    player.id = @players.self.id
    player.state = @players.self.state
    player.online = @players.self.online
    @players.self = player

  @_client_onstartgame: () =>
    console.log("game start")
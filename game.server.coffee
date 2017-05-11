# Created by duocai on 2017/5/10.

UUID = require('node-uuid')
verbose = true
# Since we are sharing code with the browser, we
# are going to include some values to handle that.
global.window = global.document = global

#Import shared game library code.
require('./bundle.js')
class GameServer
  module.exports = this


  constructor: () ->
    @games = {}
    @gameCount = 0

  onMessage: (player,mess) =>

  _onMessage: (player,mess) =>

  findGame: (player) =>
    if @gameCount > 0
      for key, game of @games
        @_joinGame(player, game)
        return;
    else
      @_createGame(player)
    console.log("we have " + @gameCount + " games")

  _joinGame: (player, game) =>
    player.send("s.j."+game.id) # tell the player he/she joined a game

    # tell the player others joined
    # s.oj. s = server message, oj = others join
    game.player_host.send("s.oj."+player.id)
    player.send("s.oj."+game.player_host.id)
    for key, player2 of game.player_clients
      player2.send("s.oj."+player.id)
      player.send("s.oj."+player2.id)

    # store the player message
    player.game = game
    game.player_count++
    game.player_clients[player.id] = player

    nwm = game.gamecore.netWorkManager
    # add this player to net work manager
    nwm.server_add_player(player)

    # log message
    console.log('player ' + player.userid + ' joined a game with id ' + player.game.id)

  _createGame: (player) =>
    # Create a new game instance
    thegame =
      id : UUID()       # generate a new id for the game
      player_host:player  # so we know who initiated the game
      player_clients:{}    # nobody else joined yet, since its new
      player_count:1            # for simple checking of state

    #  Store it in the list of game
    @games[ thegame.id ] = thegame

    # Keep track
    @gameCount++

    # Create a new game core instance, this actually runs the
    # game code like collisions and such.
    thegame.gamecore = new GameCore(thegame)
    # start game on the server
    thegame.gamecore.server_start()

    # get net work manager of this game
    nwm = thegame.gamecore.netWorkManager
    # set up game
    nwm.game_id = thegame.id
    nwm.players.self = player # means host on server

    nwm.server_add_player(player)

    # tell the player that they are now the host
    # s=server message, h=you are hosting
    player.send('s.h.'+ thegame.id)
    console.log('server host at  ' + thegame.gamecore.netWorkManager?.local_time)
    player.game = thegame
    player.hosting = true

    console.log('player ' + player.id + ' created a game with id ' + player.game.id)

    # return it
    return thegame




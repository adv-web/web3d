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

  onMessage: (mess) =>

  _onMessage: (mess) =>

  findGame: (player) =>
    if @games.length > 0
      for key, game of @games
        @_joinGame(player, game)
        return;
    else
      @_createGame(player)


  _joinGame: (player, game) =>
    game.player_host.send("s.oj."+player.id)
    player.send("s.j.") # join a game
    player.send("s.oj."+game.player_host.id)
    for key, player2 of game.player_clients
      player2.send("s.oj."+player.id)
      player.send("s.oj."+player2.id)

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
    @game_count++

    # Create a new game core instance, this actually runs the
    # game code like collisions and such.
    thegame.gamecore = new GameCore(thegame)
    # Start updating the game loop on the server
    thegame.gamecore.netWorkManager?.server_update(new Date().getTime())

    # tell the player that they are now the host
    # s=server message, h=you are hosting

    player.send('s.h.'+ String(thegame.gamecore.netWorkManager?.local_time).replace('.','-'))
    console.log('server host at  ' + thegame.gamecore.netWorkManager?.local_time)
    player.game = thegame
    player.hosting = true

    console.log('player ' + player.userid + ' created a game with id ' + player.game.id)

    # return it
    return thegame




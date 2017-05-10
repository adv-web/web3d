# Created by duocai on 2017/5/10.

UUID = require('node-uuid')
verbose = true

# Since we are sharing code with the browser, we
# are going to include some values to handle that.
global.window = global.document = global

#Import shared game library code.
gameCore = require('./bundle.js')()

class GameServer
  module.exports = this


  constructor: () ->
    @games = {}
    @gameCount = 0

  onMessage: (mess) =>

  _onMessage(mess) =>

  _findGame(player) =>

  _joinGame(player, game) =>

  _createGame(player) =>


# Created by duocai on 2017/5/10.
Component = require('../Component')

# Base class which should be inherited by scripts which
# contain networking functionality.
#
# It receive various callbacks help you to decide whether
# the player is a local player when in a multi player game.
# And it allows you to do something only to local players
#
# @example
#   class MyComponent extends NetWorkComponent
#     update: =>
#       if @isLocal
#         # do something
#
class NetWorkComponent extends Component
  module.exports = this

  constructor: (name) ->
    super name
    @isLocal = false

  setIsLocal: (@isLocal) =>

  onStartLocalPlayer: =>

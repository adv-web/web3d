# Created by duocai on 2017/5/10.
Component = require('../Component')

# Base class which should be inherited by scripts which
# contain networking functionality.
#
# It receive various callbacks help you to decide whether
# the player is a local player(@isLocal) when in a multi player game.
# And it allows you to do something only to local player or only to
# other players
#
# @example
#   class MyComponent extends NetWorkComponent
#
#     update: =>
#       if @isLocal
#         # do something
#
class NetWorkComponent extends Component
  module.exports = this

  # @param [String] name the name of this component
  constructor: (name) ->
    super name
    @isLocal = false

  # set the player as local player. This function will be called by the Network Manager.
  # @nodoc
  setIsLocal: (@isLocal) =>

  # this function will be call when the Network Manager initialize the local player.
  # You can do something only for the local player such as binding the camera.
  onStartLocalPlayer: =>

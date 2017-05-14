# Created by duocai on 2017/5/10.
Component = require('../Component')

class NetWorkComponent extends Component
  module.exports = this

  constructor: (name) ->
    super name
    @isLocal = false

  setIsLocal: (@isLocal) =>

  onStartLocalPlayer: =>

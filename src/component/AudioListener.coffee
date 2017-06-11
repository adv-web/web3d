# Created by duocai on 2017/6/9.
Component = require('../Component')
Game = require('../Game')


class AudioListener extends Component
  module.exports = @

  @_listener = new THREE.AudioListener()

  constructor: () ->
    super "AudioListener"

  onStartLocalPlayer: () =>
    @camera = Game.scene._cameras[0]
    @camera?.add(AudioListener._listener)

  update: () =>
    if @camera isnt Game.scene._cameras[0]
      @camera = Game.scene._cameras[0]
      @camera.add(AudioListener._listener)
# Created by duocai on 2017/6/9.
Component = require('../Component')
AudioListener = require('./AudioListener')

class AudioSource extends Component
  module.exports = @

  @audioClips = {}

  constructor: (options = {}) ->
    super "AudioSource"
    @audioclip = options.audioclip
    @loop = if !options.loop then options.loop else true
    @volume = if options.volume then options.volume else 0.5

    sound = new THREE.Audio(AudioListener._listener);
    if audioclip
      new THREE.AudioLoader().load(audioclip, ( buffer ) =>
        sound.setBuffer(buffer)
        sound.setLoop(@loop)
        sound.setVolume(@volume)
        sound.play()
      );

  # player a sound
  # @param [String] audioClip the path of the audio source
  # @param [Float] volume the volume of the sound, between [0,1]
  @play: (audioClip, volume=0.5) =>
    if @audioClips[audioClip]
      @audioClips[audioClip].play()
    else
      sound = new THREE.Audio(AudioListener._listener);
      if audioClip
        new THREE.AudioLoader().load(audioclip, ( buffer ) =>
          sound.setBuffer(buffer)
          sound.setLoop(false)
          sound.setVolume(volume)
          sound.play()
          # cache it
          @audioClips[audioClip] = sound
        );
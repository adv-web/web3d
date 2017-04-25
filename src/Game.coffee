# The game itself, takes a whole screen and render a scene.
#
# The Game class is responsible to:
#
# - Initialize the game.
#
# - Take the game loop: in every frame update game logic and render it.
#
# - Handle window size change.
class Game
  module.exports = this

  # @property [Scene] the current scene of the game, you should use #setScene and avoid directly assign to it
  scene: null

  # To start the game.
  start: =>
    @nowTime = @prevTime = Date.now()
    @_initialize()
    @_loop()

  # Set the scene of game.
  # @param scene [Scene] the scene to be set
  # @return [Game] the game itself to support chained invocation
  setScene: (@scene) =>
    return this

  # @private
  _initialize: =>
    # set renderer, is it reasonable to put renderer here? or in scene?
    @renderer = new THREE.WebGLRenderer({antialias: true})
    @renderer.setSize(window.innerWidth, window.innerHeight)
    document.body.appendChild(@renderer.domElement)
    # set event listener
    window.addEventListener('resize', @_onWindowResize, false);

  # @private
  _loop: =>
    @nowTime = Date.now()
    deltaTime = @nowTime - @prevTime
    # TODO process input
    @scene?.update()
    @renderer.render(@scene._scene, @scene._cameras[0]) if @scene?._cameras[0]?
    requestAnimationFrame(@_loop)
    @prevTime = @nowTime

  # @private
  _onWindowResize: =>
    @scene?._cameras[0]?.aspect = window.innerWidth / window.innerHeight;
    @scene?._cameras[0]?.updateProjectionMatrix();
    @renderer.setSize(window.innerWidth, window.innerHeight);


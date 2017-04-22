class Game

  start: =>
    @nowTime = @prevTime = Date.now()
    @_initialize()
    @_loop()

  setScene: (@scene) =>
    return this

  _initialize: =>
    # set renderer, is it reasonable to put renderer here? or in scene?
    @renderer = new THREE.WebGLRenderer({antialias: true})
    @renderer.setSize(window.innerWidth, window.innerHeight)
    document.body.appendChild(@renderer.domElement)
    # set event listener
    window.addEventListener('resize', @_onWindowResize, false);

  _loop: =>
    @nowTime = Date.now()
    deltaTime = @nowTime - @prevTime
    # TODO process input
    @scene?.update()
    @renderer.render(@scene?.pscene, @scene?.camera)  # 高耦合
    requestAnimationFrame(@_loop)
    @prevTime = @nowTime

  _onWindowResize: =>
    @scene?.camera.aspect = window.innerWidth / window.innerHeight;
    @scene?.camera.updateProjectionMatrix();
    @renderer.setSize(window.innerWidth, window.innerHeight);

module.exports = Game

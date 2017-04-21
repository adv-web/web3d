class Game

  constructor: ->
    @scenes = {}
    @scripts = []

  @instance: ->
    if not @game
      @game = new Game()
    else
      @game

  addScene: (scene) ->
    @scenes[scene.name] = scene

  addScript: (script) ->
    @scripts.push(script)

  start: (name)=>
    @nowTime = @prevTime = Date.now()
    @curScene = @scenes[name]
    @_initialize()
    @_loop()

  _initialize: =>
    @curScene.init()
    @renderer =  new THREE.WebGLRenderer()
    @renderer.setSize(window.innerWidth, window.innerHeight)
    document.body.appendChild(@renderer.domElement)

  _loop: =>
    @nowTime = Date.now()
    @deltaTime = @nowTime - @prevTime
    @prevTime = @nowTime

    # scripts update
    script.update() for script in @scripts

    @renderer.render(@curScene.scene, @curScene.camera)
    requestAnimationFrame(@_loop)

window.Game = Game

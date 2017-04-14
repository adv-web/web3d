class Game

  start: =>
    @nowTime = @prevTime = Date.now()
    _initialize()
    _loop()

  _initialize: =>

  _loop: =>
    @nowTime = Date.now()
    deltaTime = @nowTime - @prevTime

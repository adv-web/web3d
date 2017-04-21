class Game

  start: =>
    alert("hello, world")
    @nowTime = @prevTime = Date.now()
    @_initialize()
    @_loop()

  _initialize: =>
      alert("init")

  _loop: =>
    @nowTime = Date.now()
    deltaTime = @nowTime - @prevTime

module.exports = Game

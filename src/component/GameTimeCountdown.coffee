Component = require("../Component")
$ = require("jquery")
class GameTimeCountdown extends Component
  module.exports = this

  total: 180

  enabled: false

  constructor: (@total = 180) ->
    super("GameTimeCountdown")
    @grounds = []

  afterAdded: =>
    @_timeLeft = @total
    @_timer = setInterval(() =>
      return if not @enabled
      @_timeLeft -= 1 if @_timeLeft > 0
      $(".gametime-data").html("#{@_timeLeft} <span>s</span>")
      if @_timeLeft==120
        @grounds[19].mesh.mass=0.5
        @grounds[18].mesh.mass=0.5
        @grounds[9].mesh.mass=0.5
      #19 18 9
      else if  @_timeLeft==80
      #22 21 12
        @grounds[22].mesh.mass=0.5
        @grounds[21].mesh.mass=0.5
        @grounds[12].mesh.mass=0.5
      else if  @_timeLeft==50
      #17 16 7
        @grounds[17].mesh.mass=0.5
        @grounds[16].mesh.mass=0.5
        @grounds[7].mesh.mass=0.5
      else if  @_timeLeft==20
      #24 23 14
        @grounds[24].mesh.mass=0.5
        @grounds[23].mesh.mass=0.5
        @grounds[14].mesh.mass=0.5
    , 1000)
    @enabled = true
    
  beforeRemoved: =>
    clearInterval(@_timer)

  start: =>
    @enabled = true

  pause: =>
    @enabled = false

  reset: =>
    clearInterval(@_timer)
    @afterAdded()






Component = require("../Component")
$ = require("jquery")
class GameTimeCountdown extends Component
  module.exports = this

  total: 180

  enabled: false

  constructor: (@total = 180) ->
    super("GameTimeCountdown")

  afterAdded: =>
    @_timeLeft = @total
    @_timer = setInterval(() =>
      return if not @enabled
      @_timeLeft -= 1 if @_timeLeft > 0
      $(".gametime-data").html("#{@_timeLeft} <span>s</span>")
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






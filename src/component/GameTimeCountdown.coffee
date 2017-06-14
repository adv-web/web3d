Component = require("../Component")
NetWorkMananger =require("../NetWorkManager")
$ = require("jquery")
class GameTimeCountdown extends Component
  module.exports = this

  total: 180

  enabled: false

  constructor: (@total = 180) ->
    super("GameTimeCountdown")
    @grounds = []

  afterAdded: =>
    NetWorkMananger.setGameTimeListener(@_onGameTimeChange)
    NetWorkMananger.setGameEndListener(@_onGameEnd)
    
  beforeRemoved: =>
    NetWorkMananger.setGameTimeListener(null)
    NetWorkMananger.setGameEndListener(null)

  _onGameTimeChange: (time) =>
    time = parseInt(time)
    $(".gametime-data").html("#{time} <span>s</span>")
    if time <= 120
      #19 18 9
      @grounds[19].mesh.mass=0.5
      @grounds[18].mesh.mass=0.5
      @grounds[9].mesh.mass=0.5
    if time<=80
      #22 21 12
      @grounds[22].mesh.mass=0.5
      @grounds[21].mesh.mass=0.5
      @grounds[12].mesh.mass=0.5
    if time<=50
      #17 16 7
      @grounds[17].mesh.mass=0.5
      @grounds[16].mesh.mass=0.5
      @grounds[7].mesh.mass=0.5
    if time<=20
      #24 23 14
      @grounds[24].mesh.mass=0.5
      @grounds[23].mesh.mass=0.5
      @grounds[14].mesh.mass=0.5

  _onGameEnd: =>

    # change view
    $("#gamePanel canvas").remove()
    $("#gamePanel").hide()
    $("#preparePanel").show()
    # sycn to the server
    if document.userInfo.id
      $.ajax({
        type: 'PUT',
        url:  "http://120.76.125.35:5000/user/" + document.userInfo.id,
        data: document.userInfo,
        dataType: 'JSON',
        success: (data) =>
          if data.success
            # change user info
            console.log("user info synchronized")
          else
            alert(JSON.stringify(data.err))

        error: (data) =>
          alert(JSON.stringify(data));
      });





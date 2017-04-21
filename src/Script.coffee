class Script extends Component

  constructor: (@name) ->
    super @name

  update: ->

window.Script = Script

class Rotate extends Script

  constructor: ->
    super "Rotate"

  update: ->
    trans = @gameObject.mesh
    trans.rotation.x += 0.1;
    trans.rotation.y += 0.1;

window.Rotate = Rotate
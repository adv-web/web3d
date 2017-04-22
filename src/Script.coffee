
class Rotate extends Component

  constructor: ->
    super "Rotate"

  update: ->
    trans = @gameObject.mesh
    trans.rotation.x += 0.1;
    trans.rotation.y += 0.1;


module.exports = Rotate


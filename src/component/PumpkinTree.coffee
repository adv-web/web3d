Component = require("../Component")
$ = require("jquery")
Data = require("../Data")
Game = require("../Game")
# The pumpkin tree spawns a pumpkin every xx seconds
#
# name = "PumpkinTree"
class PumpkinTree extends Component
  module.exports = this

  # Construct a pumpkin tree.
  constructor: () ->
    super("PumpkinTree")
    @_nextSpawnTime = 150

  # @nodoc
  update: () =>
    time = parseInt($(".gametime-data").html())
    return if time != @_nextSpawnTime
    # spawn a pumpkin
    x = @gameObject.mesh.position.x + Math.random() - 0.5
    z = @gameObject.mesh.position.z + Math.random() - 0.5
    Game.scene.spawn(Data.prefab.pumpkin, new THREE.Vector3(x, 1, z))
    @_nextSpawnTime -= 30


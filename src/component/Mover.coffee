Component = require("../Component")
Input = require("../Input")
# The mover component, provide use with 4-direction movement using WASD
#
# name = "Mover"
class Mover extends Component
  module.exports = this

  # @property [number] how fast you can move
  velocity: 1

  # Construct a mover.
  # @param options [Object] the optional parameters
  # @option options [number] velocity the velocity of movement
  constructor: (options = {}) ->
    super("Mover")
    @velocity = if options.velocity? then options.velocity else 1

  # @nodoc
  update: (deltaTime) =>
    distance = @velocity * deltaTime / 1000
    @gameObject.mesh.translateX(distance) if Input.isPressed('D')
    @gameObject.mesh.translateX(-distance) if Input.isPressed('A')
    @gameObject.mesh.translateZ(distance) if Input.isPressed('S')
    @gameObject.mesh.translateZ(-distance) if Input.isPressed('W')
    @gameObject.mesh.__dirtyPosition = true
    #@gameObject.mesh.setAngularFactor(new THREE.Vector3(0, 0, 0))
    #@gameObject.mesh.__dirtyRotation = true
    #console.log @gameObject.mesh.rotation
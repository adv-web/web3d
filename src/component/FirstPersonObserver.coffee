Component = require("../Component")
# First person observer provides function that screen rotates as mouse move
#
# name = "FirstPersonObserver"
class FirstPersonObserver extends Component
  module.exports = this

  PI_2 = Math.PI / 2

  # @property [number] how fast the rotation when mouse move, initially 1
  sensitivity: 1

  # Construct a first person observer.
  # @param options [Object] the optional parameters
  # @option options [number] sensitivity of mouse move, by default 1
  constructor: (options = {}) ->
    super("FirstPersonObserver")
    @sensitivity = if options.sensitivity? then options.sensitivity else 1

  # @nodoc
  afterAdded: =>
    @camera = @gameObject.getComponent("Camera")
    (@_pitch = new THREE.Object3D()).add(@camera._camera)
    (@_yaw = new THREE.Object3D()).add(@_pitch)
    @gameObject.mesh.add(@_yaw)
    document.addEventListener('mousemove', @_onMouseMove, false)

  # @nodoc
  beforeRemoved: =>
    document.removeEventListener('mousemove', @_onMouseMove, false)

  # @private
  _onMouseMove: (event) =>
    movementX = event.movementX || event.mozMovementX || event.webkitMovementX || 0
    movementY = event.movementY || event.mozMovementY || event.webkitMovementY || 0
    @_yaw.rotation.y -= movementX * @sensitivity / 1000
    @_pitch.rotation.x -= movementY * @sensitivity / 1000
    @_pitch.rotation.x = Math.max(-PI_2, Math.min(PI_2, @_pitch.rotation.x))
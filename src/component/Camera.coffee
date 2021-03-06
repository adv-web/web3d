Component = require('../Component')
# The camera component, a wrapper of THREE.Camera. The game should at least have a camera, or it will render a black screen.
#
# name = "camera"
#
# A camera on a game object will move with the game object's movement.
# To implement this, in Camera#afterAdded method set the camera as a sub-object of its game object's mesh. So as #beforeRemoved method.
class Camera extends Component
  module.exports = this

  # @property [THREE.Vector3] the position of camera
  position: null

  @property 'position',
    get: -> @_camera.position
    set: (position) -> @_camera.position = position

  # Construct a camera component.
  #
  # It will create a new THREE.PerspectiveCamera.
  constructor: (options = {}) ->
    super("Camera")
    @_camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.001, 10000)
    x = if options.x? then options.x else 0
    y = if options.y? then options.y else 0
    z = if options.z? then options.z else 0
    @_camera.position.set(x, y, z)

  # @nodoc
  afterAdded: =>
    @gameObject.mesh.add(@_camera)

  # @nodoc
  beforeRemoved: =>
    @gameObject.mesh.remove(@_camera)

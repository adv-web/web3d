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
  constructor: ->
    super("Camera")
    @_camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.001, 10000)

  # @nodoc
  afterAdded: =>
    @gameObject.mesh.add(@_camera)

  # @nodoc
  beforeRemoved: =>
    @gameObject.mesh.remove(@_camera)

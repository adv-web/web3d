Component = require("../Component")
Input = require("../Input")
# The first-person controller component, provide users with first-person mouse movement, WASD move and jump.
# Modified by THREE.PointerLockControls to support when main object's mesh is not empty,
# so this can be used in both FPS and TPS.
#
# name = "FirstPersonController"
#
# **IMPORTANT**: The component is related to a Camera component. Make sure you add this camera to game object
# before you add this controller component to game object, or the controller will not work properly.
#
# When use pointer lock, you can request browser's better support. @see Game#requestPointerLock
class FirstPersonController extends Component
  module.exports = this

  PI_2 = Math.PI / 2

  # @property [boolean] tell whether the controller is enabled
  enabled: true

  # @property [number] how fast the rotation when mouse move
  sensitivity: 4

  # @property [number] the move velocity
  move_velocity: 1

  # @property [number] the jump velocity
  jump_velocity: 3

  # Construct a pointer lock controller. It's initially enabled.
  # @param camera [Camera] the camera related to
  # @param options [Object] the optional parameters
  # @option options [number] sensitivity the sensitivity of mouse
  # @option options [number] move_velocity the move velocity
  # @option options [number] jump_velocity the jump velocity
  constructor: (@camera, options = {}) ->
    super("FirstPersonController")
    (@_pitch = new THREE.Object3D()).add(@camera._camera)
    (@_yaw = new THREE.Object3D()).add(@_pitch)
    @_yaw2 = new THREE.Object3D()
    geometry = new THREE.BoxGeometry( 0.08, 0.08, 0.5);
    material = new THREE.MeshBasicMaterial({ color: 0xffcc99});
    mesh = new THREE.Mesh(geometry, material);
    @_pitch.add(mesh)
    mesh.position.set(0.25, 0, -0.2)
    @enabled = true
    @sensitivity = if options.sensitivity? then options.sensitivity else 4
    @move_velocity = if options.move_velocity? then options.move_velocity else 1
    @jump_velocity = if options.jump_velocity? then options.jump_velocity else 3

    @_canJump = true

  # @private
  _onMouseMove: (event) =>
    return if not @enabled
    movementX = event.movementX || event.mozMovementX || event.webkitMovementX || 0
    movementY = event.movementY || event.mozMovementY || event.webkitMovementY || 0
    @_yaw.rotation.y -= movementX * @sensitivity / 1000
    @_yaw2.rotation.y -= movementX * @sensitivity / 1000
    @_pitch.rotation.x -= movementY * @sensitivity / 1000
    @_pitch.rotation.x = Math.max(-PI_2, Math.min(PI_2, @_pitch.rotation.x))

  # @private
  _onCollision: (other_object, linear_velocity, angular_velocity) =>
    @_canJump = true if other_object.name == "ground"
    # TODO 判断高度

  # @nodoc
  afterAdded: =>
    @gameObject.mesh.add(@_yaw)
    @gameObject.mesh.add(@_yaw2)
    document.addEventListener('mousemove', @_onMouseMove, false)
    @gameObject.mesh.addEventListener('collision', @_onCollision);

  # @nodoc
  beforeRemoved: =>
    document.removeEventListener('mousemove', @_onMouseMove, false)
    @gameObject.mesh.removeEventListener('collision', @_onCollision);

  # @nodoc
  update: (deltaTime) =>
    distance = @move_velocity * deltaTime / 1000

    @_yaw2.translateX(distance) if Input.isPressed('D')
    @_yaw2.translateX(-distance) if Input.isPressed('A')
    @_yaw2.translateZ(distance) if Input.isPressed('S')
    @_yaw2.translateZ(-distance) if Input.isPressed('W')
    p = @_yaw2.getWorldPosition()
    @gameObject.mesh.position.x = p.x
    @gameObject.mesh.position.z = p.z
    @_yaw2.position.set(0,0,0)
    @gameObject.mesh.__dirtyPosition = true

    if @_canJump and Input.isPressed(32)
      @_canJump = false
      @gameObject.mesh.setLinearVelocity(new THREE.Vector3(0, @jump_velocity, 0))

    @gameObject.mesh.setAngularVelocity(new THREE.Vector3(0, 0, 0));
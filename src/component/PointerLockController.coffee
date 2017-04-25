Component = require("../Component")
# The pointer lock controller component, provide users with first-person mouse control.
# It's a little change of THREE.PointerLockControls
#
# name = "PointerLockController"
#
# **IMPORTANT**: The component is related to a Camera component. Make sure you add this camera to game object
# before you add this controller component to game object, or the controller will not work properly.
#
# When use pointer lock, you can request browser's better support. @see Game#requestPointerLock
class PointerLockController extends Component
  module.exports = this

  PI_2 = Math.PI / 2;

  # @property [boolean] tell whether the controller is enabled
  enabled: true

  # @property [number] how fast the rotation when mouse move
  sensitivity: 4

  # Construct a pointer lock controller. It's initially enabled.
  constructor: (camera) ->
    super("PointerLockController")
    (@_pitch = new THREE.Object3D()).add(camera._camera);
    (@_yaw = new THREE.Object3D()).add(@_pitch);
    @enabled = true
    @sensitivity = 4

  # @private
  _onMouseMove: (event) =>
    return if not @enabled
    movementX = event.movementX || event.mozMovementX || event.webkitMovementX || 0;
    movementY = event.movementY || event.mozMovementY || event.webkitMovementY || 0;
    @_yaw.rotation.y -= movementX * @sensitivity / 1000;
    @_pitch.rotation.x -= movementY * @sensitivity / 1000;
    @_pitch.rotation.x = Math.max(-PI_2, Math.min(PI_2, @_pitch.rotation.x));

  # @nodoc
  afterAdded: =>
    @gameObject.mesh.add(@_yaw)
    document.addEventListener('mousemove', @_onMouseMove, false);

  # @nodoc
  beforeRemoved: =>
    @gameObject.mesh.remove(@_yaw)
    document.removeEventListener('mousemove', @_onMouseMove, false);
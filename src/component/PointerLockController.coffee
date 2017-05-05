Component = require("../Component")
Input = require("../Input")
# The pointer lock controller component, provide users with first-person mouse movement.
# Modified by THREE.PointerLockControls to support when main object's mesh is not empty,
# so this can be used in both FPS and TPS.
#
# name = "PointerLockController"
#
# **IMPORTANT**: The component is related to a Camera component. Make sure you add this camera to game object
# before you add this controller component to game object, or the controller will not work properly.
#
# When use pointer lock, you can request browser's better support. @see Game#requestPointerLock
class PointerLockController extends Component
  module.exports = this

  PI_2 = Math.PI / 2

  # @property [boolean] tell whether the controller is enabled
  enabled: true

  # @property [number] how fast the rotation when mouse move
  sensitivity: 4

  # Construct a pointer lock controller. It's initially enabled.
  # @param camera [Camera] the camera related to
  # @param options [Object] the optional parameters
  # @option options [number] sensitivity the sensitivity of mouse
  constructor: (@scene, @camera, options = {}) ->
    super("PointerLockController")
    #(@_pitch = new THREE.Object3D()).add(camera._camera)
    @_pitch = new THREE.Object3D()
    @_pitch.name = "pitch"
    #@_pitch.add(@camera._camera)
    (@_yaw = new THREE.Object3D()).add(@_pitch)
    @_yaw2 = new THREE.Object3D()
    geometry = new THREE.BoxGeometry( 0.08, 0.08, 0.5);
    material = new THREE.MeshBasicMaterial( { color: 0xffcc99} );
    mesh = new THREE.Mesh(geometry, material);
    @_pitch.add(mesh)
    mesh.position.set(0.25, 0, -0.2)
    @_yaw.name = "yaw"
    @enabled = true
    @sensitivity = if options.sensitivity? then options.sensitivity else 4

  # @private
  _onMouseMove: (event) =>
    return if not @enabled
    movementX = event.movementX || event.mozMovementX || event.webkitMovementX || 0
    movementY = event.movementY || event.mozMovementY || event.webkitMovementY || 0
    @_yaw.rotation.y -= movementX * @sensitivity / 1000
    @_yaw2.rotation.y -= movementX * @sensitivity / 1000
    #@gameObject.mesh.rotation.y -= movementX * @sensitivity / 1000
    #@gameObject.mesh.__dirtyRotation = true
    @_pitch.rotation.x -= movementY * @sensitivity / 1000
    @_pitch.rotation.x = Math.max(-PI_2, Math.min(PI_2, @_pitch.rotation.x))

  # @nodoc
  afterAdded: =>
    # the gameObject.mesh here perform the role as @_yaw in THREE.PointerLockControls
    # so the mesh can rotate as mouse moves
    # and also convenient for 4-direction movement for move can directly perform on the mesh
    @_pitch.add(@camera._camera)
    @gameObject.mesh.add(@_yaw)
    @gameObject.mesh.add(@_yaw2)
    console.log @_yaw
    #@_pitch.add(@gameObject.mesh)
    #@_yaw.add(@gameObject.mesh)
    #@scene._scene.add(@_yaw)

    document.addEventListener('mousemove', @_onMouseMove, false)

  # @nodoc
  beforeRemoved: =>
    #@gameObject.mesh.remove(@_yaw)
    document.removeEventListener('mousemove', @_onMouseMove, false)

  # @nodoc
  update: (deltaTime) =>
    distance = 1 * deltaTime / 1000

    #d = @_yaw.clone()
    @_yaw2.translateX(distance) if Input.isPressed('D')
    @_yaw2.translateX(-distance) if Input.isPressed('A')
    @_yaw2.translateZ(distance) if Input.isPressed('S')
    @_yaw2.translateZ(-distance) if Input.isPressed('W')
    #console.log @gameObject.mesh.position
    #p = d.getWorldPosition()
    #console.log "#{@_yaw.getWorldPosition().z},#{d.getWorldPosition().z}"
    #@gameObject.mesh.position.x += d.position.x
    #@gameObject.mesh.position.z += d.position.z
    p = @_yaw2.getWorldPosition()
    @gameObject.mesh.position.x = p.x
    @gameObject.mesh.position.z = p.z
    #@_yaw2.position.set(0,0,0)
    @gameObject.mesh.__dirtyPosition = true
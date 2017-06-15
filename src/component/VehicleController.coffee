NetWorkComponent = require("./NetWorkComponent")
Input = require("../Input")
# The vehicle controller allows to control something with W/S for moving and A/D for rotating
#
# name = "VehicleController"
class VehicleController extends NetWorkComponent
  module.exports = this

  # @property [boolean] tell whether the controller is enabled, initially true
  enabled: true

  # @property [number] the move velocity, initially 3
  move_velocity: 3

  # @property [number] the rotate velocity, initially 1
  rotate_velocity: 1

  # Construct a vehicle controller.
  # @param options [Object] the optional parameters
  # @option options [number] move_velocity the move speed of vehicle, initially 3
  # @option options [number] rotate_velocity the rotate speed of vehicle, initially 1
  constructor: (options = {}) ->
    super("VehicleController")
    @enabled = false;
    @move_velocity = if options.move_velocity? then options.move_velocity else 3
    @rotate_velocity = if options.rotate_velocity? then options.rotate_velocity else 1

  # @nodoc
  afterAdded: =>
    @enabled = true

  # @nodoc
  update: (deltaTime) =>
    return if not @enabled
    return if not @isLocal

    ver = Input.getAxis(Input.axis.vertical)
    hor = Input.getAxis(Input.axis.horizontal)
    # 根据载具当前的正方向移动
    @gameObject.mesh.translateZ(ver * @move_velocity * deltaTime / 1000)
    @gameObject.mesh.__dirtyPosition = true
    # 旋转
    @gameObject.mesh.rotateY(-hor * @rotate_velocity * deltaTime / 1000)
    @gameObject.mesh.__dirtyRotation = true
NetWorkComponent = require("./NetWorkComponent")
Input = require("../Input")

class VehicleController extends NetWorkComponent
  module.exports = this

  # @property [boolean] tell whether the controller is enabled, initially true
  enabled: true

  # @property [number] the move velocity, initially 3
  move_velocity: 3

  # @property [number] the rotate velocity, initially 1
  rotate_velocity: 1

  constructor: (options = {}) ->
    super("VehicleController")
    @enabled = false;
    @move_velocity = if options.move_velocity? then options.move_velocity else 3
    @rotate_velocity = if options.rotate_velocity? then options.rotate_velocity else 1

  afterAdded: =>
    @enabled = true
    
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
# Created by duocai on 2017/5/31.
Collider = require("./Collider")

# Box collider.
#
# The Box Collider is a basic cube-shaped collision primitive.
#
# Box colliders are obviously useful for anything roughly box-shaped,
# such as a crate or a chest. However, you can use a thin box as a floor,
# wall or ramp. The box shape is also a useful element in a compound collider.
#
# @require [Physijs Mesh]: this collider must be add to game object
# that has a Physijs Mesh
class BoxCollider extends Collider
  module.exports = @

  # build a Box Collider
  #
  # @option options {Boolean} isTrigger If enabled, this Collider is used only
  #   for triggering events, and is ignored by the physics engine which simply
  #   means the player can go through it.
  # @option options {Object} center The position of the Collider
  #   in the object’s local space.
  #   default is undefined.
  #   example: {x:0,y:0,z:0}
  # @option options {Object} size the size of the Collider in x,y,z directions.
  #   default is undefined.
  #   example: {x:1,y:1,z:1}
  constructor: (options = {}) ->
    # console.log("Box collider constructor")
    isTrigger = if options.isTrigger then options.isTrigger else false
    super("BoxCollider", isTrigger)

    @center = options.center
    @size = options.size

  # @nodoc
  afterAdded: =>
    super
    if @gameObject.mesh is undefined  or @gameObject.mesh is null
      console.error("BoxCollider component needs Mesh, but there is no mesh")
      return
    physics = @gameObject.mesh._physijs
    # console.log(physics)
    if physics is undefined
      console.error("BoxCollider component needs Physijs Mesh. but the mesh is not")
      return
    physics.collider = {}
    # console.log(@gameObject.mesh.name, @center)
    if @center
      physics.collider.center = @center
    if @size
      physics.collider.size = @size

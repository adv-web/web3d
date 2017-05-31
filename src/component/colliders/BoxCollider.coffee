# Created by duocai on 2017/5/31.
Collider = require("./Collider")

# Box collider
# @require [Physijs Mesh]
class BoxCollider extends Collider
  module.exports = @

  constructor: (options = {}) ->
    # console.log("Box collider constructor")
    isTrigger = if options.isTrigger then options.isTrigger else false
    super("BoxCollider", isTrigger)

    @center = options.center
    @size = options.size


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
    if @center isnt undefined
      physics.collider.center = @center
    if @size
      physics.collider.size = @size

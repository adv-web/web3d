# Created by duocai on 2017/5/31.
Component = require("../../Component")
Input = require("../../Input")


class Collider extends Component
  module.exports = @

  constructor: (name, @isTrigger) ->
    super name
    @activateMoveTime = 50
    @_activate = 0

  # @private
  _onCollision: (other_mesh, linear_velocity, angular_velocity) =>
    # console.log("Collider _onCollision", @gameObject.name)
    if @gameObject.mesh.name == 'player'
      if other_mesh.name != 'ground'
        console.log("player on collision")
        # and if this collision is not just a trigger
        # then stop move the player
        if !@isTrigger and !other_mesh.isTrigger
          Input.canMove = false
          setTimeout(Input.activeMove, @activateMoveTime)
        # console.log("Input.canMove:", Input.canMove)
    for key, comp of @gameObject.components
      comp.onCollision?(other_mesh, linear_velocity, angular_velocity)

  # @nodoc
  afterAdded: =>
    # console.log("Collider afterAdded")
    @gameObject.mesh.addEventListener('collision', @_onCollision.bind(@))
    @gameObject.mesh.isTrigger = @isTrigger

  # @nodoc
  beforeRemoved: =>
    @gameObject.mesh.removeEventListener('collision', @_onCollision.bind(@))

#  update: =>
    # console.log("collider update: ", Input.canMove)
#    if !Input.canMove
#      @_activate++
#      if @_activate >= @activateMoveRate
#        @_activate = 0
#        Input.canMove = true
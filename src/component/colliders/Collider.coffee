# Created by duocai on 2017/5/31.
Component = require("../../Component")
Input = require("../../Input")

# the Collider class will detector the collision.
#
# if the collision happened, it will call the onCollision method
# under the game object, you can put the onCollision method in any Component
# of this game object
# - onCollision(other_mesh, linear_velocity, angular_velocity)
#
# @require [Physijs Mesh]: this collider must be add to game object
# that has a Physijs Mesh
#
# you can extend this class to implement you own collider, but never to use it
# directly. use it's subclass instead
class Collider extends Component
  module.exports = @

  # @param {String} name the name of this Collider
  # @param {Boolean} isTrigger isTrigger If enabled, this Collider is used only
  #   for triggering events, and is ignored by the physics engine which simply
  #   means the player can go through it.
  constructor: (name, @isTrigger) ->
    super name
    @activateMoveTime = 50
    @_activate = 0

  # @private
  # detector the collision event
  _onCollision: (other_mesh, linear_velocity, angular_velocity) =>
    # console.log("Collider _onCollision", @gameObject.name)
    if @gameObject.mesh?.name == 'player'
      if other_mesh.name != 'ground'
        console.log("player on collision")
        # and if this collision is not just a trigger
        # then stop move the player
        if !@isTrigger and !other_mesh.isTrigger
          Input.stopMove()
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
    @gameObject.mesh?.removeEventListener('collision', @_onCollision.bind(@))

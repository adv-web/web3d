module.exports = class extends require('../Component')

  constructor: ->
    @name = "Test"

  update: =>
    @gameObject.mesh.rotation.y += 1
    @gameObject.mesh.__dirtyRotation = true
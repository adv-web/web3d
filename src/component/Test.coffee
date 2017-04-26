module.exports = class extends require('../Component')

  constructor: ->
    @name = "Test"

  update: =>
    @gameObject.mesh.translateX(0.001)
    #@gameObject.mesh.__dirtyRotation = true
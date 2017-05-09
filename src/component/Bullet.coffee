Component = require("../Component")

class Bullet extends Component
  module.exports = this

  constructor: (@_scene) ->
    super("Bullet")

  afterAdded: =>
    @_addedTime = new Date()

  update: =>
    @_scene.remove(@gameObject) if new Date() - @_addedTime > 5000
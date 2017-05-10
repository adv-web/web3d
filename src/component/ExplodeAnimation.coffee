Component = require("../Component")
Game = require("../Game")
# The explode animation in sphere.
#
# name = "ExplodeAnimation"
class ExplodeAnimation extends Component
  module.exports = this

  # @property [number] the number of points in animation, initially 1000
  count: 1000

  # @property [number] the speed of point's flying away, initially 0.01
  speed: 0.01

  # @property [number] the size of a point, initially 0.02
  size: 0.02

  # @property [number] the duration of animation, initially 500
  duration: 500

  # @property [Function] the function invoked after explosion finish
  onExplodeFinish: null

  # Construct an explode animation.
  # @param onExplodeFinish [Function] the function invoked after explosion finish
  # @param options [Object] the optional parameters
  # @option options [number] count the number of points in animation
  # @option options [number] speed the speed of point's flying away
  # @option options [number] size the size of a point
  # @option options [number] duration the duration of animation
  constructor: (@onExplodeFinish, options = {}) ->
    super("ExplodeAnimation")
    @count = if options.count? then options.count else 1000
    @speed = if options.speed? then options.speed else 0.01
    @size = if options.size? then options.size else 0.02
    @duration = if options.duration? then options.duration else 500
    @_dirs = []

  # @nodoc
  afterAdded: =>
    geometry = new THREE.Geometry()
    for i in [0..@count]
      p = @gameObject.mesh.position
      geometry.vertices.push(new THREE.Vector3(p.x, p.y, p.z))
      @_dirs.push(@_randomSpherePoint())
    material = new THREE.PointsMaterial({size: @size, color: 0xffcc00})
    @_particles = new THREE.Points(geometry, material)
    @_startTime = new Date()
    Game.scene.add(@_particles)

  # @nodoc
  beforeRemoved: =>
    Game.scene.remove(@_particles)

  # @nodoc
  update: =>
    for i in [@count..0]
      particle =  @_particles.geometry.vertices[i]
      particle.y += @_dirs[i].y
      particle.x += @_dirs[i].x
      particle.z += @_dirs[i].z
    @_particles.geometry.verticesNeedUpdate = true
    if new Date() - @_startTime > @duration
      @onExplodeFinish?()
      Game.scene.remove(@_particles)

  # @private
  _randomSpherePoint: =>
    # make points in a sphere
    theta = Math.random() * Math.PI
    phi = Math.random() * Math.PI * 2
    x = Math.sin(theta) * Math.cos(phi) * @speed * Math.random()
    y = Math.sin(theta) * Math.sin(phi) * @speed * Math.random()
    z = Math.cos(theta) * @speed * Math.random()
    return {x: x, y: y, z: z}
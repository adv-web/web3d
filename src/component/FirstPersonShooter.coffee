Component = require("../Component")
GameObject = require("../GameObject")

class FirstPersonShooter extends Component
  module.exports = this

  constructor: (@_scene, @_controller) ->
    super("FirstPersonShooter")
    @_lastFireTime = 0

  afterAdded: =>
    document.body.onclick = @_onFire

  beforeRemoved: =>
    document.body.onclick = null

  _onFire: =>
    # 确认冷却时间
    currentTime = new Date()
    return if currentTime - @_lastFireTime < 1000
    @_lastFireTime = currentTime
    # 创造子弹，此处可以考虑使用对象池优化
    # 可以令子弹只存活5s
    geometry = new THREE.SphereGeometry(0.05)
    material = new THREE.MeshBasicMaterial({color: 0xffff00})
    mesh = new Physijs.SphereMesh(geometry, material)
    worldPosition = @gameObject.mesh.position
    mesh.position.set(worldPosition.x, worldPosition.y + 0.5, worldPosition.z)
    mesh.name = "bullet"
    @_scene.addObject(new GameObject(mesh))
    rot_y = @_controller._yaw.rotation.y
    rot_x = @_controller._pitch.rotation.x
    # 这里的设置速度是世界坐标系。好不容易调出来的方向
    mesh.setLinearVelocity(new THREE.Vector3(-Math.sin(rot_y)*Math.cos(rot_x)*10, Math.sin(rot_x)*10, -Math.cos(rot_y)*Math.cos(rot_x)*10))
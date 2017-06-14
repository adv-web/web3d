Data = require("./Data")
GameObject = require("./GameObject")
Bullet = require("./component/Bullet")
Camera = require("./component/Camera")
#FirstPersonController = require("./component/FirstPersonController")
FirstPersonObserver = require("./component/FirstPersonObserver")
VehicleController = require("./component/VehicleController")
FirstPersonShooter = require("./component/FirstPersonShooter")
GUIDat = require("./component/GUIDat")
HUD = require("./component/HUD")
NetWorkComponent = require("./component/NetWorkComponent")
NetWorkTransform = require("./component/NetWorkTransform")
TreeCollision = require("./component/TreeCollision")
BoxCollider = require("./component/colliders/BoxCollider")
AudioListener = require('./component/AudioListener')
AudioSource = require('./component/AudioSource')
Tank = require("./component/Tank")

# The scene in game to contain game objects and other essential objects.
#
# To render the scene, it will auto detect cameras and save it to an array when add a game object to the scene.
# But if there are multiply cameras in a scene, only the first one will be used to render.
class Scene
  module.exports = this

  # Construct a scene use an initializer.
  # @param initializer [Function] the user-defined initialize function to add objects in the scene
  constructor: (initializer) ->
    @_scene = new Physijs.Scene()
    # @_scene.setGravity(new THREE.Vector3(10, 0, 10))
    @_cameras = []
    @_objects = []
    initializer(this)

  # This is a generic Scene add method.
  #
  # @overload add(gameObject)
  #   Add a game object to the scene.
  #   @param [GameObject] gameObject the game object to be added
  #
  # @overload add(object)
  #   Add a light/skybox or any not GameObject to the scene.
  #   @param [Object] object the object to be added
  add: (object) =>
    if object.isGameObject
      @_objects.push(object)
      @_scene.add(object.mesh)
      @_cameras.push(object.getComponent("Camera")._camera) if object.getComponent("Camera")?
    else
      @_scene.add(object)

  # This is a generic Scene remove method.
  #
  # @overload remove(gameObject)
  #   Remove a game object to the scene.
  #   @param [GameObject] gameObject the game object to be removed
  #
  # @overload remove(mesh)
  #   Remove a game object of this mesh to the scene. It's equal to use remove(mesh.gameObject).
  #   @param [THREE.Mesh | Physijs.Mesh] mesh the mesh of the game object to be removed
  #
  # @overload remove(object)
  #   Remove a light/skybox or any not GameObject or Mesh to the scene.
  #   @param [Object] object the object to be removed
  remove: (object) =>
    return if not object
    return @_removeGameObject(object) if object.isGameObject
    return @_removeGameObject(object.gameObject) if object.isMesh
    @_scene.remove(object)  # not game object or mesh

  spawn: (prefab, position = new THREE.Vector3(0, 0, 0), rotation = new THREE.Vector3(0, 0, 0)) =>
    prototype = switch prefab.meshType
      when "vox" then Data.vox[prefab.mesh]
      when "code" then eval(prefab.mesh)
    mesh = prototype.clone()
    if prefab.mass
      mesh.mass = if prefab.mass >= 0 then prefab.mass else prototype.mass
    else
      mesh.mass = 0
    mesh.name = prefab.name
    mesh.position.set(position.x, position.y, position.z)
    mesh.rotation.set(rotation.x, rotation.y, rotation.z)
    obj = new GameObject(mesh)
    prefab.components?.forEach (comp) =>
      #eval("#{comp.name} = require('./component/#{comp.name}')")
      param = if comp.param then comp.param else ""
      eval("obj.addComponent(new #{comp.name}(#{param}))")
    @add(obj)
    return obj

  # @private
  _removeGameObject: (object) =>
    return if not object?
    @_cameras.remove(object.getComponent("Camera")._camera) if object.getComponent("Camera")?
    @_scene.remove(object.mesh) if object.mesh?
    object.beforeRemoved()
    @_objects.remove(object)

  # @nodoc
  update: (deltaTime) =>
    comp.update?(deltaTime) for name, comp of object?.components for object in @_objects
    @_scene.simulate()  # for physical simulation




class Scene
  constructor: (@name) ->
    @camera = new THREE.PerspectiveCamera( 75, window.innerWidth/window.innerHeight, 0.1, 1000 )
    @scene = new THREE.Scene()

  add: (gameObject) ->
    @scene.add(gameObject.mesh)

  init: ->
    geometry = new THREE.BoxGeometry( 1, 1, 1 )
    material = new THREE.MeshBasicMaterial( { color: 0x00ff00 } )
    cubeMesh = new THREE.Mesh( geometry, material )
    cube = new GameObject(cubeMesh)
    @add(cube)

    rotateScript = new Rotate()
    cube.addComponent(rotateScript)

    @camera.position.z = 5



window.Scene = Scene
Game.instance().addScene(new Scene('first'))
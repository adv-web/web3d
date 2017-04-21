class Scene
  constructor: (@name) ->
    @camera = new THREE.PerspectiveCamera( 75, window.innerWidth/window.innerHeight, 0.1, 1000 )
    @scene = new THREE.Scene()

  init: ->
    geometry = new THREE.BoxGeometry( 1, 1, 1 )
    material = new THREE.MeshBasicMaterial( { color: 0x00ff00 } )
    cube = new THREE.Mesh( geometry, material )
    @scene.add(cube)
    @camera.position.z = 5

window.Scene = Scene
Game.instance().addScene(new Scene('first'))
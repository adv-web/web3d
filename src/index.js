/**
 * Created by maliut on 2017/4/21.
 */
var Game = require("./Game");
var Scene = require("./Scene");
var GameObject = require("./GameObject");
var Camera = require("./component/Camera");
var PointerLockController = require("./component/PointerLockController");
var Mover = require("./component/Mover");

var voxParser = new vox.Parser();
function scene1(scene) {
    // light
    var ambient = new THREE.AmbientLight(/*0x101030*/0xcccccc);
    scene.addLight(ambient);
    // object
    voxParser.parse('vox/ground.vox').then(function (voxelData) {
        var builder = new vox.MeshBuilder(voxelData, {voxelSize: 0.05});
        var threeMesh = builder.createMesh();
        var mesh = new Physijs.BoxMesh(threeMesh.geometry, threeMesh.material, 0);
        mesh.position.set(0, -1, -1);
        scene.addObject(new GameObject(mesh));
    });
    voxParser.parse('vox/chr_knight.vox').then(function (voxelData) {
        var builder = new vox.MeshBuilder(voxelData, {voxelSize: 0.03});
        var threeMesh = builder.createMesh();
        var mesh = new Physijs.ConvexMesh(threeMesh.geometry, threeMesh.material);
        var character = new GameObject(mesh);
        // TODO add components on character
        scene.addObject(character);
        /*var constraint = new Physijs.DOFConstraint(
            mesh, // First object to be constrained
            //null, // OPTIONAL second object - if omitted then physijs_mesh_1 will be constrained to the scene
            new THREE.Vector3(0,0,0)// point in the scene to apply the constraint
        );
        scene.addConstraint( constraint );*/
        //constraint.setLinearLowerLimit( new THREE.Vector3( -100, -100, -100 ) ); // sets the lower end of the linear movement along the x, y, and z axes.
        //constraint.setLinearUpperLimit( new THREE.Vector3( 100, 100, 100 ) ); // sets the upper end of the linear movement along the x, y, and z axes.
        //constraint.setAngularLowerLimit( new THREE.Vector3( 0, -Math.PI, 0 ) ); // sets the lower end of the angular movement, in radians, along the x, y, and z axes.
        //constraint.setAngularUpperLimit( new THREE.Vector3( 0, Math.PI, 0 ) ); // sets the upper end of the angular movement, in radians, along the x, y, and z axes.
        //constraint.setAngularLowerLimit({ x: 0, y: 0, z: 0 }); // sets the lower end of the angular movement, in radians, along the x, y, and z axes.
        //constraint.setAngularUpperLimit({ x: 0, y: 0, z: 0 });
    });
    voxParser.parse('vox/chr_knight.vox').then(function (voxelData) {
        var builder = new vox.MeshBuilder(voxelData, {voxelSize: 0.03});
        var threeMesh = builder.createMesh();
        var mesh = new Physijs.ConvexMesh(threeMesh.geometry, threeMesh.material);
        //var mesh = new THREE.Mesh(threeMesh.geometry, threeMesh.material);
        mesh.position.set(0, -0.5, 1);
        var player = new GameObject(mesh);
        var camera = new Camera();
        camera._camera.position.set(0, 0.25, 0);
        player.addComponent(camera);
        player.addComponent(new PointerLockController(camera));
        player.addComponent(new Mover());
        scene.addObject(player);
        var constraint = new Physijs.HingeConstraint(
            mesh, // First object to be constrained
            mesh, // OPTIONAL second object - if omitted then physijs_mesh_1 will be constrained to the scene
            new THREE.Vector3(0,0,0),// point in the scene to apply the constraint
            new THREE.Vector3( 1, 1, 1 )
        );
        scene.addConstraint( constraint );
        //constraint.setLinearLowerLimit( new THREE.Vector3( -100, -100, -100 ) ); // sets the lower end of the linear movement along the x, y, and z axes.
        //constraint.setLinearUpperLimit( new THREE.Vector3( 100, 100, 100 ) ); // sets the upper end of the linear movement along the x, y, and z axes.
        //constraint.setAngularLowerLimit( new THREE.Vector3( 0, -Math.PI, 0 ) ); // sets the lower end of the angular movement, in radians, along the x, y, and z axes.
        //constraint.setAngularUpperLimit( new THREE.Vector3( 0, Math.PI, 0 ) ); // sets the upper end of the angular movement, in radians, along the x, y, and z axes.
        //constraint.setAngularLowerLimit({ x: -Math.PI/8, y: -Math.PI/8, z: -Math.PI/8 }); // sets the lower end of the angular movement, in radians, along the x, y, and z axes.
        //constraint.setAngularUpperLimit({ x: Math.PI/8, y: Math.PI/8, z: Math.PI/8 });
    });
    /*var geometry = new THREE.BoxGeometry( 2, 2, 2);
    var material = new THREE.MeshBasicMaterial( { color: 0xff0000, wireframe: true } );
    var mesh = new THREE.Mesh(geometry, material);
    mesh.position.set(0, -0.5, 1);
    var player = new GameObject(mesh);
    var camera = new Camera();
    player.addComponent(camera);
    player.addComponent(new PointerLockController(camera));
    player.addComponent(new Mover());
    scene.addObject(player);
    Game.requestPointerLock();*/
}
// 异步变同步？用同一个方法而且可以做进度条
var scene = new Scene(scene1);
new Game().setScene(scene).start();
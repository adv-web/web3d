/**
 * Created by maliut on 2017/4/21.
 */
var Game = require("./Game");
var Scene = require("./Scene");
var GameObject = require("./GameObject");
var Camera = require("./component/Camera");
var FirstPersonController = require("./component/FirstPersonController");

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
        mesh.name = "ground";
        scene.addObject(new GameObject(mesh));
    });
    voxParser.parse('vox/chr_knight.vox').then(function (voxelData) {
        var builder = new vox.MeshBuilder(voxelData, {voxelSize: 0.03});
        var threeMesh = builder.createMesh();
        var mesh = new Physijs.BoxMesh(threeMesh.geometry, threeMesh.material);
        mesh.name = "npc";
        var character = new GameObject(mesh);
        scene.addObject(character);
    });
    voxParser.parse('vox/chr_knight.vox').then(function (voxelData) {
        //var builder = new vox.MeshBuilder(voxelData, {voxelSize: 0.03});
        //var threeMesh = builder.createMesh();
        var geometry = new THREE.BoxGeometry( 0.2, 0.2, 0.2);
        var material = new THREE.MeshBasicMaterial( { color: 0xff0000, wireframe: true } );
        //var mesh = new THREE.Mesh(geometry, material);
        var mesh = new Physijs.BoxMesh(geometry, material);
        //var mesh = new THREE.Mesh(threeMesh.geometry, threeMesh.material);
        mesh.position.set(0, -0.5, 1);
        mesh.name = "player";

        var player = new GameObject(mesh);

        var camera = new Camera();
        camera._camera.position.set(0, 0.25, 0);
        player.addComponent(camera);
        scene.addObject(player);
        player.addComponent(new FirstPersonController(camera));

    });

}
// 异步变同步？用同一个方法而且可以做进度条
document.addEventListener('keydown', Game.requestFullScreen, false);

//Game.requestPointerLock();

var scene = new Scene(scene1);

new Game().setScene(scene).start();
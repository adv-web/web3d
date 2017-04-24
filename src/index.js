/**
 * Created by maliut on 2017/4/21.
 */
var Game = require("./Game");
var Scene = require("./Scene");
var GameObject = require("./GameObject");
var Test = require("./component/Test");

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
        character.addComponent(new Test());
        scene.addObject(character);
    });

    var geometry = new THREE.BoxGeometry( 1, 1, 1 );
    var material = new THREE.MeshBasicMaterial( { color: 0x00ff00 } );
    var cubeMesh = new THREE.Mesh( geometry, material );
    var cube = new GameObject(cubeMesh);
    scene.addObject(cube);

    var Rotate = require("./Script");
    var rotateScript = new Rotate();
    cube.addComponent(rotateScript);
}

var scene = new Scene(scene1);
new Game().setScene(scene).start();
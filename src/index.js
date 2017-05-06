/**
 * Created by maliut on 2017/4/21.
 */
var Game = require("./Game");
var Scene = require("./Scene");
var GameObject = require("./GameObject");
var Camera = require("./component/Camera");
var FirstPersonController = require("./component/FirstPersonController");

var voxParser = new vox.Parser();
var gui = new dat.GUI();
function scene1(scene) {
    var loadTree = function (x, y) {

        if (Math.abs(x)>0.3 || y>0.3  ){

            voxParser.parse('vox/obj_tree1.vox').then(function (voxelData) {
            var builder = new vox.MeshBuilder(voxelData, {voxelSize: 0.025});
            var threeMesh = builder.createMesh();
            var mesh = new Physijs.BoxMesh(threeMesh.geometry, threeMesh.material,0);
            mesh.position.set(x, -0.9, y);
            var character = new GameObject(mesh);
            scene.addObject(character);
        });
        }
    };
    var loadWall = function (x, y) {
        voxParser.parse('vox/obj_wall.vox').then(function (voxelData) {
            var builder = new vox.MeshBuilder(voxelData, {voxelSize: 0.2});
            var threeMesh = builder.createMesh();
            var mesh = new Physijs.BoxMesh(threeMesh.geometry, threeMesh.material,0);
            mesh.position.set(x, -2.6, y);
            var character = new GameObject(mesh);
            scene.addObject(character);
        });
    };
    var loadWall2 = function (x, y) {
        voxParser.parse('vox/obj_wall.vox').then(function (voxelData) {
            var builder = new vox.MeshBuilder(voxelData, {voxelSize: 0.2});
            var threeMesh = builder.createMesh();
            var mesh = new Physijs.BoxMesh(threeMesh.geometry, threeMesh.material,0);
            mesh.position.set(x, -2.6, y);
            mesh.rotation.set(0, Math.PI / 2, 0);
            var character = new GameObject(mesh);
            scene.addObject(character);
        });
    };

    // light
    var ambient = new THREE.AmbientLight(/*0x101030*/0xcccccc);
    scene.addLight(ambient);
    // object
    voxParser.parse('vox/ground.vox').then(function (voxelData) {
        var builder = new vox.MeshBuilder(voxelData, {voxelSize: 0.06});
        var threeMesh = builder.createMesh();
        var mesh = new Physijs.BoxMesh(threeMesh.geometry, threeMesh.material, 0);
        mesh.position.set(0, -1, -1);
        mesh.name = "ground";
        scene.addObject(new GameObject(mesh));
    });
    /*voxParser.parse('vox/platform.vox').then(function (voxelData) {
        var builder = new vox.MeshBuilder(voxelData, {voxelSize: 0.005});
        var threeMesh = builder.createMesh();
        var mesh = new Physijs.BoxMesh(threeMesh.geometry, threeMesh.material);
        mesh.position.set(0, -0.5, 0);
        mesh.name = "npc";
        window.mesh = mesh;
        var character = new GameObject(mesh);
        scene.addObject(character);
    });*/
    voxParser.parse('vox/8x8x8.vox').then(function (voxelData) {
        var builder = new vox.MeshBuilder(voxelData, {voxelSize: 0.25});
        var threeMesh = builder.createMesh();
        var mesh = new Physijs.BoxMesh(threeMesh.geometry, threeMesh.material,0);
        mesh.position.set(0, -0.9, -3);
        mesh.rotation.set(0, Math.PI /2.0, 0);
        var character = new GameObject(mesh);
        scene.addObject(character);
    });
    voxParser.parse('vox/chest.vox').then(function (voxelData) {
        var builder = new vox.MeshBuilder(voxelData, {voxelSize: 0.02});
        var threeMesh = builder.createMesh();
        var mesh = new Physijs.BoxMesh(threeMesh.geometry, threeMesh.material,0);
        mesh.position.set(0, -0.9, -4);
        var character = new GameObject(mesh);
        scene.addObject(character);
    });
    var myDate = new Date();
    for (var i=9; i<15; i++){
        for (var j=9; j<15; j++){
            loadTree(i*0.48-5.76+Math.random()*0.3-0.15,j*0.48-5.76+Math.random()*0.3-0.15);
        }
    }
    // loadTree(0.28 ,0.30);
    // loadTree(0.65 ,0.38);
    // loadTree(-0.32 ,-0.38);
    // loadTree(-0.46 ,0.52);
    // loadTree(0.43 ,-0.50);
    // loadTree(0.41 ,0.64);
    // //7093 8446 0955 0582 2317 2535 9408 1284 8113 7450 2841 0270 1938 5211
    // loadTree(0.32 ,-0.30);
    // loadTree(0.62 ,-0.36);
    // loadTree(0.48 ,-0.24);
    // //loadTree(-0.30 ,0.22);
    // loadTree(-0.37 ,0.12);
    // loadTree(0.42 ,0.11);
    // loadTree(0.70 ,0.67);
    // loadTree(-0.93 ,-0.21);
    // loadTree(-0.48 ,0.08);
    // loadTree(0.65 ,-0.13);
    // loadTree(0.06 ,0.32);
    // loadTree(-0.13 ,0.42);
    // loadTree(-0.12 ,-0.42);
    // loadTree(0.12 ,-0.62);
    // //loadTree(0.14 ,0.14);

    loadWall(0,3.2);
    //loadWall(0,-1);
    loadWall2(3.2,0);
    loadWall2(-2,0);

    // player
    var geometry = new THREE.BoxGeometry( 0.2, 0.2, 0.2);
    var material = new THREE.MeshBasicMaterial( { color: 0xff0000, wireframe: true } );
    var mesh = new Physijs.BoxMesh(geometry, material);
    mesh.position.set(0, -0.5, 1);
    mesh.name = "player";
    var player = new GameObject(mesh);
    var camera = new Camera();
    camera._camera.position.set(0, 0.25, 0);
    player.addComponent(camera);
    var fpc = new FirstPersonController(camera, {sensitivity: 1});
    player.addComponent(fpc);
    scene.addObject(player);
    // dat

    gui.add(fpc, 'sensitivity').min(0).step(0.5);
    gui.add(fpc, 'move_velocity').min(0).step(0.5);
    gui.add(fpc, 'jump_velocity').min(0).step(0.5);

}
// 异步变同步？用同一个方法而且可以做进度条
document.addEventListener('keydown', Game.requestFullScreen, false);

//Game.requestPointerLock();

var scene = new Scene(scene1);

new Game().setScene(scene).start();
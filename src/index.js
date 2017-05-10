/**
 * Created by maliut on 2017/4/21.
 */
var Game = require("./Game");
var Scene = require("./Scene");
var GameObject = require("./GameObject");
var Camera = require("./component/Camera");
var FirstPersonController = require("./component/FirstPersonController");
var HUD = require("./component/HUD");
var FirstPersonShooter = require("./component/FirstPersonShooter");
var TreeCollider = require("./component/TreeCollider");
// 公用资源
var voxParser = new vox.Parser();
var meshes = {};
var gui = new dat.GUI();
// 加载模型资源
var MODEL_COUNT = 6;
voxParser.parse('vox/obj_tree1.vox').then(function (voxelData) {
    var threeMesh = (new vox.MeshBuilder(voxelData, {voxelSize: 0.025})).createMesh();
    meshes.tree = new Physijs.BoxMesh(threeMesh.geometry, threeMesh.material, 0);
    checkLoad();
});
voxParser.parse('vox/obj_wall.vox').then(function (voxelData) {
    var threeMesh = (new vox.MeshBuilder(voxelData, {voxelSize: 0.2})).createMesh();
    meshes.wall = new Physijs.BoxMesh(threeMesh.geometry, threeMesh.material, 0);
    checkLoad();
});
voxParser.parse('vox/cube2.vox').then(function (voxelData) {
    var threeMesh = (new vox.MeshBuilder(voxelData, {voxelSize: 0.025})).createMesh();
    meshes.cube = new Physijs.BoxMesh(threeMesh.geometry, threeMesh.material, 0);
    checkLoad();
});
voxParser.parse('vox/ground.vox').then(function (voxelData) {
    var threeMesh = (new vox.MeshBuilder(voxelData, {voxelSize: 0.08})).createMesh();
    meshes.ground = new Physijs.BoxMesh(threeMesh.geometry, threeMesh.material, 0);
    checkLoad();
});
voxParser.parse('vox/8x8x8.vox').then(function (voxelData) {
    var threeMesh = (new vox.MeshBuilder(voxelData, {voxelSize: 0.25})).createMesh();
    meshes.x8 = new Physijs.BoxMesh(threeMesh.geometry, threeMesh.material, 0);
    checkLoad();
});
voxParser.parse('vox/chest.vox').then(function (voxelData) {
    var threeMesh = (new vox.MeshBuilder(voxelData, {voxelSize: 0.02})).createMesh();
    meshes.chest = new Physijs.BoxMesh(threeMesh.geometry, threeMesh.material, 0);
    checkLoad();
});
// 场景1初始化方法
function scene1(scene) {
    var loadTree = function (x, y) {
        if (Math.abs(x) > 0.3 || y > 0.3) {
            var mesh = meshes.tree.clone();
            mesh.position.set(x, -0.9, y);
            mesh._physijs.mass = 0;
            var tree = new GameObject(mesh);
            tree.addComponent(new TreeCollider());
            scene.add(tree);
        }
    };
    var loadWall = function (x, y) {
        var mesh = meshes.wall.clone();
        mesh.position.set(x, -2.6, y);
        mesh._physijs.mass = 0;
        scene.add(new GameObject(mesh));
    };
    var loadWall2 = function (x, y) {
        var mesh = meshes.wall.clone();
        mesh.position.set(x, -2.6, y);
        mesh.rotation.set(0, Math.PI / 2, 0);
        mesh._physijs.mass = 0;
        scene.add(new GameObject(mesh));
    };
    var loadCube = function (x, y, z) {
    var mesh = meshes.cube.clone();
    mesh.position.set(x, y, z);
    mesh._physijs.mass = 0;
    scene.add(new GameObject(mesh));
};
    // sky box
    scene.add(THREE.SkyBox(['img/Right.jpg', 'img/Left.jpg', 'img/Up.jpg', 'img/Down.jpg', 'img/Back.jpg', 'img/Front.jpg'], 100));
    // light
    scene.add(new THREE.AmbientLight(0x800000));
    var directionalLight = new THREE.DirectionalLight(0xff5808);
    directionalLight.position.set(0, 0, 1);
    directionalLight.castShadow = true;
    scene.add(directionalLight);
    var hemiLight = new THREE.HemisphereLight(0x87CEEB, 0x32CD32, 1);
    hemiLight.position.set(0, -1, -1);
    scene.add(hemiLight);
    // ground
    var mesh = meshes.ground.clone();
    mesh.position.set(0, -1, -1);
    mesh.mass = 0;     // mesh clone 的时候有 bug， 无法 clone _physijs 属性
    mesh.name = "ground";
    scene.add(new GameObject(mesh));
    // 8x8x8
    mesh = meshes.x8.clone();
    mesh.position.set(0, -0.9, -3);
    mesh.rotation.set(0, Math.PI / 2.0, 0);
    mesh.mass = 0;
    scene.add(new GameObject(mesh));
    // chest
    mesh = meshes.chest.clone();
    mesh.position.set(0, -0.9, -4);
    mesh.mass = 0;
    scene.add(new GameObject(mesh));
    // tree
    for (var i = 9; i < 15; i++) {
        for (var j = 9; j < 15; j++) {
            loadTree(i * 0.48 - 5.76 + Math.random() * 0.3 - 0.15, j * 0.48 - 5.76 + Math.random() * 0.3 - 0.15);
        }
    }
    // cube
    for (i = 0; i < 5; i++) {
        loadCube(2.5, -0.8 + 0.4 * i, -0.5 * i);
    }
    // wall
    loadWall(0, 3.2);
    loadWall2(3.2, 0);
    loadWall2(-2, 0);
    // player
    var geometry = new THREE.BoxGeometry(0.2, 0.2, 0.2);
    var material = new THREE.MeshBasicMaterial({color: 0xff0000, wireframe: true});
    mesh = new Physijs.BoxMesh(geometry, material);
    mesh.position.set(0, -0.5, 1);
    mesh.name = "player";
    var player = new GameObject(mesh);
    var camera = new Camera();
    camera.position.set(0, 0.25, 0);
    player.addComponent(camera);
    var fpc = new FirstPersonController(camera, {sensitivity: 1});
    player.addComponent(fpc);
    player.addComponent(new HUD());
    player.addComponent(new FirstPersonShooter(fpc));
    scene.add(player);
    // dat
    gui.add(fpc, 'sensitivity').min(0).step(0.5);
    gui.add(fpc, 'move_velocity').min(0).step(0.5);
    gui.add(fpc, 'jump_velocity').min(0).step(0.5);

}
document.addEventListener('keydown', Game.requestFullScreen, false);

var loadedCount = 0;
function checkLoad() {
    loadedCount++;
    if (loadedCount === MODEL_COUNT) {
        var scene = new Scene(scene1);
        new Game().setScene(scene).start();
    }
}
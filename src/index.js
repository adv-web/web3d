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
var Bullet = require("./component/Bullet");
var NetWorkManager = require('./NetWorkManager');
    // 公用资源
var voxParser = new vox.Parser();
var meshes = {};

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
    var loadTree = function (pos) {
        if (Math.abs(pos.x) > 0.3 || pos.y > 0.3) {
            var mesh = meshes.tree.clone();
            mesh.position.set(pos.x, -0.9, pos.y);
            mesh._physijs.mass = 0;
            var tree = new GameObject(mesh);
            tree.addComponent(new TreeCollider());
            return tree;
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

    // cube
    for (var i = 0; i < 5; i++) {
        loadCube(2.5, -0.8 + 0.4 * i, -0.5 * i);
    }
    // wall
    loadWall(0, 3.2);
    loadWall2(3.2, 0);
    loadWall2(-2, 0);

    // player
    function player() {
        var geometry = new THREE.BoxGeometry(0.2, 0.2, 0.2);
        var material = new THREE.MeshBasicMaterial({color: 0xff0000, wireframe: true});
        var mesh = new Physijs.BoxMesh(geometry, material);
        mesh.position.set(0, -0.5, 1);
        mesh.name = "player";
        var player = new GameObject(mesh,"player");
        var camera = new Camera();
        camera.position.set(0, 0.25, 0);
        player.addComponent(camera);
        var fpc = new FirstPersonController(camera, {sensitivity: 1});
        player.addComponent(fpc);
        player.addComponent(new HUD());
        var fps = new FirstPersonShooter(fpc)
        player.addComponent(fps);
        var GUIDatComponent = require('./component/GUIDatComponent');
        player.addComponent(new GUIDatComponent());
        var NetWorkTransformComponent = require('./component/NetWorkTransformComponent');
        player.addComponent(new NetWorkTransformComponent());
        return player;
    }

    // bullet
    var makeBullet = function(mess) {
        var pos = mess.pos;
        var vel = mess.vel;
        var geometry = new THREE.SphereGeometry(0.05);
        var material = new THREE.MeshBasicMaterial({color: 0xffff00});
        var mesh = new Physijs.SphereMesh(geometry, material);
        mesh.position.set(pos[0], pos[1], pos[2]);
        mesh.name = "bullet";
        var obj = new GameObject(mesh);
        obj.addComponent(new Bullet());
        obj.mesh.setLinearVelocity(new THREE.Vector3(vel[0], vel[1], vel[2]));
        return obj;
    };


    NetWorkManager.init(scene,player);
    loadTree.key = "loadTree";
    NetWorkManager.addPrefab(loadTree);
    makeBullet.key = "bullet";
    NetWorkManager.addPrefab(makeBullet);
}
document.addEventListener('keydown', Game.requestFullScreen, false);

var loadedCount = 0;
function checkLoad() {
    loadedCount++;
    if (loadedCount === MODEL_COUNT) {
        var scene = new Scene(scene1);
        new Game().setScene(scene).start();
        NetWorkManager.client_start();
    }
}
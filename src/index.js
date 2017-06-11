/**
 * Created by maliut on 2017/4/21.
 */
var Game = require("./Game");
var Scene = require("./Scene");
var NetWorkManager = require('./NetWorkManager');
var Data = require("./Data");

// 场景1初始化方法
function scene1(scene) {
    // sky box
    scene.add(THREE.SkyBox(['images/Right.jpg', 'images/Left.jpg', 'images/Up.jpg', 'images/Down.jpg', 'images/Back.jpg', 'images/Front.jpg'], 100));
    // light
    scene.add(new THREE.AmbientLight(0x000080,.2));
    var directionalLight = new THREE.DirectionalLight(0xFFFFFF,.7);
    directionalLight.position.set(0, 0, 1);
    directionalLight.castShadow = true;
    scene.add(directionalLight);
    var directionalLightback = new THREE.DirectionalLight(0xFFFFFF,.7);
    directionalLightback.position.set(0, 0, -1);
    directionalLightback.rotation.set(0, Math.PI, 0);
    directionalLightback.castShadow = true;
    scene.add(directionalLightback);
    var hemiLight = new THREE.HemisphereLight(0xffff80, 0xffff80, .2);
    hemiLight.position.set(0, -1, -1);
    scene.add(hemiLight);
    // objects
    scene.spawn(Data.prefab.ground, new THREE.Vector3(0, -1, -10));
    scene.spawn(Data.prefab.ground, new THREE.Vector3(0, -1, 0));
    scene.spawn(Data.prefab.ground, new THREE.Vector3(0, -1, 10));
    scene.spawn(Data.prefab.ground, new THREE.Vector3(10, -1, 0));
    scene.spawn(Data.prefab.ground, new THREE.Vector3(10, -1, -10));
    scene.spawn(Data.prefab.ground, new THREE.Vector3(10, -1, 10));
    scene.spawn(Data.prefab.ground, new THREE.Vector3(-10, -1, 0));
    scene.spawn(Data.prefab.ground, new THREE.Vector3(-10, -1, -10));
    scene.spawn(Data.prefab.ground, new THREE.Vector3(-10, -1, 10));
    scene.spawn(Data.prefab.house, new THREE.Vector3(0, -0.8, 0));
    //scene.spawn(Data.prefab.container, new THREE.Vector3(12, -0.8, 5));
    //scene.spawn(Data.prefab.container, new THREE.Vector3(5, -0.8, 5));
    //scene.spawn(Data.prefab.fence, new THREE.Vector3(8.5, -0.8, 5));
    scene.spawn(Data.prefab.train_container, new THREE.Vector3(8.5, -0.8, 5),new THREE.Vector3(0, Math.PI / 2, 0));
    //scene.spawn(Data.prefab.container, new THREE.Vector3(-12, -0.8, -5));
    //scene.spawn(Data.prefab.container, new THREE.Vector3(-5, -0.8, -5));
    //scene.spawn(Data.prefab.fence, new THREE.Vector3(-8.5, -0.8, -5));

    scene.spawn(Data.prefab.train_empty, new THREE.Vector3(-8.5, -0.8, -5));
    scene.spawn(Data.prefab.container, new THREE.Vector3(12, -0.8, -5));
    scene.spawn(Data.prefab.container, new THREE.Vector3(-12, -0.8, 5));
    scene.spawn(Data.prefab.container, new THREE.Vector3(5, -0.8, -5));
    scene.spawn(Data.prefab.container, new THREE.Vector3(-5, -0.8, 5));

    scene.spawn(Data.prefab.fence, new THREE.Vector3(8.5, -0.8, -5));
    scene.spawn(Data.prefab.fence, new THREE.Vector3(-8.5, -0.8, 5));

    scene.spawn(Data.prefab.tree, new THREE.Vector3(12, -0.8, 0));
    scene.spawn(Data.prefab.tree, new THREE.Vector3(-12, -0.8, 0));

    scene.spawn(Data.prefab.statue_red, new THREE.Vector3(0, -0.8, 12), new THREE.Vector3(0, Math.PI, 0));
    scene.spawn(Data.prefab.statue_blue, new THREE.Vector3(0, -0.8, -12));

    //scene.spawn(Data.prefab.chest, new THREE.Vector3(0, -0.9, -4));

    //scene.spawn(Data.prefab.wall, new THREE.Vector3(0, -2.6, 3.2));
   // scene.spawn(Data.prefab.wall, new THREE.Vector3(3.2, -2.6, 0), new THREE.Vector3(0, Math.PI / 2, 0));
   // scene.spawn(Data.prefab.wall, new THREE.Vector3(-2, -2.6, 0), new THREE.Vector3(0, Math.PI / 2, 0));
    //scene.spawn(Data.prefab.tank_start);

    NetWorkManager.init(scene, Data.prefab.player, 'http://120.76.125.35:5000/game');
    NetWorkManager.setSpawnPoint(new THREE.Vector3(-0.5, -0.5, -5))

}

// boot script
Data.load(null, null, function() {
    var scene = new Scene(scene1);
    Game.setScene(scene).start();
});

document.addEventListener('keydown', Game.requestFullScreen, false);

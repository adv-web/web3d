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
    // objects
    scene.spawn(Data.prefab.ground, new THREE.Vector3(0, -1, -1));
    scene.spawn(Data.prefab.x8, new THREE.Vector3(0, -0.9, -3), new THREE.Vector3(0, Math.PI / 2.0, 0));
    scene.spawn(Data.prefab.chest, new THREE.Vector3(0, -0.9, -4));
    for (var i = 0; i < 5; i++) {
        scene.spawn(Data.prefab.cube, new THREE.Vector3(2.5, -0.8 + 0.4 * i, -0.5 * i));
    }
    scene.spawn(Data.prefab.wall, new THREE.Vector3(0, -2.6, 3.2));
    scene.spawn(Data.prefab.wall, new THREE.Vector3(3.2, -2.6, 0), new THREE.Vector3(0, Math.PI / 2, 0));
    scene.spawn(Data.prefab.wall, new THREE.Vector3(-2, -2.6, 0), new THREE.Vector3(0, Math.PI / 2, 0));

    NetWorkManager.init(scene, Data.prefab.player, 'http://120.76.125.35:5000/game');

}

// boot script
Data.load(null, null, function() {
    var scene = new Scene(scene1);
    Game.setScene(scene).start();
    NetWorkManager.client_start();
});

document.addEventListener('keydown', Game.requestFullScreen, false);

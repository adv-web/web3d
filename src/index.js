/**
 * Created by maliut on 2017/4/21.
 */
var Game = require("./Game");
var Scene = require("./Scene");
var NetWorkManager = require('./NetWorkManager');
var Data = require("./Data");
var Input = require("./Input");
var GameObject = require("./GameObject");
var GameTimeCountdown = require("./component/GameTimeCountdown");

// var SERVER = "http://localhost:5000/";
var SERVER = "http://120.76.125.35:5000/";

// 场景1初始化方法
function scene1(scene) {
    // sky box
    scene.add(THREE.SkyBox(['images/Right.jpg', 'images/Left.jpg', 'images/Up.jpg', 'images/Down.jpg', 'images/Back.jpg', 'images/Front.jpg'], 100));
    // objects
    var ground_array =[
        0, -1, 0,
        0, -1, -10,
        0, -1, -20,
        0, -1, 10,
        0, -1, 20,
        10, -1, 0,
        10, -1, -10,
        10, -1, -20,
        10, -1, 10,
        10, -1, 20,
        -10, -1, 0,
        -10, -1, -10,
        -10, -1, -20,
        -10, -1, 10,
        -10, -1, 20,
        20, -1, 0,
        20, -1, -10,
        20, -1, -20,
        20, -1, 10,
        20, -1, 20,
        -20, -1, 0,
        -20, -1, -10,
        -20, -1, -20,
        -20, -1, 10,
        -20, -1, 20
    ];

    var grounds = [];

    for (var i = 0; i < 25; i++) {
        grounds[i]=scene.spawn(Data.prefab.ground, new THREE.Vector3(ground_array[i*3], ground_array[i*3+1], ground_array[i*3+2]));
        grounds[i].mesh.receiveShadow = true;
    }
    var contain_array = [

        -21,-14,0.78,
        -21,7,0.75,
        -21,14,0.4,

        -10.5, -21,1,
        -10.5,-14,0.38,
        -12,-3.5,0.75,
        -14, 3.5,0.14,
        -7.5, -7,0.76,
        -7.5, 0,0.24,
        -7.5, 7,1,
        -10.5, 14,0.43,
        -10.5, 21,0.24,
        0,  -10,0,
        0,  10,0,
        0,  -16,0,
        0,  16,0,
        10.5,  -21,0.91,
        10.5,  -14,0.35,
        7.5,  -7,0.25,
        7.5,  0,0.81,
        7.5, 7,0.91,
        13,  -3.5,0.32,
        15,  3.5,0.88,
        10.5,  14,0.8,
        10.5, 21,0.35,
        21,  -14,0.88,
        21, -7,0.5,
        20,  0,0.5


    ];
    var contains = [];
    for (i = 0; i < 28; i++){
        contains[i] = scene.spawn(Data.prefab["container" + (i % 4)], new THREE.Vector3(contain_array[i*3],-0.8,contain_array[i*3+1]),new THREE.Vector3(0, Math.PI*contain_array[i*3+2], 0));
        contains[i].mesh.castShadow = true;
    }

    var house_mesh = scene.spawn(Data.prefab.house, new THREE.Vector3(0, -0.8, 0)).mesh;
    house_mesh.castShadow = true;

    scene.spawn(Data.prefab.train_container, new THREE.Vector3(-21, -0.8, -3.5), new THREE.Vector3(0, Math.PI/2, 0)).mesh.castShadow = true;
    scene.spawn(Data.prefab.train_empty_head, new THREE.Vector3(22, -0.8, 9), new THREE.Vector3(0, 0, 0)).mesh.castShadow = true;
    scene.spawn(Data.prefab.train_empty_body, new THREE.Vector3(22, -0.8, 22), new THREE.Vector3(0, 0, 0)).mesh.castShadow = true;
    scene.spawn(Data.prefab.train_empty_body, new THREE.Vector3(22, -0.8, 15.5), new THREE.Vector3(0, 0, 0)).mesh.castShadow = true;

    scene.spawn(Data.prefab.pumpkin, new THREE.Vector3(8.5, -0.8, -5)).mesh.castShadow = true;
    scene.spawn(Data.prefab.pumpkin, new THREE.Vector3(-8.5, -0.8, 5)).mesh.castShadow = true;

    var tree_mesh = scene.spawn(Data.prefab.tree, new THREE.Vector3(24, -0.8, 0)).mesh;
    tree_mesh.castShadow = true;
    scene.spawn(Data.prefab.car, new THREE.Vector3(-3, -0.8, 0)).mesh.castShadow = true;

    var green_mesh = scene.spawn(Data.prefab.statue_green, new THREE.Vector3(0, -0.8, 22), new THREE.Vector3(0, Math.PI, 0)).mesh;
    green_mesh.castShadow = true;

    var blue_mesh = scene.spawn(Data.prefab.statue_blue, new THREE.Vector3(0, -0.8, -22)).mesh;
    blue_mesh.castShadow = true;

    scene.add(new THREE.AmbientLight(0x0c0c0c, .2));
    var directionalLight = new THREE.DirectionalLight(0xFFFFFF, .4);
    directionalLight.position.set(10, 10, 0);
    directionalLight.rotation.set(0, Math.PI/2, 0);

    directionalLight.castShadow = true;

    directionalLight.shadow.camera.near = 2;
    directionalLight.shadow.camera.far = 200;
    directionalLight.shadow.camera.left = -50;
    directionalLight.shadow.camera.right = 50;
    directionalLight.shadow.camera.top = 50;
    directionalLight.shadow.camera.bottom = -50;
    //directionalLight.shadowCameraVisible = true;
    directionalLight.distance = 0;

    directionalLight.shadow.mapSize.width = 1024;
    directionalLight.shadow.mapSize.height = 1024;
    //directionalLight.shadowDarkness = 0.3;
    scene.add(directionalLight);
    var directionalLightback = new THREE.DirectionalLight(0xFFFFFF,.4);
    directionalLightback.position.set(-10, 10, 0);
    directionalLightback.rotation.set(0, -Math.PI/2, 0);
    scene.add(directionalLightback);
    var hemiLight = new THREE.HemisphereLight(0xffffff,0xffffff, .2);
    hemiLight.position.set(0, 10, 0);
    scene.add(hemiLight);
    var light = new THREE.SpotLight(0xffffff, .3);
    light.position.set(0.5, -1, 5);
    light.distance = 0;
    var light2 = new THREE.SpotLight(0xffffff, .3);
    light2.position.set(0.5, -1, -5);
    light2.distance = 0;
    scene.add(light);
    scene.add(light2);
    var lightgreen = new THREE.SpotLight(0x00ff00, 1);
    lightgreen.target = green_mesh;
    lightgreen.position.set(0, 3, 18);
    lightgreen.distance = 0;
    //var lightblue = new THREE.SpotLight(0x0000ff, .7, 100, Math.PI, 25);
    var lightblue = new THREE.SpotLight(0x0000ff, 1);
    lightblue.rotation.set(0, -Math.PI, 0);
    lightblue.target = blue_mesh;
    lightblue.position.set(0, 3, -18);
    lightblue.distance = 0;
    scene.add(lightgreen);
    scene.add(lightblue);
    var skygold = new THREE.SpotLight(0xFF4000, .7, 100, Math.PI, 5);
    skygold.position.set(0, 7, 0);
    skygold.distance=0;
    skygold.target = grounds[0].mesh;
    scene.add(skygold);
    /*var skyyellow = new THREE.SpotLight(0xFF7000, .5);
    skyyellow.position.set(0, 12, 0);
    skyyellow.distance=0;
    scene.add(skyyellow);
    var housered = new THREE.SpotLight(0xFF4000, 2);
    housered.position.set(0, 1.7, 0);
    housered.distance=0;
    scene.add(housered);*/
    var housegold = new THREE.SpotLight(0xFF4000, 2,0,Math.PI/4);
    //lightyellow.rotation.set(0, -Math.PI, 0);
    housegold.position.set(0, 1.7, 0);
    housegold.distance=0;
    scene.add(housegold);
    var treered = new THREE.SpotLight(0xFFB000, 2,0,Math.PI/6);
    treered.shadow.camera.fov = 10;
    //treered.shadowCameraVisible = true;
    //lightgold.rotation.set(0, -Math.PI, 0);
    treered.position.set(24, 1.7, 0);
    treered.distance = 0;
    treered.target = tree_mesh;
    scene.add(treered);

    var gameManager = new GameObject();
    var cd = new GameTimeCountdown();
    cd.grounds = grounds;
    gameManager.addComponent(cd);


    NetWorkManager.init(scene, Data.prefab.player, SERVER + 'game');
    NetWorkManager.setSpawnPoint(new THREE.Vector3(-0.5, -0.5, -5));
    NetWorkManager.setUserInfo(document.userInfo, function(data) {
        var info = JSON.parse(data);
        info.sort(function(a, b) {
            return b.score - a.score;
        });
        var orderList = $("#gamePanel").find("#order-list");
        var inner = "";
        for (var i = 0; i < info.length; i++) {
            inner += "<li>" + info[i].nickname + "<span>" + info[i].score + "</span>" + "</li>";
        }
        orderList.html(inner);
    });

    // simulate score update
    /*setInterval(function () {
        document.userInfo.score += Math.round(Math.random()*10);
        NetWorkManager.updateUserInfo(document.userInfo);
    }, 1000);*/

}

// boot script
$(function() {
    var preparePage = $("#preparePanel");
    var sourceTag = preparePage.find(".coldtime-title");

    // load game source
    var progress = 0;   // 当前进度
    var lastMajorPart = -1;  // 上一个大类的号码
    var minorPartDelta = 0; // 每加载一个项目增加的进度
    Data.load(null, function(data) {
        // 开始加载新的大类，重新计算 delta
        if (lastMajorPart !== data.major) minorPartDelta = 100 / Data.MAJOR / data.minorCount;
        progress += minorPartDelta;
        sourceTag.text("加载中…… " + Math.floor(progress) + "%");
    }, function() {
        sourceTag.text("加载完成");
        // start game
        Input.registerClickResponse(Game.requestFullScreen);
        preparePage.find("#start").click(function() {
            //document.addEventListener('keydown', Game.requestFullScreen, false);
            Game.setScene(new Scene(scene1)).start();
            preparePage.hide();
            $("#gamePanel").show();
        })
    });

});


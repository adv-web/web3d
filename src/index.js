/**
 * Created by maliut on 2017/4/21.
 */
var Game = require("./Game");
var Scene = require("./Scene");
var NetWorkManager = require('./NetWorkManager');
var Data = require("./Data");
var GameObject = require("./GameObject");
var GameTimeCountdown = require("./component/GameTimeCountdown");

// var SERVER = "http://localhost:5000/";
var SERVER = "http://120.76.125.35:5000/";

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
    hemiLight.position.set(0, 10, 0);
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
    scene.spawn(Data.prefab.train_container, new THREE.Vector3(8.5, -0.8, 5), new THREE.Vector3(0, Math.PI / 2, 0));
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

    var gameManager = new GameObject();
    gameManager.addComponent(new GameTimeCountdown());

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
    setInterval(function () {
        document.userInfo.score += Math.round(Math.random()*10);
        NetWorkManager.updateUserInfo(document.userInfo);
    }, 1000);

}

// boot script
$(function() {
    var preparePage = $("#preparePanel");
    var sourceTag = preparePage.find(".coldtime-title");

    // load game source
    var progress = 0;   // 当前进度
    var lastMajorPart = -1;  // 上一个大类的号码
    var minorPartDelta = 0; // 每加载一个项目增加的进度
    Data.load(null, function (data) {
        // 开始加载新的大类，重新计算 delta
        if (lastMajorPart !== data.major) minorPartDelta = 100 / Data.MAJOR / data.minorCount;
        progress += minorPartDelta;
        sourceTag.text("加载中…… " + Math.floor(progress) + "%");
    }, function() {
        sourceTag.text("加载完成");
        // start game
        preparePage.find("#start").click(function() {
            document.addEventListener('keydown', Game.requestFullScreen, false);
            var scene = new Scene(scene1);
            Game.setScene(scene).start();
            preparePage.hide();
            $("#gamePanel").show();
        })
    });

});


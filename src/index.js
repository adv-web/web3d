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
$(function() {
    var loginPage = $("#loginPanel");
    var preparePage = $("#preparePanel");
    var gamePage = $("#gamePanel");
    var startButton = preparePage.find("#start");
    var sourceTag = preparePage.find(".coldtime-title");
    var prepareUserInfoBlock = preparePage.find(".usr_info");
    var gameUserInfoBlock = gamePage.find(".usr_info");
    var server = "http://localhost:5000/";
    var userInfo = {};

    //hide game page
    gamePage.hide();
    //hide login page
    loginPage.hide();

    // load game source
    Data.load(null, null, function() {
        sourceTag.text("加载完成");
        // start game
        startButton.click(function () {
            preparePage.hide();
            gamePage.show();

            document.addEventListener('keydown', Game.requestFullScreen, false);
            var scene = new Scene(scene1);
            Game.setScene(scene).start();
        })
    });

    // change to login page
    prepareUserInfoBlock.click(function () {
        preparePage.hide();
        loginPage.show();
    });

    // login
    loginPage.find("#login").click(function () {

        //do login
        var login = loginPage.find(".login");
        var mess = {
            username: login.find("input[name='username']").val(),
            password: login.find("input[name='password']").val()
        };
        $.ajax({
            type: 'POST',
            url: server + 'session',
            data: mess,
            dataType: 'JSON',
            success: function(data){
                if (data.success) {
                    //change user info
                    userInfo = JSON.parse(data.user);
                    setUserInfo(userInfo);
                    //show game
                    loginPage.hide();
                    preparePage.show();
                }
                else {
                    alert(JSON.stringify(data.err));
                }
            },
            error: function(data){
                alert(JSON.stringify(data));
            }
        });
    });

    //register
    loginPage.find("#register").click(function () {
       // do register
        var register = loginPage.find(".registe");
        var mess = {
            username: register.find("input[name='username']").val(),
            nickname: register.find("input[name='nickname']").val(),
            password: register.find("input[name='password']").val()
        };
        if (mess.password !== register.find("input[name='password2']").val()) {
            alert("密码不一致");
            return ;
        }

        $.ajax({
            type: 'POST',
            url: server + 'user',
            data: mess,
            dataType: 'JSON',
            success: function(data){
                if (data.success) {
                    //change user info
                    userInfo = JSON.parse(data.user);
                    setUserInfo(userInfo);
                    //show game
                    loginPage.hide();
                    preparePage.show();
                }
                else {
                    alert(JSON.stringify(data.err));
                }
            },
            error: function(data){
                alert(JSON.stringify(data));
            }
        });
    });

    function setUserInfo(user) {
        console.log(user);
        prepareUserInfoBlock.find(".usr_name").text(user.username);
        prepareUserInfoBlock.find(".user_rank").text(user.rank);//军衔
        prepareUserInfoBlock.find(".win_rate").text(user.win_rate+"%");
        prepareUserInfoBlock.find(".battle_number").text(user.battle_number);

        gameUserInfoBlock.find(".usr_name").text(user.username);
        gameUserInfoBlock.find(".user_rank").text(user.rank);//军衔
        gameUserInfoBlock.find(".win_rate").text(user.win_rate+"%");

        gamePage.find(".battle_number").text(user.battle_number);
        gamePage.find(".level .d-data").text(user.level);
        gamePage.find(".equip .d-data").text(user.equipment);
        gamePage.find(".power .d-data").text(user.power);
    }
});


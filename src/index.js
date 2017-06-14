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
    NetWorkManager.setUserInfo(document.userInfo, document.updateScoreBoard);

    // simulate score update
    setInterval(function () {
        document.userInfo.score += Math.round(Math.random()*10);
        NetWorkManager.updateUserInfo(document.userInfo);
    }, 1000);

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
        startButton.click(function () {
            document.addEventListener('keydown', Game.requestFullScreen, false);
            var scene = new Scene(scene1);
            Game.setScene(scene).start();
            preparePage.hide();
            gamePage.show();
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
            url: SERVER + 'session',
            data: mess,
            dataType: 'JSON',
            success: function(data) {
                if (data.success) {
                    //change user info
                    document.userInfo = JSON.parse(data.user);
                    document.userInfo.score = 0;
                    setUserInfo(document.userInfo);
                    //show game
                    loginPage.hide();
                    preparePage.show();
                } else {
                    alert(JSON.stringify(data.err));
                }
            },
            error: function(data) {
                alert(JSON.stringify(data));
            }
        });
    });

    //register
    loginPage.find("#register").click(function() {
       // do register
        var register = loginPage.find(".registe");
        var mess = {
            username: register.find("input[name='username']").val(),
            nickname: register.find("input[name='nickname']").val(),
            password: register.find("input[name='password']").val()
        };
        if (mess.password !== register.find("input[name='password2']").val()) {
            alert("密码不一致");
            return;
        }

        $.ajax({
            type: 'POST',
            url: SERVER + 'user',
            data: mess,
            dataType: 'JSON',
            success: function(data) {
                if (data.success) {
                    //change user info
                    document.userInfo = JSON.parse(data.user);
                    document.userInfo.score = 0;
                    setUserInfo(document.userInfo);
                    //show game
                    loginPage.hide();
                    preparePage.show();
                    //hide register
                    loginPage.find(".box").hide();
                } else {
                    alert(JSON.stringify(data.err));
                }
            },
            error: function(data) {
                alert(JSON.stringify(data));
            }
        });
    });

    function setUserInfo(user) {
        //console.log(user);
        prepareUserInfoBlock.find(".usr_name").text(user.nickname);
        prepareUserInfoBlock.find(".user_rank").text(user.rank);//军衔
        prepareUserInfoBlock.find(".win_rate").text(user.win_rate+"%");
        prepareUserInfoBlock.find(".battle_number").text(user.battle_number);

        gameUserInfoBlock.find(".usr_name").text(user.nickname);
        gameUserInfoBlock.find(".user_rank").text(user.rank);//军衔
        gameUserInfoBlock.find(".win_rate").text(user.win_rate+"%");

        gamePage.find(".battle_number").text(user.battle_number);
        gamePage.find(".level .d-data").text(user.level);
        gamePage.find(".equip .d-data").text(user.equipment);
        gamePage.find(".power .d-data").text(user.power);
    }

    document.updateScoreBoard = function (data) {
        var infos = JSON.parse(data);
        infos.sort(function (a, b) {
            return b.score - a.score;
        });
        // select sort
        /*for (var i = 0; i < infos.length-1; i++) {
            var min = infos[i];
            var minIndex = i;
            // select min
            for (var j = i+1; j < infos.length; j++) {
                if (infos[j].score > min.score) {
                    min = infos[j];
                    minIndex = j;
                }
            }
            //swap
            infos[minIndex] = infos[i];
            infos[i] = min;
        }*/
        //update score board
        var orderList = gamePage.find("#order-list");
        //<li>LTL<span>490</span></li>
        var inner = "";
        for (i = 0; i < infos.length; i++) {
            inner += "<li>" + infos[i].nickname +
                    "<span>" + infos[i].score + "</span>" + "</li>";
        }
        orderList.html(inner);
    };

    document.userInfo = {
        username: "Guest"+ Math.ceil(Math.random()*500),
        nickname: "Guest"+ Math.ceil(Math.random()*500),
        rank: "新兵",
        battle_number: 0,
        win_rate: 100,
        level: 1,
        power: 99,
        equipment: "木甲",
        score: 0
    };
    setUserInfo(document.userInfo);
});


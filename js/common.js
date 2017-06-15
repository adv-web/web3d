
(function() {
    var SERVER = "http://120.76.125.35:5000/";
    var loginPage = $("#loginPanel");
    var preparePage = $("#preparePanel");
    var gamePage = $("#gamePanel");
    var prepareUserInfoBlock = preparePage.find(".usr_info");
    var gameUserInfoBlock = gamePage.find(".usr_info");
    // 将用户信息显示在界面上的函数
    var maxHPAreaLength = $(".HP-data").width();
    var setUserInfo = document.setUserInfo = function(user) {
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

        $(".HP-data").animate({width: maxHPAreaLength * user.hp});
        $(".pp-data").animate({width: maxHPAreaLength * user.exp});
        //$(".HP-data").width(maxHPAreaLength * user.hp);
        //$(".pp-data").width(maxHPAreaLength * user.exp);
    };

    // 显示登录界面
    prepareUserInfoBlock.click(function() {
        preparePage.hide();
        loginPage.show();
    });

    // 登录功能
    loginPage.find("#login").click(function() {
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

    // 注册功能
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
    // 放置初始人物信息
    document.userInfo = {
        username: "Guest"+ Math.ceil(Math.random()*500),
        nickname: "Guest"+ Math.ceil(Math.random()*500),
        rank: "新兵",
        battle_number: 0,
        win_rate: 100,
        level: 1,
        power: 300,
        equipment: "中坦",
        score: 0,
        hp: 1, // 百分比
        type: "MT",
        exp: 0  // 百分比
    };
    setUserInfo(document.userInfo);

//     // 游戏内提示信息的左右滚动
//     var marquee = document.getElementById('message');
//     var offset = 0;
//     var scrollwidth = marquee.offsetWidth;

//     setInterval(function() {
//         if (offset === 2 * scrollwidth) {
//             offset = 0;
//         }
//         marquee.style.marginLeft = scrollwidth - offset + "px";
//         offset += 2;
//     }, 15);
})();


//提示信息的左右滚动
(function() {
    var marquee = document.getElementById('message');
    var offset = 0;
    var scrollwidth = marquee.offsetWidth;

    setInterval(function() {
        if (offset == 2 * scrollwidth) {
            offset = 0;
        }
        marquee.style.marginLeft = scrollwidth - offset + "px";
        offset += 2;
    }, 15);
})();
